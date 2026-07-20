#!/usr/bin/env bash
#
# dar-agent.sh — Lanza Claude Code en modo headless con worktree aislado
# para ejecutar tareas dar-ready-for-agent del equipo daredevils.
#
# Uso:
#   ./dar-agent.sh                        # Ejecuta TODAS las tareas ready-for-agent
#   ./dar-agent.sh PLATFORM-12974         # Ejecuta solo esa tarea
#   ./dar-agent.sh --no-sandbox           # Batch sin sandbox
#   ./dar-agent.sh --no-sandbox PLATFORM-12974  # Una tarea sin sandbox
#
# Requisitos:
#   - claude CLI en el PATH
#   - TWG CLI en el PATH (twg)
#
set -euo pipefail

# ── Parsear flags ────────────────────────────────────────────────
USE_SANDBOX=true
while [[ "${1:-}" == --* ]]; do
  case "$1" in
    --no-sandbox) USE_SANDBOX=false; shift ;;
    *) echo "Flag desconocido: $1" >&2; exit 1 ;;
  esac
done

# Settings según modo
if $USE_SANDBOX; then
  SETTINGS='{
    "model": "opus",
    "sandbox": {
      "autoAllowBashIfSandboxed": true,
      "filesystem": {
        "allowWrite": ["."],
        "denyWrite": [".git", ".claude"]
      },
      "network": {
        "allowedDomains": [
          "github.com",
          "registry.npmjs.org"
        ]
      }
    }
  }'
  CLAUDE_EXTRA_ARGS=(--dangerously-skip-permissions --settings "$SETTINGS")
else
  CLAUDE_EXTRA_ARGS=(--dangerously-skip-permissions)
fi

# ── Función para lanzar un worktree por issue ────────────────────
run_issue() {
  local issue_key="$1"
  echo ""
  echo "════════════════════════════════════════════════════════════"
  echo "🚀 Lanzando agente para $issue_key..."
  echo "════════════════════════════════════════════════════════════"
  echo ""

  # Capturar worktrees existentes ANTES de lanzar claude
  local worktrees_before
  worktrees_before=$(git worktree list --porcelain | grep '^worktree ' | awk '{print $2}' | sort)

  tmux rename-window "⏳ working"

  claude -p \
    "Usa la skill dar-agent para implementar la issue $issue_key. Lee el brief de agente de la issue en Jira con TWG, implementa los cambios en idealista.com.static, ejecuta los checks (make deps, make check, make typecheck-precommit, make test), crea la PR con TWG Bitbucket, actualiza Jira con TWG (comentario, labels, transición a 'Pendiente de aprobación')." \
    --worktree \
    "${CLAUDE_EXTRA_ARGS[@]}" \
    --verbose \
    --output-format stream-json \
  | jq -r --unbuffered 'select(.type == "assistant") | .message.content[] | select(.type == "text") | .text // empty'

  local exit_code=${PIPESTATUS[0]}
  if [[ $exit_code -ne 0 ]]; then
    echo "⚠️  El agente terminó con errores para $issue_key (exit code: $exit_code)"
  else
    echo "✅ $issue_key completada"
  fi

  # Limpiar SOLO el worktree creado por esta ejecución (diff antes/después)
  local worktrees_after
  worktrees_after=$(git worktree list --porcelain | grep '^worktree ' | awk '{print $2}' | sort)
  local new_worktree
  new_worktree=$(comm -13 <(echo "$worktrees_before") <(echo "$worktrees_after"))

  if [[ -n "$new_worktree" ]]; then
    echo "  🧹 Limpiando worktree: $new_worktree"
    git worktree remove --force "$new_worktree" 2>/dev/null
    git worktree prune 2>/dev/null
  fi

  tmux rename-window "✅ done"

  return 0  # No parar el lote por un fallo individual
}

# ── Main ─────────────────────────────────────────────────────────
ISSUE_KEY="${1:-}"

if [[ -n "$ISSUE_KEY" ]]; then
  run_issue "$ISSUE_KEY"
else
  echo "🔍 Buscando tareas dar-ready-for-agent en Jira..."

  # Consultar Jira directamente con TWG CLI
  QUERY_OUTPUT=$(twg jira workitem query \
    --jql "project = PLATFORM AND cf[11052] = daredevils AND labels = dar-ready-for-agent ORDER BY priority DESC, created ASC" \
    --site idealista \
    --output json \
    --output-summary auto \
    --agent-fields "data.issues.key" 2>/dev/null)

  # Parsear issue keys del output TWG (YAML envelope con stdout_inline o fichero)
  STDOUT_FILE=$(echo "$QUERY_OUTPUT" | grep '^\s*stdout:' | head -1 | awk '{print $2}' | tr -d '"')
  if echo "$QUERY_OUTPUT" | grep -q 'stdout_inline:'; then
    # Output inline: extraer keys del YAML
    ISSUES=$(echo "$QUERY_OUTPUT" | grep 'key:' | awk '{print $2}' | tr -d '"')
  elif [[ -n "$STDOUT_FILE" && -f "$STDOUT_FILE" ]]; then
    # Output en fichero: parsear con jq
    ISSUES=$(jq -r '.data.issues[].key' "$STDOUT_FILE" 2>/dev/null)
  else
    ISSUES=""
  fi

  # Limpiar posibles líneas vacías
  ISSUES=$(echo "$ISSUES" | sed '/^$/d' | tr -d ' ')

  if [[ -z "$ISSUES" || "$ISSUES" == "NONE" ]]; then
    echo "✨ No hay tareas dar-ready-for-agent pendientes. ¡Todo limpio!"
    exit 0
  fi

  TOTAL=$(echo "$ISSUES" | wc -l | tr -d ' ')
  echo "📋 Encontradas $TOTAL issues:"
  echo ""
  echo "$ISSUES" | while read -r key; do
    echo "   • $key"
  done
  echo ""

  CURRENT=0
  echo "$ISSUES" | while read -r key; do
    CURRENT=$((CURRENT + 1))
    echo "[$CURRENT/$TOTAL] Procesando: $key"
    run_issue "$key"
    echo ""
  done

  echo "════════════════════════════════════════════════════════════"
  echo "🏁 Lote completado. Procesadas $TOTAL issues."
  echo "════════════════════════════════════════════════════════════"
fi

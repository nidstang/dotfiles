#!/usr/bin/env bash
#
# dar-agent.sh — Lanza Claude Code en modo headless con worktree aislado
# para ejecutar tareas dar-ready-for-agent del equipo daredevils.
#
# Uso:
#   ./dar-agent.sh                  # Ejecuta TODAS las tareas ready-for-agent (una por worktree)
#   ./dar-agent.sh PLATFORM-12974   # Ejecuta solo esa tarea
#
# Requisitos:
#   - claude CLI en el PATH
#   - MCP de Atlassian configurado
#
set -euo pipefail

# Settings: modelo Opus, sandbox con filesystem aislado y network allowlist
SANDBOX_SETTINGS='{
  "model": "opus",
  "sandbox": {
    "autoAllowBashIfSandboxed": true,
    "filesystem": {
      "allowWrite": ["."],
      "denyWrite": [".git", ".claude"]
    },
    "network": {
      "allowedDomains": [
        "api.atlassian.com",
        "idealista.atlassian.net",
        "github.com",
        "registry.npmjs.org"
      ]
    }
  }
}'

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
    "Usa la skill dar-agent para implementar la issue $issue_key. Lee el brief de agente de la issue en Jira, implementa los cambios en idealista.com.static, ejecuta los checks (make deps, make check, make typecheck-precommit, make test), crea el DESCRIPTION.md, crea la PR, actualiza Jira a 'Pendiente de aprobación' y cambia las labels." \
    --worktree \
    --dangerously-skip-permissions \
    --settings "$SANDBOX_SETTINGS" \
    --output-format text

  local exit_code=$?
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

  # Usa Claude con MCP de Atlassian para obtener las issue keys
  ISSUES=$(claude -p \
    "Busca en Jira con JQL: project = PLATFORM AND cf[11052] = daredevils AND labels = dar-ready-for-agent ORDER BY priority DESC, created ASC (cloudId: 2e3f60f0-6b80-4388-93bd-d94c92c7d19d). Responde SOLO con las issue keys separadas por saltos de línea, sin explicación ni texto adicional. Si no hay resultados, responde exactamente NONE." \
    --output-format text 2>/dev/null)

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

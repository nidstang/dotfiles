#!/usr/bin/env bash
#
# dar-agent.sh — Lanza Claude Code en sandbox + worktree para ejecutar
# tareas dar-ready-for-agent del equipo daredevils.
#
# Uso:
#   ./dar-agent.sh                  # Ejecuta TODAS las tareas ready-for-agent (una por sandbox)
#   ./dar-agent.sh PLATFORM-12974   # Ejecuta solo esa tarea
#
set -euo pipefail

# ── Función para lanzar un sandbox por issue ─────────────────────
run_issue() {
  local issue_key="$1"
  echo ""
  echo "════════════════════════════════════════════════════════════"
  echo "🚀 Lanzando agente para $issue_key..."
  echo "════════════════════════════════════════════════════════════"
  echo ""

  claude --sandbox --worktree \
    --print \
    --prompt "Usa la skill dar-agent para implementar la issue $issue_key. Lee el brief de agente de la issue en Jira, implementa los cambios en idealista.com.static, ejecuta los checks (make deps, make check, make typecheck-precommit, make test), crea la PR, actualiza Jira a 'Pendiente de aprobación' y cambia las labels."

  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    echo "⚠️  El agente terminó con errores para $issue_key (exit code: $exit_code)"
  else
    echo "✅ $issue_key completada"
  fi

  return 0  # No parar el lote por un fallo individual
}

# ── Main ─────────────────────────────────────────────────────────
ISSUE_KEY="${1:-}"

if [[ -n "$ISSUE_KEY" ]]; then
  run_issue "$ISSUE_KEY"
else
  echo "🔍 Buscando tareas dar-ready-for-agent en Jira..."

  # Usa Claude con MCP de Atlassian para obtener las issue keys
  ISSUES=$(claude --print \
    --prompt "Busca en Jira con JQL: project = PLATFORM AND cf[11052] = daredevils AND labels = dar-ready-for-agent ORDER BY priority DESC, created ASC (cloudId: 2e3f60f0-6b80-4388-93bd-d94c92c7d19d). Responde SOLO con las issue keys separadas por saltos de línea, sin explicación ni texto adicional. Si no hay resultados, responde exactamente NONE." \
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

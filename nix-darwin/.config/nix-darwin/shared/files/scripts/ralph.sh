# ralph.sh
# Uso: ralph <iteraciones> [PRD.json] [branch-name] [opencode|claude] [modelo]

set -e

if [ -z "$1" ]; then
  echo "Uso: ralph <iteraciones> [PRD.json] [branch-name] [opencode|claude] [modelo]"
  exit 1
fi

PRD_FILE="${2:-PRD.json}"

AGENT="${4:-opencode}"
if [[ "$AGENT" != "opencode" && "$AGENT" != "claude" ]]; then
  echo "Agente desconocido: $AGENT. Usa 'opencode' o 'claude'."
  exit 1
fi

if [[ "$AGENT" == "opencode" ]]; then
  MODEL="${5:-codex}"
else
  MODEL="${5:-opus}"
fi

WORKSPACE="$(pwd)"

if [ -n "$3" ]; then
  REPO_ROOT=$(git rev-parse --show-toplevel)
  WORKTREE_PATH="${REPO_ROOT}/../$(basename "$REPO_ROOT")-$3"
  if [ -d "$WORKTREE_PATH" ]; then
    echo "Worktree ya existe en $WORKTREE_PATH, reutilizando."
  elif git show-ref --verify --quiet "refs/heads/$3"; then
    echo "Rama '$3' ya existe. Creando worktree en $WORKTREE_PATH"
    git worktree add "$WORKTREE_PATH" "$3"
  else
    echo "Creando worktree con nueva rama '$3' en $WORKTREE_PATH"
    git worktree add -b "$3" "$WORKTREE_PATH" develop
  fi
  WORKSPACE="$WORKTREE_PATH"
  # Copiar ficheros no trackeados necesarios al worktree
  ORIG_DIR="$(pwd)"
  [ -f "$ORIG_DIR/$PRD_FILE" ] && cp "$ORIG_DIR/$PRD_FILE" "$WORKSPACE/$PRD_FILE"
  [ -f "$ORIG_DIR/progress.txt" ] && cp "$ORIG_DIR/progress.txt" "$WORKSPACE/progress.txt"
fi

LABEL="${3:+$3/}${AGENT}"

echo "Iniciando Ralph Wiggum con $AGENT (Dockerizado) por $1 iteraciones..."

PROMPT="Lee los archivos $PRD_FILE y progress.txt. Eres un agente autónomo ('Ralph').

Tu objetivo en este bucle es implementar EXACTAMENTE UNA tarea. Sigue estos pasos estrictamente:

REGLAS DEL ENTORNO (¡CRÍTICO LÉELO ANTES DE EJECUTAR NADA!):
- Estás corriendo en un entorno linux/arm64.
- Para instalar dependencias, usa SIEMPRE: 'pnpm install --frozen-lockfile -r --ignore-scripts'.

1. SELECCIÓN DE TAREA:
   - Lee el $PRD_FILE y busca las tareas donde 'passes' sea false.
   - Decide cuál hacer priorizando: 1) Arquitectura, 2) Integración, 3) Funcionalidades, 4) UI.
   - Lee progress.txt para entender qué se hizo antes.

2. IMPLEMENTACIÓN:
   - Mantén los cambios pequeños. Calidad sobre velocidad.

3. FEEDBACK LOOPS (Obligatorio):
   - Ejecuta los comandos de validación que encuentres
   - NO des la tarea por válida si fallan. Arréglalos primero.

4. ACTUALIZAR ESTADO:
   - Si todo funciona, cambia 'passes' a true en $PRD_FILE para esa tarea.
   - Añade un resumen al final de progress.txt: ID de tarea, archivos cambiados, decisiones técnicas, bloqueos.

5. COMMIT:
   - Haz un git commit detallado empezando por el ID de la tarea, ej: '[TASK-1] Implementado login'. Mete en el commit SOLO los ficheros que tu has modificado en esta tarea. No pongas nada de Co-authored by.

REGLA DE SALIDA:
Si ABSOLUTAMENTE TODAS las tareas tienen 'passes: true', genera exactamente este texto: <promise>COMPLETE</promise>."

for ((i=1; i<=$1; i++)); do
  echo "--- Iteración $i de $1 ---"

  COMMON_ARGS=(
    --rm
    -v "$WORKSPACE:/workspace"
    -e HOME="/tmp/home"
    -e GIT_AUTHOR_NAME="Pablo Fernandez"
    -e GIT_AUTHOR_EMAIL="pffranco@idealista.com"
    -e GIT_COMMITTER_NAME="Pablo Fernandez"
    -e GIT_COMMITTER_EMAIL="pffranco@idealista.com"
    -v "$HOME/.npmrc:/tmp/home/.npmrc:ro"
  )

  if [[ "$AGENT" == "opencode" ]]; then
    result=$(docker run "${COMMON_ARGS[@]}" \
      -v "$HOME/.local/share/opencode/auth.json:/tmp/home/.local/share/opencode/auth.json:ro" \
      -v "$HOME/.cache/opencode:/tmp/home/.cache/opencode" \
      opencode run --agent "$MODEL" "$PROMPT")
  else
    CLAUDE_TMP=$(mktemp -d /tmp/claude-XXXXXX)
    cp -r "$HOME/.claude/." "$CLAUDE_TMP/"
    security find-generic-password -s "Claude Code-credentials" -w > "$CLAUDE_TMP/.credentials.json"
    RESULT_FILE=$(mktemp /tmp/claude-result-XXXXXX)
    docker run "${COMMON_ARGS[@]}" \
      -v "$CLAUDE_TMP:/tmp/home/.claude" \
      claude --model "$MODEL" --dangerously-skip-permissions -p "$PROMPT" 2>&1 | tee "$RESULT_FILE"
    result=$(cat "$RESULT_FILE")
    rm -f "$RESULT_FILE"
    rm -rf "$CLAUDE_TMP"
  fi

  echo "$result"

  REMAINING=$(grep -c '"passes": false' "$WORKSPACE/$PRD_FILE" 2>/dev/null || echo "?")

  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo "PRD completado al 100%. Saliendo del bucle."
    curl -s -o /dev/null -G "http://api.callmebot.com/text.php" \
      --data-urlencode "user=Pablinger" \
      --data-urlencode "text=[$LABEL] PRD DONE in $i iterations"
    exit 0
  fi

  echo "Iteración $i finalizada. Pausando 5 segundos..."
  curl -s -o /dev/null -G "http://api.callmebot.com/text.php" \
    --data-urlencode "user=Pablinger" \
    --data-urlencode "text=[$LABEL] Iter $i/$1 done - $REMAINING tasks remaining"
  sleep 5
done

REMAINING=$(grep -c '"passes": false' "$WORKSPACE/$PRD_FILE" 2>/dev/null || echo "?")
echo "Límite de iteraciones alcanzado ($1)."
curl -s -o /dev/null -G "http://api.callmebot.com/text.php" \
  --data-urlencode "user=Pablinger" \
  --data-urlencode "text=[$LABEL] LIMIT reached after $1 iterations - $REMAINING tasks remaining"

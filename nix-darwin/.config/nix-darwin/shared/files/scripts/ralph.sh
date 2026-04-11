# ralph.sh
# Uso: ralph <iteraciones> <branch-name>

set -e

if [ -z "$1" ]; then
  echo "Uso: ralph <iteraciones> <branch-name>"
  exit 1
fi

if [ -n "$2" ]; then
  echo "Creando rama $2 desde develop"
  git checkout develop
  git checkout -b "$2"
fi


echo "Iniciando Ralph Wiggum con OpenCode (Dockerizado) por $1 iteraciones..."

PROMPT="Lee los archivos PRD.json y progress.txt. Eres un agente autónomo ('Ralph').

Tu objetivo en este bucle es implementar EXACTAMENTE UNA tarea. Sigue estos pasos estrictamente:

REGLAS DEL ENTORNO (¡CRÍTICO LÉELO ANTES DE EJECUTAR NADA!):
- Estás corriendo en un entorno linux/arm64.
- Para instalar dependencias, usa SIEMPRE: 'pnpm install --frozen-lockfile -r --ignore-scripts'.

1. SELECCIÓN DE TAREA: 
   - Lee el PRD.json y busca las tareas donde 'passes' sea false.
   - Decide cuál hacer priorizando: 1) Arquitectura, 2) Integración, 3) Funcionalidades, 4) UI.
   - Lee progress.txt para entender qué se hizo antes.

2. IMPLEMENTACIÓN:
   - Mantén los cambios pequeños. Calidad sobre velocidad.

3. FEEDBACK LOOPS (Obligatorio):
   - Para instalar dependencias en idealista.com.static, debes de ejecutar el comando make deps dentro de idealista.com.static
   - Ejecuta los comandos de validación de idealista.com.static/ (pnpm run check, pnpm run build).
   - NO des la tarea por válida si fallan. Arréglalos primero.

4. ACTUALIZAR ESTADO:
   - Si todo funciona, cambia 'passes' a true en PRD.json para esa tarea.
   - Añade un resumen al final de progress.txt: ID de tarea, archivos cambiados, decisiones técnicas, bloqueos.

5. COMMIT:
   - Haz un git commit detallado empezando por el ID de la tarea, ej: '[TASK-1] Implementado login'. Mete en el commit SOLO los ficheros que tu has modificado en esta tarea. No pongas nada de Co-authored by.

REGLA DE SALIDA:
Si ABSOLUTAMENTE TODAS las tareas tienen 'passes: true', genera exactamente este texto: <promise>COMPLETE</promise>."

for ((i=1; i<=$1; i++)); do
  echo "--- Iteración $i de $1 ---"
  
  result=$(docker run --rm \
    -v "$(pwd):/workspace" \
    -e HOME="/tmp/home" \
    -e GIT_AUTHOR_NAME="Pablo Fernandez" \
    -e GIT_AUTHOR_EMAIL="pffranco@idealista.com" \
    -e GIT_COMMITTER_NAME="Pablo Fernandez" \
    -e GIT_COMMITTER_EMAIL="pffranco@idealista.com" \
    -v "$HOME/.local/share/opencode/auth.json:/tmp/home/.local/share/opencode/auth.json:ro" \
    -v "$HOME/.cache/opencode:/tmp/home/.cache/opencode" \
    -v "$HOME/.npmrc:/tmp/home/.npmrc:ro" \
    opencode run --agent codex "$PROMPT")

  echo "$result"

  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo "PRD completado al 100%. Saliendo del bucle."
    curl -X GET "http://api.callmebot.com/text.php?user=Pablinger&text=PRD+completed+after+${i}+iterations"
    exit 0
  fi
  
  echo "Iteración $i finalizada. Pausando 5 segundos..."
  curl -X GET "http://api.callmebot.com/text.php?user=Pablinger&text=Iteration+${i}+complete"
  sleep 5
done

echo "Límite de iteraciones alcanzado ($1)."
curl -X GET "http://api.callmebot.com/text.php?user=Pablinger&text=Limit+of+${1}+iterations+reached"

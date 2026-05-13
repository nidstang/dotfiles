---
name: dar-triage
description: Triaje de issues de Jira para el equipo daredevils mediante una máquina de estados basada en labels. Usa esta skill cuando el usuario quiera triar issues, revisar bugs o peticiones de features entrantes, preparar issues para un agente autónomo, gestionar el flujo de trabajo de issues, o pregunte qué necesita atención en el proyecto PLATFORM. También se activa con comandos como /triage, "qué hay pendiente", "triagea esto", o cualquier mención a dar-needs-triage, dar-ready-for-agent, dar-wontfix, o labels similares. Incluso si el usuario pregunta casualmente "qué tengo pendiente" o "enséñame lo que hay que revisar", usa esta skill.
---

# Triaje Daredevils

Mover issues de Jira en el proyecto PLATFORM (equipo: daredevils) a través de una pequeña máquina de estados basada en labels de triaje.

## Contexto de Jira

- **Atlassian Cloud ID:** `2e3f60f0-6b80-4388-93bd-d94c92c7d19d`
- **Proyecto:** PLATFORM (key: `PLATFORM`)
- **Campo de equipo:** `cf[11052]` (campo de grupo, valor: `daredevils`)
- **Tracker:** Jira (herramientas MCP de Atlassian)

Todo comentario publicado en Jira durante el triaje **debe** empezar con este disclaimer:

> *Esto fue generado por IA durante el triaje.*

## Documentos de referencia

- [AGENT-BRIEF.md](./AGENT-BRIEF.md) — cómo escribir briefs duraderos para agentes
- [OUT-OF-SCOPE.md](./OUT-OF-SCOPE.md) — cómo funciona la base de conocimiento de fuera de alcance

## Labels

Dos labels de **categoría**:

- `dar-bug` — algo está roto
- `dar-enhancement` — nueva funcionalidad o mejora

Cinco labels de **estado**:

- `dar-needs-triage` — el mantenedor necesita evaluar
- `dar-needs-info` — esperando al reporter para más información
- `dar-ready-for-agent` — completamente especificada, lista para un agente autónomo
- `dar-ready-for-human` — necesita implementación humana
- `dar-wontfix` — no se va a hacer

Cada issue triada debe llevar exactamente una label de categoría y una de estado. Si hay labels de estado en conflicto, señálalo y pregunta al mantenedor antes de hacer nada.

**Importante:** Al actualizar labels mediante la API de Jira, el campo `labels` **reemplaza** todas las labels. Siempre lee la issue primero, conserva las labels existentes, y añade/elimina solo las labels `dar-*` que estés cambiando.

## Transiciones de estado

Una issue con `dar-needs-triage` puede moverse a:
- `dar-needs-info` — el reporter necesita dar más detalle
- `dar-ready-for-agent` — completamente especificada, un agente autónomo puede implementarla
- `dar-ready-for-human` — necesita juicio humano, acceso externo o decisiones de diseño
- `dar-wontfix` — no se va a hacer

`dar-needs-info` vuelve a `dar-needs-triage` cuando el reporter responde.

El mantenedor puede forzar cualquier transición en cualquier momento — señala las que parezcan inusuales y pregunta antes de proceder.

## Invocación

El mantenedor invoca `/triage` o pide en lenguaje natural lo que necesita. Interpreta la petición y actúa. Ejemplos:

- "Muéstrame lo que necesita mi atención"
- "Vamos a ver PLATFORM-12974"
- "Mueve PLATFORM-12974 a ready-for-agent"
- "¿Qué hay listo para que lo coja un agente?"

## Mostrar lo que necesita atención

Consulta Jira con JQL y presenta tres grupos, del más antiguo al más reciente:

1. **Sin etiquetar** — issues del equipo daredevils sin ninguna label `dar-*`.
   JQL: `project = PLATFORM AND cf[11052] = daredevils AND statusCategory != Done AND labels not in (dar-needs-triage, dar-needs-info, dar-ready-for-agent, dar-ready-for-human, dar-wontfix, dar-bug, dar-enhancement)`

2. **`dar-needs-triage`** — pendientes de evaluación.
   JQL: `project = PLATFORM AND cf[11052] = daredevils AND labels = dar-needs-triage ORDER BY created ASC`

3. **`dar-needs-info` con actividad reciente del reporter** — necesitan re-evaluación.
   JQL: `project = PLATFORM AND cf[11052] = daredevils AND labels = dar-needs-info ORDER BY updated DESC`
   (Revisa los comentarios manualmente para ver si el reporter ha respondido desde las últimas notas de triaje.)

Muestra contadores y un resumen de una línea por issue. Deja que el mantenedor elija.

## Triar una issue concreta

1. **Recopilar contexto.** Lee la issue completa (descripción, comentarios, labels, reporter, fechas) usando `getJiraIssue`. Analiza las notas de triaje previas para no repetir preguntas ya resueltas. Comprueba si una petición de feature similar fue rechazada anteriormente (ver OUT-OF-SCOPE.md).

2. **Recomendar.** Dile al mantenedor tu recomendación de categoría y estado con el razonamiento, más un breve resumen relevante a la issue. Espera instrucciones.

3. **Reproducir (solo bugs).** Antes de interrogar, intenta la reproducción: lee los pasos del reporter, traza el código relevante si es accesible, razona sobre la ruta del código. Informa de lo que pasó — razonamiento de reproducción exitosa, reproducción fallida, o detalle insuficiente (señal fuerte de `dar-needs-info`). Una reproducción confirmada hace un brief de agente mucho más sólido.

4. **Interrogar (si es necesario).** Si la issue necesita más desarrollo, haz al mantenedor preguntas dirigidas para rellenar los huecos.

5. **Aplicar el resultado:**

   - `dar-ready-for-agent` — publica un comentario con el brief del agente (ver AGENT-BRIEF.md).
   - `dar-ready-for-human` — misma estructura que un brief de agente, pero indicando por qué no se puede delegar (decisiones de juicio, acceso externo, decisiones de diseño, testing manual).
   - `dar-needs-info` — publica notas de triaje (plantilla más abajo).
   - `dar-wontfix` (bug) — comentario con explicación educada.
   - `dar-wontfix` (enhancement) — documenta en la base de conocimiento de fuera de alcance, enlaza desde un comentario.
   - `dar-needs-triage` — aplica la label. Comentario opcional si hay progreso parcial.

## Cambio de estado rápido

Si el mantenedor dice "mueve PLATFORM-12974 a ready-for-agent", confía en él y aplica la label directamente. Confirma lo que vas a hacer (cambios de labels, comentario) y luego actúa. Sáltate el interrogatorio. Si se mueve a `dar-ready-for-agent` sin sesión de interrogatorio, pregunta si quiere redactar un brief de agente.

## Plantilla de needs-info

Publica esto como comentario en Jira:

```
> *Esto fue generado por IA durante el triaje.*

## Notas de triaje

**Lo que hemos establecido hasta ahora:**

- punto 1
- punto 2

**Lo que necesitamos que nos aclares (@reporter):**

- pregunta 1
- pregunta 2
```

Captura todo lo resuelto durante el interrogatorio bajo "Lo que hemos establecido hasta ahora" para que el trabajo no se pierda. Las preguntas deben ser específicas y accionables, no "por favor proporciona más información".

## Retomar una sesión previa

Si existen notas de triaje previas en la issue (comentarios con el disclaimer de IA), léelas, comprueba si el reporter ha respondido alguna pregunta pendiente, y presenta una foto actualizada antes de continuar. No repitas preguntas ya resueltas.

## Referencia rápida de JQL

Consultas JQL útiles para el equipo daredevils:

```
# Todas las issues abiertas de daredevils pendientes de triaje
project = PLATFORM AND cf[11052] = daredevils AND labels = dar-needs-triage ORDER BY created ASC

# Todas las issues abiertas de daredevils listas para agente
project = PLATFORM AND cf[11052] = daredevils AND labels = dar-ready-for-agent ORDER BY priority DESC, created ASC

# Todas las issues abiertas de daredevils esperando información
project = PLATFORM AND cf[11052] = daredevils AND labels = dar-needs-info ORDER BY updated DESC

# Todas las issues abiertas de daredevils (no completadas/descartadas)
project = PLATFORM AND cf[11052] = daredevils AND statusCategory != Done ORDER BY created ASC
```

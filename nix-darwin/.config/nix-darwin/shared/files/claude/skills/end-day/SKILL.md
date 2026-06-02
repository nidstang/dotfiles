---
name: end-day
description: End-of-day review skill that summarizes today's daily note and reminds about actionables created today or due soon. Use this skill whenever the user says "end day", "cerrar el día", "wrap up", "end of day", "qué hice hoy", "resumen del día", "cierre del día", or any variation of wanting to review what happened during the day and what's left pending. Also trigger when the user asks for a daily recap, today's summary, or reminders about what needs attention before tomorrow.
---

# End Day — Daily Wrap-Up

Generate an end-of-day summary by reviewing today's daily note and surfacing actionables that need attention.

## Prerequisites

Before starting, read `references/vault-conventions.md` to understand the vault structure and frontmatter schema.

## Workflow

### Step 1: Locate the vault

The vault root is at `/Users/pffranco/Documents/work/work`. Use this path directly — do not ask the user. The relevant subdirectories are:
- Daily notes: `/Users/pffranco/Documents/work/work/daily-notes/`
- Actionables: `/Users/pffranco/Documents/work/work/actionables/`

### Step 2: Read today's daily note

1. Determine today's date: `YYYY-MM-DD`.
2. Look for `daily-notes/YYYY-MM-DD.md`.
3. If it exists, read the full content.
4. If it doesn't exist, note that there's no daily note for today and skip to actionables.

### Step 3: Summarize today's note

If today's daily note exists:

1. Extract the **key highlights** — decisions, conversations, progress, blockers.
2. Identify any **implicit actionables** mentioned in the note that might not have a dedicated file yet (e.g. "tengo que hablar con X sobre Y", "pendiente revisar Z"). Flag these as suggestions.
3. Keep the summary concise but complete — this is a review, not a re-read.

### Step 4: Scan actionables

1. List all files in `actionables/`.
2. Parse YAML frontmatter for each.
3. Collect three groups:

**🆕 Creados hoy**:
- Filter by `created: <today's date>`.
- Show each with its full description body (these are fresh, the user wants to see what they committed to today).

**⏰ Con deadline próximo**:
- Filter `status: pending` with `due` date within the **next 3 days** (including tomorrow).
- Sort by `due` ascending.
- This is a "don't forget for tomorrow" reminder.

**⚠️ Vencidos**:
- Filter `status: pending` with `due` date **before today**.
- These need attention — they slipped through.

### Step 5: Present the wrap-up

Structure as a conversational end-of-day review:

1. **Saludo de cierre** — with today's date.
2. **Lo que pasó hoy** — summary of the daily note, if it exists. Highlight the most important points.
3. **Sugerencias** — if implicit actionables were found in the note that don't have files, suggest creating them.
4. **Nuevos actionables** — items created today, so the user can confirm they captured everything.
5. **Próximos deadlines** — what's due in the next 3 days.
6. **Vencidos** — overdue items, if any, with a gentle nudge.
7. **Cierre** — something like "¿Quieres ajustar algo antes de cerrar el día?"

### Example output structure

```
Buenas tardes, Pablo. Cierre del lunes 2 de junio de 2026.

## Lo que pasó hoy

- Sesión de debugging del race condition en luxury listings — se identificó que el script dinámico bypasses defer
- 1:1 con [reportee] — se habló sobre carga de trabajo y prioridades del sprint
- Revisión del approach del jQuery shim con el equipo de seguridad

💡 **Sugerencia**: En tu nota mencionas "preguntar a infra sobre los headers de cache en CloudFront" — ¿quieres crear un actionable para esto?

## 🆕 Actionables creados hoy

- investigate-defer-race.md — Investigar alternativas al defer para carga de scripts dinámicos
- update-jquery-shim-tests.md — Añadir tests del shim con happy-dom

## ⏰ Próximos deadlines

📅 Mañana — prepare-cto-report.md
  Preparar informe de impacto de IA para el CTO

📅 Jueves 5 — review-pnpm-cache.md
  Revisar configuración de caché de pnpm en CI

## ⚠️ Vencidos

- review-jquery-shim.md (due: 28 mayo) — Llevas 5 días de retraso

¿Quieres ajustar algo antes de cerrar el día?
```

## Language

Default to Spanish. Switch to English if the user asks or if the notes are in English.

## Edge Cases

- **No daily note for today**: Skip the summary section, say "No hay daily note de hoy" and focus on actionables.
- **No actionables created today**: Say so — "No se crearon actionables nuevos hoy."
- **No upcoming deadlines**: Good news — say "No tienes deadlines en los próximos 3 días."
- **Malformed frontmatter**: Skip the file, mention it as a warning at the end.
- **Implicit actionables detection**: Be conservative — only suggest creating actionables for clear action items, not vague mentions. Look for patterns like "tengo que", "hay que", "pendiente", "TODO", "hablar con X sobre", "revisar".

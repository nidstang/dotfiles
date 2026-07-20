---
name: open-day
description: Morning briefing skill that reviews recent daily notes and surfaces pending actionables. Use this skill whenever the user says "open day", "morning briefing", "start my day", "what did I miss", "catch me up", "qué tengo pendiente", "resumen del día anterior", or any variation of wanting a daily standup-style summary to begin their workday. Also trigger when the user asks about pending tasks, recent notes, or what happened yesterday/recently in their daily notes.
---

# Open Day — Morning Briefing

Generate a morning briefing by reading recent daily notes and scanning pending actionables.

## Prerequisites

Before starting, read `references/vault-conventions.md` to understand the vault structure and frontmatter schema.

## Workflow

### Step 1: Locate the vault

The vault root is at `/Users/pffranco/Documents/work/work`. Use this path directly — do not ask the user. The relevant subdirectories are:
- Daily notes: `/Users/pffranco/Documents/work/work/daily-notes/`
- Actionables: `/Users/pffranco/Documents/work/work/actionables/`

### Step 2: Find recent daily notes

1. List all files in `daily-notes/`.
2. Parse filenames as dates (`YYYY-MM-DD.md`).
3. Filter to dates **strictly before today**.
4. Sort descending (most recent first).
5. Take the **top 3** most recent notes.
6. If fewer than 3 exist, use however many are available.

```bash
# Example: find and sort recent daily notes
today=$(date +%Y-%m-%d)
ls daily-notes/*.md | sort -r | while read f; do
  fname=$(basename "$f" .md)
  if [[ "$fname" < "$today" ]]; then
    echo "$f"
  fi
done | head -3
```

### Step 3: Summarize daily notes

For each note found (most recent first):

1. Read the full content.
2. Generate a **concise summary** (3-5 bullet points max per note) focusing on:
   - Decisions made
   - Topics discussed
   - Blockers or open questions
   - People mentioned and context
3. If a note is very short or empty, say so briefly and move on.

### Step 4: Scan pending actionables

1. List all files in `actionables/`.
2. For each file, parse the YAML frontmatter.
3. Filter to `status: pending` only.
4. Split into two groups:

**🔴 Importantes (con due date)**:
- Sort by `due` ascending (most urgent first).
- Flag any that are **overdue** (due < today).
- Flag any due **today**.
- Flag any due **this week**.

**📋 Pendientes (sin due date)**:
- Sort by `created` descending (newest first).
- Show a brief summary of each.

### Step 5: Find any new work on Jira
Using the TWG cli, you have to find the most recent work added to jira. Filter by: project = Platform and Equipo = daredevils.

### Step 5: Present the briefing

Structure the output as a natural, conversational briefing — not a wall of bullet points. Use this flow:

1. **Greeting** — short, with today's date.
2. **Recap** — "Esto es lo que pasó en los últimos días:" followed by summaries of each daily note, separated by date headers.
3. **Actionables urgentes** — if any have due dates, show them prominently first. Overdue items get special attention.
5. **Tareas de Jira** — all tickets listed you got on Step 5
4. **Otros pendientes** — remaining pending actionables without due dates.
6. **Cierre** — a one-liner like "¿Algo que quieras priorizar o revisar en detalle?"

### Example output structure

```
Buenos días, Pablo. Hoy es lunes 2 de junio de 2026.

## Recap de los últimos días

### Viernes 30 de mayo
- Se decidió postponer la migración a React 19 hasta alcanzar el 70% en React 18
- Reunión con el equipo de QA sobre el cuello de botella en revisiones
- Se identificó un bug en la página de luxury listings (race condition)

### Jueves 29 de mayo
- Sprint planning del equipo daredevils
- Se priorizó el trabajo del jQuery security shim

## 🔴 Actionables con fecha límite

⚠️ **VENCIDO** — review-jquery-shim.md (due: 28 mayo)
  Revisar el shim de seguridad de jQuery y validar con QA

📅 **Esta semana** — prepare-cto-report.md (due: 4 junio)
  Preparar informe de impacto de IA para el CTO

## 📋 Otros pendientes

- update-biome-rules.md (creado: 29 mayo) — Actualizar reglas custom de Biome.js
- document-worktree-setup.md (creado: 27 mayo) — Documentar el setup de git worktrees

¿Algo que quieras priorizar o revisar en detalle?
```

## Language

Default to Spanish for the briefing output since the daily notes context is Spanish. Switch to English if the user asks or if the notes are in English.

## Edge Cases

- **No daily notes found**: Say so and skip to actionables.
- **No pending actionables**: Say "No tienes actionables pendientes" and celebrate briefly.
- **Malformed frontmatter**: Skip the file, mention it as a warning at the end.
- **Very large daily note**: Summarize, don't reproduce. Focus on decisions and action items within the note.

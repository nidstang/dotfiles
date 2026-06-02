# Vault Conventions

## Directory Structure

```
vault/
├── daily-notes/      # One file per day
│   ├── 2026-06-01.md
│   ├── 2026-05-30.md
│   └── ...
└── actionables/      # One file per actionable item
    ├── migrate-react-18.md
    ├── review-jquery-shim.md
    └── ...
```

## Daily Notes

- **Location**: `daily-notes/`
- **Filename format**: `YYYY-MM-DD.md` (ISO 8601)
- **Content**: Free-form markdown. May contain meeting notes, decisions, thoughts, links, code snippets, etc.

## Actionables

- **Location**: `actionables/`
- **Filename**: Descriptive slug, e.g. `migrate-react-18.md`
- **Frontmatter schema**:

```yaml
---
status: pending | done | cancelled
due: YYYY-MM-DD        # optional — if present, treat as important/urgent
created: YYYY-MM-DD    # date the actionable was created
tags: [tag1, tag2]     # optional
---
```

### Parsing Rules

1. Read frontmatter between the opening `---` and closing `---`.
2. `status` is required. Only `pending` items are active.
3. `due` is optional. When present, it signals importance — show these prominently and sort by proximity to today.
4. `created` is required. Used to determine when an actionable was created.
5. `tags` is optional. Can be used for filtering but not required by default.
6. Everything after the frontmatter closing `---` is the actionable's body/description in markdown.

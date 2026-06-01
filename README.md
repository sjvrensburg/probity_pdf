# Probity Data Analytics — Quarto PDF template

A Quarto format extension that produces brand-compliant PDF reports for
Probity Data Analytics: navy/gold palette, Calibri type, logo cover page,
running header and footer, and styled tables. Output is PDF via Typst —
no LaTeX installation required.

## Quick start

```bash
cp template.qmd my-report.qmd
quarto render my-report.qmd     # produces my-report.pdf
```

Minimum front matter:

```yaml
---
title: "Report Title"
subtitle: "A short descriptive subtitle"
author: "Author Name, Role"
date: today
format: probity-typst
lang: en-GB
abstract: |
  One short paragraph: what this document is and what it concludes.
---
```

## What's here

| Path | Purpose |
|---|---|
| `_extensions/probity/` | The Quarto format extension (`probity-typst`) |
| `_extensions/probity/typst-template.typ` | Typst template function |
| `_extensions/probity/typst-show.typ` | Pandoc partial wiring front matter |
| `_extensions/probity/assets/` | Probity logo files |
| `template.qmd` | Starter document |
| `SKILL.md` | Full guide: usage, brand rules, writing voice |
| `install.sh` | Installs the extension into another project |

## Using it in another project

### Option A: install script (recommended)

```bash
./install.sh /path/to/target/project                 # report at the project root
./install.sh /path/to/target/project pipeline/docs   # report in a subdirectory
```

Copies `_extensions/probity/` into the target and creates a minimal
`_quarto.yml` if one does not exist. If the report will live in a
**subdirectory**, pass that subdirectory as a second argument — the script then
also places the extension next to the report, which is required for a
subdirectory report to render (see [Required directory
structure](#required-directory-structure)). The default is a copy (portable,
Windows-safe); `--link` makes a relative symlink instead on Unix.

### Option B: manual copy

```bash
cp -r _extensions/probity /path/to/target/project/_extensions/
```

Then set `format: probity-typst` in your document's front matter.

### Required directory structure

A report **at the project root** — beside `_extensions/` and `_quarto.yml` —
renders with no special handling:

```
my-project/
  _quarto.yml              ← marks the project root
  _extensions/
    probity/
  report.qmd               ← format: probity-typst
```

A report in a **subdirectory** is trickier, for two independent reasons:

1. **Discovery.** Quarto finds `_extensions/` by walking up from the `.qmd` only
   as far as the project root (the nearest ancestor with a `_quarto.yml`).
   Without a root `_quarto.yml` — for example after `quarto add`, which does not
   create one — or with an *intermediate* `_quarto.yml` that re-anchors the root
   below `_extensions/`, the render fails with `Unable to read the extension`.
2. **Logo path.** Even when discovery succeeds, the Typst template loads its logo
   via the relative path `_extensions/probity/assets/...`, which Typst resolves
   against the **report's own directory** — not the project root. So a report at
   `pipeline/docs/report.qmd` looks for `pipeline/docs/_extensions/probity/assets/`
   and fails with `file not found ... assets/logo_trim.png`, even with the
   extension correctly installed at the project root.

Because of (2), the reliable layout for a subdirectory report is to **co-locate
the extension with the report**. The install script does this when you pass the
report's subdirectory:

```bash
./install.sh my-project pipeline/docs
```

```
my-project/
  _quarto.yml
  _extensions/
    probity/                 ← project-root copy
  pipeline/
    docs/
      _extensions/
        probity/             ← co-located copy, next to the report
      report.qmd             ← format: probity-typst
```

Use `--link` to symlink the co-located copy back to the project-root one instead
of duplicating it (Unix filesystems only; the script falls back to a copy if a
working symlink cannot be created). Minimal `_quarto.yml`:

```yaml
project:
  title: "My Project"
```

The install script creates this automatically if it is missing.

## Troubleshooting

### `Unable to read the extension 'probity'`

Quarto could not discover `_extensions/` while walking up from the report to
the project root. Usual causes: no `_quarto.yml` at the project root (e.g. after
`quarto add`), or an intermediate `_quarto.yml` in a subdirectory that
re-anchors the root below `_extensions/`. For a report at the project root,
ensure a root `_quarto.yml` exists. For a report in a subdirectory, co-locate
the extension with it: `./install.sh <project> <report-subdir>` (see [Required
directory structure](#required-directory-structure)).

### `file not found ... assets/logo_trim.png`

The Typst template loads its logo via `_extensions/probity/assets/...`, a path
resolved relative to the **report's own directory**. The error means there is no
`_extensions/probity/` *next to the report* — which is always the case for a
report in a subdirectory, even when the extension is installed correctly at the
project root. Co-locate the extension with the report:

```bash
./install.sh <project> <report-subdir>     # e.g. ./install.sh . pipeline/docs
```

Or move the report up to the project root, beside `_extensions/`.

### Font not found (Calibri)

Calibri is a Microsoft font. On Linux the template falls back to Carlito,
then Liberation Sans, then Arial. Install Carlito for the closest match:

```bash
sudo apt-get install fonts-crosextra-carlito   # Debian / Ubuntu
```

### Header and footer missing on page 1

Expected behaviour. The cover page intentionally has no running header or
footer. They appear from page 2 onward.

## Modifying the template

Edit `_extensions/probity/typst-template.typ` (colour constants, font
stacks, layout), then re-render `template.qmd` to confirm. The
`typst-show.typ` file wires front-matter variables into the template
function; only edit it to expose additional variables.

The template targets Typst 0.10 (bundled with Quarto 1.4) and avoids
`context { }` blocks and `table.cell` selectors, which require Typst 0.11+.

See `SKILL.md` for the full brand specification and Probity writing voice.

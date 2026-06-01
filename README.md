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
./install.sh /path/to/target/project
```

Copies `_extensions/probity/` into the target and creates a minimal
`_quarto.yml` if one does not exist.

### Option B: manual copy

```bash
cp -r _extensions/probity /path/to/target/project/_extensions/
```

Then set `format: probity-typst` in your document's front matter.

### Required directory structure

Quarto walks up from the document to the project root to find
`_extensions/`. For documents in subdirectories, two things are required:

1. `_extensions/probity/` is a direct child of the project root.
2. A `_quarto.yml` exists at the project root (even a minimal one).

```
my-project/
  _quarto.yml              ← required: marks the project root
  _extensions/
    probity/
      _extension.yml
      typst-template.typ
      typst-show.typ
      assets/
  pipeline/
    docs/
      report.qmd           ← format: probity-typst
```

Minimal `_quarto.yml`:

```yaml
project:
  title: "My Project"
```

The install script creates this automatically if it is missing.

## Troubleshooting

### `Unable to read the extension 'probity'`

Missing `_quarto.yml` at the project root. See the directory structure
above. The install script creates one; if you copied the extension
manually, create it yourself.

### `file not found ... assets/logo_trim.png`

The `_extensions/probity/` directory is not a direct child of the project
root. The Typst compiler resolves image paths relative to the project root,
so the extension must live at `<root>/_extensions/probity/`. Re-run
`install.sh` from the correct root.

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

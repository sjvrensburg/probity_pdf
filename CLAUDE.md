# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A Quarto format extension (`probity-typst`) that produces branded A4 PDFs for Probity Data Analytics. Authors write `.qmd` files with `format: probity-typst`; the extension supplies all chrome (cover page, header, footer, headings, tables, blockquotes). Output is PDF via Typst — no LaTeX required.

## Key commands

```bash
# Render the starter template (smoke-test the extension)
quarto render template.qmd

# Visual check — convert PDF to images and inspect
pdftoppm -png -r 90 template.pdf build/pg

# Install the extension into another project
./install.sh /path/to/target/project
```

## Architecture

The extension is a Quarto **format extension** in `_extensions/probity/`.

- `_extension.yml` — registers `probity-typst` as a Typst-based format with default options (TOC depth 3, fig/tbl caption locations).
- `typst-template.typ` — pure Typst file defining `probity-report(...)`, the template function. Contains all brand constants (colours, fonts), page geometry, running header/footer, title page layout, and show rules for headings, tables, blockquotes, and code.
- `typst-show.typ` — Pandoc template partial (uses `$...$` variable syntax). Quarto substitutes front-matter values here and generates the `#show: doc => probity-report(...)` call that wraps the document body.

**Rendering pipeline:** Quarto converts `.qmd` → Pandoc → `<file>.typ` (with the template inlined) → Typst compiler → `<file>.pdf`. The template contents are inlined verbatim into the generated `.typ` at the project root, so all image paths in `typst-template.typ` must be relative to the project root (i.e. `_extensions/probity/assets/logo_trim.png`, not `assets/logo_trim.png`).

## Typst 0.10 constraint

Quarto 1.4 bundles Typst 0.10. The template must avoid:
- `context { }` blocks — use `locate(loc => ...)` instead for page-aware content.
- `table.cell` selectors — not available until Typst 0.11.
- `align:` as a `grid()` parameter — apply `align(...)` inside each cell instead.

## Extension discovery requirement

Quarto walks up from the document to find `_extensions/`. When documents are in subdirectories, a `_quarto.yml` must exist at the project root, otherwise rendering fails with "Unable to read the extension 'probity'". `install.sh` creates a minimal one automatically.

## Brand reference

| Token | Hex |
|---|---|
| Primary navy | `#0A325A` |
| Deep navy | `#062340` |
| Mid blue | `#4A7BA8` |
| Pale blue tint | `#E8EEF5` |
| Gold accent | `#C8881F` |
| Body text | `#1F2937` |
| Muted text | `#6B7280` |
| Rule / hairline | `#D5DEE9` |

Primary font: Calibri (Carlito → Liberation Sans → Arial fallback). Mono: Consolas.

See `SKILL.md` for the full Probity writing voice and agent workflow.

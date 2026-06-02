# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A Quarto format extension providing two branded PDF formats for Probity Data Analytics:

- **`probity-typst`** — A4 report (cover page, TOC, running header/footer). Output via Typst — no LaTeX required.
- **`probity-beamer`** — 16:9 slide deck (navy/gold, Carlito). Output via XeLaTeX/Beamer. Design aligned with the GRAP104 PowerPoint master.

## Key commands

```bash
# Render the report starter template
quarto render template.qmd

# Render the slide deck starter template
quarto render template-slides.qmd

# Visual check — convert PDF to images and inspect
pdftoppm -png -r 90 template.pdf build/pg
pdftoppm -png -r 144 template-slides.pdf build/slides-pg

# Install the extension into another project
./install.sh /path/to/target/project
```

## Architecture

The extension is a Quarto **format extension** in `_extensions/probity/`.

### Report format (`probity-typst`)

- `_extension.yml` — registers both formats; `typst:` section sets TOC depth, caption locations.
- `typst-template.typ` — pure Typst file defining `probity-report(...)`. Contains brand constants, page geometry, running header/footer, title page, and show rules. Also defines the `probity-grouped-table(...)` helper for row-grouped tables (callable from raw `{=typst}` blocks; markdown pipe tables can't express row groups). See README → "Grouped tables".
- `typst-show.typ` — Pandoc partial wiring front-matter into `probity-report(...)`. Passes `authors` straight through to `document.author` (an empty array means no author — do not `.join()` it, an empty join yields `none` and fails compilation).

### Slide format (`probity-beamer`)

- `_extension.yml` — `beamer:` section: xelatex, 16:9, Carlito via `sansfont:`, `format-resources` for asset delivery.
- `probity-beamer.sty` — complete Beamer theme. Do NOT call `\setsansfont` here (Quarto handles it via `font-settings.latex`).
- Assets (`logo_white.png`, `logo_navy_small.png`) are copied by `format-resources` to the document directory at render time — reference by basename only in the `.sty`.

**Slide layout (aligned with GRAP104 PPTX master):**
- Content slides: white background, running `logo_navy_small` + `#D5DEE9` hairline rule at top, 18pt bold navy title text — **no coloured title bar**.
- Navy slides (title page, section dividers): full `#0A325A` background, 2.2mm gold vertical bar at left edge, left-aligned title at 32% from top, short gold rule at 73%, subtitle in gold `#C8881F`.

**Section divider slides** use `{.plain}` on the `##` heading (suppresses headline/footline via Beamer) with `\ProbSectionContent{title}{subtitle}` in a raw LaTeX block:
```markdown
## {.plain}

```{=latex}
\ProbSectionContent{Part One: Findings}{}
\ProbSectionContent{Part Two: Method}{How we built it}
```
```

**Rendering pipeline:** Quarto converts `.qmd` → Pandoc → `<file>.typ` (with the template inlined) → Typst compiler → `<file>.pdf`. The template contents are inlined verbatim into the generated `.typ` at the project root, so all image paths in `typst-template.typ` must be relative to the project root (i.e. `_extensions/probity/assets/logo_trim.png`, not `assets/logo_trim.png`).

## Typst version

Quarto 1.9 bundles Typst 0.14. Page-aware content (the running header/footer and
"Page X of Y") uses `context { ... }` with `counter(page).get()` and
`counter(page).final()`. The old `locate(loc => ...)` callback form was removed
after Typst 0.10 and must not be reintroduced. The minimum supported toolchain is
Quarto 1.5 / Typst 0.11 — the first release with `context` — pinned via
`quarto-required: ">=1.5.0"` in `_extension.yml`.

Quarto now emits `table.header(...)` for table header rows, so a header repeats
automatically when a table spans a page break. The `set table(fill: ...)` rule in
`typst-template.typ` fills the header (row 0) with the hairline blue and
zebra-stripes the body; that logic is unaffected by the semantic header markup.

## Extension discovery requirement

Quarto discovers `_extensions/` by walking up from the document only as far as the project root (the nearest ancestor with a `_quarto.yml`). A report in a subdirectory hits two distinct failures:

1. **Discovery** — no root `_quarto.yml` (e.g. after `quarto add`), or an intermediate `_quarto.yml` that re-anchors the root below `_extensions/`, gives "Unable to read the extension 'probity'". `install.sh` creates a minimal root `_quarto.yml` automatically.
2. **Logo path** — `typst-template.typ` loads its logo via the relative path `_extensions/probity/assets/...`, which Typst resolves against the *document's* directory. A subdirectory report therefore fails with "file not found ... assets/logo_trim.png" even when the extension is installed at the project root.

Both are fixed by co-locating the extension with the report: `install.sh <project> <report-subdir>` copies `_extensions/probity/` next to the report (`--link` symlinks instead on Unix). Reports at the project root need none of this. See `README.md` → "Required directory structure".

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

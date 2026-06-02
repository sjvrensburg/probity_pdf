# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

Branded Quarto formats for Probity Data Analytics — both output via Typst, no LaTeX required:

- **`probity-typst`** — A4 report (cover page, TOC, running header/footer). Extension dir `_extensions/probity/`.
- **`probity-slides-typst`** — 16:9 slide deck (navy/gold, Carlito) with a card-component library. Extension dir `_extensions/probity-slides/`.

(A legacy XeLaTeX `probity-beamer` deck was removed in v2.0.0 — see git history if ever needed.)

## Key commands

```bash
# Render the report starter template
quarto render template.qmd

# Render the slide deck starter template
quarto render template-slides.qmd

# Visual check — convert PDF to images and inspect
pdftoppm -png -r 90 template.pdf build/pg
pdftoppm -png -r 110 template-slides.pdf build/slides-pg

# Install the report extension into another project
./install.sh /path/to/target/project
```

## Architecture

The extension lives in two directories: `_extensions/probity/` (report) and `_extensions/probity-slides/` (Typst slides).

### Report format (`probity-typst`)

- `_extension.yml` — registers both formats; `typst:` section sets TOC depth, caption locations.
- `typst-template.typ` — pure Typst file defining `probity-report(...)`. Contains brand constants, page geometry, running header/footer, title page, and show rules. Also defines the `probity-grouped-table(...)` helper for row-grouped tables (callable from raw `{=typst}` blocks; markdown pipe tables can't express row groups). See README → "Grouped tables".
- `typst-show.typ` — Pandoc partial wiring front-matter into `probity-report(...)`. Passes `authors` straight through to `document.author` (an empty array means no author — do not `.join()` it, an empty join yields `none` and fails compilation). Also wires the optional `header-text` / `footer-text` / `footer-note` keys (running header/footer text). Pass these as **content** (`[$footer-note$]`), not strings — Pandoc encodes em dashes etc. as Typst markup (`---`), which only converts inside content, not a string literal. Defaults live in the `probity-report` signature and are kept via `$if$` (omitted key → signature default). `header-text`/`footer-text` default to the brand text. `footer-note` defaults to `[]` (empty) and is rendered only when `footer-note != []`, so **omitting it hides the classification** — the starter `template.qmd` sets `Confidential`. (Pandoc also trims whitespace-only values to empty, so `footer-note: ""` hides it too.)

### Slide format (`probity-slides-typst`)

Dependency-free, **page-based** Typst slides (no Touying/polylux). Lives in `_extensions/probity-slides/`.

- `_extension.yml` — registers a `typst` format (`presentation-16-9`). Referenced as `format: probity-slides-typst` (the short `probity-slides` does **not** resolve).
- `typst-template.typ` — defines `probity-slides(...)` plus the slide/card helpers. Mechanism:
  - `set page(paper: "presentation-16-9", footer:)` draws the running footer on every content slide (suppressed on page 1, the title slide). The footer is a three-cell grid: `footer-text` brand + optional `footer-note` (left), `footer-center` running title (centre), page number (right). Top margin is small (~0.85 cm) so the frame title sits near the top edge.
  - `show heading.where(level: 1): it => { pagebreak(weak: true); <frame title left + logo right + hairline> }` — **each `##` starts a new white content slide**, with the frame title and logo above a hairline. **Note the level:** Quarto normalises the deck's shallowest heading (`##`) to Typst **level 1**, so the rule targets level 1, and `###` (Typst level 2) is the subtitle. Author convention: use `##` for every slide; introducing a `#` shifts the normalisation and breaks the rules.
  - Full-bleed navy slides (title, section dividers, navy content) are produced by `#page(fill: navy, margin: 0pt, header: none, footer: none)` inside the `_navy-canvas` helper — a `page()` call mid-document yields isolated pages with their own chrome, and the page counter keeps incrementing so footers stay correct.
- `typst-show.typ` — wires front matter (`title`, `subtitle`, `authors`, `date`, `footer-text`, `footer-note`, `footer-center`) into `probity-slides(...)`. Footer text is passed as **content** (`[$footer-note$]`) so punctuation renders; `footer-text`/`footer-note`/`footer-center` mirror the report's footer keys (`footer-note` is hidden when omitted/empty).
- `assets/` — own copy of the logos; referenced as `_extensions/probity-slides/assets/...` (resolved against the document dir, like the report).

**Authoring model (two modes):**
- Plain text/bullet slide → `## Title` + markdown. The heading show-rule renders the slide.
- Any slide with cards or a full-navy background → a raw ` ```{=typst} ` block calling a helper (`prob-section`, `prob-navy-slide`, `prob-scenario-cards`, `prob-steps`, `prob-formula-card`, `prob-result-card`, `prob-metric-cards`, `prob-equation-box`, `prob-cols`, `prob-measure`). These give a hard one-page boundary and `v(1fr)` space-between layout.

**One-page caveat:** there is no auto-fit. Content slides flow; if a component is taller than the ~13.2 cm body it silently spills onto the next page. To detect overflow during editing, wrap content in `prob-measure([ ... ])`, which displays a red warning box if content exceeds the safe height. Card helpers take a `height:` parameter and ship with conservative defaults sized to fit. `height: 100%` inside an auto grid row resolves against the *page* (not the sibling column) and overflows — pass an explicit `cm` height to balance two-column slides instead. Quarto's native `::: {.columns}` does **not** produce side-by-side layout in Typst output; use the `prob-cols(left, right, ratio:)` helper.

**Bold text on navy backgrounds (issue #6):** Bold text (`*word*` or `**text**`) on navy-background slides (title slide, `prob-section`, `prob-navy-slide`) now renders in white for visibility. The global show rule for `strong` is overridden within `_navy-canvas` so navy-on-navy is avoided.

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

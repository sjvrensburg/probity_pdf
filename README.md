# Probity Data Analytics — Quarto PDF templates

A Quarto format extension providing two branded PDF output formats for
Probity Data Analytics: navy/gold palette, Calibri type, and Probity
visual identity.

| Format | Output | Engine | Use for |
|---|---|---|---|
| `probity-typst` | A4 report | Typst (no LaTeX) | Written reports, methodology, deliverables |
| `probity-beamer` | 16:9 slides | XeLaTeX + Beamer | Client presentations, slide decks |

## Quick start

### Report

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

### Slide deck

```bash
cp template-slides.qmd my-slides.qmd
quarto render my-slides.qmd     # produces my-slides.pdf
```

Minimum front matter:

```yaml
---
title: "Presentation Title"
subtitle: "A short descriptive subtitle"
author: "Author Name, Role"
date: today
format: probity-beamer
lang: en-GB
---
```

## What's here

| Path | Purpose |
|---|---|
| `_extensions/probity/` | The Quarto format extension |
| `_extensions/probity/_extension.yml` | Format definitions (`probity-typst`, `probity-beamer`) |
| `_extensions/probity/typst-template.typ` | Typst template function (report) |
| `_extensions/probity/typst-show.typ` | Pandoc partial wiring front matter (report) |
| `_extensions/probity/probity-beamer.sty` | Beamer theme (slides) |
| `_extensions/probity/assets/` | Probity logo files |
| `template.qmd` | Starter report document |
| `template-slides.qmd` | Starter slide deck |
| `SKILL.md` | Full guide: usage, brand rules, writing voice |
| `install.sh` | Installs the extension into another project |

## Using it in another project

### Option A: install script (recommended)

```bash
./install.sh /path/to/target/project                 # document at the project root
./install.sh /path/to/target/project pipeline/docs   # document in a subdirectory
```

Copies `_extensions/probity/` into the target and creates a minimal
`_quarto.yml` if one does not exist. If the document will live in a
**subdirectory**, pass that subdirectory as a second argument — the script then
also places the extension next to the document, which is required for a
subdirectory document to render (see [Required directory
structure](#required-directory-structure)). The default is a copy (portable,
Windows-safe); `--link` makes a relative symlink instead on Unix.

### Option B: manual copy

```bash
cp -r _extensions/probity /path/to/target/project/_extensions/
```

Then set `format: probity-typst` or `format: probity-beamer` in your
document's front matter.

### Required directory structure

A document **at the project root** — beside `_extensions/` and `_quarto.yml` —
renders with no special handling:

```
my-project/
  _quarto.yml              ← marks the project root
  _extensions/
    probity/
  report.qmd               ← format: probity-typst  (or probity-beamer)
```

A document in a **subdirectory** is trickier, for two independent reasons:

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

Because of (2), the reliable layout for a subdirectory document is to **co-locate
the extension with the document**. The install script does this when you pass the
document's subdirectory:

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
        probity/             ← co-located copy, next to the document
      report.qmd             ← format: probity-typst  (or probity-beamer)
```

Use `--link` to symlink the co-located copy back to the project-root one instead
of duplicating it (Unix filesystems only; the script falls back to a copy if a
working symlink cannot be created). Minimal `_quarto.yml`:

```yaml
project:
  title: "My Project"
```

The install script creates this automatically if it is missing.

## Authoring reports

### Grouped tables (row groups)

Markdown pipe tables cannot express grouped rows (the `kableExtra::pack_rows` /
`gt` row-group look). For those, call the `probity-grouped-table` helper from a
raw `{=typst}` block. It draws booktabs-style navy rules, bolds the header, and
renders each group as a full-width bold label with its rows indented beneath:

````markdown
```{=typst}
#probity-grouped-table(
  columns: (auto, auto, auto, auto, auto, auto, auto),
  align: (left, right, right, right, right, right, right),
  header: ([], [mpg], [cyl], [disp], [hp], [drat], [wt]),
  ungrouped: (
    ([Mazda RX4],     [21.0], [6], [160.0], [110], [3.90], [2.620]),
    ([Datsun 710],    [22.8], [4], [108.0], [93],  [3.85], [2.320]),
  ),
  groups: (
    (name: "Group 1", rows: (
      ([Hornet 4 Drive], [21.4], [6], [258.0], [110], [3.08], [3.215]),
      ([Valiant],        [18.1], [6], [225.0], [105], [2.76], [3.460]),
    )),
    (name: "Group 2", rows: (
      ([Merc 240D], [24.4], [4], [146.7], [62], [3.69], [3.190]),
      ([Merc 230],  [22.8], [4], [140.8], [95], [3.92], [3.150]),
    )),
  ),
)
```
````

- `header` — column headings (bolded for you); pass `none` to omit.
- `ungrouped` — rows shown above the first group; omit for none.
- `groups` — a list of `(name: "…", rows: (…))` dictionaries.

The helper deliberately resets the report's zebra-stripe fill so the grouped
layout reads cleanly. If you hand-build a grouped `#table` instead of using the
helper, pass `fill: none` yourself for the same reason.

## Authoring slides

### Slide sections

Use a `## {.plain}` heading followed by a raw LaTeX block to insert a
full-navy section divider slide:

```markdown
## {.plain}

```{=latex}
\ProbSectionContent{Part One: Findings}{}
\ProbSectionContent{Part Two: Method}{How we built it}
```
```

The first argument is the section title; the second is an optional subtitle
(leave empty `{}` to omit). The `{.plain}` attribute suppresses the running
header and footer so the TikZ navy background fills the entire slide.

### Closing slide

Use a plain `## Closing` heading and add raw LaTeX for the centred content:

```markdown
## Closing

\vspace{1.2cm}

\begin{center}
{\large\color{probitynavy}\textbf{Thank you}}

\vspace{0.4cm}

{\normalsize\color{probitymuted}Questions and discussion}
\end{center}
```

## Troubleshooting

### `Unable to read the extension 'probity'`

Quarto could not discover `_extensions/` while walking up from the document to
the project root. Usual causes: no `_quarto.yml` at the project root (e.g. after
`quarto add`), or an intermediate `_quarto.yml` in a subdirectory that
re-anchors the root below `_extensions/`. For a document at the project root,
ensure a root `_quarto.yml` exists. For a document in a subdirectory, co-locate
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

### Beamer package not installed

On first render, Quarto attempts to install `beamer.cls` automatically via
TinyTeX. If auto-install is disabled, install it manually:

```bash
tlmgr install beamer
```

### Font not found (Calibri / Carlito)

**Report (`probity-typst`):** Calibri is a Microsoft font. On Linux the template
falls back to Carlito, then Liberation Sans, then Arial.

**Slides (`probity-beamer`):** the theme requires Carlito (the metric-compatible
Calibri substitute). Install it:

```bash
sudo apt-get install fonts-crosextra-carlito   # Debian / Ubuntu
```

### Header and footer missing on page 1 (report)

Expected behaviour. The cover page intentionally has no running header or
footer. They appear from page 2 onward.

### Header missing on section divider slides

Expected behaviour. Section divider slides use `{.plain}`, which suppresses the
running header and footer via Beamer's built-in mechanism, leaving only the TikZ
navy background.

## Modifying the templates

**Report:** edit `_extensions/probity/typst-template.typ` (colour constants,
font stacks, layout), then re-render `template.qmd` to confirm. The
`typst-show.typ` file wires front-matter variables into the template function;
only edit it to expose additional variables.

The template targets Typst 0.10 (bundled with Quarto 1.4) and avoids
`context { }` blocks and `table.cell` selectors, which require Typst 0.11+.

**Slides:** edit `_extensions/probity/probity-beamer.sty` (colour definitions,
headline/footline templates, title page and section divider TikZ). Do **not**
call `\setsansfont` inside the `.sty` — Quarto's `font-settings.latex` partial
handles this via the `sansfont: Carlito` option in `_extension.yml`, and a
double call causes a fontspec error.

See `SKILL.md` for the full brand specification and Probity writing voice.

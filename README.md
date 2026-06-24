# Probity Data Analytics — Quarto PDF templates

Branded Quarto formats for Probity Data Analytics: navy/gold palette,
Calibri type, and Probity visual identity.

| Format | Output | Engine | Use for |
|---|---|---|---|
| `probity-typst` | A4 report | Typst (no LaTeX) | Written reports, methodology, deliverables |
| `probity-slides-typst` | 16:9 slides | Typst (no LaTeX) | Client presentations, slide decks |
| `probity-invoice-typst` | A4 invoice | Typst (no LaTeX) | Branded invoices (single page, YAML-driven) |

The slide deck ships a card-component library (scenario cards, numbered
steps, formula / result cards, metric rows, equation boxes) — see
[Authoring slides](#authoring-slides).

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

The running header and footer text (from page 2 onward) can be set from the
front matter:

```yaml
header-text: "Data Analytics"          # right of the logo (omit → default)
footer-text: "Probity Data Analytics"  # bold navy brand at the foot, left (omit → default)
footer-note: "Confidential"            # muted classification (e.g. "Draft", "Public")
```

`header-text` and `footer-text` fall back to their brand defaults when omitted.
`footer-note` is optional — **omit it (or set it empty) to show no
classification** at all; the starter template sets `"Confidential"`.

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
format: probity-slides-typst
footer-text: "Probity Data Analytics"        # footer brand, bold navy (left); omit → default
footer-note: "Confidential"                  # classification after the brand; omit/empty to hide
footer-center: "GRAP 104 forward-looking α"  # centre running title; omit → none
lang: en-GB
---
```

The footer keys are all optional:

- `footer-text` — footer brand text, bold navy, at the foot left. Omit → the
  default "Probity Data Analytics".
- `footer-note` — optional muted classification shown after the brand (e.g.
  "Confidential", "Draft", "Public"). Omit it (or set it empty) to show no
  classification. Same behaviour as the report's `footer-note`.
- `footer-center` — optional centre running title in the footer (e.g. the deck
  topic, "GRAP 104 forward-looking α"). Omit → none.

> **Renamed key.** `footer-center` was previously called `footer-text`, which
> used to mean the centre running title. `footer-text` now means the footer
> brand, so `footer-text` and `footer-note` mean the same thing in both the
> report and the slides.

> The format name is `probity-slides-typst` (the short `probity-slides`
> does not resolve).

### Invoice

```bash
cp template-invoice.qmd my-invoice.qmd
quarto render my-invoice.qmd     # produces my-invoice.pdf
```

The invoice is **entirely front-matter driven** — every field renders from
YAML and the body is empty. Money values are **bare numeric strings** (no
symbol, no thousands separator) so cents survive the YAML→Typst pipeline; the
template parses them and formats with thousands separators. Quantities may be
whole or fractional.

```yaml
---
format: probity-invoice-typst
lang: en-GB
company-name: "Probity Data Analytics"
company-address: |
  Suite 12, Riverside Court
  Cape Town, 8001
company-phone: "+27 21 555 0142"
company-email: "accounts@probity.example"
invoice-number: "INV-2026-014"
issue-date: "23 June 2026"
due-date: "23 July 2026"
terms: "Net 30"
customer-id: "CUST-0042"
client-name: "Northwind Traders (Pty) Ltd"
client-address: |
  42 Quarry Industrial Park
  Durban, 4001
items:
  - description: "Consulting — June"
    qty: 16
    unit: "2500.00"        # money string; amount = qty × unit (auto)
discount: "5000.00"        # money string; omit / "0" to hide the row
tax-rate: 0.15             # fraction; omit / 0 to hide the row
tax-label: "VAT"           # shown as "VAT (15%)"
currency: "R"
invoice-notes: "All amounts in ZAR."   # note: 'notes' is reserved by Quarto — use 'invoice-notes'
bank-holder: "Probity Data Analytics (Pty) Ltd"
bank-account: "62345678901"
bank-name: "First National Bank"
bank-branch-code: "250655"
bank-reference: "INV-2026-014"
footer-email: "accounts@probity.example"
---
```

The format name is `probity-invoice-typst` (the short `probity-invoice` does
not resolve). Single A4 page; the bank-transfer footer is pinned to the page
bottom. There is no auto-pagination — a very long item list will spill onto a
second page.

## What's here

| Path | Purpose |
|---|---|
| `_extensions/probity/` | Report extension |
| `_extensions/probity/typst-template.typ` | Typst template function (report) |
| `_extensions/probity-slides/` | Typst slide-deck extension |
| `_extensions/probity-slides/typst-template.typ` | Slide template + card-component library |
| `_extensions/probity-invoice/` | Typst invoice extension |
| `_extensions/probity-invoice/typst-template.typ` | Invoice template + money/totals helpers |
| `template.qmd` | Starter report document |
| `template-slides.qmd` | Starter slide deck (Typst) |
| `template-invoice.qmd` | Starter invoice (Typst) |
| `SKILL.md` | Full guide: usage, brand rules, writing voice |
| `install.sh` | Installs the report extension into another project |

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

Then set `format: probity-typst` in your document's front matter.

### Required directory structure

A document **at the project root** — beside `_extensions/` and `_quarto.yml` —
renders with no special handling:

```
my-project/
  _quarto.yml              ← marks the project root
  _extensions/
    probity/
  report.qmd               ← format: probity-typst
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

The Typst deck (`probity-slides-typst`) has **two authoring modes**:

1. **Plain slides** — a `## Heading` starts a new white content slide; write
   normal Markdown (bullets, text, `###` subtitle) beneath it.
2. **Card / navy slides** — call a helper from a raw ` ```{=typst} ` block.
   The brand colours (`probity-navy`, `probity-gold`, `probity-green`, …) and
   all helpers are in scope inside these blocks.

Title slide, author and the footer come from the YAML front matter
(`title`, `subtitle`, `author`, `date`, `footer-text`, `footer-note`,
`footer-center`).

> **Keep one slide to one page.** There is no auto-fit: content that is taller
> than the body silently spills onto the next page. Every card helper takes a
> `height:` parameter and ships with defaults sized to fit; trim text or lower
> the height if a slide overflows.

### Section divider (full navy)

```{=typst}
#prob-section("Part One", subtitle: "The Model")
```

### Navy content slide

A full-navy slide that still carries the logo, hairline and title — host for
equation boxes and metric cards:

```{=typst}
#prob-navy-slide("The model", subtitle: "A linear regression …")[
  #prob-equation-box[Loss Rate#sub[t] = β#sub[0] + β#sub[1] · (Gap)#sub[t−1] + ε]
  #v(0.5cm)
  #prob-metric-cards((
    (label: "Intercept",   value: [β#sub[0] = +0.0861],  desc: [Baseline loss rate.]),
    (label: "Macro slope", value: [β#sub[1] = +0.00862], desc: [Stress up, losses up.]),
    (label: "Fit",         value: [R#super[2] = 0.97],   desc: [Post-COVID, n = 4.]),
  ))
]
```

### Scenario cards (white slide)

A row of equal-height cards, each with a coloured accent bar:

```{=typst}
#prob-scenario-cards((
  (accent: probity-green,    label: "Strong Growth", meta: [GDP +3 % · gap 0],  value: [α = 0.85], desc: [Held at the 0.85 floor.]),
  (accent: probity-mid-blue, label: "Steady",        meta: [GDP +1 % · gap 4],  value: [α = 1.00], desc: [Matrix unchanged.]),
  (accent: probity-gold,     label: "Downturn",      meta: [GDP −1 % · gap 8],  value: [α = 1.28], desc: [Matrix lifted ~28 %.]),
  (accent: probity-red,      label: "Severe Stress", meta: [GDP −3 % · gap 13], value: [α = 1.45], desc: [Held at the 1.45 cap.]),
))
```

### Numbered steps + formula card (two columns)

`prob-cols(left, right, ratio:)` lays out two columns (Quarto's `::: {.columns}`
does **not** work in Typst output). `prob-formula-card` aligns `name = expr`
mono lines:

```{=typst}
#prob-cols(
  prob-steps((
    (title: [Read the macros], body: [SARB GDP growth and Stats SA CPI YoY.]),
    (title: [Form the gap],    body: [ig_gap is the simple subtraction.]),
  )),
  prob-formula-card(
    (
      ([ig_gap],         [cpi_yoy − gdp_growth]),
      ([predicted_loss], [0.0861 + 0.00862 × ig_gap]),
    ),
    note: [Excel-style; substitute last year's values.],
    footnote: [0.0861 = β₀ · 0.00862 = β₁],
    height: 7.7cm,
  ),
  ratio: (1fr, 1.1fr),
)
```

### Result card

```{=typst}
#prob-result-card(
  [α = 0.89],
  label: "Result",
  desc: [Inflation eased while growth stayed weak.],
  footnote: [The matrix scales down by about 11 %.],
  height: 7.7cm,
)
```

The full set of helpers — `prob-section`, `prob-navy-slide`,
`prob-scenario-cards`, `prob-metric-cards`, `prob-steps`, `prob-formula-card`,
`prob-result-card`, `prob-equation-box`, `prob-cols` — is defined and commented
in `_extensions/probity-slides/typst-template.typ`. `template-slides.qmd` shows
every one in context.

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

### Font not found (Calibri / Carlito)

**Report (`probity-typst`):** Calibri is a Microsoft font. On Linux the template
falls back to Carlito, then Liberation Sans, then Arial.

**Slides (`probity-slides-typst`):** the theme requires Carlito (the
metric-compatible Calibri substitute). Install it:

```bash
sudo apt-get install fonts-crosextra-carlito   # Debian / Ubuntu
```

### Header and footer missing on page 1 (report)

Expected behaviour. The cover page intentionally has no running header or
footer. They appear from page 2 onward.

## Modifying the templates

**Report:** edit `_extensions/probity/typst-template.typ` (colour constants,
font stacks, layout), then re-render `template.qmd` to confirm. The
`typst-show.typ` file wires front-matter variables into the template function;
only edit it to expose additional variables.

The report template targets Typst 0.11+ (Quarto 1.5+) and uses `context { }`
blocks for the page-aware running header/footer and `table.cell` /
`table.header` selectors; `_extension.yml` pins `quarto-required: ">=1.5.0"`.
The slide deck uses newer Typst features (single-argument `measure`, `stroke`
`rest:` keys) and targets Typst 0.13+ (Quarto 1.7+), pinned accordingly.

**Slides:** edit `_extensions/probity-slides/typst-template.typ` — brand
constants, the `probity-slides()` page/chrome function, and the card helpers.
Re-render `template-slides.qmd` to confirm. The `typst-show.typ` file wires
front-matter variables into the template function; only edit it to expose
additional variables.

See `SKILL.md` for the full brand specification and Probity writing voice.

---
name: probity-quarto
description: "Create branded PDF outputs for Probity Data Analytics using the Quarto extension in this repository. Use this skill whenever the user asks to write, draft, restyle, or produce a Probity PDF report or slide deck from Quarto or Markdown: methodology write-ups, technical reports, audit-trail documents, memos, proposals, client deliverables, presentations, or anything that will leave the studio under the Probity name. Trigger it even when the user only says 'make a Probity report', 'use our PDF template', 'apply our branding', or attaches a Quarto/Markdown file to convert. Output is always a PDF file (not Word/docx). Formats: probity-typst (A4 report, no LaTeX) and probity-slides-typst (16:9 slides, no LaTeX, with a card-component library); probity-beamer is a legacy XeLaTeX slide deck superseded by probity-slides-typst. It pins down the navy/gold palette, Calibri type, Probity visual identity, and the Probity writing voice."
---

# Probity Data Analytics — Quarto PDF templates (agent guide)

This skill produces brand-compliant PDF outputs for Probity Data Analytics
through Quarto:

| Format | Output | Engine | Use for |
|---|---|---|---|
| `probity-typst` | A4 report | Typst — no LaTeX required | Written reports, methodology, deliverables |
| `probity-slides-typst` | 16:9 slides | Typst — no LaTeX required | Client presentations, slide decks |
| `probity-beamer` | 16:9 slides | XeLaTeX + Beamer | Legacy — superseded by `probity-slides-typst` |

The extension lives at `/home/stefan/Documents/probity_pdf/` (the
`probity_pdf` repository). When working in an external project, install it
there with `install.sh` before rendering.

---

## Agent workflow — step by step

Follow these steps in order every time you produce or modify a Probity PDF.

### Step 1 — Establish the working project

Determine whether the document lives inside the `probity_pdf` repo or in a
separate project.

**Inside `probity_pdf`** (the `.qmd` is in `/home/stefan/Documents/probity_pdf/`
or a subdirectory): the extension is already present. Skip to step 3.

**External project** (anywhere else): proceed to step 2.

### Step 2 — Install the extension

Check whether the extension is already installed:

```bash
ls <project-root>/_extensions/probity/_extension.yml 2>/dev/null \
  && echo "already installed" || echo "needs install"
```

If missing, install it:

```bash
/home/stefan/Documents/probity_pdf/install.sh <project-root>

# If the report will live in a subdirectory, pass it as a second argument so
# the extension is co-located with the report (required — see below):
/home/stefan/Documents/probity_pdf/install.sh <project-root> pipeline/docs
```

The script copies `_extensions/probity/` into the target and creates a
minimal `_quarto.yml` at the project root if one does not exist. Both are
required. Confirm after:

```bash
ls <project-root>/_extensions/probity/_extension.yml   # must exist
ls <project-root>/_quarto.yml                          # must exist
```

**Critical: subdirectory reports need the extension co-located.** A report at
the project root renders with no special handling. A report in a *subdirectory*
hits two problems: (1) Quarto only discovers `_extensions/` by walking up to the
project root, so a missing or intermediate `_quarto.yml` yields "Unable to read
the extension 'probity'"; and (2) the Typst template loads its logo via
`_extensions/probity/assets/...`, a path resolved relative to the **report's own
directory**, so a subdirectory report fails with "file not found ...
logo_trim.png" even when the extension is installed at the project root. Both are
fixed by co-locating the extension with the report — pass the report subdirectory
to `install.sh` as shown above (it copies by default; `--link` symlinks on Unix).
Prefer keeping reports at the project root when you can.

### Step 3 — Write or update the `.qmd`

If starting fresh, copy the appropriate starter document:

```bash
# Report
cp /home/stefan/Documents/probity_pdf/template.qmd <project-root>/my-report.qmd

# Slide deck
cp /home/stefan/Documents/probity_pdf/template-slides.qmd <project-root>/my-slides.qmd
```

**Report front matter** (`format: probity-typst`):

```yaml
---
title: "Document Title"
subtitle: "A short descriptive subtitle"
author: "Author Name, Role"
date: today
format: probity-typst
lang: en-GB
abstract: |
  One short paragraph: what this document is and what it concludes.
  Lead with the answer, then the qualification.
---
```

| Field | Effect | Required |
|---|---|---|
| `title` | Large navy heading on cover page (30pt bold) | Yes |
| `subtitle` | Mid-blue line below title (16pt) | Recommended |
| `author` | Muted text left of the cover hairline | Recommended |
| `date` | Muted text right of the cover hairline; use `today` for auto | Recommended |
| `format` | Must be `probity-typst` | Yes |
| `lang` | Document language; use `en-GB` for Probity | Recommended |
| `abstract` | Pale-tint block with navy left border on cover | Recommended |
| `toc` | `true` (default) shows a Contents page; set `false` to suppress | Optional |

**Slide deck front matter** (`format: probity-slides-typst`):

```yaml
---
title: "Presentation Title"
subtitle: "A short descriptive subtitle"
author: "Author Name, Role"
date: today
format: probity-slides-typst
footer-text: "Optional centre-footer running title"
lang: en-GB
---
```

| Field | Effect | Required |
|---|---|---|
| `title` | Bold white title on the navy title slide | Yes |
| `subtitle` | Gold subtitle below title on the title slide | Recommended |
| `author` | Light-blue author line near the bottom of the title slide | Recommended |
| `date` | Appended to author, separated by a pipe | Recommended |
| `footer-text` | Centre-footer running title on content slides | Optional |
| `format` | Must be `probity-slides-typst` (the short `probity-slides` does not resolve) | Yes |
| `lang` | Document language; use `en-GB` for Probity | Recommended |

The slide deck is a **dependency-free, page-based Typst** format (no Touying).
The legacy XeLaTeX deck is still available as `format: probity-beamer`
(starter `template-beamer.qmd`) but should not be used for new work.

**Slide authoring — two modes:**

1. **Plain slides** — a `## Heading` starts a new white content slide (frame
   title left, logo right, above a hairline — matching Beamer); write normal
   Markdown beneath it (bullets, numbered lists, text, `###` subtitle). Use
   `##` for every slide; do **not** add a `#` (level-1) heading — Quarto
   normalises the shallowest level to Typst level 1 and a stray `#` shifts it,
   breaking the frame-title styling.
2. **Card / navy slides** — call a helper from a raw ` ```{=typst} ` block.
   Brand colours (`probity-navy`, `probity-gold`, `probity-green`,
   `probity-mid-blue`, `probity-red`) and the helpers are in scope there.

Key helpers (all in `_extensions/probity-slides/typst-template.typ`, full
examples in `template-slides.qmd` and README → "Authoring slides"):

| Helper | Slide / element |
|---|---|
| `prob-section(title, subtitle:)` | Full-navy section divider |
| `prob-navy-slide(title, subtitle:)[…]` | Navy content slide (hosts equation box + metric cards) |
| `prob-scenario-cards((…))` | Row of accent-bar cards on a white slide |
| `prob-metric-cards((…))` | Row of gold-bar metric cards on a navy slide |
| `prob-steps((…))` | Numbered-circle process list |
| `prob-formula-card((…), …)` | Navy card of aligned `name = expr` mono lines |
| `prob-result-card(value, …)` | Pale-tint card with a big headline value |
| `prob-equation-box[…]` | Gold-bordered centred equation |
| `prob-cols(left, right, ratio:)` | Two columns (Quarto `.columns` does NOT work in Typst) |

**One-page rule:** there is no auto-fit — content taller than the body spills
silently onto the next page. Card helpers take a `height:` parameter; trim text
or lower the height if a slide overflows. For two-column slides pass an explicit
`cm` height to the cards (never rely on `height: 100%`, which overflows).

### Step 4 — Apply writing conventions

Before rendering, verify the content follows Probity conventions (see
"Writing voice" and "Authoring conventions" sections below). Apply these
as you draft; do not write loosely then clean up.

### Step 5 — Render

```bash
quarto render <path-to-file>.qmd
```

Output is `<file>.pdf` in the same directory as the `.qmd`. A document in a
subdirectory renders only if the extension has been co-located with it (Step 2);
otherwise it fails at discovery or at logo loading.

### Step 6 — Visual check

**Report:**

```bash
pdftoppm -png -r 90 <file>.pdf build/pg
```

Confirm on every page:

- **Cover (page 1):** Probity logo top-left, navy title, mid-blue subtitle,
  muted author / date flanking a navy hairline, pale-tint abstract block.
  No running header or footer on this page.
- **TOC page:** small wordmark header top-left, "Data Analytics" top-right,
  navy hairline below header. "Contents" heading in navy. Footer: bold navy
  "Probity Data Analytics · Confidential", right-aligned "Page X of Y".
- **Body pages:** same header and footer. Navy H1, navy H2, deep-navy H3.
  Tables with rule-band header row. Blockquotes with mid-blue left border
  and pale-tint fill. Code blocks on pale-tint background.

**Slide deck:**

```bash
pdftoppm -png -r 144 <file>.pdf build/slides-pg
```

Confirm on every slide:

- **Title slide (1):** full navy background, gold vertical bar at left edge,
  white Probity logo top-left, bold white title, gold subtitle, gold rule,
  light-blue author/date. No running header or footer.
- **Content slides:** navy bold title top-left, Probity logo top-right (both
  vertically centred in the header band), `#D5DEE9` hairline below the header.
  White body area. Page number bottom-right. No other footer elements.
- **Section dividers:** full navy background, gold vertical bar, bold white
  title, gold rule, optional gold subtitle. No header or footer visible.

### Step 7 — Voice and spelling pass

```bash
grep -nP '\xe2\x80\x94' <file>.qmd                   # em dash — must be zero hits
grep -niE 'color|analyze|behavior|defense|organization' <file>.qmd  # US spellings
```

Fix every hit before delivering.

---

## Authoring conventions

Write Markdown the normal way. Probity-specific patterns:

- **Bold navy lead-in** for caveat lists: begin the bullet or sentence with
  `**Phrase.**` then continue in plain body text. Bold renders navy
  automatically — no extra markup needed.
- **Tables**: standard pipe tables. Caption goes on the line immediately
  after the closing row: `: Caption text {#tbl-id}`. For **row groups**
  (bold group labels with indented rows, à la `kableExtra::pack_rows`), call
  the `probity-grouped-table(...)` helper from a raw `{=typst}` block — pipe
  tables cannot express row groups. See README → "Grouped tables".
- **Figures**: `![Caption](path/to/figure.png){#fig-id width=60%}`. Use
  paths relative to the `.qmd` file for user-supplied figures. Do NOT
  reference `_extensions/probity/assets/` for content figures — those are
  logo assets used by the template internally.
- **Blockquotes** (`>`): headline finding first, then what it depends on.
- **Code**: fenced blocks (` ``` `) render in Consolas on a pale-tint
  background. Inline backtick renders in deep navy.
- **Mathematics**: standard Quarto/Pandoc math fences (`$...$` inline,
  `$$...$$` display). Use actual Greek characters (`α`, `β₁`) in tables
  and equations; write them out in prose.

---

## Writing voice (non-negotiable)

Apply every rule to every word in a Probity document.

1. **No em dashes.** Replace with a colon, comma, full stop, parentheses,
   or a restructured sentence. Hyphens and en dashes in compounds are fine
   (`forward-looking`, `lag-1`, `out-of-sample`).
2. **UK spelling.** `rigour, behaviour, defence, analyse, recognised,
   modelled, centred, organisation, programme`. Keep native spelling in
   proper nouns (Stats SA, SARB, Bureau of Labor Statistics).
3. **Plain register.** Short sentences, one idea each. Active voice.
   Concrete nouns. Cut filler: "in order to" → "to"; drop "it should be
   noted that".
4. **Lead with the answer, then the qualification.** State the headline
   finding, then the dependency or limitation in the very next sentence.
   Do not bury caveats.
5. **Honesty about limitations.** State sample sizes, regime dependencies,
   and out-of-sample residuals openly. When reporting model fit, lead with
   whether the sign matches theory, not with R².
6. **No AI-slop tells.** Avoid: "delve into", "leverage", "unleash",
   "robust" (when vague), "holistic", "seamless", "navigate the
   landscape", "in today's fast-paced world", emoji. No decorative
   full-width coloured bars beyond the template's own hairlines.
7. **Smart typography.** Use `'`, `'`, `"`, `"` for quotes and
   apostrophes. Never straight `'` or `"` in running prose.
8. **Numbers.** Thousands separators (`R 14,903,239`). Percentages with
   no space (`12.5%`). Shorthand money `R 14.9M` in prose, full digits in
   tables. Dates: ISO `2024-06-30` in tables, "30 June 2024" in prose.
   Fiscal years `FY 2024/25`. Lag notation `lag-1`.
9. **Title case for headings.** Every heading and subheading, at all levels,
   uses title case: capitalise the first and last word plus all principal
   words; keep minor words lower-case in the middle — articles (`a`, `an`,
   `the`), coordinating conjunctions (`and`, `but`, `or`), and short
   prepositions (`of`, `to`, `in`, `on`, `for`, `with`). `Provision Under
   Each Scenario`, not `Provision under each scenario`. Body text, captions,
   and bullet fragments stay sentence case.

---

## Quick reference — brand palette and settings

| Element | Value |
|---|---|
| Primary navy | `#0A325A` |
| Deep navy | `#062340` |
| Mid blue | `#4A7BA8` |
| Light blue | `#8BABCB` |
| Pale blue tint | `#E8EEF5` |
| Gold accent | `#C8881F` (reserved — not for body text or chart fills) |
| Body text | `#1F2937` |
| Muted text | `#6B7280` |
| Rule / hairline | `#D5DEE9` |
| Primary font | Calibri (Carlito → Liberation Sans → Arial fallback) |
| Mono / code | Consolas (Courier New → Liberation Mono fallback) |
| Report format | `probity-typst` — PDF via Typst, no LaTeX required; page size A4 |
| Slides format | `probity-slides-typst` — PDF via Typst, 16:9; card-component library |
| Legacy slides | `probity-beamer` — XeLaTeX + Beamer; superseded, do not use for new work |

---

## Troubleshooting

**`Unable to read the extension 'probity'`**
Quarto could not discover `_extensions/` while walking up to the project root.
Causes: no `_quarto.yml` at the project root (e.g. after `quarto add`), or an
intermediate `_quarto.yml` that re-anchors the root below `_extensions/`. For a
root-level document, create a root `_quarto.yml` (`project:\n  title: "My
Project"`). For a subdirectory document, co-locate the extension:
`install.sh <project> <subdir>`.

**`file not found ... assets/logo_trim.png`**
The Typst template loads its logo via `_extensions/probity/assets/...`, resolved
relative to the **report's own directory**. A subdirectory report fails here even
when the extension is installed at the project root. Co-locate it:
`install.sh <project> <subdir>` — or move the report to the project root.

**`error: expected comma` or similar Typst parse errors**
A front-matter field value contains characters that break the Typst template.
Check for unescaped special characters in `title`, `subtitle`, `author`, or
`abstract`.

**Beamer package not installed**
On first render, Quarto attempts to install `beamer.cls` automatically via
TinyTeX. If that fails: `tlmgr install beamer`.

**Font not found (Calibri / Carlito)**
On Linux without Microsoft fonts, the report template falls back to Carlito,
then Liberation Sans, then Arial. The slide theme requires Carlito explicitly.
Install it:
```bash
sudo apt-get install fonts-crosextra-carlito   # Debian/Ubuntu
```

**Render succeeds but header/footer missing on page 1 (report)**
Correct behaviour. The cover page has no running header or footer by design.

**A card slide bled onto the next page**
There is no auto-fit. Lower the card's `height:` parameter or trim its text so
the slide's content fits the ~13.2 cm body. Never use `height: 100%` in a
`prob-cols` column — it resolves against the page and overflows.

---

## Modifying the templates

**Report:** edit `_extensions/probity/typst-template.typ` (colour constants,
font stacks, layout) then re-render `template.qmd` to confirm. The
`typst-show.typ` file wires front-matter variables into the
`probity-report()` function; only edit it to expose additional variables.

**Slides (Typst):** edit `_extensions/probity-slides/typst-template.typ` — brand
constants, the `probity-slides()` page/chrome function, and the card helpers.
Re-render `template-slides.qmd` and inspect with `pdftoppm -r 110`. Page-aware
content uses `context { ... }` (Typst 0.11+); the old `locate(loc => ...)` form
was removed after Typst 0.10 and must not be reintroduced.

**Legacy Beamer slides:** edit `_extensions/probity/probity-beamer.sty`. Do
**not** call `\setsansfont` inside it (Quarto handles fonts via `sansfont:`).
Kept for back-compatibility; prefer the Typst deck for new work.

---

## Files in this repository

- `_extensions/probity/typst-template.typ` — Typst template function (report) + `probity-grouped-table` helper
- `_extensions/probity/typst-show.typ` — Pandoc partial wiring front matter (report)
- `_extensions/probity/probity-beamer.sty` — legacy Beamer theme
- `_extensions/probity-slides/typst-template.typ` — Typst slide template + card-component library
- `_extensions/probity-slides/typst-show.typ` — Pandoc partial wiring front matter (slides)
- `_extensions/probity-slides/assets/` — slide-deck copy of the logos
- `_extensions/probity/assets/logo_trim.png` — report cover wordmark
- `template.qmd` — starter report document
- `template-slides.qmd` — starter slide deck (Typst)
- `template-beamer.qmd` — starter slide deck (legacy Beamer)
- `install.sh` — installs the report extension into another project

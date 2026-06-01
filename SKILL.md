---
name: probity-quarto-typst
description: "Create branded PDF reports for Probity Data Analytics using the Quarto Typst extension in this repository. Use this skill whenever the user asks to write, draft, restyle, or produce a Probity PDF report from Quarto or Markdown: methodology write-ups, technical reports, audit-trail documents, memos, proposals, client deliverables, or anything that will leave the studio under the Probity name. Trigger it even when the user only says 'make a Probity report', 'use our PDF template', 'apply our branding', or attaches a Quarto/Markdown file to convert. Output is a PDF file (not Word/docx). It pins down the navy/gold palette, Calibri type, logo cover page, running header and footer, table styling, and the Probity writing voice."
---

# Probity Data Analytics — Quarto PDF template (agent guide)

This skill produces brand-compliant PDF reports for Probity Data Analytics
through Quarto, using a Typst-based format extension (`probity-typst`). No
LaTeX installation is required. Authors write plain Quarto (`.qmd`) and set
`format: probity-typst`; the extension handles all chrome and styling.

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
```

The script copies `_extensions/probity/` into the target and creates a
minimal `_quarto.yml` at the project root if one does not exist. Both are
required. Confirm after:

```bash
ls <project-root>/_extensions/probity/_extension.yml   # must exist
ls <project-root>/_quarto.yml                          # must exist
```

**Critical: `_quarto.yml` at the project root.** Without it, Quarto cannot
discover the extension when documents are in subdirectories, and rendering
fails with "Unable to read the extension 'probity'". The install script
creates a minimal one automatically, but verify it is present if you are
installing manually.

### Step 3 — Write or update the `.qmd`

If starting fresh, copy the starter document:

```bash
cp /home/stefan/Documents/probity_pdf/template.qmd <project-root>/my-report.qmd
```

Then write or edit the content. Required front matter:

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

All front-matter fields and their effects:

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

### Step 4 — Apply writing conventions

Before rendering, verify the content follows Probity conventions (see
"Writing voice" and "Authoring conventions" sections below). Apply these
as you draft; do not write loosely then clean up.

### Step 5 — Render

Run from the project root (not from a subdirectory):

```bash
quarto render <path-to-file>.qmd
```

Output is `<file>.pdf` in the same directory as the `.qmd`.

### Step 6 — Visual check

Convert the PDF to images and inspect every page:

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
  after the closing row: `: Caption text {#tbl-id}`.
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
| Output format | `probity-typst` (PDF via Typst, no LaTeX) |
| Page size | A4 |

---

## Troubleshooting

**`Unable to read the extension 'probity'`**
Most likely a missing `_quarto.yml` at the project root. Quarto needs this
to walk up from subdirectories to `_extensions/`. Create one:
```yaml
project:
  title: "My Project"
```

**`file not found ... assets/logo_trim.png`**
The `_extensions/probity/` directory is not a direct child of the project
root, or was installed in the wrong location. Re-run `install.sh` from the
correct project root.

**`error: expected comma` or similar Typst parse errors**
A front-matter field value contains characters that break the Typst
template. Check for unescaped special characters in `title`, `subtitle`,
`author`, or `abstract`.

**Font not found (Calibri)**
On Linux without Microsoft fonts, the template falls back to Carlito, then
Liberation Sans, then Arial. Install Carlito for the closest match:
```bash
sudo apt-get install fonts-crosextra-carlito   # Debian/Ubuntu
```
The PDF will render correctly with any fallback font; only the typeface
changes.

**Render succeeds but header/footer missing on page 1**
This is correct behaviour. The cover page intentionally has no running
header or footer. They appear from page 2 onward.

---

## Modifying the template

Edit `_extensions/probity/typst-template.typ` (colour constants, font
stacks, layout) then re-render `template.qmd` to confirm. The
`typst-show.typ` file wires front-matter variables into the
`probity-report()` function; only edit it to expose additional variables.

**Typst 0.10 constraint.** Quarto 1.4 bundles Typst 0.10. The template
avoids `context { }` blocks and `table.cell` selectors (both require Typst
0.11+). Use `locate(loc => ...)` for any page-aware additions. If the
project upgrades to Quarto 1.5+, these constraints lift.

---

## Files in this repository

- `_extensions/probity/_extension.yml` — format definition (`probity-typst`)
- `_extensions/probity/typst-template.typ` — Typst template function
- `_extensions/probity/typst-show.typ` — Pandoc partial wiring front matter
- `_extensions/probity/assets/logo_trim.png` — cover page wordmark
- `_extensions/probity/assets/logo_navy_small.png` — header wordmark
- `template.qmd` — starter document
- `install.sh` — installs the extension into another project

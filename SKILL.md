---
name: probity-quarto
description: "Create branded PDF outputs for Probity Data Analytics using the Quarto extension in this repository. Use this skill whenever the user asks to write, draft, restyle, or produce a Probity PDF report or slide deck from Quarto or Markdown: methodology write-ups, technical reports, audit-trail documents, memos, proposals, client deliverables, presentations, or anything that will leave the studio under the Probity name. Trigger it even when the user only says 'make a Probity report', 'use our PDF template', 'apply our branding', or attaches a Quarto/Markdown file to convert. Output is always a PDF file (not Word/docx). Formats: probity-typst (A4 report, no LaTeX) and probity-slides-typst (16:9 slides, no LaTeX, with a card-component library). It pins down the navy/gold palette, Calibri type, Probity visual identity, and the Probity writing voice."
---

# Probity Data Analytics — Quarto PDF templates (agent guide)

This skill produces brand-compliant PDF outputs for Probity Data Analytics
through Quarto:

| Format | Output | Engine | Use for |
|---|---|---|---|
| `probity-typst` | A4 report | Typst — no LaTeX required | Written reports, methodology, deliverables |
| `probity-slides-typst` | 16:9 slides | Typst — no LaTeX required | Client presentations, slide decks |
| `probity-invoice-typst` | A4 invoice | Typst — no LaTeX required | Single-page branded invoices (front-matter driven) |

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
| `header-text` | Running-header text right of the logo (omit → default "Data Analytics") | Optional |
| `footer-text` | Bold navy brand text at the foot, left (omit → default "Probity Data Analytics") | Optional |
| `footer-note` | Muted classification after the footer brand — e.g. "Confidential", "Draft", "Public". **Omit (or leave empty) to show no note.** The starter sets "Confidential". | Optional |

The running header/footer appear from page 2 onward (not the cover).
`header-text` and `footer-text` are brand defaults — omit to keep them.
`footer-note` is optional: set it to show a classification, omit it (or set it
empty) to show none. Special characters and dashes render correctly (the values
are passed as content).

**Slide deck front matter** (`format: probity-slides-typst`):

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

| Field | Effect | Required |
|---|---|---|
| `title` | Bold white title on the navy title slide | Yes |
| `subtitle` | Gold subtitle below title on the title slide | Recommended |
| `author` | Light-blue author line near the bottom of the title slide | Recommended |
| `date` | Appended to author, separated by a pipe | Recommended |
| `footer-text` | Footer brand, bold navy (left); omit → default "Probity Data Analytics" | Optional |
| `footer-note` | Muted classification after the footer brand (e.g. "Draft", "Public"); omit/empty to hide | Optional |
| `footer-center` | Centre-footer running title on content slides; omit → none | Optional |
| `format` | Must be `probity-slides-typst` (the short `probity-slides` does not resolve) | Yes |
| `lang` | Document language; use `en-GB` for Probity | Recommended |

The slide deck is a **dependency-free, page-based Typst** format (no Touying).
`footer-text` / `footer-note` mean the same as in the report (`footer-note`
hides when omitted/empty); `footer-center` is the slide-only centre running
title — renamed from the slide deck's previous `footer-text`.

**Slide authoring — three modes:**

1. **Plain slides** — a `## Heading` starts a new white content slide (frame
   title left, logo right, above a hairline); write normal
   Markdown beneath it (bullets, numbered lists, text, `###` subtitle). Use
   `##` for every slide; do **not** add a `#` (level-1) heading — Quarto
   normalises the shallowest level to Typst level 1 and a stray `#` shifts it,
   breaking the frame-title styling.
2. **Card / navy slides** — call a helper from a raw ` ```{=typst} ` block.
   Brand colours (`probity-navy`, `probity-gold`, `probity-green`,
   `probity-mid-blue`, `probity-red`) and the helpers are in scope there.
3. **Full-bleed image slides** — call `prob-image-slide("path/to/image.png")`
   from a raw ` ```{=typst} ` block. Image fills the entire 16:9 frame with no
   margins, title, or footer. Use `fit: "cover"` (default, may crop) or
   `fit: "contain"` (entire image visible, may letterbox).

Key helpers (all in `_extensions/probity-slides/typst-template.typ`, full
examples in `template-slides.qmd` and README → "Authoring slides"):

| Helper | Slide / element |
|---|---|
| `prob-section(title, subtitle:)` | Full-navy section divider |
| `prob-navy-slide(title, subtitle:)[…]` | Navy content slide (hosts equation box + metric cards) |
| `prob-image-slide(path, fit:)` | Full-bleed image slide (16:9, no margins/title/footer) |
| `prob-scenario-cards((…))` | Row of accent-bar cards on a white slide (values align via `header-height:`) |
| `prob-metric-cards((…))` | Row of gold-bar metric cards on a navy slide (values align via `label-height:`) |
| `prob-steps((…))` | Numbered-circle process list |
| `prob-formula-card((…), …)` | Navy card of aligned `name = expr` mono lines |
| `prob-result-card(value, …)` | Pale-tint card with a big headline value |
| `prob-equation-box[…]` | Gold-bordered centred equation |
| `prob-cols(left, right, ratio:)` | Two columns (Quarto `.columns` does NOT work in Typst) |
| `prob-data-table(columns:, header:, rows:, align:)` | Branded table: navy header + pale-tint zebra rows |
| `prob-qa((…))` | Stacked bold-navy question / body-answer blocks |
| `prob-flow((…))` | Horizontal row of boxes (pale/navy) joined by gold arrows |
| `prob-measure(content, max-height:)` | Wrap slide content to detect overflow during editing (shows red warning) |

In the **report** (`probity-typst`), the extra helpers are `probity-grouped-table(…)`
(row-grouped tables — see README → "Grouped tables") and `prob-callout(body, label:,
accent:)` — a pale-tint block with a coloured accent bar and an optional tracked
uppercase eyebrow, for the formal "Key finding" / "Bottom line" callout (distinct
from the italic markdown blockquote, which renders a softer mid-blue-bar aside).

**One-page rule:** there is no auto-fit — content taller than the body spills
silently onto the next page. To detect overflow during editing, wrap your slide
content in `prob-measure([ ... ])`, which displays a red warning box if the
content exceeds ~13.2 cm. Card helpers take a `height:` parameter; trim text
or lower the height if a slide overflows. For two-column slides pass an explicit
`cm` height to the cards (never rely on `height: 100%`, which overflows).

**Invoice front matter** (`format: probity-invoice-typst`):

The invoice is **entirely front-matter driven** — the `.qmd` body stays empty;
all content arrives through YAML keys.

```yaml
---
format: probity-invoice-typst
company-name: "Probity Data Analytics"
company-address: "Suite 12, Riverside Court, Cape Town, 8001"
company-phone: "+27 21 555 0142"
company-email: "accounts@probity.example"
invoice-number: "INV-2026-014"
issue-date: "23 June 2026"        # strings, NOT YAML dates (date objects can't be field-accessed)
due-date: "23 July 2026"
terms: "Net 30"
customer-id: "CUST-0042"
client-name: "Northwind Traders (Pty) Ltd"
client-address: "42 Quarry Industrial Park, Durban, 4001"
items:                            # list of {description, qty, unit}
  - description: "Data engineering consulting — June"
    qty: 16
    unit: "2500.00"               # money values are BARE NUMERIC STRINGS (cents survive Pandoc)
  - description: "Support retainer — 1 month"
    qty: 1
    unit: "7500.00"
discount: "5000.00"               # an amount (string), not a percentage; omit/0 to hide
tax-rate: 0.15                    # a fraction; 0 hides the tax row
tax-label: "VAT"
currency: "R"
invoice-notes: "All amounts in ZAR. Quote the invoice number as the reference."
bank-holder: "Probity Data Analytics (Pty) Ltd"   # omit all bank-* to suppress the navy bank banner
bank-name: "First National Bank"
bank-account: "62345678901"
bank-branch-code: "250655"
bank-reference: "INV-2026-014"
footer-email: "accounts@probity.example"
---
```

Two reserved-key traps:
- The notes field is **`invoice-notes`**, not `notes` (Quarto also renders a
  `notes` key into the body, duplicating it).
- Dates are **strings**, not YAML dates (Pandoc date objects can't be
  field-accessed in the template partial).

Money rules: every money value (`unit`, `discount`) is a **bare numeric string**
so cents survive Pandoc's float stringification. `tax-rate` is a fraction
(`0.15` = 15%); the displayed percent matches the charged amount, including
fractional rates (`0.155` → "15.5%"). Per-line amounts are rounded to cents and
sum to the printed subtotal. Omit all `bank-*` keys and the navy bank-transfer
banner is suppressed. The format is `probity-invoice-typst` (the short
`probity-invoice` does **not** resolve).

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
  **Bold text** (e.g. `**emphasis**`) renders navy on white slides and white
  on navy backgrounds (for visibility).
- **Section dividers:** full navy background, gold vertical bar, bold white
  title, gold rule, optional gold subtitle. No header or footer visible.
- **Image-only slides** (via `prob-image-slide()`): full-bleed image covering
  entire 16:9 frame with no margins, title, or footer. Image fills or fits
  depending on the `fit:` parameter ("cover" scales and crops, "contain"
  preserves aspect ratio).

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
`prob-cols` column — it resolves against the page and overflows. To debug
during editing, wrap your content in `prob-measure([ ... ])` — it displays a
red warning box if content exceeds the safe height.

**Image slide looks distorted or has unexpected margins**
Check the `fit:` parameter in `prob-image-slide()`: use `fit: "cover"` (default,
scales to fill, may crop edges) or `fit: "contain"` (entire image visible, may
add letterboxing). For a portrait image on a 16:9 slide, use `fit: "contain"`
to avoid distortion.

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

---

## Files in this repository

- `_extensions/probity/typst-template.typ` — Typst template function (report) + `probity-grouped-table` helper
- `_extensions/probity/typst-show.typ` — Pandoc partial wiring front matter (report)
- `_extensions/probity-slides/typst-template.typ` — Typst slide template + card-component library
- `_extensions/probity-slides/typst-show.typ` — Pandoc partial wiring front matter (slides)
- `_extensions/probity-slides/assets/` — slide-deck copy of the logos
- `_extensions/probity/assets/logo_trim.png` — report cover wordmark
- `template.qmd` — starter report document
- `template-slides.qmd` — starter slide deck (Typst)
- `install.sh` — installs the report extension into another project

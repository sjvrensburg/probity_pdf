# Probity Data Analytics — Quarto PDF template

A Quarto format extension that produces brand-compliant PDF reports for
Probity Data Analytics: navy/gold palette, Calibri type, logo cover page,
running header and footer, and styled tables. No LaTeX required — output is
PDF via the bundled Typst compiler.

## Quick start

```bash
cp template.qmd my-report.qmd     # start from the example
quarto render my-report.qmd       # produces my-report.pdf
```

In the front matter, set:

```yaml
format: probity-typst
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
| `install.sh` | Helper script to install into another project |

## Using it in another project

### Option A: install script (recommended)

```bash
# From the probity_pdf repo:
./install.sh /path/to/target/project
```

The script copies `_extensions/probity/` into the target and validates the
installation.

### Option B: manual copy

```bash
cp -r _extensions/probity /path/to/target/project/_extensions/
```

Then set `format: probity-typst` in the document's front matter.

### Important: directory structure

Quarto discovers extensions by walking up from the document to the project
root. For documents in subdirectories, two things are required:

1. `_extensions/probity/` must live at the project root.
2. A `_quarto.yml` must exist at the project root so Quarto can identify
   the project boundary.

```
my-project/
  _quarto.yml              # required — marks the project root
  _extensions/
    probity/
      _extension.yml
      typst-template.typ
      typst-show.typ
      assets/
  pipeline/
    docs/
      report.qmd          # format: probity-typst
```

A minimal `_quarto.yml`:

```yaml
project:
  title: "My Project"
```

## Troubleshooting

### `Unable to read the extension 'probity'`

Most likely a missing `_quarto.yml` at the project root. See the directory
structure section above.

### Font not found (Calibri)

Calibri is a Microsoft font. On Linux without Microsoft fonts installed, the
template falls back to Carlito, then Liberation Sans, then Arial. Install
Carlito (`fonts-crosextra-carlito` on Debian/Ubuntu) for the closest match.

### Modifying the template

Edit `_extensions/probity/typst-template.typ` (colour constants, layout,
fonts) then re-render `template.qmd` to confirm. See `SKILL.md` for the
full brand specification and writing voice.

// Probity Data Analytics — typst-template.typ
// Brand: navy/gold palette, Calibri, logo header, page-numbered footer.
// Targets Typst 0.11+ (Quarto 1.5+); uses context-based page chrome.

#let probity-navy      = rgb("#0A325A")
#let probity-deep-navy = rgb("#062340")
#let probity-mid-blue  = rgb("#4A7BA8")
#let probity-light-blue = rgb("#8BABCB")
#let probity-pale-tint = rgb("#E8EEF5")
#let probity-gold      = rgb("#C8881F")
#let probity-body      = rgb("#1F2937")
#let probity-muted     = rgb("#6B7280")
#let probity-rule      = rgb("#D5DEE9")

#let body-font = ("Calibri", "Carlito", "Liberation Sans", "Arial")
#let mono-font = ("Consolas", "Courier New", "Liberation Mono")

#let probity-report(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  abstract: none,
  toc: true,
  lang: "en",
  // Running header/footer text — overridable from the YAML front matter.
  header-text: [Data Analytics],          // header, right of the logo
  footer-text: [Probity Data Analytics],  // footer, bold navy (left)
  footer-note: [],                        // optional muted note after the brand; empty = hidden
  doc,
) = {

  // ── Document metadata ──────────────────────────────────────────────────
  // `document.author` takes the array directly; an empty array means "no
  // author". (Avoid authors.join(", ") — an empty array joins to `none`, which
  // document.author rejects, so an author-less document would fail to compile.)
  set document(
    title: if title != none { title } else { "" },
    author: authors,
  )

  // ── Page geometry and running chrome ───────────────────────────────────
  set page(
    paper: "a4",
    margin: (top: 2.8cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
    header: context {
      let pg = counter(page).get().first()
      if pg > 1 [
        #set text(font: body-font, size: 9pt)
        #grid(
          columns: (1fr, auto),
          image("_extensions/probity/assets/logo_navy_small.png", height: 16pt),
          align(right + horizon)[#text(fill: probity-muted)[#header-text]],
        )
        #v(-4pt)
        #line(length: 100%, stroke: 0.5pt + probity-navy)
      ]
    },
    footer: context {
      let pg = counter(page).get().first()
      if pg > 1 [
        #line(length: 100%, stroke: 0.5pt + probity-rule)
        #v(-2pt)
        #set text(font: body-font, size: 9pt)
        #grid(
          columns: (1fr, auto),
          {
            text(weight: "bold", fill: probity-navy)[#footer-text]
            if footer-note != [] {
              text(fill: probity-muted)[ · #footer-note]
            }
          },
          align(right)[
            #text(fill: probity-muted)[Page #pg of #counter(page).final().first()]
          ],
        )
      ]
    },
  )

  // ── Base typography ─────────────────────────────────────────────────────
  set text(font: body-font, size: 11pt, fill: probity-body, lang: lang)
  set par(leading: 0.75em, justify: true)

  // ── Heading styles ──────────────────────────────────────────────────────
  // Space above each heading is weak (collapses at a page top); space below is
  // a fixed block so the heading is never cramped against the following text.
  show heading.where(level: 1): it => {
    v(1.4em, weak: true)
    block(below: 0.8em, text(size: 18pt, weight: "bold", fill: probity-navy, font: body-font)[#it.body])
  }
  show heading.where(level: 2): it => {
    v(1.1em, weak: true)
    block(below: 0.65em, text(size: 14pt, weight: "bold", fill: probity-navy, font: body-font)[#it.body])
  }
  show heading.where(level: 3): it => {
    v(0.9em, weak: true)
    block(below: 0.55em, text(size: 12pt, weight: "bold", fill: probity-deep-navy, font: body-font)[#it.body])
  }
  show heading.where(level: 4): it => {
    v(0.7em, weak: true)
    block(below: 0.45em, text(size: 11pt, weight: "bold", style: "italic", fill: probity-deep-navy, font: body-font)[#it.body])
  }

  // ── Strong (bold) ── navy tint ──────────────────────────────────────────
  show strong: it => text(fill: probity-navy, weight: "bold")[#it.body]

  // ── Inline and block code ───────────────────────────────────────────────
  show raw.where(block: false): it => {
    text(font: mono-font, size: 9.5pt, fill: probity-deep-navy)[#it]
  }
  show raw.where(block: true): it => {
    set text(font: mono-font, size: 9pt, fill: probity-body)
    set par(leading: 0.55em, justify: false)
    block(
      fill: probity-pale-tint,
      inset: (x: 12pt, y: 10pt),
      radius: 2pt,
      width: 100%,
      it,
    )
  }

  // ── Tables ──────────────────────────────────────────────────────────────
  // Header row gets a hairline-blue fill with bold navy text (no white-on-navy);
  // body rows zebra-stripe between white and the pale tint.
  set table(
    stroke: none,
    fill: (_, row) => if row == 0 { rgb("#D5DEE9") }
                      else if calc.odd(row) { white }
                      else { probity-pale-tint },
    inset: (x: 10pt, y: 6pt),
  )
  show table: it => {
    set text(size: 10pt)
    block(width: 100%, it)
  }

  // ── Block quotes ─────────────────────────────────────────────────────────
  show quote: it => {
    block(
      width: 100%,
      inset: (left: 24pt, right: 0pt, y: 8pt),
      stroke: (left: 3pt + probity-mid-blue),
      fill: probity-pale-tint,
      text(fill: probity-body, style: "italic")[#it.body],
    )
  }

  // ── Title page (no running header/footer) ────────────────────────────────
  page(
    header: none,
    footer: none,
    margin: (top: 3.5cm, bottom: 3cm, left: 2.5cm, right: 2.5cm),
  )[
    #image("_extensions/probity/assets/logo_trim.png", width: 48%)
    #v(2.8cm)

    #if title != none {
      text(size: 30pt, weight: "bold", fill: probity-navy, font: body-font)[#title]
      v(0.35em)
    }

    #if subtitle != none {
      text(size: 16pt, fill: probity-mid-blue, font: body-font)[#subtitle]
      v(0.5em)
    }

    #line(length: 100%, stroke: 1pt + probity-navy)
    #v(0.35em)

    #grid(
      columns: (1fr, auto),
      text(size: 10pt, fill: probity-muted)[#authors.join(", ")],
      align(right)[#text(size: 10pt, fill: probity-muted)[#date]],
    )

    #if abstract != none {
      v(1.4cm)
      block(
        width: 100%,
        inset: (x: 20pt, y: 14pt),
        fill: probity-pale-tint,
        stroke: (left: 3pt + probity-navy),
        text(size: 10.5pt, fill: probity-body)[#abstract],
      )
    }
  ]

  // ── Table of contents ────────────────────────────────────────────────────
  if toc {
    outline(
      title: text(size: 14pt, weight: "bold", fill: probity-navy)[Contents],
      depth: 3,
      indent: auto,
    )
    pagebreak()
  }

  doc
}

// ── Grouped table helper ─────────────────────────────────────────────────────
// Booktabs-style table with bold navy group labels spanning all columns and
// indented member rows (the look of kableExtra::pack_rows / gt row groups).
// Markdown pipe tables cannot express row groups, so call this from a raw
// `{=typst}` block. It resets the report's zebra fill and draws its own navy
// rules, so the grouped layout reads cleanly.
//
//   ```{=typst}
//   #probity-grouped-table(
//     columns: (auto, auto, auto, auto, auto, auto, auto),
//     align: (left, right, right, right, right, right, right),
//     header: ([], [mpg], [cyl], [disp], [hp], [drat], [wt]),
//     ungrouped: (
//       ([Mazda RX4], [21.0], [6], [160.0], [110], [3.90], [2.620]),
//     ),
//     groups: (
//       (name: "Group 1", rows: (
//         ([Valiant], [18.1], [6], [225.0], [105], [2.76], [3.460]),
//       )),
//     ),
//   )
//   ```
//
// header   — array of column-heading cells (bolded automatically); pass none to omit.
// ungrouped — array of rows shown before the first group; each row is an array of cells.
// groups   — array of (name: <str>, rows: <array of row-arrays>) dictionaries.
#let probity-grouped-table(
  columns: auto,
  align: auto,
  header: none,
  ungrouped: (),
  groups: (),
  indent: 1.4em,
) = {
  // Column count, needed for the group label's colspan.
  let ncols = if type(columns) == int { columns }
    else if type(columns) == array { columns.len() }
    else if header != none { header.len() }
    else if ungrouped.len() > 0 { ungrouped.first().len() }
    else if groups.len() > 0 and groups.first().rows.len() > 0 { groups.first().rows.first().len() }
    else { 1 }

  // Flatten ungrouped rows, then each group: a full-width bold label followed by
  // its rows with the first cell indented.
  let body = ()
  for row in ungrouped { body += row }
  for g in groups {
    body.push(table.cell(colspan: ncols, inset: (top: 11pt, bottom: 4pt))[*#g.name*])
    for row in g.rows {
      body.push([#h(indent)#row.first()])
      body += row.slice(1)
    }
  }

  let head = if header != none {
    (table.header(..header.map(strong)), table.hline(stroke: 0.6pt + probity-navy))
  } else { () }

  table(
    columns: columns,
    align: align,
    stroke: none,
    fill: none,
    inset: (x: 8pt, y: 5pt),
    table.hline(stroke: 1pt + probity-navy),
    ..head,
    ..body,
    table.hline(stroke: 1pt + probity-navy),
  )
}

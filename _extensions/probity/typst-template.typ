// Probity Data Analytics — typst-template.typ
// Brand: navy/gold palette, Calibri, logo header, page-numbered footer.
// Compatible with Typst 0.10 (Quarto 1.4).

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
  doc,
) = {

  // ── Document metadata ──────────────────────────────────────────────────
  set document(
    title: if title != none { title } else { "" },
    author: authors.join(", "),
  )

  // ── Page geometry and running chrome ───────────────────────────────────
  set page(
    paper: "a4",
    margin: (top: 2.8cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
    header: locate(loc => {
      let pg = counter(page).at(loc).at(0)
      if pg > 1 [
        #set text(font: body-font, size: 9pt)
        #grid(
          columns: (1fr, auto),
          image("_extensions/probity/assets/logo_navy_small.png", height: 16pt),
          align(right + horizon)[#text("Data Analytics", fill: probity-muted)],
        )
        #v(-4pt)
        #line(length: 100%, stroke: 0.5pt + probity-navy)
      ]
    }),
    footer: locate(loc => {
      let pg = counter(page).at(loc).at(0)
      if pg > 1 [
        #line(length: 100%, stroke: 0.5pt + probity-rule)
        #v(-2pt)
        #set text(font: body-font, size: 9pt)
        #grid(
          columns: (1fr, auto),
          [
            #text(weight: "bold", fill: probity-navy)[Probity Data Analytics]
            #text(" · Confidential", fill: probity-muted)
          ],
          align(right)[
            #text(fill: probity-muted)[Page ]
            #counter(page).display("1")
            #text(fill: probity-muted)[ of ]
            #counter(page).final(loc).at(0)
          ],
        )
      ]
    }),
  )

  // ── Base typography ─────────────────────────────────────────────────────
  set text(font: body-font, size: 11pt, fill: probity-body, lang: lang)
  set par(leading: 0.75em, justify: true)

  // ── Heading styles ──────────────────────────────────────────────────────
  show heading.where(level: 1): it => {
    v(1.4em, weak: true)
    text(size: 18pt, weight: "bold", fill: probity-navy, font: body-font)[#it.body]
    v(0.5em, weak: true)
  }
  show heading.where(level: 2): it => {
    v(1.1em, weak: true)
    text(size: 14pt, weight: "bold", fill: probity-navy, font: body-font)[#it.body]
    v(0.35em, weak: true)
  }
  show heading.where(level: 3): it => {
    v(0.9em, weak: true)
    text(size: 12pt, weight: "bold", fill: probity-deep-navy, font: body-font)[#it.body]
    v(0.25em, weak: true)
  }
  show heading.where(level: 4): it => {
    v(0.7em, weak: true)
    text(size: 11pt, weight: "bold", style: "italic", fill: probity-deep-navy, font: body-font)[#it.body]
    v(0.15em, weak: true)
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
  // Typst 0.10: table.cell selector unavailable, so we style header via fill
  // and bold navy text on a pale-tint background (no white-on-navy).
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

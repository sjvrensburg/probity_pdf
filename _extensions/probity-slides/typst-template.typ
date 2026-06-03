// Probity Data Analytics — typst-template.typ (slide deck)
// 16:9 Typst slide deck. Dependency-free, page-based: each `##` heading starts
// a new white content slide; full-navy title / section / navy-content slides and
// the card components are helper functions callable from raw `{=typst}` blocks.
// Targets Typst 0.13+ (Quarto 1.7+).

// ── Brand palette ─────────────────────────────────────────────────────────────
#let probity-navy       = rgb("#0A325A")
#let probity-deep-navy  = rgb("#062340")
#let probity-mid-blue   = rgb("#4A7BA8")
#let probity-light-blue = rgb("#8BABCB")
#let probity-pale-tint  = rgb("#E8EEF5")
#let probity-gold       = rgb("#C8881F")
#let probity-body       = rgb("#1F2937")
#let probity-muted      = rgb("#6B7280")
#let probity-rule       = rgb("#D5DEE9")
// Scenario accents
#let probity-green = rgb("#2E7D46")
#let probity-red   = rgb("#B23A3A")

#let body-font = ("Calibri", "Carlito", "Liberation Sans", "Arial")
#let mono-font = ("Consolas", "Liberation Mono", "Courier New")

#let _logo-navy  = "_extensions/probity-slides/assets/logo_navy_small.png"
#let _logo-white = "_extensions/probity-slides/assets/logo_white.png"

// ── Full-bleed navy canvas (title / section / navy content slides) ─────────────
// margin 0 so the gold edge bar and background reach the page edges; inner
// padding is applied to `body`.
#let _navy-canvas(body, foot: none, top-inset: 1.5cm) = page(
  fill: probity-navy,
  margin: 0pt,
  header: none,
  footer: foot,
)[
  #place(top + left, rect(width: 2.2mm, height: 100%, fill: probity-gold))
  #block(width: 100%, height: 100%, inset: (left: 1.8cm, right: 1.6cm, top: top-inset, bottom: 1.1cm), body)
]

// ── Main template ───────────────────────────────────────────────────────────
#let probity-slides(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  footer-text: [Probity Data Analytics],  // footer brand, bold navy (left)
  footer-note: [],                         // optional classification after the brand; empty = hidden
  footer-center: none,                     // optional running title (footer centre)
  lang: "en",
  doc,
) = {
  set document(title: if title != none { title } else { "" }, author: authors)

  // Page geometry + running chrome (white content slides; suppressed on page 1).
  set page(
    paper: "presentation-16-9",
    margin: (left: 1.6cm, right: 1.6cm, top: 0.85cm, bottom: 1.0cm),
    header: none,
    footer: context {
      if counter(page).get().first() > 1 {
        set text(size: 9pt, fill: probity-muted)
        grid(
          columns: (1fr, auto, 1fr),
          {
            text(weight: "bold", fill: probity-navy)[#footer-text]
            if footer-note != [] {
              text(fill: probity-muted)[ · #footer-note]
            }
          },
          if footer-center != none { footer-center } else { [] },
          align(right)[#counter(page).get().first()],
        )
      }
    },
  )

  set text(font: body-font, size: 17pt, fill: probity-body, lang: lang)
  set par(leading: 0.65em)

  // Each `##` starts a new white content slide. Quarto normalises the deck's
  // shallowest heading (`##`) to Typst level 1, so this rule targets level 1.
  // The frame title sits on the left with the logo on the right, both above a
  // hairline. (Author convention: use `##` for every slide; do not use `#`,
  // or the heading-level normalisation shifts.)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    // Hairline is the block's bottom border so the gap to the title is exactly
    // the bottom inset — no surprise block spacing.
    block(
      width: 100%,
      below: 0.55cm,
      inset: (bottom: 5pt),
      stroke: (bottom: 0.4pt + probity-rule),
      grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        text(size: 24pt, weight: "bold", fill: probity-navy)[#it.body],
        image(_logo-navy, height: 0.9cm),
      ),
    )
  }
  // `###` (Typst level 2) becomes a slide subtitle line below the hairline.
  show heading.where(level: 2): it => {
    text(size: 13pt, fill: probity-mid-blue)[#it.body]
    v(0.25em)
  }

  show strong: it => text(fill: probity-navy, weight: "bold")[#it.body]
  show raw.where(block: false): it => text(font: mono-font, fill: probity-deep-navy)[#it]
  show raw.where(block: true): it => block(
    fill: probity-pale-tint, inset: 12pt, radius: 2pt, width: 100%,
    text(font: mono-font, size: 13pt, fill: probity-body)[#it],
  )

  set list(marker: text(fill: probity-navy)[•])
  set enum(numbering: n => text(fill: probity-navy, weight: "bold")[#n.])

  // ── Title slide (page 1) ──
  _navy-canvas(foot: none)[
    #image(_logo-white, width: 24%)
    #v(1fr)
    #if title != none { text(size: 34pt, weight: "bold", fill: white)[#title] }
    #if subtitle != none {
      v(0.5em)
      text(size: 16pt, fill: probity-gold)[#subtitle]
    }
    #v(0.5cm)
    #line(length: 26mm, stroke: 1pt + probity-gold)
    #v(0.4cm)
    #text(size: 11pt, fill: probity-light-blue)[
      #authors.join(", ")
      #if date != none [ #h(0.4em) #text(fill: probity-rule)[|] #h(0.4em) #date]
    ]
    #v(1.4fr)
  ]

  doc
}

// ════════════════════════════════════════════════════════════════════════════
// Slide helpers — call from a raw ```{=typst} block.
// ════════════════════════════════════════════════════════════════════════════

// Spaced small-caps label used on every card.
#let _eyebrow(label, fill: probity-navy) = text(
  size: 12pt, weight: "bold", fill: fill, tracking: 1.6pt,
)[#upper(label)]

// ── Full-navy section divider ──
#let prob-section(title, subtitle: none) = _navy-canvas[
  #v(1fr)
  #text(size: 32pt, weight: "bold", fill: white)[#title]
  #v(0.45cm)
  #line(length: 26mm, stroke: 1pt + probity-gold)
  #if subtitle != none {
    v(0.35cm)
    text(size: 15pt, fill: probity-gold)[#subtitle]
  }
  #v(1.6fr)
]

// ── Navy content slide: frame title (left) + white logo (right) + hairline,
//    then `body` on navy. Header geometry matches the white content slides. ──
#let prob-navy-slide(title, subtitle: none, foot: none, body) = _navy-canvas(foot: foot, top-inset: 0.85cm)[
  #block(
    width: 100%,
    below: if subtitle != none { 0.3cm } else { 0.55cm },
    inset: (bottom: 5pt),
    stroke: (bottom: 0.4pt + probity-light-blue.transparentize(35%)),
    grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      text(size: 24pt, weight: "bold", fill: white)[#title],
      image(_logo-white, height: 0.9cm),
    ),
  )
  #if subtitle != none {
    text(size: 13pt, fill: probity-light-blue)[#subtitle]
    v(0.5cm)
  }
  #body
]

// ── Scenario card row (white slide): accent bar + label + meta + value + desc ──
// cards: array of (accent, label, meta, value, desc)
#let prob-scenario-cards(cards, height: 8.3cm) = grid(
  columns: (1fr,) * cards.len(),
  gutter: 12pt,
  ..cards.map(c => rect(
    width: 100%, height: height, fill: white,
    stroke: (rest: 0.6pt + probity-rule, left: 3pt + c.accent),
    inset: (left: 16pt, top: 16pt, right: 14pt, bottom: 14pt),
  )[
    #_eyebrow(c.label, fill: c.accent)
    #v(11pt)
    #text(size: 11pt, fill: probity-muted)[#c.meta]
    #v(1fr)
    #text(size: 32pt, weight: "bold", fill: probity-navy)[#c.value]
    #v(1fr)
    #text(size: 12pt)[#c.desc]
  ]),
)

// ── Metric card row on a navy slide: gold bar + gold label + white value ──
// cards: array of (label, value, desc)
#let prob-metric-cards(cards, height: 4.9cm) = grid(
  columns: (1fr,) * cards.len(),
  gutter: 14pt,
  ..cards.map(c => rect(
    width: 100%, height: height, fill: none,
    stroke: (rest: 0.6pt + probity-light-blue.transparentize(45%), left: 3pt + probity-gold),
    inset: (left: 16pt, top: 14pt, right: 14pt, bottom: 12pt),
  )[
    #_eyebrow(c.label, fill: probity-gold)
    #v(1fr)
    #text(size: 27pt, weight: "bold", fill: white)[#c.value]
    #v(1fr)
    #text(size: 11pt, fill: probity-light-blue)[#c.desc]
  ]),
)

// ── Numbered steps (left column of a process slide) ──
// steps: array of (title, body)
#let prob-steps(steps, gap: 0.5cm) = {
  set text(size: 13pt)
  grid(
    rows: (auto,) * steps.len(),
    row-gutter: gap,
    // Each step is a 2x2 grid:
    //   row 1: number badge + title, vertically centred against each other
    //   row 2: empty under the badge, body hanging-indented under the title
    // (Previously the badge was horizon-centred against title+body together, so on
    //  multi-line steps it drifted to the middle instead of sitting with the title.)
    ..steps.enumerate().map(((i, s)) => grid(
      columns: (1.0cm, 1fr),
      column-gutter: 0.5cm,
      row-gutter: 5pt,
      grid.cell(align: center + horizon, circle(radius: 0.5cm, fill: probity-navy)[
        #align(center + horizon, text(fill: white, weight: "bold", size: 15pt)[#(i + 1)])
      ]),
      grid.cell(align: left + horizon,
        text(weight: "bold", fill: probity-navy, size: 15pt)[#s.title]),
      [],
      text(fill: probity-body)[#s.body],
    )),
  )
}

// ── Formula card (navy fill, gold bar): aligned mono lines ──
// lines: array of (name, expr) — `name = expr` rendered with gold name, white expr.
#let prob-formula-card(lines, label: "The Formula", note: none, footnote: none, height: auto) = block(
  fill: probity-navy, width: 100%, height: height,
  stroke: (left: 4pt + probity-gold),
  inset: (left: 18pt, right: 16pt, top: 15pt, bottom: 13pt),
)[
  #_eyebrow(label, fill: probity-gold)
  #if note != none {
    v(7pt)
    text(fill: probity-light-blue, style: "italic", size: 11pt)[#note]
  }
  #v(13pt)
  #set text(font: mono-font, size: 13pt)
  #grid(
    columns: (auto, auto, 1fr),
    column-gutter: 10pt,
    row-gutter: 11pt,
    ..lines.map(((name, expr)) => (
      text(fill: probity-gold, weight: "bold")[#name],
      text(fill: white)[\=],
      text(fill: white)[#expr],
    )).flatten(),
  )
  #if footnote != none {
    v(1fr)
    text(fill: probity-light-blue.transparentize(15%), style: "italic", size: 10pt)[#footnote]
  }
]

// ── Result card (pale-tint fill, gold bar): label + big value + desc ──
#let prob-result-card(value, label: "Result", desc: none, footnote: none, height: auto) = block(
  fill: probity-pale-tint, width: 100%, height: height,
  stroke: (left: 4pt + probity-gold),
  inset: (left: 20pt, right: 18pt, top: 18pt, bottom: 16pt),
)[
  #_eyebrow(label, fill: probity-gold)
  #v(0.55cm)
  #text(size: 36pt, weight: "bold", fill: probity-navy)[#value]
  #if desc != none {
    v(0.45cm)
    text(size: 13pt, fill: probity-body)[#desc]
  }
  #if footnote != none {
    v(1fr)
    v(0.3cm)
    text(size: 11pt, fill: probity-muted, style: "italic")[#footnote]
  }
]

// ── Big centered equation box (gold border) ──
#let prob-equation-box(content, fill-col: none, border: probity-gold, text-col: white) = align(center,
  block(
    width: 100%, fill: fill-col, stroke: 1pt + border, radius: 2pt,
    inset: (x: 24pt, y: 17pt),
  )[
    #set text(fill: text-col, size: 23pt, weight: "bold")
    #content
  ]
)

// ── Two-column layout convenience ──
#let prob-cols(left, right, ratio: (1fr, 1fr), gutter: 1cm) = grid(
  columns: ratio, column-gutter: gutter, align: top, left, right,
)

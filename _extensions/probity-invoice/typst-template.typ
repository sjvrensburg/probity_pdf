// Probity Data Analytics — invoice template (typst-template.typ)
// Brand: navy/blue palette, Carlito. A4 portrait, single-page invoice.
// Targets Typst 0.11+ (Quarto 1.5+). All invoice data arrives as function
// arguments wired from YAML front-matter by typst-show.typ.

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

// ── Money formatting ──────────────────────────────────────────────────────
// Format a money value as "R 40,000.00". `value` may be a float, int, or bare
// numeric string (the form money takes in YAML front-matter). Rounds through
// integer cents to dodge float-repr noise; inserts thousands separators;
// emits an ASCII minus for negatives (str(float) yields a U+2212 minus).
#let money(value, symbol: "R") = {
  let n = float(value)
  let neg = n < 0
  let n = calc.abs(n)
  let cents = calc.round(n * 100)
  let whole = calc.floor(cents / 100)
  let frac = calc.rem(cents, 100)
  let whole-str = str(whole)
  let grouped = ()
  for (i, c) in whole-str.rev().clusters().enumerate() {
    if i > 0 and calc.rem(i, 3) == 0 { grouped.push(",") }
    grouped.push(c)
  }
  let whole-grouped = grouped.rev().join()
  let frac-str = if frac < 10 { "0" + str(frac) } else { str(frac) }
  let prefix = if neg { "-" + symbol + " " } else { symbol + " " }
  prefix + whole-grouped + "." + frac-str
}

// ── Totals ─────────────────────────────────────────────────────────────────
// items: array of (description:, qty:, unit:) — `unit` is a money string.
// discount: money string (amount, not a percentage). tax-rate: fraction.
#let compute-totals(items, discount: "0", tax-rate: 0) = {
  let subtotal = items.fold(0.0, (acc, it) => acc + float(it.qty) * float(it.unit))
  let disc = float(discount)
  let taxable = subtotal - disc
  let tax = calc.round(taxable * tax-rate, digits: 2)
  (subtotal: subtotal, discount: disc, tax: tax, total: taxable + tax)
}

// Small tracked uppercase eyebrow label, in a given fill (navy for headings,
// mid-blue for accents).
#let _eyebrow(label, fill: probity-navy) = text(
  size: 8.5pt, tracking: 0.12em, weight: "bold", fill: fill,
)[#upper(label)]

// One label/value row for the metadata mini-table.
#let _meta-row(label, value) = (
  text(size: 8.5pt, fill: probity-muted, tracking: 0.04em)[#upper(label)],
  text(size: 10pt, weight: "bold", fill: probity-body)[#value],
)

// ── Main template ──────────────────────────────────────────────────────────
#let probity-invoice(
  company-name: [Probity Data Analytics],
  company-address: [],
  company-phone: none,
  company-email: none,
  invoice-number: none,
  issue-date: none,
  due-date: none,
  terms: none,
  customer-id: none,
  client-name: none,
  client-address: [],
  items: (),
  discount: "0",
  tax-rate: 0,
  tax-label: "VAT",
  currency: "R",
  invoice-notes: none,
  bank-holder: none,
  bank-account: none,
  bank-name: none,
  bank-branch-code: none,
  bank-reference: none,
  footer-email: none,
  lang: "en",
  doc,
) = {
  set text(font: body-font, fill: probity-body, lang: lang)
  set page(
    paper: "a4",
    margin: (top: 1.4cm, bottom: 1.4cm, left: 1.5cm, right: 1.5cm),
    numbering: none,
  )

  let t = compute-totals(items, discount: discount, tax-rate: tax-rate)
  let show-discount = float(discount) != 0.0
  let show-tax = tax-rate != 0

  // Metadata rows, each only if its value is present.
  let meta-rows = ()
  if invoice-number != none { meta-rows.push(_meta-row("Invoice #", invoice-number)) }
  if customer-id != none { meta-rows.push(_meta-row("Customer ID", customer-id)) }
  if issue-date != none { meta-rows.push(_meta-row("Issue date", issue-date)) }
  if due-date != none { meta-rows.push(_meta-row("Due date", due-date)) }
  if terms != none { meta-rows.push(_meta-row("Terms", terms)) }

  // ── Header: logo + company (left), INVOICE word + number (right) ──
  grid(
    columns: (1fr, auto), column-gutter: 1cm, align: (left, right),
    block[
      #image("_extensions/probity-invoice/assets/logo_trim.png", width: 4.6cm)
      #v(4pt)
      #text(size: 13pt, weight: "bold", fill: probity-navy)[#company-name]
      #if company-address != [] [ #text(size: 9pt, fill: probity-muted)[#company-address] ]
      #v(1pt)
      #text(size: 9pt, fill: probity-muted)[
        #if company-phone != none [#company-phone#h(1em)]]
        #if company-email != none [#company-email]
      ]
    ,
    align(right + horizon)[
      #text(size: 30pt, weight: "bold", tracking: 0.04em, fill: probity-navy)[INVOICE]
      #if invoice-number != none [
        #v(2pt)
        #text(size: 11pt, weight: "bold", fill: probity-mid-blue)[#invoice-number]
      ]
    ],
  )
  v(10pt)
  line(length: 100%, stroke: 1.2pt + probity-navy)
  v(12pt)

  // ── Meta row: BILL TO (left), invoice metadata (right) ──
  grid(
    columns: (1.25fr, 1fr), column-gutter: 1cm, align: (left, left),
    // BILL TO
    block[
      #_eyebrow("Bill to", fill: probity-mid-blue)
      #v(5pt)
      #text(size: 11.5pt, weight: "bold", fill: probity-navy)[#client-name]
      #v(2pt)
      #text(size: 9.5pt, fill: probity-body)[#client-address]
    ],
    // Metadata mini-table
    block[
      #table(
        columns: (auto, 1fr), column-gutter: 10pt, row-gutter: 4pt,
        stroke: none, align: (left, right),
        ..meta-rows.flatten(),
      )
    ],
  )
  v(16pt)

  // ── Line items ──
  // No column-gutter: gutters punch white slivers through the navy header and
  // the zebra fill. Cell padding comes from `inset` instead, so the fills run
  // edge to edge.
  table(
    columns: (1fr, auto, auto, auto),
    align: (left, right, right, right),
    stroke: (top: 1pt + probity-navy, bottom: 0.6pt + probity-rule, x: none),
    inset: (x: 10pt, y: 7pt),
    fill: (_, y) => if y == 0 { probity-navy } else if calc.odd(y) { probity-pale-tint } else { white },
    table.header(
      text(fill: white, weight: "bold", size: 9pt)[DESCRIPTION],
      text(fill: white, weight: "bold", size: 9pt)[QTY],
      text(fill: white, weight: "bold", size: 9pt)[UNIT PRICE],
      text(fill: white, weight: "bold", size: 9pt)[AMOUNT],
    ),
    table.hline(stroke: 1.2pt + probity-mid-blue),
    ..items.map(it => (
      text(size: 10pt)[#it.description],
      text(size: 10pt)[#it.qty],
      text(size: 10pt)[#money(it.unit, symbol: currency)],
      text(size: 10pt, weight: "bold")[#money(float(it.qty) * float(it.unit), symbol: currency)],
    )).flatten(),
  )
  v(10pt)

  // ── Totals (right-aligned) ──
  align(right)[
    #block(width: 9.5cm)[
      #table(
        columns: (1fr, auto), column-gutter: 14pt, row-gutter: 5pt,
        stroke: none, align: (left, right), inset: (x: 10pt, y: 6pt),
        text(size: 9.5pt, fill: probity-muted)[Subtotal],
        text(size: 10pt)[#money(t.subtotal, symbol: currency)],
        ..(if show-discount {
          (text(size: 9.5pt, fill: probity-muted)[Discount], text(size: 10pt, fill: probity-mid-blue)[#money(-t.discount, symbol: currency)],)
        } else { () }),
        ..(if show-tax {
          (text(size: 9.5pt, fill: probity-muted)[#tax-label #if tax-rate != 0 [ (#(str(calc.round(tax-rate * 100)))%)]], text(size: 10pt)[#money(t.tax, symbol: currency)],)
        } else { () }),
      )
      #block(
        width: 100%, fill: probity-navy, inset: (x: 10pt, y: 8pt), above: 4pt,
        grid(
          columns: (1fr, auto), column-gutter: 14pt,
          text(fill: white, weight: "bold", size: 10pt, tracking: 0.04em)[TOTAL DUE],
          text(fill: white, weight: "bold", size: 13pt)[#money(t.total, symbol: currency)],
        ),
      )
    ]
  ]

  // ── Notes ──
  if invoice-notes != none {
    v(14pt)
    _eyebrow("Notes", fill: probity-mid-blue)
    v(3pt)
    text(size: 9pt, fill: probity-muted)[#invoice-notes]
  }

  // Render any residual document body (normally empty for an invoice).
  doc

  // ── Bank-transfer footer, pinned to the bottom of the body ──
  // `v(1fr)` consumes leftover vertical space so the banner sits flush at the
  // bottom of the content area (within the page margins, so nothing clips).
  v(1fr)
  block(width: 100%, spacing: 0pt)[
    #block(width: 100%, fill: probity-navy, inset: (x: 14pt, y: 8pt))[
      #grid(
        columns: (1fr,) * 2, column-gutter: 18pt, row-gutter: 3pt,
        text(size: 8.5pt, fill: probity-light-blue, tracking: 0.04em)[#upper("Accountholder")],
        text(size: 8.5pt, fill: probity-light-blue, tracking: 0.04em)[#upper("Bank")],
        text(size: 9.5pt, fill: white)[#bank-holder],
        text(size: 9.5pt, fill: white)[#bank-name],
        text(size: 8.5pt, fill: probity-light-blue, tracking: 0.04em)[#upper("Account no.")],
        text(size: 8.5pt, fill: probity-light-blue, tracking: 0.04em)[#upper("Branch code")],
        text(size: 9.5pt, fill: white)[#bank-account],
        text(size: 9.5pt, fill: white)[#bank-branch-code],
        text(size: 8.5pt, fill: white, weight: "bold", tracking: 0.04em)[#upper("Reference")],
        [],
        text(size: 9.5pt, fill: white)[#bank-reference],
        [],
      )
    ]
    #v(6pt)
    #align(center, text(size: 9pt, fill: probity-muted)[
      Thank you for your business.#if footer-email != none [
        #h(1em) Questions? #footer-email]
    ])
  ]
}

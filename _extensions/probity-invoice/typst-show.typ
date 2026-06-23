#show: doc => probity-invoice(
$if(company-name)$
  company-name: [$company-name$],
$endif$
$if(company-address)$
  company-address: [$company-address$],
$endif$
$if(company-phone)$
  company-phone: [$company-phone$],
$endif$
$if(company-email)$
  company-email: [$company-email$],
$endif$
$if(invoice-number)$
  invoice-number: "$invoice-number$",
$endif$
$if(issue-date)$
  issue-date: "$issue-date$",
$endif$
$if(due-date)$
  due-date: "$due-date$",
$endif$
$if(terms)$
  terms: "$terms$",
$endif$
$if(customer-id)$
  customer-id: "$customer-id$",
$endif$
$if(client-name)$
  client-name: [$client-name$],
$endif$
$if(client-address)$
  client-address: [$client-address$],
$endif$
$if(items)$
  items: (
$for(items)$
    (description: [$it.description$], qty: $it.qty$, unit: "$it.unit$"),
$endfor$
  ),
$endif$
$if(discount)$
  discount: "$discount$",
$endif$
$if(tax-rate)$
  tax-rate: $tax-rate$,
$endif$
$if(tax-label)$
  tax-label: "$tax-label$",
$endif$
$if(currency)$
  currency: "$currency$",
$endif$
$if(invoice-notes)$
  invoice-notes: [$invoice-notes$],
$endif$
$if(bank-holder)$
  bank-holder: [$bank-holder$],
$endif$
$if(bank-account)$
  bank-account: "$bank-account$",
$endif$
$if(bank-name)$
  bank-name: [$bank-name$],
$endif$
$if(bank-branch-code)$
  bank-branch-code: "$bank-branch-code$",
$endif$
$if(bank-reference)$
  bank-reference: [$bank-reference$],
$endif$
$if(footer-email)$
  footer-email: "$footer-email$",
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
  doc,
)

#show: doc => probity-slides(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  authors: (
$for(by-author)$
    "$it.name.literal$",
$endfor$
  ),
$endif$
$if(date)$
  date: "$date$",
$endif$
$if(footer-text)$
  footer-text: [$footer-text$],
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
  doc,
)

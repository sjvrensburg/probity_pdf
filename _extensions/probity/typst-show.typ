#show: doc => probity-report(
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
$if(abstract)$
  abstract: [$abstract$],
$endif$
  toc: $if(toc)$$toc$$else$false$endif$,
$if(lang)$
  lang: "$lang$",
$endif$
  doc,
)

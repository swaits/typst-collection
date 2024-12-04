#import "/lib.typ": *

#let myGlossary = (
  html: (
    short: "HTML",
    long: "Hypertext Markup Language",
    description: "A standard language for creating web pages",
  ),
  css: (
    short: "CSS",
    long: "Cascading Style Sheets",
    description: "A language used for describing the presentation of a document",
  ),
  tps: (
    short: "TPS",
    long: "test procedure specification",
    description: "A document on how to run all the test procedures"
  ),
)

#show: init-glossary.with(myGlossary, show-term: (body) => [#emph(body)])

#text(size: 18pt, weight: "bold")[Theme Gallery]

First, we refer to each term at least once so they'll actually show up in the
glossaries. Our terms include: @html:cap, @css, and @tps.

// TODO: ask Discord if there's a way to get a symbol (ie function) name as a
// TODO: figure out if there's a way to get a symbol (ie function) name as a
// string or content
#let themes = (
  ("theme-basic",   theme-basic),
  ("theme-compact", theme-compact),
)

#for theme in themes {
  block(
    breakable: false,
    spacing: 2em,
    inset: 1em,
    stroke: 1pt+gray,
    glossary(title: raw(theme.first()), theme: theme.last())
  )
}

// HACK: special case theme-twocol so we can restrict the height
#block(
  breakable: false,
  spacing: 2em,
  inset: 1em,
  stroke: 1pt+gray,
  height: 1.5in,
  glossary(title: raw("theme-twocol"), theme: theme-twocol)
)

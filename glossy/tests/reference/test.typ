#import "/lib.typ": *


#show: init-glossary.with(
  yaml("glossary.yaml"),
)


= Testing
Sample referencing of acronyms with `reference` dictionary. @refac does not use any supplement while @refacwsup uses a supplement


#glossary(title: "Academic", theme: theme-academic)
#glossary(title: "Basic", theme: theme-basic)
#glossary(title: "Chicago", theme: theme-chicago-index)
#glossary(title: "Compact", theme: theme-compact)
#glossary(title: "Table", theme: theme-table)
#glossary(title: "Twocol", theme: theme-twocol)



#bibliography("test.bib")
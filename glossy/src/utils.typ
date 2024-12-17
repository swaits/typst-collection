// Returns the provided value if it is not none, otherwise returns the default value
// Parameters:
//   val: The value to check
//   default: The fallback value to use if val is none
// Returns: val if not none, otherwise default
#let __default(val, default) = if val == none { default } else { val }

// Converts an English word to its plural form following standard English pluralization rules
// Parameters:
//   word: The singular word to pluralize
// Returns: The pluralized form of the word, or none if input is none
#let __pluralize(word) = {
  // Early exit for invalid input
  if word == none {
    return none
  }

  // Helper functions for checking endings
  let ends_with = (suffix) => lower(word).ends-with(suffix)
  let ends_with_any = (suffixes) => suffixes.any((suffix) => ends_with(suffix))

  // Map of irregular plurals for common words
  let irregulars = (
    "alumna": "alumnae",
    "alumnus": "alumni",
    "analysis": "analyses",
    "appendix": "appendices",
    "basis": "bases",
    "cactus": "cacti",
    "child": "children",
    "crisis": "crises",
    "criterion": "criteria",
    "datum": "data",
    "foot": "feet",
    "fungus": "fungi",
    "goose": "geese",
    "man": "men",
    "medium": "media",
    "mouse": "mice",
    "nucleus": "nuclei",
    "oasis": "oases",
    "person": "people",
    "phenomenon": "phenomena",
    "stimulus": "stimuli",
    "thesis": "theses",
    "tooth": "teeth",
    "woman": "women",
  )

  // Set of plural-only words
  let plural_only = (
    "advice",
    "alumni",
    "bison",
    "children",
    "criteria",
    "data",
    "deer",
    "feet",
    "fish",
    "geese",
    "information",
    "media",
    "men",
    "mice",
    "money",
    "moose",
    "octopi",
    "octopodes",
    "people",
    "scissors",
    "series",
    "sheep",
    "species",
    "teeth",
    "trousers",
    "women",
  )

  // Irregular suffixes
  let f_to_ves = ("leaf", "loaf", "calf", "half", "wolf", "thief")
  let fe_to_ves = ("wife", "knife", "life")
  let o_to_os = ("photo", "piano", "halo", "radio", "video", "studio", "solo", "taco", "memo", "zero")

  // Convenience
  let w = lower(word)

  // Check for words already plural
  if plural_only.contains(w) {
    return word
  }

  // Check for irregular singulars
  if irregulars.keys().contains(w) {
    return irregulars.at(w)
  }

  // Standard pluralization rules
  if ends_with("iz") {
    word + "zes"
  } else if ends_with_any(("s", "x", "z", "sh", "ch")) {
    word + "es"
  } else if ends_with("y") {
    if not ends_with_any(("ay", "ey", "iy", "oy", "uy")) {
      word.slice(0, -1) + "ies"
    } else {
      word + "s"
    }
  } else if ends_with("f") {
    if f_to_ves.contains(w) {
      word.slice(0, -1) + "ves"
    } else {
      word + "s"
    }
  } else if ends_with("fe") {
    if fe_to_ves.contains(w) {
      word.slice(0, -2) + "ves"
    } else {
      word + "s"
    }
  } else if ends_with("us") {
    word.slice(0, -2) + "i"
  } else if ends_with("is") {
    word.slice(0, -2) + "es"
  } else if ends_with("on") {
      word + "s"
  } else if ends_with("o") {
    if o_to_os.contains(w) {
      word + "s"
    } else {
      word + "es"
    }
  } else {
    word + "s"
  }
}

ColorRow = require("./ColorRow")

module.exports = class PossibleSolutions
  @all: (colors, morePegs) ->
    if not Array.isArray(colors)
      throw new Error("Need color array to generate solutions")
    if morePegs < 1
      throw new Error("Need at least one peg for solutions")
    solutions = colors.map (c) -> [c]
    morePegs -= 1
    while morePegs > 0
      nextgen = []
      for col in colors
        for sol in solutions
          newsol = sol.slice()
          newsol.push(col)
          nextgen.push(newsol)
      solutions = nextgen
      morePegs -= 1
    return new PossibleSolutions(solutions.map((c) -> new ColorRow(c)))

  # keeps a list of possible solutions
  constructor: (colorRows) -> @possible = colorRows

  # Simple cloning
  clone: () -> new PossibleSolutions(@possible.slice())

  # for a ColorRow and given result, remove impossible solutions
  winnow: (colorRow, result) ->
    copy = @possible.slice()
    ix = 0
    while ix < copy.length
      sol = copy[ix]
      res = sol.compare(colorRow)
      if res.correct isnt result.correct or res.misplaced isnt result.misplaced
        copy.splice(ix, 1)
      else
        ix += 1
    return new PossibleSolutions(copy)

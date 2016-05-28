###
# An evil opponent who keeps the solution slippery
###

ColorRow = require("./ColorRow")
PossibleSolutions = require("./PossibleSolutions")


module.exports = class Codemaker
  constructor: (@colors, @length) ->
    @solutions = PossibleSolutions.all(@colors, @length)
  # Submits a guess, limiting the possible solutions, returns result
  guess: (row) ->
    if not row instanceof ColorRow
      throw new Error("I require a ColorRow to guess")
    for col in row.colors when -1 is @colors.indexOf(col)
      throw new Error("Color '#{col}' is not in the game")
    # gather the possible results
    possibleResults = {}
    for pos in @solutions.possible
      result = pos.compare(row)
      sRes = "b#{result.correct},w#{result.misplaced}"
      possibleResults[sRes] ?= {result: result, rows: []}
      possibleResults[sRes].rows.push(pos)
    # Pick the result that leaves the most solutions still fitting
    picked = null
    for desc, obj of possibleResults
      if picked and picked.rows.length >= obj.rows.length and not picked.result.exact
        continue
      else
        picked = obj
    # Modify our solutions and return the new result
    @solutions = new PossibleSolutions(picked.rows)
    return picked.result

  # Number of open solutions still possible
  count: () -> @solutions.possible.length

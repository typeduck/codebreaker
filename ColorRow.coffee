###
# Class representing an ordered pick of colors. could represent eiter a guess or
a solution.
###
module.exports = class ColorRow
  constructor: (@colors) ->
    if not Array.isArray(@colors)
      throw new Error("ColorRow requires array of color strings")
    @type = []
    mine = @colors.slice()
    while mine.length
      toSet = 1
      col = mine.shift()
      while -1 isnt (idx = mine.indexOf(col))
        toSet += 1
        mine.splice(idx, 1)
      @type.push(toSet)
    @type.sort().reverse()

  compare: (other) ->
    mine = @colors.slice()
    if not other instanceof ColorRow
      throw new Error("ColorRow can only compare to ColorRow")
    theirs = other.colors.slice()
    if mine.length isnt theirs.length
      throw new Error("ColorRows can only compare same length")
    # Create a comparison object for the rows
    ret = {correct: 0, misplaced: 0}
    # First, count (and remove) exactly correct answers
    idx = 0
    while idx < mine.length
      colMine = mine[idx]
      colTheirs = theirs[idx]
      if colMine is colTheirs
        ret.correct += 1
        mine.splice(idx, 1)
        theirs.splice(idx, 1)
      else
        idx += 1
    # Next, count (and remove) misplaced colors)
    while theirs.length
      colTheirs = theirs.shift()
      if -1 isnt (idx = mine.indexOf(colTheirs))
        mine.splice(idx, 1)
        ret.misplaced += 1
    # return the comparison
    ret.exact = (ret.correct is @colors.length)
    return ret

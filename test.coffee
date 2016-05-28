
require("should")

ColorRow = require("./ColorRow")
PossibleSolutions = require("./PossibleSolutions")
allColors = [
  "red"
  "yellow"
  "blue"
  "green"
  "black"
  "white"
  "brown"
  "orange"
]

describe "ColorRow", () ->
  it "should accept instantiation", () ->
    row = new ColorRow(["red", "blue", "yellow", "white", "white"])

  it "should compare accurately", () ->
    row = new ColorRow(["red", "blue", "yellow", "white", "white"])
    test = new ColorRow(["yellow", "blue", "white", "white", "black"])
    comp = row.compare(test)
    comp.correct.should.equal(2)
    comp.misplaced.should.equal(2)
    comp.exact.should.equal(false)

  # first version compared this row wrong
  it "should compare accurately", () ->
    row = new ColorRow([ "orange", "brown", "black", "black", "brown" ])
    test = new ColorRow(["green", "black", "red", "black", "black"])
    comp = row.compare(test)
    comp.correct.should.equal(1)
    comp.misplaced.should.equal(1)
    comp.exact.should.equal(false)

  it "should compare accurately for a real game", () ->
    solution = new ColorRow(["black", "blue", "black", "brown", "orange"])
    test = new ColorRow(["green", "green", "black", "brown", "yellow"])
    comp = solution.compare(test)
    comp.correct.should.equal(2)
    comp.misplaced.should.equal(0)
    comp.exact.should.equal(false)

    test = new ColorRow(["orange", "blue", "red", "white", "white"])
    comp = solution.compare(test)
    comp.correct.should.equal(1)
    comp.misplaced.should.equal(1)
    comp.exact.should.equal(false)

    test = new ColorRow(["orange", "green", "brown", "brown", "red"])
    comp = solution.compare(test)
    comp.correct.should.equal(1)
    comp.misplaced.should.equal(1)
    comp.exact.should.equal(false)

    test = new ColorRow(["black", "blue", "black", "brown", "orange"])
    comp = solution.compare(test)
    comp.correct.should.equal(5)
    comp.misplaced.should.equal(0)
    comp.exact.should.equal(true)

  it "should report repetition type of colors", () ->
    row = new ColorRow(["black", "blue", "yellow", "brown", "orange"])
    row.type.should.eql([1, 1, 1, 1, 1])
    
    row = new ColorRow(["black", "blue", "black", "brown", "orange"])
    row.type.should.eql([2, 1, 1, 1])
    
    row = new ColorRow(["black", "blue", "black", "brown", "blue"])
    row.type.should.eql([2, 2, 1])
    
    row = new ColorRow(["orange", "blue", "black", "black", "blue"])
    row.type.should.eql([2, 2, 1])

    row = new ColorRow(["orange", "blue", "orange", "orange", "blue"])
    row.type.should.eql([3, 2])

    row = new ColorRow(["orange", "blue", "orange", "orange", "orange"])
    row.type.should.eql([4, 1])

    row = new ColorRow(["orange", "orange", "orange", "orange", "orange"])
    row.type.should.eql([5])


# Try out a game
describe "PossibleSolutions", () ->
  it "should winnow for a real game", () ->
    # Create a placeholder for possible solutions, winnow down
    all = PossibleSolutions.all(allColors, 5)

    # Create the solution to obtain the comparison
    solution = new ColorRow(["black", "blue", "black", "brown", "orange"])

    test = new ColorRow(["green", "green", "black", "brown", "yellow"])
    comp = solution.compare(test)
    all = all.winnow(test, comp)

    test = new ColorRow(["orange", "blue", "red", "white", "white"])
    comp = solution.compare(test)
    all = all.winnow(test, comp)

    test = new ColorRow(["orange", "green", "brown", "brown", "red"])
    comp = solution.compare(test)
    all = all.winnow(test, comp)

    test = new ColorRow(["black", "blue", "black", "brown", "orange"])
    comp = solution.compare(test)
    all = all.winnow(test, comp)

    all.possible.length.should.equal(1)

  it "should winnow for a real game (2)", () ->
    # Create a placeholder for possible solutions, winnow down
    all = PossibleSolutions.all(allColors, 5)

    # Create the solution to obtain the comparison
    solution = new ColorRow(["orange", "brown", "black", "black", "brown"]);

    test = new ColorRow(["green", "green", "black", "brown", "yellow"])
    comp = solution.compare(test)
    all = all.winnow(test, comp)

    test = new ColorRow(["orange", "blue", "red", "white", "white"])
    comp = solution.compare(test)
    all = all.winnow(test, comp)

    test = new ColorRow(["green", "brown", "red", "red", "brown"])
    comp = solution.compare(test)
    all = all.winnow(test, comp)

    test = new ColorRow(["green", "blue", "blue", "blue", "brown"])
    comp = solution.compare(test)
    all = all.winnow(test, comp)

    test = new ColorRow([ 'black', 'brown', 'black', 'white', 'brown' ])
    comp = solution.compare(test)
    all = all.winnow(test, comp)

    all.possible.length.should.equal(1)

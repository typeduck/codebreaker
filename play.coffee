#!/usr/bin/env coffee
Promise = require("bluebird")

Codemaker = require("./Codemaker")
ColorRow = require("./ColorRow")
PossibleSolutions = require("./PossibleSolutions")

colors = [
  "red"
  "yellow"
  "blue"
  "green"
  "black"
  "white"
  "brown"
  "orange"
]

game = new Codemaker(colors, 5)

reader = require("readline").createInterface(process.stdin, process.stdout)
reader.setPrompt(">")
readLine = () ->
  return new Promise((resolve, reject) ->
    reader.question("Guess: ", resolve)
  )

# Read in guesses, winnow possible solutions & output results
looper = () ->
  console.log("%d Solutions remain", game.count())
  readLine().then((line) ->
    row = new ColorRow(line.split(/[^a-z]+/))
    result = game.guess(row)
    pegs = []
    for i in [0...result.correct]
      pegs.push("b")
    for i in [0...result.misplaced]
      pegs.push("w")
    console.log("You get: %s", pegs)
    if result.exact
      console.log("Congratulations!")
      reader.close()
    else
      setImmediate(looper)
  )
  .catch((e) ->
    console.error(e)
    setImmediate(looper)
  )

setImmediate(looper)

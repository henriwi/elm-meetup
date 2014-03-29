import Window

{-- Part 1: Model the user input --------}

type Input = { time:Float }




{-- Part 2: Model the game ---------------}

type Game = {}

defaultGame : Game
defaultGame = {}




{-- Part 3: Update the game ---------------}

stepGame : Input -> Game -> Game
stepGame {time} g = g




{-- Part 4: Display the game --------------}

display : (Int,Int) -> Game -> Element
display (w,h) g = asText g


delta = fps 30
input = sampleOn delta (lift Input delta)

gameState = foldp stepGame defaultGame input

main = lift2 display Window.dimensions gameState
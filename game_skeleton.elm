import Window

{-- Part 1: Model the user input ----------------------------------------------
------------------------------------------------------------------------------}

type UserInput = {}

userInput : Signal UserInput
userInput = constant {}

type Input = { timeDelta:Float, userInput:UserInput }


{-- Part 2: Model the game ----------------------------------------------------
------------------------------------------------------------------------------}

type GameState = {}

defaultGame : GameState
defaultGame = {}


{-- Part 3: Update the game ---------------------------------------------------
------------------------------------------------------------------------------}

stepGame : Input -> GameState -> GameState
stepGame {timeDelta,userInput} gameState = gameState


{-- Part 4: Display the game --------------------------------------------------
------------------------------------------------------------------------------}

display : (Int,Int) -> GameState -> Element
display (w,h) gameState = asText gameState


delta = fps 30
input = sampleOn delta (lift2 Input delta userInput)

gameState = foldp stepGame defaultGame input

main = lift2 display Window.dimensions gameState
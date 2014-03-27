-- Basics
-- SHOW THIS ON YOUR COMPUTER
-- SHOW GENERATED SOURCES

main = asText "Hello Haskell Meetup!"

-- Show compiled versions of a Elm-program

-- Lister
--
main = asText [1,2,3]

-- Records
-- A record is a lightweight labeled data structure. 
--
main = asText { x=3, y=4 }

-- Acess and update values
--
henrik = {name="Wingerei", age=27}
n1 = henrik.name
n2 = .name henrik
main = asText [n1,n2]

-- Pattern matching on records
-- under30 will match any record having an age field
-- THIS ONE

henrik = {name="Wingerei", age=27}
under30 {age} = age < 30
main = asText (under30 henrik)

-- Updating records
--
henrik = {name="Wingerei", age=27}
henrik2 = {henrik | age <- 28}
main = asText henrik2

-- Funksjoner
hello : String -> String
hello name = "Hello " ++ name ++ "!"
main = asText [ hello "Joel", hello "Henrik" ]

-- Records and functions together
-- This pattern you will often see in Elm-games (Model and step functions)
type Person = {age:Int}
henrik : Person
henrik = {age=27}

stepPerson : Person -> Person
stepPerson person = { person | age <- person.age + 1}

main = henrik |> stepPerson |> asText

-- Graphics

-- Basic graphical elements are called elements in Elm. An element is a rectangle with a known width and height. 
-- text, image, video :: String -> Element

--
main = image 200 200 "/img/yogi.jpg"

--  In Elm, irregular shapes that cannot be stacked easily are called forms. 
--  These visual forms have shape, color, and many more properties and can be displayed any which way on a collage.

--
main = collage 400 400 [square 50 |> filled red]

-- |> means function application (borrowed from F#)
-- More readable than (these to examples are the same)

--
main = collage 400 400  [move (50,50) (filled red (square 50))]

main = collage 400 400  [square 50 |> filled red |> move (50, 50)]

--
-- Signals

main = lift asText Mouse.position

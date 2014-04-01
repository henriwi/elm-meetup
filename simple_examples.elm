-- Basics
-- SHOW THIS ON YOUR COMPUTER
-- SHOW GENERATED SOURCES

main = asText "Hello Haskell Meetup!"

-- Show compiled versions of a Elm-program
-- GO ON elm-lang.org

main = [markdown|

# Hello Haskell
## Meetup!

|]

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

-- Types are inferred in Elm, so you don't have to define them
-- But you can also define them on records and functions
-- Pattern matching on records
-- under30 will match any record having an age field
type Person = {name:String, age:Int}

henrik : Person
henrik = {name="Wingerei", age=27}

under30 : Person -> Bool
under30 p = p.age < 30

main = asText (under30 henrik)

-- Updating records
-- Take henrik and update these particular fields

type Person = {name:String, age:Int}
henrik : Person
henrik = {name="Wingerei", age=27}

setAge : Person -> Int -> Person
setAge henrik a = {henrik | age <- a}

main = asText (setAge henrik 28)

-- setAge takes two parameters => implicit currying
-- currying:  is the technique of transforming a function that takes multiple arguments 
-- in such a way that it can be called as a chain of functions, each with a single argument

type Person = {name:String, age:Int}
henrik : Person
henrik = {name="Wingerei", age=27}

setAge : Person -> Int -> Person
setAge henrik a = {henrik | age <- a}

setAge2 = setAge henrik

main = asText (setAge2 30)
--OR
main = asText (setAge henrik (29))


-- Graphics

-- Basic graphical elements are called elements in Elm. An element is a rectangle with a known width and height. 
-- text, image, video :: String -> Element

--
main = image 200 200 "/yogi.jpg"

-- You can also stack these elements
yogi = image 200 200 "/yogi.jpg"
book = image 200 200 "/book.jpg"
main = flow down [yogi, book]

--  In Elm, irregular shapes that cannot be stacked easily are called forms. 
--  These visual forms have shape, color, and many more properties and can be displayed any which way on a collage.

main = collage 400 400 [square 50 |> filled red]

-- |> means application (borrowed from F#)
-- f x == x |> f
-- a way of saving parenthesis
-- More readable than (these to examples are the same)

main = collage 400 400 [move (50,50) (filled red (square 50))]

main = collage 400 400 [square 50 |> filled red |> move (50, 50)]

-- "So fare we've seen functional static programming, what about the reactive part?"
-- Mouse.position is a Signal (Int, Int) = a pair of integeres that changes over time

--  lift = take some function, and always apply it to the current value of the signal
--  Doing a transformation on the latest value

import Mouse
main = lift asText Mouse.position

-- Combining Signals and Graphics

import Keyboard

yogi = image 200 200 "/yogi.jpg"

shapes {x,y} = collage 400 400 
                 [square 100 |> filled red |> move (toFloat x*100, toFloat y*100)]

main = lift shapes Keyboard.arrows

-- Move yogi instead

import Keyboard

yogi = image 200 200 "/yogi.jpg"

shapes {x,y} = collage 400 400 
                 [toForm yogi |> move (toFloat x*100, toFloat y*100)]

main = lift shapes Keyboard.arrows

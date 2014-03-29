import Window
import Mouse
import Random

(width, height) = (400, 400)
(hWidth, hHeight) = (width/2, height/2)

delta = fps 30

relPos : (Int, Int) -> (Int, Int) -> (Int, Int)
relPos (x,y) (w,h) = (x - div w 2, -y + div h 2)

{-- Part 1: Model the user input --------}

type Input = { mPos:(Int, Int), time:Float, rand:Float }


input = sampleOn delta <| Input <~ lift2 relPos Mouse.position Window.dimensions
                                 ~ delta
                                 ~ (Random.float delta)



{-- Part 2: Model the game ---------------}

type Game = {ball:Ball, cat:Cat, kittens:[Cat]}
type Ball = {pos:(Float, Float)}
type Cat = {pos:(Float, Float), vel:(Float, Float)}

defaultGame = {ball = defaultBall, cat = defaultCat, kittens = []}
defaultBall = {pos = (0,0)}
defaultCat = {pos = (0,0), vel = (0,0)}




{-- Part 3: Update the game ---------------}

stepGame : Input -> Game -> Game
stepGame {mPos, time, rand} g = {g | ball <- stepBall mPos g.ball,
                                     cat  <- stepCat  mPos g.cat,
                                  kittens <- spawnKitten g.cat g.kittens rand}

stepBall : (Int, Int) -> Ball -> Ball
stepBall mPos b = { b | pos <- (fst mPos |> toFloat,
                                snd mPos |> toFloat) }

stepCat : (Int, Int) -> Cat -> Cat
stepCat mPos c = { c | pos <- tupAdd c.pos c.vel 1,
                       vel <- tupVel c.pos (fst mPos |> toFloat,
                                            snd mPos |> toFloat)}

spawnKitten : Cat -> [Cat] -> Float -> [Cat]
spawnKitten c kittens r = let kitten = {defaultCat | pos <- c.pos,
                                                     vel <- c.vel}
                              updatedKittens = stepKittens kittens
                          in if length kittens < 50 && r < 0.05
                             then kitten::updatedKittens
                             else updatedKittens

stepKittens : [Cat] -> [Cat]
stepKittens kittens = map (\k -> {k | pos <- tupAdd k.pos k.vel 3})
                      <| filter (\k -> onScreen k.pos) kittens

onScreen (x,y) = x < hWidth && x > -hWidth && y < hHeight && y > -hHeight

tupAdd (ax,ay) (bx,by) s = (ax + s * bx, ay + s * by)


tupVel : (Float, Float) -> (Float, Float) -> (Float, Float)
tupVel (ax,ay) (bx,by) = let s1 = bx - ax
                             s2 = by - ay
                             len = sqrt (s1 * s1 + s2 * s2)
                           in (3.0 * (bx - ax)/len, 3.0 * (by - ay)/len)



{-- Part 4: Display the game --------------}

display : (Int,Int) -> Game -> Element
display (w,h) g = let bPos = g.ball.pos
                      cPos = g.cat.pos
                      drawBall = circle 15 |> filled darkRed
                                           |> move bPos
                      drawCat = square 40  |> filled black
                                           |> move cPos
                                           |> rotate ((fst cPos)/10)
                      drawKitten k = square 10  |> filled blue
                                                |> move k.pos
                                                |> rotate ((fst k.pos)/5)
                                                    
                  in container w h middle <| color gray
                                          <| collage width height (drawBall::drawCat::(map drawKitten g.kittens))


gameState = foldp stepGame defaultGame input

main = lift2 display Window.dimensions gameState
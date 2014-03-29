import Window
import Mouse
import Random

(width, height) = (600, 600)
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
type Cat = {pos:(Float, Float), vel:(Float, Float), shouting:Bool}

defaultGame = {ball = defaultBall, cat = defaultCat, kittens = []}
defaultBall = {pos = (0,0)}
defaultCat = {pos = (0,0), vel = (0,0), shouting = False}




{-- Part 3: Update the game ---------------}

stepGame : Input -> Game -> Game
stepGame {mPos, time, rand} g = {g | ball <- stepBall mPos g.ball,
                                     cat  <- stepCat  mPos g.cat rand,
                                  kittens <- spawnKitten g.cat g.kittens rand}

stepBall : (Int, Int) -> Ball -> Ball
stepBall mPos b = { b | pos <- (fst mPos |> toFloat,
                                snd mPos |> toFloat) }

stepCat : (Int, Int) -> Cat -> Float -> Cat
stepCat mPos c r = { c | pos <- tupAdd c.pos c.vel 1,
                         vel <- tupVel c.pos (fst mPos |> toFloat,
                                              snd mPos |> toFloat),
                         shouting <- if r < 0.05 then not c.shouting else c.shouting}

spawnKitten : Cat -> [Cat] -> Float -> [Cat]
spawnKitten c kittens r = let kitten = {defaultCat | pos <- c.pos,
                                                     vel <- c.vel}
                              updatedKittens = stepKittens kittens
                          in if length kittens < 50 && r < 0.05
                             then kitten::updatedKittens
                             else updatedKittens

stepKittens : [Cat] -> [Cat]
stepKittens kittens = map (\k -> {k | pos <- tupAdd k.pos k.vel 4})
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
display (w,h) g = let catImage c = if (fst c.vel) < 0 then "/img/catl.gif" else "/img/catr.gif"
                      drawBall = circle 25 |> filled darkBlue
                                           |> move g.ball.pos
                      drawCat = catImage g.cat |> image 150 150  
                                               |> toForm
                                               |> move g.cat.pos
                      drawKitten k = catImage k |> image 75 75  
                                                |> toForm
                                                |> move k.pos
                      drawBackground = tiledImage 600 600 "/img/grass.bmp" |> toForm

                      meowTxt  = if g.cat.shouting then "MEOW!" else ""
                      drawMeow = meowTxt |> boldTxt (Text.height 40)
                                         |> toForm
                                         |> move (fst g.cat.pos - 15 * (fst g.cat.vel), snd g.cat.pos + 50.0)
                                                    
                  in container w h middle <| color gray
                                          <| collage width height (drawBackground::(map drawKitten g.kittens) ++ [drawBall, drawCat, drawMeow])

boldTxt   f = leftAligned . f . bold . Text.color darkRed . toText

gameState = foldp stepGame defaultGame input

main = lift2 display Window.dimensions gameState
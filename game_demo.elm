import Mouse
import Window

(width, height) = (500,500)


-- mouse pos relative to the window
relPos : (Int, Int) -> (Int, Int) -> (Int, Int)
relPos (ox,oy) (x,y) = (x - div ox 2, y - div oy 2)


delta = inSeconds <~ fps 40
type Input = { mPos:(Int, Int), delta:Time }
input = sampleOn delta (Input <~ lift2 relPos Window.dimensions Mouse.position
                               ~ delta )
                               
-- Models       
type Game   = { player:Player, enemy:Enemy }
type Player = { pos: (Int, Int) }
type Enemy  = { pos: (Int, Int) }

defaultGame = { player = defaultPlayer, enemy = defaultEnemy }
defaultPlayer = { pos = (0, 0) }
defaultEnemy  = { pos = (width, height) }


-- Step functions
stepGame : Input -> Game -> Game
stepGame input g = { g | player <- stepPlayer input g.player,
                         enemy  <- stepEnemy g.player g.enemy }


stepPlayer : Input -> Player -> Player
stepPlayer input p = { p | pos <- input.mPos }


stepEnemy : Player -> Enemy -> Enemy
stepEnemy p e = { e | pos <- vecFollow e.pos p.pos }


vecFollow (x1, y1) (x2, y2) = (x1 + div (x2 - x1) 10, y1 + div (y2- y1) 10)


-- Display
display : (Int, Int) -> Game -> Element
display (w, h) g = let p          = g.player
                       e          = g.enemy
                       drawPlayer = circle 20 |> filled darkRed
                                              |> move (toFloat (fst p.pos), toFloat -(snd p.pos))
                       drawEnemy  = square 30 |> filled black
                                              |> move (toFloat (fst e.pos), toFloat -(snd e.pos))
                            
                   in color lightGray <| container w h middle
                                      <| color darkGreen
                                      <| collage width height [drawPlayer, drawEnemy]


--main = asText <~ input
main = display <~ Window.dimensions ~ (foldp stepGame defaultGame input)
import Mouse
import Window

(width, height) = (500,500)


-- mouse pos relative to the window
pos : (Int, Int) -> (Int, Int) -> (Int, Int)
pos (ox,oy) (x,y) = (x - div ox 2, y - div oy 2)



display : (Int, Int) -> (Int, Int) -> Element
display (w, h) (x, y) = let drawCircle = circle 20 |> filled darkRed
                                                   |> move (toFloat x, toFloat -y)
                            drawSquare = square 50 |> filled black
                                                   |> move (100, 0)
                            
                        in color lightGray <| container w h middle
                                           <| color darkGreen
                                           <| collage width height [drawCircle,
                                                                    drawSquare]


mouseInput = pos <~ Window.dimensions ~ Mouse.position

main = display <~ Window.dimensions ~ mouseInput
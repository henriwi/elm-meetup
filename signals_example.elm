import Mouse
import Keyboard
import Window


type Input = { mousePos:(Int,Int), mouseClicks:Int, window:(Int,Int), shift:Bool }
input = sampleOn (fps 20) (Input <~ Mouse.position
                                  ~ (count Mouse.clicks)
                                  ~ Window.dimensions
                                  ~ Keyboard.shift)
                                  

display input = let drawClicks = toText (show input.mouseClicks ++ " clicks") |> Text.height 30
                                                                              |> text
                                                                              |> toForm
                                                                              |> move (10,0)
                    drawMouseP = toText ("position: " ++ show input.mousePos) |> Text.height 30
                                                                              |> text
                                                                              |> toForm
                                                                              |> move (10,50)
                    drawShift = toText (if input.shift then "SHIFT!" else "") |> Text.height 50
                                                                              |> Text.color red
                                                                              |> text
                                                                              |> toForm
                                                                              |> move (10,100)
                in collage 400 400 [drawClicks, drawMouseP, drawShift]

--main = asText <~ input
main = display <~ input
import Mouse
import Keyboard
import Window


type Input = { mousePos:(Int,Int), mouseClicks:Int, window:(Int,Int), shift:Bool }
input = sampleOn (fps 20) (Input <~ Mouse.position
                                  ~ (count Mouse.clicks)
                                  ~ Window.dimensions
                                  ~ Keyboard.shift)
                                  

display input = let drawClicks = show input.mouseClicks ++ " clicks" |> formText (Text.color blue)
                                                                     |> move (10,0)
                                                                     
                    drawMouseP = "position: " ++ show input.mousePos |> formText (Text.color brown)
                                                                     |> move (10,50)
                                                                     
                    shiftText = if input.shift then "SHIFT!" else ""
                    drawShift = shiftText |> formText ((Text.color red) . bold)
                                          |> move (10,100)
                in collage 400 400 [drawClicks, drawMouseP, drawShift]


formText f = toForm . text . f . (Text.height 30) . toText



--main = asText <~ input
main = display <~ input
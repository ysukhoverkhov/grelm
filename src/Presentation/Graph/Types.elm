module Presentation.Graph.Types
    exposing
        ( Coordinate
        , makeCoordinate
        , toFloat
        , Color
        , makeColor
        , toHex
        )

import Hex


type Coordinate
    = Coordinate Float


makeCoordinate : Float -> Coordinate
makeCoordinate =
    Coordinate


toFloat : Coordinate -> Float
toFloat (Coordinate f) =
    f


type alias Color =
    { red : Int
    , green : Int
    , blue : Int
    }


makeColor : ( Int, Int, Int ) -> Color
makeColor ( red, green, blue ) =
    { red = red, green = green, blue = blue }


toHex : Color -> String
toHex color =
    Hex.toString color.red ++ Hex.toString color.green ++ Hex.toString color.blue

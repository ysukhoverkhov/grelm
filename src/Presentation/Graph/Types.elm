module Presentation.Graph.Types
    exposing
        ( Position
        , Color
        , makeColor
        , toHex
        , Id
        , initialId
        , makeId
        , (==)
        )

import Hex


type alias Position =
    { width : Float
    , height : Float
    , x : Float
    , y : Float
    }


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


type Id
    = Id Int


initialId : Id
initialId =
    Id 0


makeId : Id -> Id
makeId (Id n) =
    Id (n + 1)


(==) : Id -> Id -> Bool
(==) (Id a) (Id b) =
    case compare a b of
        EQ ->
            True

        _ ->
            False

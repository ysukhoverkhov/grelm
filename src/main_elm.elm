module Main exposing (..)

import Html exposing (..)
import Presentation.Elm exposing (..)
import StubData exposing (..)


main : Html msg
main =
    Html.div [] (stub |> present |> String.lines |> (List.concatMap (\x -> [ Html.text x, Html.br [] [] ])))

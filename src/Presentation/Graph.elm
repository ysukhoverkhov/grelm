module Presentation.Graph exposing (..)

import Ast
import Result.Extra exposing (combine)
import Presentation.Graph.Types exposing (..)


type alias Module =
    { visual : Visual
    , functions : List Function
    }


type alias Function =
    { visual : Visual }


type alias Visual =
    { position : Position
    , color : Color
    , name : String
    }


type alias Position =
    { width : Coordinate
    , height : Coordinate
    , x : Coordinate
    , y : Coordinate
    }


{-| TODO: move to common place
-}
type Error
    = InternalError String


present : Ast.Module -> Result Error Module
present (Ast.Module (Ast.Name name) terms) =
    let
        functions : Result Error (List Function)
        functions =
            terms |> List.map presentTopTerm |> combine

        makeModel functions =
            { visual =
                { position =
                    { width = makeCoordinate 1024
                    , height = makeCoordinate 768
                    , x = makeCoordinate 0
                    , y = makeCoordinate 0
                    }
                , name = name
                , color = makeColor ( 20, 210, 20 )
                }
            , functions = functions
            }
    in
        Result.map makeModel functions


presentTopTerm : Ast.Term -> Result Error Function
presentTopTerm term =
    let
        visual name =
            { name = name
            , color = makeColor ( 210, 20, 20 )
            , position =
                { width = makeCoordinate 300
                , height = makeCoordinate 120
                , x = makeCoordinate 50
                , y = makeCoordinate 50
                }
            }
    in
        case term of
            Ast.Abstraction (Ast.Name name) term ->
                Result.Ok
                    { visual = visual name
                    }

            _ ->
                "Incorrect top level term: " ++ toString term |> InternalError |> Result.Err

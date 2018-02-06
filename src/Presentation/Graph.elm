module Presentation.Graph exposing (..)

import Ast
import Result.Extra exposing (combine)
import Presentation.Graph.Types exposing (..)
import Presentation.Types exposing (..)
import State exposing (State)


type alias Module =
    { visual : Visual
    , functions : List Function
    }


type alias Function =
    { visual : Visual }


type alias Visual =
    { id : Id
    , position : Position
    , color : Color
    , name : String
    }


present : Ast.Module -> Result Error Module
present (Ast.Module (Ast.Name name) terms) =
    presentFunctions terms
        |> State.andThen (presentModule name)
        |> State.finalValue initialId


presentModule : String -> Result Error (List Function) -> State Id (Result Error Module)
presentModule name functions =
    State.map (presentModuleWithId name functions) State.get
        |> mapState makeId


presentModuleWithId : String -> Result Error (List Function) -> Id -> Result Error Module
presentModuleWithId name functions id =
    let
        module_ functions =
            { visual =
                { id = id
                , position = Position 1024 768 0 0
                , name = name
                , color = makeColor ( 20, 210, 20 )
                }
            , functions = functions
            }
    in
        Result.map module_ functions


presentFunctions : List Ast.Term -> State Id (Result Error (List Function))
presentFunctions functions =
    let
        modifyOne : Ast.Term -> State Id (Result Error Function)
        modifyOne function =
            State.map (presentTopFunctionWithId function) State.get
                |> mapState makeId
    in
        functions
            |> State.traverse modifyOne
            |> State.map combine


presentTopFunctionWithId : Ast.Term -> Id -> Result Error Function
presentTopFunctionWithId term id =
    let
        visual name =
            { id = id
            , name = name
            , color = makeColor ( 210, 20, 20 )
            , position = Position 300 120 0 0
            }
    in
        case term of
            Ast.Abstraction (Ast.Name name) term ->
                Result.Ok
                    { visual = visual name
                    }

            _ ->
                "Incorrect top level term: " ++ toString term |> InternalError |> Result.Err


{-| move me to util
-}
mapState : (s -> s) -> State s a -> State s a
mapState mapper =
    State.andThen (\v -> State.map (\_ -> v) (State.modify mapper))

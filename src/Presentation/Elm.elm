module Presentation.Elm exposing (..)

import Ast exposing (..)
import List exposing (map, foldl)


present : Module -> String
present m =
    let
        mod (Module (Name name) _) =
            "module " ++ name ++ " exposing (..)\n\n"

        sta (Module _ terms) =
            map presentTopTerm terms
    in
        mod m ++ (foldl (++) "" (sta m))


presentTopTerm : Term -> String
presentTopTerm term =
    case term of
        Abstraction (Name name) term ->
            name ++ " = " ++ presentTerm term ++ "\n\n"

        _ ->
            "TODO: this is impossible and please make present to return Result"


presentTerm : Term -> String
presentTerm term =
    case term of
        Literal l ->
            presentLiteral l

        Identifier (Name name) ->
            name

        Abstraction (Name name) term ->
            "\\" ++ name ++ " -> " ++ presentTerm term

        Application term1 term2 ->
            presentTerm term1 ++ " " ++ presentTerm term2


presentLiteral : Literal -> String
presentLiteral literal =
    case literal of
        StringLiteral literal ->
            "\"" ++ literal ++ "\""

        IntLiteral literal ->
            toString literal

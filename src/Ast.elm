module Ast exposing (..)


type Name
    = Name String


type Statement
    = Binding Name Term


type Term
    = Literal Literal
    | Identifier Name
    | Abstraction Name Term
    | Application Term Term


type Literal
    = StringLiteral String
    | IntLiteral Int


type Module
    = Module Name (List Term)

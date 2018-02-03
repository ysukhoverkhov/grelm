module StubData exposing (..)

import Ast exposing (..)


stub : Module
stub =
    Module (Name "GrelmTest")
        [ Abstraction
            (Name "f1")
            (Abstraction (Name "a") (Identifier (Name "f2")))
        , Abstraction
            (Name "f2")
            (Literal (StringLiteral "liter"))
        , Abstraction
            (Name "f5")
            (Literal (IntLiteral 12))
        , Abstraction
            (Name "f3")
            (Abstraction (Name "msg") (Application (Identifier (Name "f1")) (Identifier (Name "msg"))))
        ]

module Main exposing (..)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (on)
import Css exposing (..)
import Json.Decode as Decode
import Mouse exposing (Position)
import Exts.List exposing (maybeSingleton)
import Presentation.Graph exposing (..)
import Presentation.Graph.Types as PT
import StubData


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { drag : Maybe Drag
    , module_ : Maybe Module
    }


type alias Drag =
    { start : Mouse.Position
    , current : Mouse.Position
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { drag = Nothing
    , module_ = StubData.stub |> present |> Result.toMaybe
    }



-- UPDATE


type Msg
    = DragStart Mouse.Position
    | DragAt Mouse.Position
    | DragEnd Mouse.Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateHelp msg model, Cmd.none )


updateHelp : Msg -> Model -> Model
updateHelp msg model =
    model



-- case msg of
--     DragStart xy ->
--         Model position (Just (Drag xy xy)) Nothing
-- DragAt xy ->
--     Model position (Maybe.map (\{ start } -> Drag start xy) drag) Nothing
-- DragEnd _ ->
--     Model (getPosition model) Nothing Nothing
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]



-- VIEW


view : Model -> Html Msg
view model =
    div [] (model.module_ |> maybeSingleton |> List.map viewModule)


viewModule : Module -> Html Msg
viewModule m =
    viewVisual m (List.map viewFunction m.functions)


viewFunction : Function -> Html Msg
viewFunction f =
    viewVisual f []


viewVisual : { a | visual : Visual } -> List (Html Msg) -> Html Msg
viewVisual { visual } children =
    div
        [ onMouseDown
        , css
            [ position absolute
            , displayFlex
            , justifyContent center
            , alignItems center
            , cursor move
            , borderRadius <| px <| 4
            , backgroundColor <| hex <| PT.toHex <| visual.color
            , Css.width <| px <| visual.position.width
            , Css.height <| px <| visual.position.height
            , Css.left <| px <| visual.position.x
            , Css.top <| px <| visual.position.y
            ]
        ]
        (text (visual.name ++ " " ++ (toString visual.id)) :: children)



-- getPosition : Maybe Drag -> Visual -> Mouse.Position
-- getPosition drag visual =
--     case drag of
--         Nothing ->
--             { x = visual.position.x, y = visual.position.y }
--
--         Just { start, current } ->
--             Mouse.Position
--                 (position.x + current.x - start.x)
--                 (position.y + current.y - start.y)
-- onMouseDown : Attribute Msg


onMouseDown : Attribute Msg
onMouseDown =
    on "mousedown" (Decode.map DragStart Mouse.position)

module Main exposing (main)
--
import Browser
import Html exposing (..)
--import Page.Entries

type alias Model =
    { todos : List Int
    }

type Msg =
    Loading

init : () -> (Model, Cmd Msg)
init _ =
    ({ todos = []}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Loading ->
            (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

view : Model -> Html Msg
view model =
   div [] []


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

module Page.Todos.Form exposing (Model, Msg(..), initModel, postTodo, update, view)

import Api.Endpoint as Endpoint exposing (..)
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Html exposing (..)
import Http
import Todo as Todo exposing (..)


type alias Model =
    { todo : Todo
    }


type Msg
    = GotTodo (Result Http.Error Todo)
    | ChangeContent String
    | SubmitTodo


initModel =
    { todo = Todo.init
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTodo result ->
            case result of
                Err error ->
                    ( model, Cmd.none )

                Ok _ ->
                    ( { model | todo = Todo.init }, Cmd.none )

        ChangeContent content ->
            let
                todo =
                    model.todo
            in
            ( { model | todo = { todo | content = content } }, Cmd.none )

        SubmitTodo ->
            ( model, postTodo model.todo )


postTodo : Todo -> Cmd Msg
postTodo newTodo =
    let
        body =
            Todo.encoder newTodo
                |> Http.jsonBody
    in
    Endpoint.request
        { method = "POST"
        , url = Endpoint.todos
        , body = body
        , expect = Http.expectJson GotTodo Todo.decoder
        }


view : Html Msg
view =
    div []
        [ Form.group []
            [ Form.label [] [ text "内容" ]
            , Input.text [ Input.onInput ChangeContent ]
            ]
        , Form.group []
            [ Button.button [ Button.onClick SubmitTodo, Button.primary ] [ text "作成" ]
            ]
        ]

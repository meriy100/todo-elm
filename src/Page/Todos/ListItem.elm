module Page.Todos.ListItem exposing (..)

import Http
import Bootstrap.ListGroup as ListGroup

import Api.Endpoint as Endpoint
import Todo as Todo exposing (..)
import Json.Decode as Decode exposing (..)

type alias Model =
    Todo

type Msg =
    ClickDone Todo
    | DonedTodo (Result Http.Error String)

update msg model =
    case msg of
        DonedTodo result ->
            case result of
                Err err ->
                    ( model, Cmd.none )

                Ok todo ->
                    ( if model.id == todo.id then todo else model, Cmd.none )

        ClickDone todo ->
            ( model, doneTodo todo )


doneTodo : Todo -> Cmd Msg
doneTodo todo =
    let
        body =
            Todo.statusEncoder ({todo | status = Todo.DONE })
                |> Http.jsonBody
    in
    Endpoint.request
        { method = "PATCH"
        , url = Endpoint.todo todo
        , body = body
        , expect = Http.expectJson DonedTodo (Decode.succeed "success")
        }



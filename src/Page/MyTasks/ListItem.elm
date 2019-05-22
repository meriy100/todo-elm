module Page.Todos.ListItem exposing (..)

import Http
import Bootstrap.ListGroup as ListGroup

import Api.Endpoint as Endpoint
import MyTask as MyTask exposing (..)
import MyTask.Status as Status exposing (Status)
import Json.Decode as Decode exposing (..)

type RequestStatus myTask =
    Loaded myTask
    | DoneLoading myTask

type alias Model =
    RequestStatus MyTask

type Msg =
    ClickDone MyTask
    | DonedMyTask (Result Http.Error String)

toMyTask : RequestStatus MyTask -> MyTask
toMyTask r =
    case r of
        Loaded t ->
            t
        DoneLoading t ->
            t
equal : Model -> MyTask -> Bool
equal model myTask =
    myTask.id == (toMyTask model).id

update msg model =
    case msg of
        DonedMyTask result ->
            case result of
                Err err ->
                    ( model, Cmd.none )

                Ok task ->
                    if task |> equal model then
                        (Loaded task, Cmd.none)
                    else
                        (model, Cmd.none)

        ClickDone task ->
            if task |> equal model then
                ( DoneLoading task, doneMyTask task )
            else
                ( model, Cmd.none )


doneMyTask : MyTask -> Cmd Msg
doneMyTask task =
    let
        body =
            Status.statusEncoder (Status.DONE)
                |> Http.jsonBody
    in
    Endpoint.request
        { method = "PATCH"
        , url = Endpoint.task task
        , body = body
        , expect = Http.expectJson DonedMyTask (Decode.succeed "success")
        }



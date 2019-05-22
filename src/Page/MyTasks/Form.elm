module Page.MyTasks.Form exposing (..)

import Api.Endpoint as Endpoint exposing (..)
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Html exposing (..)
import Http
import MyTask as MyTask exposing (..)


type alias Model =
    { task : MyTask
    }


type Msg
    = GotMyTask (Result Http.Error MyTask)
    | ChangeContent String
    | SubmitMyTask


initModel =
    { task = MyTask.init
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMyTask result ->
            case result of
                Err error ->
                    ( model, Cmd.none )

                Ok _ ->
                    ( { model | task = MyTask.init }, Cmd.none )

        ChangeContent content ->
            let
                task =
                    model.task
            in
            ( { model | task = { task | content = content } }, Cmd.none )

        SubmitMyTask ->
            ( model, postMyTask model.task )


postMyTask : MyTask -> Cmd Msg
postMyTask newMyTask =
    let
        body =
            MyTask.encoder newMyTask
                |> Http.jsonBody
    in
    Endpoint.request
        { method = "POST"
        , url = Endpoint.tasks
        , body = body
        , expect = Http.expectJson GotMyTask MyTask.decoder
        }


view : Html Msg
view =
    div []
        [ Form.group []
            [ Form.label [] [ text "内容" ]
            , Input.text [ Input.onInput ChangeContent ]
            ]
        , Form.group []
            [ Button.button [ Button.onClick SubmitMyTask, Button.primary ] [ text "作成" ]
            ]
        ]

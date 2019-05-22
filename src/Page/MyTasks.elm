module Page.MyTasks exposing (..)

import Api.Endpoint as Endpoint
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Tab as Tab
import Html exposing (..)
import Http
import Page.MyTasks.Form as Form exposing (..)
import MyTask as MyTask exposing (..)
import MyTask.Status as Status exposing (Status)


type alias Model =
    { tasks : List MyTask
    , newMyTask : Form.Model
    , tab: Tab.State
    }


type Msg
    = GotMyTasks (Result Http.Error (List MyTask))
    | ClickDone MyTask
    | DonedMyTask (Result Http.Error MyTask)
    | FormMsg Form.Msg
    | TabMsg Tab.State


init : () -> ( Model, Cmd Msg )
init _ =
    ( { tasks = [], newMyTask = Form.initModel, tab = Tab.initialState }, fetchMyTasks )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMyTasks result ->
            case result of
                Err err ->
                    ( model, Cmd.none )

                Ok tasks ->
                    ( { model | tasks = tasks }, Cmd.none )
        DonedMyTask result ->
            case result of
                Err err ->
                    ( model, Cmd.none )

                Ok task ->
                    ( { model | tasks = List.map (\t -> if t.id == task.id then task else t) model.tasks }, Cmd.none )

        ClickDone task ->
            ( model, doneMyTask task )

        FormMsg formMsg ->
            case formMsg of
                GotMyTask result ->
                    case result of
                        Err error ->
                            ( model, Cmd.none )

                        Ok task ->
                            let
                                tasks =
                                    model.tasks
                            in
                            ( { model | tasks = List.append tasks [ task ], newMyTask = Form.initModel }, Cmd.none )

                _ ->
                    case Form.update formMsg model.newMyTask of
                        ( newMyTask, cmd ) ->
                            ( { model | newMyTask = newMyTask }, Cmd.map FormMsg cmd )
        TabMsg state ->
            ({ model | tab = state }, Cmd.none)


fetchMyTasks : Cmd Msg
fetchMyTasks =
    Endpoint.request
        { method = "GET"
        , url = Endpoint.tasks
        , body = Http.emptyBody
        , expect = Http.expectJson GotMyTasks MyTask.listDecoder
        }

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
        , expect = Http.expectJson DonedMyTask MyTask.decoder
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


viewMyTask : MyTask -> ListGroup.Item Msg
viewMyTask task =
    ListGroup.li []
        [ Grid.row []
            [ Grid.col [ Col.md1 ] [ Button.button [ Button.success, Button.onClick (ClickDone task) ] [ text "Done!" ] ]
            , Grid.col [ Col.md6 ] [ text task.content ]
            ]
        ]

view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , Grid.row []
            [ Grid.col [ Col.md12 ]
                [ h1 [] [ text "Task" ]
                , Html.map FormMsg Form.view
                , Grid.row []
                    [ Grid.col [ Col.md12 ]
                        [ Tab.config TabMsg
                            |> Tab.items
                                [ Tab.item
                                    { id = "tabItem1"
                                    , link = Tab.link [] [ text "Todo" ]
                                    , pane =
                                        Tab.pane []
                                            [ model.tasks
                                                |> List.filter (\t -> t.status == Status.TODO)
                                                |> List.map viewMyTask
                                                |> ListGroup.ul
                                            ]
                                    }
                                , Tab.item
                                    { id = "tabItem2"
                                    , link = Tab.link [] [ text "Done" ]
                                    , pane =
                                        Tab.pane []
                                            [ model.tasks
                                                |> List.filter (\t -> t.status == Status.DONE)
                                                |> List.map viewMyTask
                                                |> ListGroup.ul
                                            ]
                                    }
                                ]
                            |> Tab.view model.tab
                        ]
                    ]
                ]
            ]
        ]

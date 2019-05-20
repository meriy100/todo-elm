module Page.Todos exposing (Model, Msg(..), fetchTodos, init, subscriptions, update, view, viewTodo)

import Api.Endpoint as Endpoint
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.ListGroup as ListGroup
import Html exposing (..)
import Http
import Page.Todos.Form as Form exposing (..)
import Todo exposing (..)


type alias Model =
    { todos : List Todo
    , newTodo : Form.Model
    }


type Msg
    = GotTodos (Result Http.Error (List Todo))
    | ClickDone Todo
    | FormMsg Form.Msg


init : () -> ( Model, Cmd Msg )
init _ =
    ( { todos = [], newTodo = Form.initModel }, fetchTodos )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTodos result ->
            case result of
                Err err ->
                    ( model, Cmd.none )

                Ok todos ->
                    ( { model | todos = todos }, Cmd.none )

        ClickDone todo ->
            ( model, Cmd.none )

        FormMsg formMsg ->
            case formMsg of
                GotTodo result ->
                    case result of
                        Err error ->
                            ( model, Cmd.none )

                        Ok todo ->
                            let
                                todos =
                                    model.todos
                            in
                            ( { model | todos = List.append todos [ todo ], newTodo = Form.initModel }, Cmd.none )

                _ ->
                    case Form.update formMsg model.newTodo of
                        ( newTodo, cmd ) ->
                            ( { model | newTodo = newTodo }, Cmd.map FormMsg cmd )


fetchTodos : Cmd Msg
fetchTodos =
    Endpoint.request
        { method = "GET"
        , url = Endpoint.todos
        , body = Http.emptyBody
        , expect = Http.expectJson GotTodos Todo.listDecoder
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


viewTodo : Todo -> ListGroup.Item Msg
viewTodo todo =
    ListGroup.li []
        [ Grid.row []
            [ Grid.col [ Col.md1 ] [ Button.button [ Button.success, Button.onClick (ClickDone todo) ] [ text "Done!" ] ]
            , Grid.col [ Col.md6 ] [ text todo.content ]
            ]
        ]


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , Grid.row []
            [ Grid.col [ Col.md12 ]
                [ h1 [] [ text "Todo" ]
                , Html.map FormMsg Form.view
                , div []
                    [ model.todos
                        |> List.map viewTodo
                        |> ListGroup.ul
                    ]
                ]
            ]
        ]

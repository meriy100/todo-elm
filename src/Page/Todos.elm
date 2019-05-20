module Page.Todos exposing (..)

import Api.Endpoint as Endpoint
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Todo exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Button as Button
import Bootstrap.Form.Input as Input
import Bootstrap.Form as Form

type alias Model =
    { todos : List Todo
    , newTodo : Todo
    }

type Msg =
    GotTodos (Result Http.Error (List Todo))
    | GotTodo (Result Http.Error Todo)
    | ClickDone Todo
    | ChangeContent String
    | SubmitTodo

init : () -> (Model, Cmd Msg)
init _ =
    ({ todos = [], newTodo = Todo.init}, fetchTodos)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotTodos result ->
            case result of
                Err err ->
                    (model, Cmd.none)
                Ok todos ->
                    ({ model | todos = todos }, Cmd.none)
        GotTodo result ->
            case result of
                Err err ->
                    (model, Cmd.none)
                Ok todo ->
                    let
                        todos =
                            model.todos
                    in
                    ({ model | todos = List.append todos [todo], newTodo = Todo.init }, Cmd.none)
        ClickDone todo ->
            (model, Cmd.none)
        ChangeContent content ->
            let
                newTodo =
                    model.newTodo
            in
            ({model | newTodo = { newTodo | content = content } }, Cmd.none )
        SubmitTodo ->
            (model, postTodo model.newTodo)


fetchTodos : Cmd Msg
fetchTodos =
    Endpoint.request
        { method = "GET"
        , url = Endpoint.todos
        , body = Http.emptyBody
        , expect = Http.expectJson GotTodos Todo.listDecoder
        }

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

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

viewForm : Html Msg
viewForm =
    div []
        [ Form.group []
            [ Form.label [] [ text "内容" ]
            , Input.text [ Input.onInput ChangeContent ]
            ]
        , Form.group []
            [ Button.button [ Button.onClick SubmitTodo, Button.primary ] [ text "作成" ]
            ]
        ]

viewTodo : Todo -> ListGroup.Item Msg
viewTodo todo =
   ListGroup.li []
   [ Grid.row []
       [ Grid.col [Col.md1] [ Button.button [ Button.success, Button.onClick (ClickDone todo) ] [text "Done!"] ]
       , Grid.col [Col.md6] [text todo.content]
       ]
   ]

view : Model -> Html Msg
view model =
   Grid.container [ ]
   [ CDN.stylesheet
   , Grid.row []
       [ Grid.col [ Col.md12 ]
           [ h1 [] [text "Todo"]
           , viewForm
           , div []
               [ model.todos
                  |> List.map viewTodo
                  |> ListGroup.ul
               ]
           ]
       ]
   ]


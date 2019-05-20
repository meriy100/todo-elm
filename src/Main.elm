module Main exposing (main)
--
import Browser
import Page.Todos exposing (..)


main =
    Browser.element
        { init = Page.Todos.init
        , update = Page.Todos.update
        , view = Page.Todos.view
        , subscriptions = Page.Todos.subscriptions
        }

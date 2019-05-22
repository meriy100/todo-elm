module Main exposing (main)

import Browser
import Page.MyTasks exposing (..)


main =
    Browser.element
        { init = Page.MyTasks.init
        , update = Page.MyTasks.update
        , view = Page.MyTasks.view
        , subscriptions = Page.MyTasks.subscriptions
        }

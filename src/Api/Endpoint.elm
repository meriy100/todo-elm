module Api.Endpoint exposing (..)

import Url.Builder exposing(..)
import Http
import Todo exposing (..)

type Endpoint =
    Endpoint String
unwrap : Endpoint -> String
unwrap (Endpoint str) =
    str


request
    : { method: String
      , url : Endpoint
      , body : Http.Body
      , expect : Http.Expect msg
      }
      -> Cmd msg
request config =
    Http.request
        { method = config.method
        , headers = []
        , url = unwrap config.url
        , body = config.body
        , expect = config.expect
        , timeout = Nothing
        , tracker = Nothing
        }
url : List String -> List QueryParameter -> Endpoint
url paths queryParams =
    Url.Builder.crossOrigin "https://1y2akyrem4.execute-api.ap-northeast-1.amazonaws.com/dev"
        paths
        queryParams
        |> Endpoint

todos : Endpoint
todos =
    url ["todos"] []

todo : Todo -> Endpoint
todo t =
    url ["todos", Maybe.withDefault "" t.id] []

module Api.Endpoint exposing (..)

import Url.Builder exposing(..)
import Http
import MyTask exposing (..)

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
    Url.Builder.crossOrigin "https://fu58fy81j0.execute-api.ap-northeast-1.amazonaws.com/dev"
        paths
        queryParams
        |> Endpoint

tasks : Endpoint
tasks =
    url ["tasks"] []

task : MyTask -> Endpoint
task t =
    url ["tasks", Maybe.withDefault "" t.id] []

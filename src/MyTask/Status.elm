module MyTask.Status exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (Value)

type Status
    = TODO
    | DONE


toInt : Status -> Int
toInt status =
    case status of
        TODO ->
            10
        DONE ->
            20


toStatus : Int -> Status
toStatus n =
    case n of
        10 ->
            TODO

        20 ->
            DONE

        _ ->
            TODO

statusDecoder : Decoder Status
statusDecoder =
    Decode.map toStatus Decode.int


statusEncoder : Status -> Value
statusEncoder status =
    Encode.object
        [ ( "status", Encode.int (toInt status) )
        ]

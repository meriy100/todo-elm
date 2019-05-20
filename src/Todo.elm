module Todo exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (Value)


type Status
    = TODO
    | DONE


type alias Todo =
    { id : Maybe String
    , content : String
    , status : Status
    , timestamp : Maybe Int
    }


init : Todo
init =
    { id = Nothing
    , content = ""
    , status = TODO
    , timestamp = Nothing
    }


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


decoder : Decoder Todo
decoder =
    Decode.map4 Todo
        (Decode.field "Id" (Decode.maybe Decode.string))
        (Decode.field "Content" Decode.string)
        (Decode.field "Status" statusDecoder)
        (Decode.field "Timestamp" (Decode.maybe Decode.int))


listDecoder : Decoder (List Todo)
listDecoder =
    Decode.field "Items" (Decode.list decoder)


encoder : Todo -> Value
encoder todo =
    Encode.object
        [ ( "content", Encode.string todo.content )
        ]

statusEncoder : Todo -> Value
statusEncoder todo =
    Encode.object
        [ ( "status", Encode.int (toInt todo.status) )
        ]

module Todo exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (Value)

type Status =
    TODO
    | DONE

type alias Todo =
    { id : Maybe String
    , content : String
    , status : Status
    , timestamp : Maybe Int
    }

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
    Decode.map toStatus  Decode.int



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
        [  ( "Content", Encode.string todo.content )
        ]

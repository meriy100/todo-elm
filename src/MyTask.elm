module MyTask exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (Value)

import MyTask.Status as Status exposing (Status)

type alias MyTask =
    { id : Maybe String
    , content : String
    , status : Status
    , timestamp : Maybe Int
    }


init : MyTask
init =
    { id = Nothing
    , content = ""
    , status = Status.TODO
    , timestamp = Nothing
    }

decoder : Decoder MyTask
decoder =
    Decode.map4 MyTask
        (Decode.field "Id" (Decode.maybe Decode.string))
        (Decode.field "Content" Decode.string)
        (Decode.field "Status" Status.statusDecoder)
        (Decode.field "Timestamp" (Decode.maybe Decode.int))


listDecoder : Decoder (List MyTask)
listDecoder =
    Decode.field "Items" (Decode.list decoder)


encoder : MyTask -> Value
encoder task =
    Encode.object
        [ ( "content", Encode.string task.content )
        ]

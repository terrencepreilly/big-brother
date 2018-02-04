module Message exposing
    ( Message
    , messageDecoder
    , messageEncoder
    )

import Json.Encode as Encode
import Json.Decode as Decode

{-| The information which will be sent to the backend
or received from the backend.

-}
type alias Message =
    { username : String
    , site : String
    , message : String
    }

messageEncoder : Message -> Encode.Value
messageEncoder message =
    Encode.object
        [ ("username", Encode.string message.username)
        , ("site", Encode.string message.site)
        , ("message", Encode.string message.message)
        ]

messageDecoder =
    Decode.map3 Message
        (Decode.field "username" Decode.string)
        (Decode.field "site" Decode.string)
        (Decode.field "message" Decode.string)

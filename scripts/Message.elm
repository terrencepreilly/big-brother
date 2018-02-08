module Message exposing
    ( Message
    , messageDecoder
    , messageEncoder
    , messageView
    )

import Html exposing
    ( Html
    , div
    , span
    , text
    )
import Html.Attributes exposing
    ( class
    )
import Json.Encode as Encode
import Json.Decode as Decode

-- MODEL

{-| The information which will be sent to the backend
or received from the backend.

-}
type alias Message =
    { username : String
    , site : String
    , message : String
    }


-- SERIALIZERS

messageEncoder : Message -> Encode.Value
messageEncoder message =
    Encode.object
        [ ("username", Encode.string message.username)
        , ("site", Encode.string message.site)
        , ("message", Encode.string message.message)
        ]

messageDecoder : Decode.Decoder Message
messageDecoder =
    Decode.map3 Message
        (Decode.field "username" Decode.string)
        (Decode.field "site" Decode.string)
        (Decode.field "message" Decode.string)


-- VIEW

messageView : Message -> (Html msg)
messageView message =
    div [ class "user-message" ]
      [ span [ class "username" ] [ text message.username ]
      , span [ class "message" ] [ text message.message ]
      ]

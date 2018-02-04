port module BigBrother exposing (..)

{-| A utility which continually pings a redis service. -}

import Platform exposing ( programWithFlags, Program )
import Time exposing ( Time, second )
import Json.Encode as Encode
import Json.Decode as Decode
import Http

import UrlJoin exposing (urlJoin)
import Message exposing
    ( Message
    , messageEncoder
    )

main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL

type alias Flags =
    { username : String
    , site : String
    , initialMessage : String
    , host : Maybe String
    }

type alias Model =
    { message : Message
    , host : String
    }

-- TODO: A port should be added to update the message.
-- That way, apps using the backend's data can display
-- what users are doing in real time.

-- Change by just callling message encoder on message.
modelEncoder : Model -> Encode.Value
modelEncoder model = messageEncoder model.message

init : Flags -> (Model, Cmd Msg)
init flags = 
    let
        host = "http://localhost:8000"  
        message_ =
            { username = flags.username
            , site = flags.site
            , message = flags.initialMessage
            }
        model =
            { message = message_
            , host = host
            }
    in
        ( model , Cmd.none )

-- UPDATE
type Msg
    = Tick Time
    | Noop (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime -> (model, ping model)
        Noop (Ok message) -> (model, Cmd.none)
        Noop (Err message) ->
            let
                errorModel = "Failed ping: " ++ toString message
            in
                (model, log errorModel)


-- PORTS
port log : String -> Cmd msg


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (5 * second) Tick


{-| Send a ping to the backend, discarding the result if it
 - succeeds, otherwise sending the result to the JSON port,
 - log, if it does not.
 -}
ping : Model -> Cmd Msg
ping model =
    let
        url = urlJoin model.host "ping"
        body = Http.jsonBody <| modelEncoder model
    in
        Http.send Noop (Http.post url body Decode.string)

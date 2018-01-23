port module BigBrother exposing (..)

{-| A utility which continually pings a redis service. -}

import Platform exposing ( program, Program )
import Time exposing ( Time, second )
import Json.Encode as Encode
import Json.Decode as Decode
import Http

main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL

type alias User =
    { username : String
    }


userEncoder : User -> Encode.Value
userEncoder user =
    Encode.object [("username", Encode.string user.username)]

userDecoder : Decode.Decoder User
userDecoder =
    Decode.map User
            (Decode.field "username" Decode.string)


type alias Model =
    { user : User
    }

init : (Model, Cmd Msg)
init = 
    ( { user = User "Samantha" }
    , Cmd.none
    )

-- UPDATE
type Msg
    = Tick Time
    | Noop (Result Http.Error User)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
--        Tick newTime -> (model, log "Hello!")
        Tick newTime -> (model, ping model)
        Noop (Ok user) -> (model, Cmd.none)
        Noop (Err _) -> (model, Cmd.none)


-- PORTS
port log : String -> Cmd msg


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (5 * second) Tick


ping : Model -> Cmd Msg
ping model =
    let
        url = "http://localhost:3000/ping"
        body = Http.jsonBody <| userEncoder model.user
    in
        Http.send Noop (Http.post url body userDecoder)

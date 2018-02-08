port module BigBrotherReporter exposing (..)

import Dict
import Http
import Time exposing
    ( Time
    , second
    )
import Html exposing
    ( Html
    , div
    , text
    )
import Json.Decode as Decode

import Message exposing
    ( Message
    , messageDecoder
    , messageView
    )
import UrlJoin exposing ( urlJoin )

main : Program Flags Model Msg
main = Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
type alias Flags =
    { host: String
    , site : String
    , duration : Int
    }
-- TODO: Remove debug string.
type alias Model =
    { host : String
    , site : String
    , duration : Int
    , userData : Dict.Dict String Message 
    , debug : String
    }

init : Flags -> (Model, Cmd msg)
init flags =
    ( Model
        flags.host
        flags.site
        flags.duration
        Dict.empty
        "Debug String"
    , Cmd.none
    )


-- VIEW

view : Model -> (Html msg)
view model =
    div []
        (model.userData
            |> Dict.values
            |> List.map messageView)


-- UPDATE
type Msg
    = Tick Time
    | UpdateUserData (Result Http.Error (Dict.Dict String Message))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick time ->
            (model, getUserData model)
        UpdateUserData (Ok newUserData) ->
            let
                debug = "Howdy"
                newModel =
                    { model
                        | userData = newUserData
                        , debug = debug
                        }
            in
                (newModel, Cmd.none)
        UpdateUserData (Err error) ->
            let
                errorModel = toString error
            in
                (model, log errorModel)

-- PORTS
port log : String -> Cmd msg

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (5 * second) Tick


-- REQUESTS

getUserData : Model -> Cmd Msg
getUserData model =
    let
        baseUrl = List.foldr urlJoin ""
            [ model.host
            , "report"
            , model.site
            ]
        url = baseUrl ++ "?duration=" ++ toString model.duration
        decoder = Decode.dict messageDecoder
    in
        Http.send UpdateUserData <| Http.get url decoder

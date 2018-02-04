module Example exposing (..)

import Test exposing (..)
import Expect
import Json.Decode as Decode

import Message exposing (..)


suite : Test
suite =
    describe "The Message module"
        [ messageModelTests
        ]


messageModelTests =
    describe "Message"
        [ test "Can access username through user" <|
            \_ ->
                let
                    user = "jennifer"
                    site = "elm-lang.org"
                    msg = "hello world"
                    message = Message user site msg
                in
                    Expect.equal message.username "jennifer"
        , test "Can encode user as JSON" <|
            \_ ->
                let
                    username = "gerald"
                    site = "elm-lang.org"
                    msg = "Howdy"
                    message = Message username site msg
                    encoded = toString <| messageEncoder message
                in
                    Expect.true
                        "Contains username"
                        (String.contains username encoded)
        , test "Can decode JSON" <|
            \_ ->
                let
                    response = """
                        {
                            "username":"Jake",
                            "site": "lesswrong",
                            "message": "Hey"
                        }
                    """
                    message =
                        case Decode.decodeString messageDecoder response of
                            Ok msg -> msg
                            Err _ -> Message "" "" ""
                in
                    Expect.equal message.username "Jake"
        ]

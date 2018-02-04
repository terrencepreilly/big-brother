module BigBrotherReporter exposing (..)

import Html exposing
    ( Html
    , div
    )

main : Program Flags Model msg
main = Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
type alias Flags =
    { site : String
    }
type alias Model = Int

init : Flags -> (Model, Cmd msg)
init flags = (5, Cmd.none)


-- VIEW

view : Model -> (Html msg)
view model = div [] []


-- UPDATE

update : msg -> Model -> (Model, Cmd msg)
update msg model = (model, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub msg
subscriptions model = Sub.none

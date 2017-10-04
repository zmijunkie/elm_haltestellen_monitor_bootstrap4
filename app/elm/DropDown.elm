-- https://stackoverflow.com/questions/39371105/how-to-use-select-dropdown-tag-in-elm-lang
-- http://johnkpaul.com/blog/2016/02/16/elm-ungooglables/
-- https://github.com/izdi/elm-cheat-sheet#infix
-- https://github.com/elm-lang/elm-platform/blob/master/upgrade-docs/0.18.md#backticks-and-andthen
-- https://stackoverflow.com/questions/37376509/work-with-elm-and-select
-- https://github.com/elm-lang/html/issues/23

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

initialModel =
  (Model)

init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

type Role
  = None
  | Admin
  | User

type alias Model = 
  { role: Role
  }

type Msg
  = SelectRole Role


update msg model =
  case msg of
    SelectRole role ->
      { model | role = role }


view : Model -> Html Msg
view model =
  div
    []
    [ select
        [ on "change" (Json.Decode.map SelectRole targetValueRoleDecoder)
        ]
        [ viewOption None
        , viewOption Admin
        , viewOption User
        ]
    ]

    
viewOption : Role -> Html Msg
viewOption role =
  option
    [ value <| toString role ]
    [ text <| toString role ]
    

targetValueRoleDecoder : Json.Decode.Decoder Role
targetValueRoleDecoder =
  targetValue |> Json.Decode.andThen (\val ->
    case val of
      "Admin" -> Json.Decode.succeed Admin
      "User" -> Json.Decode.succeed User
      "None" -> Json.Decode.succeed None
      _ -> Json.Decode.fail ("Invalid Role: " ++ val)
      
    )
    
    
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

      
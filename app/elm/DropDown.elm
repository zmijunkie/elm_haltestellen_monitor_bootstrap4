-- https://stackoverflow.com/questions/39371105/how-to-use-select-dropdown-tag-in-elm-lang

import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Json.Decode

main =
  beginnerProgram
    { model = initialModel
    , view = view
    , update = update
    }

initialModel =
  { role = None
  }

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


    
viewOption : Role -> Html Msg
viewOption role =
  option
    [ value <| toString role ]
    [ text <| toString role ]
    

targetValueRoleDecoder : Json.Decode.Decoder Role
targetValueRoleDecoder =
  targetValue `Json.Decode.andThen` \val ->
    case val of
      "Admin" -> Json.Decode.succeed Admin
      "User" -> Json.Decode.succeed User
      "None" -> Json.Decode.succeed None
      _ -> Json.Decode.fail ("Invalid Role: " ++ val)
      
      
      
-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html

-- elm package install elm-lang/http 3.0.1
-- elm package install lukewestby/elm-http-builder / Video: https://elmseeds.thaterikperson.com/http-builder
-- elm package install NoRedInk/elm-decode-pipeline
-- elm package install JeremyBellows/elm-bootstrapify

-- starten mit elm-reactor

import Html
import Rest exposing (abfahrtDecoder,abfahrtenDecoder,getAbfahrten)
import Types exposing (Abfahrt,Abfahrten,Model,Msg)
import View exposing (rootView)
import Dict
import List

initialOptOut : Dict.Dict String Bool
initialOptOut = Dict.fromList [ 
      ("transport_ice", True) 
    , ("transport_zug", True) 
    , ("transport_sbahn", True) 
    , ("transport_ubahn", True) 
    , ("transport_strassenbahn", True) 
    , ("transport_bus", True) 
    ]


initialState : ( Model , Cmd Msg ) -- https://github.com/elm-lang/elm-compiler/blob/0.18.0/hints/type-annotations.md
initialState =
    ( Model 20000196 "Dortmund, Dorstfeld S"  (Abfahrten 20000196 "Dortmund, Dorstfeld S" [ ] ) initialOptOut "" ""
    , getAbfahrten 20000196
    )


main =
  Html.program
    { init = initialState
    , view = rootView
    , update = update
    , subscriptions = subscriptions
    }


-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Types.MorePlease ->
      (model, getAbfahrten model.stationId)

    Types.AbfahrtenEnvelopIsLoaded (Ok abfahrtenEnvelop) ->
      ( Model abfahrtenEnvelop.stationId abfahrtenEnvelop.stationName (Abfahrten abfahrtenEnvelop.stationId  abfahrtenEnvelop.stationName ( List.map .abfahrt abfahrtenEnvelop.abfahrten) )  model.optOut "abfrage ..." ("Aktualisiert für: " ++ abfahrtenEnvelop.stationName)  , Cmd.none )

    Types.AbfahrtenEnvelopIsLoaded (Err _) ->
      ( { model | feedback = "Ein Fehler ist aufgetreten ..." }, Cmd.none)

    Types.Toggle_ICE ->
      (model, getAbfahrten model.stationId)

    Types.Toggle_Zug ->
      (model, getAbfahrten model.stationId)

    Types.Toggle_Sbahn ->
      (model, getAbfahrten model.stationId)

    Types.Toggle_Ubahn ->
      (model, getAbfahrten model.stationId)

    Types.Toggle_Strassenbahn ->
      (model, getAbfahrten model.stationId)

    Types.Toggle_Bus ->
      (model, getAbfahrten model.stationId)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none






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
import HttpErrorString exposing (httpErrorString)

initialOptOutList: List ( String, Bool )
initialOptOutList = [ 
      ("transport_ice", True) 
    , ("transport_zug", True) 
    , ("transport_sbahn", True) 
    , ("transport_ubahn", True) 
    , ("transport_strassenbahn", True) 
    , ("transport_bus", True) 
    ]

initialOptOut : Dict.Dict String Bool
initialOptOut = Dict.fromList initialOptOutList

-- String.join "," (List.map Tuple.first (List.filter Tuple.second (List.indexedMap (\i x -> ((toString (i+1)),Tuple.second x) ) initialOptOutList) ))
-- "1,2,5" : String
-- fuer
-- initialOptOutList = [ ("transport_ice", True), ("transport_zug", True) , ("transport_sbahn", False) , ("transport_ubahn", False) , ("transport_strassenbahn", True) , ("transport_bus", False) ]
        

initialState : ( Model , Cmd Msg ) -- https://github.com/elm-lang/elm-compiler/blob/0.18.0/hints/type-annotations.md
initialState =
    ( Model 20000196 "Dortmund, Dorstfeld S"  (Abfahrten 20000196 "Dortmund, Dorstfeld S" [ ] ) initialOptOut "" ""
    , getAbfahrten 20000196 initialOptOutList
    )

-- 20000825 Dorstfeld Süd

main =
  Html.program
    { init = initialState
    , view = rootView
    , update = update
    , subscriptions = subscriptions
    }


-- UPDATE
-- https://becoming-functional.com/http-error-checking-in-elm-fee8c4b68b7b


toggleOptOutForKey: Dict.Dict String Bool -> String -> Dict.Dict String Bool
toggleOptOutForKey optOut key =
    Dict.update key (\_ -> Just ( (Dict.get key optOut)== Just(False) )) optOut


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Types.MorePlease ->
      (model, getAbfahrten model.stationId initialOptOutList)

    Types.AbfahrtenEnvelopIsLoaded (Ok abfahrtenEnvelop) ->
      ( Model abfahrtenEnvelop.stationId abfahrtenEnvelop.stationName (Abfahrten abfahrtenEnvelop.stationId  abfahrtenEnvelop.stationName ( List.map .abfahrt abfahrtenEnvelop.abfahrten) )  model.optOut "abfrage ..." ("Aktualisiert für: " ++ abfahrtenEnvelop.stationName)  , Cmd.none )

    Types.AbfahrtenEnvelopIsLoaded (Err e) ->
      ({ model | feedback = httpErrorString e }, Cmd.none)              

    Types.Toggle_ICE ->
      ({ model | optOut = toggleOptOutForKey model.optOut "transport_ice" }, getAbfahrten model.stationId initialOptOutList)

    Types.Toggle_Zug ->
      ({ model | optOut = toggleOptOutForKey model.optOut "transport_zug" }, getAbfahrten model.stationId initialOptOutList)

    Types.Toggle_Sbahn ->
      ({ model | optOut = toggleOptOutForKey model.optOut "transport_sbahn" }, getAbfahrten model.stationId initialOptOutList)

    Types.Toggle_Ubahn ->
      ({ model | optOut = toggleOptOutForKey model.optOut "transport_ubahn" }, getAbfahrten model.stationId initialOptOutList)

    Types.Toggle_Strassenbahn ->
      ({ model | optOut = toggleOptOutForKey model.optOut "transport_strassenbahn" } , getAbfahrten model.stationId initialOptOutList)

    Types.Toggle_Bus ->
      ({ model | optOut = toggleOptOutForKey model.optOut "transport_bus" }, getAbfahrten model.stationId initialOptOutList)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none






-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html

-- elm package install elm-lang/http 3.0.1
-- elm package install lukewestby/elm-http-builder / Video: https://elmseeds.thaterikperson.com/http-builder
-- elm package install NoRedInk/elm-decode-pipeline
-- elm package install JeremyBellows/elm-bootstrapify
-- npm install popper.js --save
-- elm package install MadonnaMat/elm-select-two/latest


import Html
import Rest exposing (abfahrtDecoder,abfahrtenDecoder,getAbfahrten)
import Types exposing (Station,Abfahrt,Abfahrten,Model,Msg)
import View exposing (rootView)
import Dict
import List
import HttpErrorString exposing (httpErrorString)
import Time exposing (Time, minute)
import SelectTwo exposing (update)

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
       
initialStations : List Types.Station
initialStations =
    [
     (Station 20000196 "Dortmund, Dorstfeld S")
    ,(Station 20001205 "Dortmund, Karl-Funke-Straße")
    ,(Station 20001119 "Fine Frau")
    ,(Station 20000439 "Sengsbank")
    ,(Station 20000825 "Dorstfeld Süd")
    ]

initalFeedback: String
initalFeedback =
    ""

initialState : ( Model , Cmd Msg ) -- https://github.com/elm-lang/elm-compiler/blob/0.18.0/hints/type-annotations.md
initialState =
    ( Model initialStations [] 10 [10,20,50,100] initialOptOut initalFeedback
    , getAbfahrten initialStations initialOptOutList initialOptOut
    )

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
      (model, getAbfahrten model.stations initialOptOutList Dict.empty)

    Types.UserTypedStationName someStationName ->
      ({ model | feedback = "Ihre Eingabe:" ++ someStationName}, Cmd.none)

    Types.AbfahrtenEnvelopIsLoaded (Ok abfahrtenEnvelop) ->
      let abfahrten = 
                (Abfahrten abfahrtenEnvelop.stationId  abfahrtenEnvelop.stationName ( List.map .abfahrt abfahrtenEnvelop.abfahrten) )
          station = 
                (Station abfahrtenEnvelop.stationId abfahrtenEnvelop.stationName) -- nice be we do not use this variable
                
      in 
        ( Model model.stations (model.abfahrten++[abfahrten]) model.rowCount model.listOfPossibleRowCounts model.optOut  ("Aktualisiert für: " ++ abfahrtenEnvelop.stationName)  , Cmd.none )

    Types.AbfahrtenEnvelopIsLoaded (Err e) ->
      ({ model | feedback = httpErrorString e }, Cmd.none) 
      
    Types.BatchDropDownSelected ->
      ({ model | abfahrten=[] , feedback = "BatchDropDownSelected ..."}, Cmd.none) 

    Types.Toggle_ICE ->
      ({ model | abfahrten=[] , optOut = toggleOptOutForKey model.optOut "transport_ice" }, getAbfahrten model.stations initialOptOutList (toggleOptOutForKey model.optOut "transport_ice" ))

    Types.Toggle_Zug ->
      ({ model | abfahrten=[] , optOut = toggleOptOutForKey model.optOut "transport_zug" }, getAbfahrten model.stations initialOptOutList (toggleOptOutForKey model.optOut "transport_zug" ))

    Types.Toggle_Sbahn ->
      ({ model | abfahrten=[] , optOut = toggleOptOutForKey model.optOut "transport_sbahn" }, getAbfahrten model.stations initialOptOutList (toggleOptOutForKey model.optOut "transport_sbahn" ))

    Types.Toggle_Ubahn ->
      ({ model | abfahrten=[] , optOut = toggleOptOutForKey model.optOut "transport_ubahn" }, getAbfahrten model.stations initialOptOutList (toggleOptOutForKey model.optOut "transport_ubahn" ))

    Types.Toggle_Strassenbahn ->
      ({ model | abfahrten=[] , optOut = toggleOptOutForKey model.optOut "transport_strassenbahn" } , getAbfahrten model.stations initialOptOutList (toggleOptOutForKey model.optOut "transport_strassenbahn" ))

    Types.Toggle_Bus ->
      ({ model | abfahrten=[] , optOut = toggleOptOutForKey model.optOut "transport_bus" }, getAbfahrten model.stations initialOptOutList (toggleOptOutForKey model.optOut "transport_bus"))

    Types.Tick _ ->
      ( { model | abfahrten=[] , feedback = "Aktualisierung ..." },  getAbfahrten model.stations initialOptOutList model.optOut)

-- SUBSCRIPTIONS
-- https://github.com/aeveris/super-spotlight/blob/312b59b5ed3e3256caac2f6bfb19d227a3ef6e9f/src/Main.elm#L89

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every (minute*1) Types.Tick



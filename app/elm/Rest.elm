module Rest exposing (abfahrtenEnvelopDecoder,abfahrtenDecoder,abfahrtEnvelopDecoder,abfahrtDecoder,getAbfahrten)

-- http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest
import Json.Decode exposing (list, int, string, float, nullable, Decoder,decodeString,map)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

import HttpBuilder exposing (..)
import Time
import Http

import List
import String
import Dict
import Maybe

import Types exposing (AbfahrtenEnvelop,Station,Stationsinfo,AbfahrtEnvelop,Abfahrten,Abfahrt,Msg)


-- http://stackoverflow.com/questions/40736079/how-to-convert-from-string-to-int-in-json-decoder-in-elm-core-5-0-0?rq=1
stringIntDecoder : Decoder Int
stringIntDecoder =
    Json.Decode.map (\str -> String.toInt (str) |> Result.withDefault 0) string


abfahrtenEnvelopDecoder : Decoder AbfahrtenEnvelop
abfahrtenEnvelopDecoder =
    decode AbfahrtenEnvelop
        |> required "stationInfo" stationInfoDecoder
        |> required "stationId"   stringIntDecoder
        |> required "stationName" string
        |> required "abfahrten"   (Json.Decode.list abfahrtEnvelopDecoder)


stationInfoDecoder : Decoder Stationsinfo
stationInfoDecoder =
    decode Stationsinfo
        |> optional "sitzen"  string "keine Angaben"
        |> optional "aufzug"  string "keine Angaben"
        |> optional "automat" string "keine Angaben"
        |> optional "treppe"  string "keine Angaben"

-- https://github.com/NoRedInk/elm-decode-pipeline


abfahrtEnvelopDecoder : Decoder AbfahrtEnvelop
abfahrtEnvelopDecoder =
  decode AbfahrtEnvelop
    |> required "abfahrt" abfahrtDecoder


abfahrtDecoder : Decoder Abfahrt
abfahrtDecoder =
  decode Abfahrt
    |> required "hour" stringIntDecoder
    |> required "minute" stringIntDecoder
    |> required "delay" stringIntDecoder
    |> required "subname" string
    |> required "lineNumber" string
    |> required "lineCode" string
    |> required "direction" string


abfahrtenDecoder : Decoder Abfahrten
abfahrtenDecoder =
    decode Abfahrten
        |> required "stationId" int
        |> required "stationName" string
        |> required "abfahrten" (Json.Decode.list abfahrtDecoder)

--        |> required "currentTime" int
--        |> required "globalInfo" string
--        |> required "currentTimeReal" int
--        |> required "marquee" int


-- HTTP

-- "departure" "stationId" (toString(stationId))
-- "departure" "platformVisibility" "1"
-- "departure" "transport" (transport)
-- "departure" "useAllLines" "1"
-- "departure" "rowCount"  (toString(batch))
-- "departure" "distance"  (toString(distance))
-- "departure" "marquee" "0"

-- Argument aList zB.: [("transport_bus",False),("transport_ice",True),("transport_sbahn",False),("transport_strassenbahn",True),("transport_ubahn",False),("transport_zug",True)]
elementIndexesInListWhichHaveTupleSecondSetToTrueInDict: Dict.Dict String Bool -> List ( String, Bool ) -> List String
elementIndexesInListWhichHaveTupleSecondSetToTrueInDict aDict aList =
    --von diesen nur die in aDict gewählten: (1,"transport_bus", 2,"transport_ice", )
    List.map Tuple.first (List.filter (\x ->(Maybe.withDefault False ( Dict.get (Tuple.second x) aDict))) (List.indexedMap (\i x -> ((toString i),Tuple.first x) ) aList)  ) 

postQuery : Int -> String -> Int -> Int -> Cmd Msg
postQuery stationId transport rowCount distance =
    HttpBuilder.post "http://localhost:5000/abfahrten_for_station"
        |> withQueryParams [ ("stationId", (toString stationId ))
                            ,("transport", transport) 
                            ,("rowCount", (toString 10))
                            ,("distance", (toString distance))
                            ]
                            
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectJson abfahrtenEnvelopDecoder)
        |> withCredentials
        |> send Types.AbfahrtenEnvelopIsLoaded

--      |> withJsonBody (itemEncoder item)
--      |> withHeader "Origin" "haltestellenmonitor.vrr.de"

getAbfahrten : List Station -> List ( String, Bool ) -> Dict.Dict String Bool -> Cmd Msg
getAbfahrten stations inititionalOptOutList optOutDict =

    let transport = 
        String.join ","  (elementIndexesInListWhichHaveTupleSecondSetToTrueInDict optOutDict inititionalOptOutList)

        stationId = 
            case List.head stations of                  
              Nothing ->                              
                -1                 -- fake station id
              Just val ->                             
                val.stationId
        
        

    in

        postQuery stationId transport 10 0


module Rest exposing (abfahrtenEnvelopDecoder,abfahrtenDecoder,abfahrtEnvelopDecoder,abfahrtDecoder,getAbfahrten)

-- http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest
import Json.Decode exposing (list, int, string, float, nullable, Decoder,decodeString,map)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

import HttpBuilder exposing (..)
import Time
import Http

-- import Json.Decode as Decode


import Types exposing (AbfahrtenEnvelop,Stationsinfo,AbfahrtEnvelop,Abfahrten,Abfahrt,Msg)


-- http://stackoverflow.com/questions/40736079/how-to-convert-from-string-to-int-in-json-decoder-in-elm-core-5-0-0?rq=1
stringIntDecoder : Decoder Int
stringIntDecoder =
    Json.Decode.map (\str -> String.toInt (str) |> Result.withDefault 0) string


abfahrtenEnvelopDecoder : Decoder AbfahrtenEnvelop
abfahrtenEnvelopDecoder =
    Json.Decode.Pipeline.decode AbfahrtenEnvelop
        |> Json.Decode.Pipeline.required "stationInfo" stationInfoDecoder
        |> Json.Decode.Pipeline.required "stationId"   stringIntDecoder
        |> Json.Decode.Pipeline.required "stationName" string
        |> Json.Decode.Pipeline.required "abfahrten"   (Json.Decode.list abfahrtEnvelopDecoder)


stationInfoDecoder : Decoder Stationsinfo
stationInfoDecoder =
    Json.Decode.Pipeline.decode Stationsinfo
        |> Json.Decode.Pipeline.required "sitzen"  string
        |> Json.Decode.Pipeline.required "aufzug"  string
        |> Json.Decode.Pipeline.required "automat" string
        |> Json.Decode.Pipeline.required "treppe"  string



abfahrtEnvelopDecoder : Decoder AbfahrtEnvelop
abfahrtEnvelopDecoder =
  decode AbfahrtEnvelop
    |> Json.Decode.Pipeline.required "abfahrt" abfahrtDecoder


abfahrtDecoder : Decoder Abfahrt
abfahrtDecoder =
  decode Abfahrt
    |> Json.Decode.Pipeline.required "hour" stringIntDecoder
    |> Json.Decode.Pipeline.required "minute" stringIntDecoder
    |> Json.Decode.Pipeline.required "delay" stringIntDecoder
    |> Json.Decode.Pipeline.required "subname" string
    |> Json.Decode.Pipeline.required "lineNumber" string
    |> Json.Decode.Pipeline.required "lineCode" string
    |> Json.Decode.Pipeline.required "direction" string


abfahrtenDecoder : Decoder Abfahrten
abfahrtenDecoder =
    Json.Decode.Pipeline.decode Abfahrten
        |> Json.Decode.Pipeline.required "stationId" int
        |> Json.Decode.Pipeline.required "stationName" string
        |> Json.Decode.Pipeline.required "abfahrten" (Json.Decode.list abfahrtDecoder)

--        |> Json.Decode.Pipeline.required "currentTime" int
--        |> Json.Decode.Pipeline.required "globalInfo" string
--        |> Json.Decode.Pipeline.required "currentTimeReal" int
--        |> Json.Decode.Pipeline.required "marquee" int


-- HTTP


getAbfahrten : Int -> Cmd Msg
getAbfahrten stationId =
    HttpBuilder.post "http://localhost:5000/abfahrten_for_station"
        |> withQueryParams [ ("stationId", (toString stationId) ) ]
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectJson abfahrtenEnvelopDecoder)
        |> withCredentials
        |> send Types.AbfahrtenEnvelopIsLoaded

--      |> withJsonBody (itemEncoder item)
--      |> withHeader "Origin" "haltestellenmonitor.vrr.de"

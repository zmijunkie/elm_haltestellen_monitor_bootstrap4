module Types exposing (AbfahrtenEnvelop,Abfahrten,Stationsinfo,AbfahrtEnvelop,Abfahrt,Model,Msg(..) )


import Http
import Dict

type alias AbfahrtenEnvelop =
    { stationInfo : Stationsinfo
    , stationId : Int
    , stationName : String
    , abfahrten : List AbfahrtEnvelop
    }

type alias Stationsinfo =
    { sitzen : String
    , aufzug : String
    , automat : String
    , treppe : String
    }


type alias AbfahrtEnvelop =
 {   abfahrt : Abfahrt
 }


type alias Abfahrt =
 {   hour : Int  
   , minute: Int
   , delay: Int
   , subname: String
   , lineNumber: String
   , lineCode: String
   , direction: String
 }

type alias Abfahrten =
   {
       stationId : Int
     , stationName : String
     , departureData : List Abfahrt

--   , currentTime : Int
--   , globalInfo : String
--   , currentTimeReal : Int
--   , marquee : Int


}

type alias Station =
 {   stationId : Int  
 }


-- MODEL

type alias Model =
  { stationId : Int          -- besser:  , stations  : List Station
  , stationName : String
  , abfahrten : Abfahrten
  , optOut : Dict.Dict String Bool 
  , lastQuery : String
  , feedback : String
  }

--  , abfahrten : List Abfahrt




type Msg
  = MorePlease
  | StationsInfoIsLoaded (Result Http.Error AbfahrtenEnvelop)
  | Toggle_ICE
  | Toggle_Zug
  | Toggle_Sbahn
  | Toggle_Ubahn
  | Toggle_Strassenbahn
  | Toggle_Bus

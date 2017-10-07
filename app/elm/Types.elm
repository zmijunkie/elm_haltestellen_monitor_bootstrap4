module Types exposing (AbfahrtenEnvelop,Abfahrten,Station,Stationsinfo,AbfahrtEnvelop,Abfahrt,Model,Msg(..) )


import Http
import Dict
import Time exposing (Time)

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

-- used in View only
type alias Station =
    { stationId : Int
    , stationName : String
    }


-- MODEL

type alias Model =
  { stations  : List Station
  , abfahrten : Abfahrten
  , rowCount : Int
  , listOfPossibleRowCounts : List Int
  , optOut : Dict.Dict String Bool 
  , lastQuery : String
  , feedback : String
  }

--  , abfahrten : List Abfahrt




type Msg
  = Tick Time
  | MorePlease
  | BatchDropDownSelected 
  | UserTypedStationName String
  | AbfahrtenEnvelopIsLoaded (Result Http.Error AbfahrtenEnvelop)
  | Toggle_ICE
  | Toggle_Zug
  | Toggle_Sbahn
  | Toggle_Ubahn
  | Toggle_Strassenbahn
  | Toggle_Bus

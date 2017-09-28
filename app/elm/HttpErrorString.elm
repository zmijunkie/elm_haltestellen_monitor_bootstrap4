module HttpErrorString exposing (httpErrorString)

import Http exposing (..)

httpErrorString : Error -> String
httpErrorString error =
    case error of
        BadUrl text ->
            "Bad Url: " ++ text
        Timeout ->
            "Http Timeout"
        NetworkError ->
            "Netzwerkfehler  - ich erreiche den Abfrageserver nicht"
        BadStatus response ->
            "Bad Http Status: " ++ toString response.status.code
        BadPayload message response ->
            "Bad Http Payload: "
                ++ toString message
                ++ " ("
                ++ toString response.status.code
                ++ ")"
                

-- this code was copied from:             
-- https://becoming-functional.com/http-error-checking-in-elm-fee8c4b68b7b
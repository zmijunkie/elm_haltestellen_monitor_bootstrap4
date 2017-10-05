module View exposing (rootView)

import Html exposing (Html, div, h1, text, p, a, hr, input,span, li, ul, dl, ol, button, label, strong, td, th, tr, tbody, thead, table)
import Html.Attributes exposing (class,attribute,href,type_,placeholder,id, checked, scope )
import Html.Events exposing (onClick,onInput)

-- import State exposing (..)
import Types exposing (Abfahrt,Model,Msg)


import Dict
import Maybe
-- import Json

show_alert_if_text : String -> Html msg
show_alert_if_text someText =
     case someText of
        "" ->
        div [] []
        _  ->
        div [ class "alert alert-success", attribute "role" "alert" ]
            [ strong []
                [ text "Hinweis: " ]
            , text someText
            ]


user_feedback_msg : Model -> String
user_feedback_msg model =

    let (ice,zug,sbahn,ubahn,strassenbahn,bus) = 
        (  (Maybe.withDefault True (Dict.get "transport_ice" model.optOut) )
          ,(Maybe.withDefault True (Dict.get "transport_zug" model.optOut) )
          ,(Maybe.withDefault True (Dict.get "transport_sbahn" model.optOut) )
          ,(Maybe.withDefault True (Dict.get "transport_ubahn" model.optOut) )
          ,(Maybe.withDefault True (Dict.get "transport_strassenbahn" model.optOut) )
          ,(Maybe.withDefault True (Dict.get "transport_bus" model.optOut) )
        )
    
    in
        case (ice,zug,sbahn,ubahn,strassenbahn,bus) of
            (False,False,False,False,False,False)  -> "Wählen Sie mindestens ein Verkehrsmittel aus, um Ergebnisse zu bekommen"
            -- (_,_,_,_,_,True)  -> "Sorry, Busse sind heute alle ausgefallen"
            (_,_,_,_,_,_)  -> ""


checkbox : msg -> String -> Bool -> Html msg
checkbox msg name state =
  label [ class "btn btn-primary active" ] -- FIXME: active wants to be set by 'state'
    [ input [ attribute "autocomplete" "off", type_ "checkbox", onClick msg, checked state ]
        []
    , text name
    ]



renderNumber : Int -> String
renderNumber i =
    if i <10 then ("0" ++ (toString i)) else (toString i)
        
    

renderBatchdropdown : msg -> List Int -> Html msg
renderBatchdropdown msg batchsizeList =
    div [ class "dropdown" ]
        [ button [ attribute "aria-expanded" "false", attribute "aria-haspopup" "true", class "btn btn-secondary dropdown-toggle", attribute "data-toggle" "dropdown", id "dropdownMenuButton", type_ "button" ]
            [ text "10" ]
        , div [ attribute "aria-labelledby" "dropdownMenuButton", class "dropdown-menu" ]
            [ a [ class "dropdown-item", href "#" ]
                [ text "20" ]
            , a [ class "dropdown-item", href "#" ]
                [ text "50" ]
            ]
        ]


-- , div [ attribute "aria-labelledby" "dropdownMenuButton", class "dropdown-menu" , on "change" (Json.Decode.map BatchDropDownSelected targetValueDecoder)]

--targetValueDecoder : Json.Decode.Decoder Role
--targetValueDecoder =
--  targetValue |> Json.Decode.andThen (\val ->
--    case val of
--      "Admin" -> Json.Decode.succeed Admin
--      "User" -> Json.Decode.succeed User
--      "None" -> Json.Decode.succeed None
--      _ -> Json.Decode.fail ("Invalid Role: " ++ val)
--      
--    )
 

renderAbfahrt : Int -> Abfahrt -> Html Msg
renderAbfahrt index a =
    tr []
    [
    th [ scope "row" ]
       [ text (toString(index+1)) ]
    , td  [class "hour"]
         [(text (renderNumber (a.hour) ++ ":" ++ renderNumber (a.minute)  ++ "h" ++ "+" ++ renderNumber (a.delay) ++ "min" )   ) ]
    , td [class "subname"]
       [(text (a.subname))]
    , td [class "lineCode"]
       [(text (a.lineCode) )]
    , td [class "direction"]
       [(text (a.direction))]
    ]


renderAbfahrten : List Abfahrt -> Html Msg
renderAbfahrten abfahrten =
    table [ class "table table-hover" ]
        [ thead []
            [ tr []
                [ th []
                    [ renderBatchdropdown Types.BatchDropDownSelected  [10,20,50]  ]
                , th []
                    [ text "Uhrzeit" ]
                , th []
                    [ text "Verkehrsmittel" ]
                , th []
                    [ text "Linie" ]
                , th []
                    [ text "Richtung" ]

                ]
            ]

        , tbody []
                (List.indexedMap (\index abfahrt -> (renderAbfahrt index abfahrt)) abfahrten) 

        ]

renderList lst renderer =
    ul []
        (List.map (\l -> li [] [ renderer l ]) lst)
        
-- VIEW

rootView : Model -> Html Msg
rootView model =
    div [ class "jumbotron" ]
        [ h1 [ class "display-3" ]
            [ text "Haltestellenmonitor" ]
        , p [ class "lead" ]
            [ text model.feedback ]
        , hr [ class "my-4" ]
            []
        , p []
            [ text "Geben Sie die Haltestelle ein!" ] 
            
        , div [ class "input-group input-group-lg" ]
            [ span [ class "input-group-addon", id "sizing-addon1" ]
                [ text "Von" ]
            , input [ onInput Types.UserTypedStationName, attribute "aria-describedby" "sizing-addon1", class "form-control", placeholder model.stationName, Html.Attributes.type_ "text" ]
                []
            ]            

            , checkbox Types.Toggle_ICE "ICE/IC/EC"            (Maybe.withDefault True (Dict.get "transport_ice" model.optOut) )
            , checkbox Types.Toggle_Zug "Zug"                  (Maybe.withDefault True (Dict.get "transport_zug" model.optOut) ) 
            , checkbox Types.Toggle_Sbahn "S-Bahn"             (Maybe.withDefault True (Dict.get "transport_sbahn" model.optOut) ) 
            , checkbox Types.Toggle_Ubahn "U-Bahn"             (Maybe.withDefault True (Dict.get "transport_ubahn" model.optOut) ) 
            , checkbox Types.Toggle_Strassenbahn "Straßenbahn" (Maybe.withDefault True (Dict.get "transport_strassenbahn" model.optOut) ) 
            , checkbox Types.Toggle_Bus "Bus"                  (Maybe.withDefault True (Dict.get "transport_bus" model.optOut) )

            , show_alert_if_text (user_feedback_msg model)

            , renderAbfahrten model.abfahrten.departureData

            ]


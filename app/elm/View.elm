module View exposing (rootView)

import Html exposing (Html, div, h1, text, p, a, hr, input,span, li, ul, dl, ol, button, label, strong, td, th, tr, tbody, thead, table)
import Html.Attributes exposing (class,attribute,href,type_,placeholder,id, checked, scope )
import Html.Events exposing (onClick)

-- import State exposing (..)
import Types exposing (Abfahrt,Model,Msg)


import Dict
import Maybe

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


renderAbfahrt : Int -> Abfahrt -> Html Msg
renderAbfahrt index a =
    tr []
    [
    th [ scope "row" ]
       [ text (toString(index+1)) ]
    , td  [class "hour"]
         [(text (toString (a.hour) ++ ":" ++ toString (a.minute)  ++ "h" )   ) ]
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
                    [ text "#" ]
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
            , input [ attribute "aria-describedby" "sizing-addon1", class "form-control", placeholder model.stationName, Html.Attributes.type_ "text" ]
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


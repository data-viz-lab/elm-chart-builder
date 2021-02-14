module Chart.Internal.SquarePie exposing (renderPie)

import Array
import Chart.Internal.Type as Type
    exposing
        ( fromConfig
        , getDomainBandFromData
        )
import Html exposing (Html)
import Html.Attributes exposing (class, style)


renderPie : ( Type.DataBand, Type.Config ) -> Html msg
renderPie ( data, config ) =
    let
        c =
            fromConfig config

        w =
            c.width

        h =
            c.height

        domain : Type.DomainBandStruct
        domain =
            getDomainBandFromData data config

        _ =
            Debug.log "data" data

        chartEl =
            square ( data, c )
    in
    case c.accessibilityContent of
        Type.AccessibilityNone ->
            Html.div [] [ chartEl ]

        _ ->
            Html.div []
                [ Html.figure
                    []
                    [ chartEl, tableElement data c.accessibilityContent ]
                ]


tableElement : Type.DataBand -> Type.AccessibilityContent -> Html msg
tableElement data accessibilityContent =
    Html.text ""


square : ( Type.DataBand, Type.ConfigStruct ) -> Html msg
square ( data, c ) =
    List.range 0 9
        |> List.map
            (\idx0 ->
                List.range 0 9
                    |> List.map
                        (\idx1 ->
                            Html.div
                                [ class (String.fromInt idx0 ++ "--" ++ String.fromInt idx1)
                                , style "background-color" "teal"
                                ]
                                []
                        )
            )
        |> List.concat
        |> (\rows ->
                Html.div
                    [ style "display" "grid"
                    , style "grid-template-rows" "repeat(10, 1fr)"
                    , style "grid-template-columns" "repeat(10, 1fr)"
                    , style "grid-gap" "1px"
                    , style "width" ((c.width |> String.fromFloat) ++ "px")
                    , style "height" ((c.height |> String.fromFloat) ++ "px")
                    ]
                    rows
           )

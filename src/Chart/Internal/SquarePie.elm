module Chart.Internal.SquarePie exposing (renderPie)

import Array exposing (Array)
import Chart.Internal.Type as Type
    exposing
        ( fromConfig
        , getDomainBandFromData
        )
import Color
import Html exposing (Html)
import Html.Attributes exposing (class, style)


renderPie : ( List Type.PointBand, Type.Config ) -> Html msg
renderPie ( data, config ) =
    let
        c =
            fromConfig config

        w =
            c.width

        h =
            c.height

        dataBand : Type.DataBand
        dataBand =
            [ { groupLabel = Nothing, points = data } ]
                |> Type.toDataBand

        domain : Type.DomainBandStruct
        domain =
            getDomainBandFromData dataBand config

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


tableElement : List Type.PointBand -> Type.AccessibilityContent -> Html msg
tableElement data accessibilityContent =
    Html.text ""


square : ( List Type.PointBand, Type.ConfigStruct ) -> Html msg
square ( data, c ) =
    let
        size =
            10
    in
    Html.div
        [ style "display" "grid"
        , style "grid-template-rows" ("repeat(" ++ String.fromInt size ++ ", 1fr)")
        , style "grid-template-columns" ("repeat(" ++ String.fromInt size ++ ", 1fr)")
        , style "grid-gap" "1px"
        , style "width" ((c.width |> String.fromFloat) ++ "px")
        , style "height" ((c.height |> String.fromFloat) ++ "px")
        ]
        (initializeGrid size
            |> Array.toList
            |> List.map
                (\item ->
                    let
                        cssClass =
                            String.fromInt item.idx0 ++ "--" ++ String.fromInt item.idx1

                        luminosity =
                            ((item.idx0 + 1 |> toFloat) * (item.idx1 + 1 |> toFloat)) / (size * size)

                        color =
                            Color.hsl 0.9 1.0 luminosity
                    in
                    Html.div
                        [ class cssClass

                        --, style "background-color" (Color.toCssString color)
                        , style "background-color" "white"
                        ]
                        --[]
                        [ Html.text cssClass ]
                )
        )



-- GRID


type alias GridItem =
    { idx0 : Int
    , idx1 : Int
    , xValue : String
    , yValue : Float
    }


initializeGrid : Int -> Array GridItem
initializeGrid size =
    Array.initialize size (\n -> n + 1)
        |> Array.map
            (\idx0 ->
                Array.initialize size (\n -> n + 1)
                    |> Array.map
                        (\idx1 ->
                            { idx0 = idx0 - 1
                            , idx1 = idx1 - 1
                            , xValue = ""
                            , yValue = 0
                            }
                        )
            )
        |> Array.foldl (\arr acc -> Array.append acc arr) Array.empty

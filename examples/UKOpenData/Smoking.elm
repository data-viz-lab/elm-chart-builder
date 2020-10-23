module UKOpenData.Smoking exposing (main)

{-| This module shows how to build a line chart.
-}

import Axis
import Chart.Line as Line
import Data exposing (smokeStats)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Set
import Shape


css : String
css =
    """
body {
  font-family: Sans-Serif;
}

ul {
    padding: 0;
}

.header {
    font-size: 20px;
    margin: 20px;
}

footer {
    font-size: 12px;
    margin: 20px;
}

.wrapper {
  display: grid;
  grid-template-columns: 800px 800px;
  grid-gap: 20px;
  background-color: #fff;
  color: #444;
  margin: 25px;
}

.axis path,
.axis line {
    stroke: #b7b7b7;
}

text {
    fill: #333;
    font-size: 14px;
}

.line {
    stroke-width: 2px;
    fill: none;
}

.male .line {
    stroke: lightskyblue;
}

.female .line {
    stroke: plum;
}

figure {
  margin: 0;
}
"""


dataMale : List Data.SmokeStats
dataMale =
    smokeStats
        |> List.filter (\s -> String.contains "Male" s.regionPerGender)


dataFemale : List Data.SmokeStats
dataFemale =
    smokeStats
        |> List.filter (\s -> String.contains "Female" s.regionPerGender)


xAxisTicks : List Float
xAxisTicks =
    smokeStats
        |> List.map .year
        |> Set.fromList
        |> Set.toList
        |> List.sort
        |> List.filter (\s -> modBy 2 (round s) /= 0)


accessor : Line.Accessor Data.SmokeStats
accessor =
    Line.linear (Line.AccessorLinear (.regionPerGender >> Just) .year .percentage)


xAxis : Line.XAxis Float
xAxis =
    Line.axisBottom
        [ Axis.ticks xAxisTicks
        , Axis.tickFormat (round >> String.fromInt)
        ]


yAxis : Line.YAxis Float
yAxis =
    Line.axisRight [ Axis.tickCount 5 ]


line =
    Line.init
        { margin = { top = 10, right = 50, bottom = 30, left = 30 }
        , width = 700
        , height = 400
        }
        |> Line.withXAxisLinear xAxis
        |> Line.withYAxis yAxis
        |> Line.withCurve Shape.basisCurve
        |> Line.withYDomain ( 0, 50 )


lineMale : Html msg
lineMale =
    line
        |> Line.render ( dataMale, accessor )


lineFemale : Html msg
lineFemale =
    line
        |> Line.render ( dataFemale, accessor )


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" "700px"
    , Html.Attributes.style "width" "400px"
    , class "chart-wrapper"
    ]


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div [ class "wrapper" ]
            [ Html.div (class "male" :: attrs) [ lineMale ]
            , Html.div (class "female" :: attrs) [ lineFemale ]
            ]
        , Html.footer []
            [ Html.a
                [ Html.Attributes.href
                    "https://digital.nhs.uk/data-and-information/publications/clinical-indicators/compendium-of-population-health-indicators/compendium-public-health/current/smoking/cigarette-smoking-standardised-percent-16-years-annual-trend-mfp"
                ]
                [ Html.text "Data source" ]
            ]
        ]

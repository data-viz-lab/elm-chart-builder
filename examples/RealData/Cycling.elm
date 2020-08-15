module RealData.Cycling exposing (main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.Bar as Bar
import Html exposing (Html)
import Html.Attributes exposing (class)
import Numeral


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

.footer {
    font-size: 12px;
    margin: 20px;
}

.wrapper {
  display: grid;
  grid-template-columns: 260px 240px 500px;
  grid-gap: 20px;
  background-color: #fff;
  color: #444;
  margin: 25px;
}

.column-0 rect,
.column-0 .symbol {
    fill: #fecc5c;
}

.column-1 rect,
.column-1 .symbol {
    fill: #fd8d3c;
}

.column-2 rect,
.column-2 .symbol {
    fill: #f03b20;
}

.column-3 rect,
.column-3 .symbol {
    fill: #bd0026;
}

.axis path,
.axis line {
    stroke: #b7b7b7;
}

text {
    fill: #333;
    font-size: 14px;
}

.legend-wrapper {
    display: flex;
    align-items: center;
}

.legend {
    display: flex;
    margin-right: 40px;
    height: 300px;
}

.legend-labels {
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    margin-left: 10px;
}

"""


width : Float
width =
    500


height : Float
height =
    600


type alias Data =
    { x : String, y : Float, groupLabel : String }


accessor : Bar.Accessor Data
accessor =
    Bar.Accessor .groupLabel .x .y


data : List Data
data =
    [ { groupLabel = "16-24", x = "once per month", y = 0.211 }
    , { groupLabel = "16-24", x = "once per week", y = 0.015 }
    , { groupLabel = "16-24", x = "three times per week", y = 0.078 }
    , { groupLabel = "16-24", x = "five times per week", y = 0.049 }
    , { groupLabel = "25-34", x = "once per month", y = 0.019 }
    , { groupLabel = "25-34", x = "once per week", y = 0.131 }
    , { groupLabel = "25-34", x = "three times per week", y = 0.07 }
    , { groupLabel = "25-34", x = "five times per week", y = 0.045 }
    , { groupLabel = "35-44", x = "once per month", y = 0.219 }
    , { groupLabel = "35-44", x = "once per week", y = 0.151 }
    , { groupLabel = "35-44", x = "three times per week", y = 0.072 }
    , { groupLabel = "35-44", x = "five times per week", y = 0.042 }
    , { groupLabel = "45-54", x = "once per month", y = 0.217 }
    , { groupLabel = "45-54", x = "once per week", y = 0.015 }
    , { groupLabel = "45-54", x = "three times per week", y = 0.069 }
    , { groupLabel = "45-54", x = "five times per week", y = 0.004 }
    , { groupLabel = "55-64", x = "once per month", y = 0.152 }
    , { groupLabel = "55-64", x = "once per week", y = 0.107 }
    , { groupLabel = "55-64", x = "three times per week", y = 0.045 }
    , { groupLabel = "55-64", x = "five times per week", y = 0.025 }
    , { groupLabel = "65+years", x = "once per month", y = 0.076 }
    , { groupLabel = "65+years", x = "once per week", y = 0.053 }
    , { groupLabel = "65+years", x = "three times per week", y = 0.021 }
    , { groupLabel = "65+years", x = "five times per week", y = 0.012 }
    ]


dataGender : List Data
dataGender =
    [ { groupLabel = "Male", x = "once per month", y = 0.229 }
    , { groupLabel = "Male", x = "once per week", y = 0.168 }
    , { groupLabel = "Male", x = "three times per week", y = 0.084 }
    , { groupLabel = "Male", x = "five times per week", y = 0.051 }
    , { groupLabel = "Female", x = "once per month", y = 0.117 }
    , { groupLabel = "Female", x = "once per week", y = 0.072 }
    , { groupLabel = "Female", x = "three times per week", y = 0.031 }
    , { groupLabel = "Female", x = "five times per week", y = 0.017 }
    ]


dataLegend : List Data
dataLegend =
    [ { groupLabel = "legend", x = "Once per month", y = 0.25 }
    , { groupLabel = "legend", x = "Once per week", y = 0.25 }
    , { groupLabel = "legend", x = "Three times per week", y = 0.25 }
    , { groupLabel = "legend", x = "Five times per week", y = 0.25 }
    ]


valueFormatter : Float -> String
valueFormatter =
    Numeral.format "0%"


stackedByFrequency : Html msg
stackedByFrequency =
    Bar.init
        { margin = { top = 30, right = 20, bottom = 30, left = 0 }
        , width = width
        , height = height
        }
        |> Bar.withStackedLayout Bar.noDirection
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.withYAxis False
        |> Bar.withDomainLinear ( 0, 0.55 )
        |> Bar.render ( data, accessor )


stackedByFrequencyGender : Html msg
stackedByFrequencyGender =
    Bar.init
        { margin = { top = 30, right = 20, bottom = 30, left = 50 }
        , width = 240
        , height = height
        }
        |> Bar.withStackedLayout Bar.noDirection
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.withDomainLinear ( 0, 0.55 )
        |> Bar.render ( dataGender, accessor )


stackedByFrequencyLegend : Html msg
stackedByFrequencyLegend =
    Bar.init
        { margin = { top = 0, right = 0, bottom = 0, left = 0 }
        , width = 30
        , height = 300
        }
        |> Bar.withStackedLayout Bar.noDirection
        |> Bar.withYAxis False
        |> Bar.withXAxis False
        |> Bar.render ( dataLegend, accessor )


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


attrsGender : List (Html.Attribute msg)
attrsGender =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" "240px"
    , class "chart-wrapper"
    ]


footer : Html msg
footer =
    Html.footer [ class "footer" ]
        [ Html.ul []
            [ Html.li []
                [ Html.a
                    [ Html.Attributes.href
                        "https://www.gov.uk/government/statistics/walking-and-cycling-statistics-england-2016"
                    ]
                    [ Html.text "Data source" ]
                ]
            , Html.li []
                [ Html.a
                    [ Html.Attributes.href
                        "https://github.com/data-viz-lab/elm-chart-builder/blob/master/examples/RealData/Cycling.elm"
                    ]
                    [ Html.text "Source code" ]
                ]
            ]
        ]


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.header [ class "header" ]
            [ Html.text "Proportion of adults that cycle, by frequency and demographic, England, 2015-2016" ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div [ class "legend-wrapper" ]
                [ Html.div [ class "legend" ]
                    [ Html.div [ class "legend-chart" ] [ stackedByFrequencyLegend ]
                    , Html.div [ class "legend-labels" ]
                        (dataLegend
                            |> List.reverse
                            |> List.map (\d -> Html.div [] [ Html.text d.x ])
                        )
                    ]
                ]
            , Html.div attrsGender [ stackedByFrequencyGender ]
            , Html.div attrs [ stackedByFrequency ]
            ]
        , footer
        ]

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


data : List Bar.DataGroupBand
data =
    [ { groupLabel = Just "16-24"
      , points =
            [ ( "once per month", 0.211 )
            , ( "once per week", 0.015 )
            , ( "three times per week", 0.078 )
            , ( "five times per week", 0.049 )
            ]
      }
    , { groupLabel = Just "25-34"
      , points =
            [ ( "once per month", 0.019 )
            , ( "once per week", 0.131 )
            , ( "three times per week", 0.07 )
            , ( "five times per week", 0.045 )
            ]
      }
    , { groupLabel = Just "35-44"
      , points =
            [ ( "once per month", 0.219 )
            , ( "once per week", 0.151 )
            , ( "three times per week", 0.072 )
            , ( "five times per week", 0.042 )
            ]
      }
    , { groupLabel = Just "45-54"
      , points =
            [ ( "once per month", 0.217 )
            , ( "once per week", 0.015 )
            , ( "three times per week", 0.069 )
            , ( "five times per week", 0.004 )
            ]
      }
    , { groupLabel = Just "55-64"
      , points =
            [ ( "once per month", 0.152 )
            , ( "once per week", 0.107 )
            , ( "three times per week", 0.045 )
            , ( "five times per week", 0.025 )
            ]
      }
    , { groupLabel = Just "65+years"
      , points =
            [ ( "once per month", 0.076 )
            , ( "once per week", 0.053 )
            , ( "three times per week", 0.021 )
            , ( "five times per week", 0.012 )
            ]
      }
    ]


dataGender : List Bar.DataGroupBand
dataGender =
    [ { groupLabel = Just "Male"
      , points =
            [ ( "once per month", 0.229 )
            , ( "once per week", 0.168 )
            , ( "three times per week", 0.084 )
            , ( "five times per week", 0.051 )
            ]
      }
    , { groupLabel = Just "Female"
      , points =
            [ ( "once per month", 0.117 )
            , ( "once per week", 0.072 )
            , ( "three times per week", 0.031 )
            , ( "five times per week", 0.017 )
            ]
      }
    ]


dataLegendPoints : List ( String, Float )
dataLegendPoints =
    [ ( "Once per month", 0.25 )
    , ( "Once per week", 0.25 )
    , ( "Three times per week", 0.25 )
    , ( "Five times per week", 0.25 )
    ]


dataLegend : List Bar.DataGroupBand
dataLegend =
    [ { groupLabel = Just "legend"
      , points = dataLegendPoints
      }
    ]


valueFormatter : Float -> String
valueFormatter =
    Numeral.format "0%"


stackedByFrequency : Html msg
stackedByFrequency =
    Bar.init data
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.setTitle "Cycling frequency by age"
        |> Bar.setDesc "Proportion of adults that cycle, by frequency and demographic, England, 2015-2016"
        |> Bar.setLinearAxisTickFormat valueFormatter
        |> Bar.setShowContinousAxis False
        |> Bar.setDimensions
            { margin = { top = 30, right = 20, bottom = 30, left = 0 }
            , width = width
            , height = height
            }
        |> Bar.setDomainLinear ( 0, 0.55 )
        |> Bar.render


stackedByFrequencyGender : Html msg
stackedByFrequencyGender =
    Bar.init dataGender
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.setTitle "Cycling frequency by gender"
        |> Bar.setDesc "Proportion of adults that cycle, by frequency and demographic, England, 2015-2016"
        |> Bar.setLinearAxisTickFormat valueFormatter
        |> Bar.setDimensions
            { margin = { top = 30, right = 20, bottom = 30, left = 50 }
            , width = 240
            , height = height
            }
        |> Bar.setDomainLinear ( 0, 0.55 )
        |> Bar.render


stackedByFrequencyLegend : Html msg
stackedByFrequencyLegend =
    Bar.init dataLegend
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.setShowContinousAxis False
        |> Bar.setShowOrdinalAxis False
        |> Bar.setTitle "Cycling frequency by age legend"
        |> Bar.setDesc "Proportion of adults that cycle, by frequency and demographic, England, 2015-2016"
        |> Bar.setDimensions
            { margin = { top = 0, right = 0, bottom = 0, left = 0 }
            , width = 30
            , height = 300
            }
        |> Bar.render


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
                        (dataLegendPoints
                            |> List.reverse
                            |> List.map (\d -> Html.div [] [ Html.text <| Tuple.first d ])
                        )
                    ]
                ]
            , Html.div attrsGender [ stackedByFrequencyGender ]
            , Html.div attrs [ stackedByFrequency ]
            ]
        , footer
        ]

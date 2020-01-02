module Examples.RealData.BarChart exposing (main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.Bar as Bar
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes
import Numeral
import Svg exposing (..)
import Svg.Attributes exposing (..)


css : String
css =
    """
body {
  font-family: Sans-Serif;
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
  grid-template-columns: 550px 250px;
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

.legend {
    display: flex;
}

.legend-labels {
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    margin-left: 10px;
}

"""


data : Bar.Data
data =
    Bar.dataBand
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


dataLegend : Bar.Data
dataLegend =
    Bar.dataBand
        [ { groupLabel = Just "legend"
          , points =
                [ ( "Once per month", 0.25 )
                , ( "Once per week", 0.25 )
                , ( "Three times per week", 0.25 )
                , ( "Five times per week", 0.25 )
                ]
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
        |> Bar.setLinearAxisTickFormat (Bar.linearAxisCustomTickFormat valueFormatter)
        |> Bar.setDimensions
            { margin = { top = 30, right = 20, bottom = 30, left = 50 }
            , width = width
            , height = height
            }
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
            { margin = { top = 30, right = 0, bottom = 30, left = 0 }
            , width = 50
            , height = height
            }
        |> Bar.render


width : Float
width =
    500


height : Float
height =
    600


attrs =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ text css ]
        , Html.header [ class "header" ]
            [ text "Proportion of adults that cycle, by frequency and demographic, England, 2015-2016" ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div attrs [ stackedByFrequency ]
            , Html.div [ class "legend" ]
                [ Html.div [ class "legend-chart" ] [ stackedByFrequencyLegend ]
                , Html.div [ class "legend-labels" ]
                    [ Html.div [] [ text "Five times per week" ]
                    , Html.div [] [ text "Three times per week" ]
                    , Html.div [] [ text "Once per week" ]
                    , Html.div [] [ text "Once per month" ]
                    ]
                ]
            ]
        , Html.footer [ class "footer" ]
            [ Html.a
                [ Html.Attributes.href
                    "https://www.gov.uk/government/statistics/walking-and-cycling-statistics-england-2016"
                ]
                [ text "data source" ]
            ]
        ]

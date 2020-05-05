module HistogramBarChart exposing (data, main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.HistogramBar as Bar
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Scale.Color


css : String
css =
    """
body {
  font-family: Sans-Serif;
}

.wrapper {
  display: grid;
  grid-template-columns: repeat(2, 500px);
  grid-gap: 20px;
  background-color: #fff;
  color: #444;
  margin: 25px;
}

.chart-wrapper {
    border: 1px solid #c4c4c4;
}

.axis path,
.axis line {
    stroke: #b7b7b7;
}

text {
    fill: #333;
}
"""


type alias Data =
    Float


bucketedData =
    [ { buket = 0.8
      , count = 10
      }
    , { buket = 0.7
      , count = 0
      }
    , { buket = 0.9
      , count = 0
      }
    , { buket = 0.0
      , count = 5
      }
    , { buket = 0.2
      , count = 0
      }
    , { buket = 1.0
      , count = 7
      }
    , { buket = 0.1
      , count = 0
      }
    , { buket = 0.4
      , count = 0
      }
    , { buket = 0.3
      , count = 0
      }
    , { buket = 0.6
      , count = 0
      }
    , { buket = 0.5
      , count = 0
      }
    ]


data : List Data
data =
    [ 0.01
    , 0.02
    , 0.09
    , 0.1
    , 0.12
    , 0.15
    , 0.21
    , 0.3
    , 0.31
    , 0.35
    , 0.5
    , 0.55
    , 0.55
    , 0.56
    , 0.61
    , 0.62
    , 0.63
    , 0.65
    , 0.75
    , 0.81
    , 0.9
    , 0.91
    , 0.99
    ]


accessor : Bar.Accessor Data
accessor =
    identity


width : Float
width =
    500


height : Float
height =
    500


margin =
    { top = 10, left = 20, bottom = 20, right = 10 }


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


verticalGrouped : Html msg
verticalGrouped =
    Bar.init
        |> Bar.setDimensions { margin = margin, width = width, height = height }
        |> Bar.setDomain ( 0, 1 )
        |> Bar.setSteps [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 ]
        |> Bar.render ( data, accessor )


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div attrs [ verticalGrouped ]
            ]
        ]

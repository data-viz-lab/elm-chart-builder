module HistogramBarChart exposing (data, main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.HistogramBar as Histo
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


preProcessedData =
    [ { bucket = 0.8
      , count = 10
      }
    , { bucket = 0.7
      , count = 0
      }
    , { bucket = 0.9
      , count = 0
      }
    , { bucket = 0.0
      , count = 5
      }
    , { bucket = 0.2
      , count = 0
      }
    , { bucket = 1.0
      , count = 7
      }
    , { bucket = 0.1
      , count = 0
      }
    , { bucket = 0.4
      , count = 0
      }
    , { bucket = 0.3
      , count = 0
      }
    , { bucket = 0.6
      , count = 0
      }
    , { bucket = 0.5
      , count = 0
      }
    ]
        |> List.sortBy .bucket


type alias Data =
    Float


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


accessor : data -> data
accessor =
    identity


histoConfig =
    Histo.initHistogramConfig
        |> Histo.setSteps [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 ]


dataAccessor =
    Histo.dataAccessor histoConfig accessor


histo : Html msg
histo =
    Histo.init
        |> Histo.setDimensions { margin = margin, width = width, height = height }
        |> Histo.setDomain ( 0, 1 )
        |> Histo.render ( data, dataAccessor )


preProcessedDataAccessor =
    Histo.preProcessedDataAccessor
        (\d ->
            { x0 = d.bucket
            , x1 = d.bucket + 0.1
            , values = []
            , length = d.count
            }
        )


preProcessedHisto : Html msg
preProcessedHisto =
    Histo.init
        |> Histo.setDimensions { margin = margin, width = width, height = height }
        |> Histo.render ( preProcessedData, preProcessedDataAccessor )


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div attrs [ histo ]
            , Html.div attrs [ preProcessedHisto ]
            ]
        ]

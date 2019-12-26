module Examples.LineChart exposing (data, main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.Line as Line
import Chart.Type exposing (..)
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes
import Svg exposing (..)
import Svg.Attributes exposing (..)


css : String
css =
    """
.wrapper {
  display: grid;
  grid-template-columns: 350px 350px;
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

.axis text {
    fill: #333;
}

path {
    stroke: red;
    stroke-width: 2px;
    fill: none;
}
"""


width : Float
width =
    350


height : Float
height =
    250


data : Data
data =
    DataLinear
        [ { groupLabel = Just "A"
          , points =
                [ ( 1, 10 )
                , ( 2, 13 )
                , ( 16, 16 )
                ]
          }
        , { groupLabel = Just "B"
          , points =
                [ ( 1, 11 )
                , ( 2, 23 )
                , ( 3, 16 )
                ]
          }
        ]


attrs =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


doubleLine : Html msg
doubleLine =
    Line.init data
        |> Line.setTitle "A two line chart"
        |> Line.setDesc "A two line chart example to demonstrate the charting library"
        |> Line.setDomain (DomainLinear { horizontal = ( 1, 16 ), vertical = ( 10, 23 ) })
        |> Line.setDimensions
            { margin = { top = 10, right = 10, bottom = 10, left = 10 }
            , width = width
            , height = height
            }
        --|> Line.setContinousDataTickFormat (CustomTickFormat (\v -> abs v |> valueFormatter))
        |> Line.render


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ text css ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div attrs [ doubleLine ]
            ]
        ]

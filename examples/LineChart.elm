module LineChart exposing (data, main)

{-| This module shows how to build a simple line chart.
-}

import Chart.Line as Line
import Html exposing (Html)
import Html.Attributes exposing (class)


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

.line {
    stroke-width: 2px;
    fill: none;
}

.line-0 {
    stroke: crimson;
}

.line-1 {
    stroke: #3949ab;
}
"""


width : Float
width =
    350


height : Float
height =
    250


data : List Line.DataGroupLinear
data =
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


attrs : List (Html.Attribute msg)
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
        |> Line.setDomain (Line.domainLinear { horizontal = ( 1, 16 ), vertical = ( 10, 23 ) })
        |> Line.setAxisVerticalTickCount 5
        |> Line.setDimensions
            { margin = { top = 10, right = 10, bottom = 30, left = 30 }
            , width = width
            , height = height
            }
        |> Line.render


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div attrs [ doubleLine ]
            ]
        ]

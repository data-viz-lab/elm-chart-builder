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


type alias Data =
    { x : Float, y : Float, groupLabel : String }


data : List Data
data =
    [ { groupLabel = "A"
      , x = 1
      , y = 10
      }
    , { groupLabel = "A"
      , x = 2
      , y = 13
      }
    , { groupLabel = "A"
      , x = 5
      , y = 16
      }
    , { groupLabel = "B"
      , x = 1
      , y = 11
      }
    , { groupLabel = "B"
      , x = 2
      , y = 23
      }
    , { groupLabel = "B"
      , x = 3
      , y = 16
      }
    ]


accessor : Line.Accessor Data
accessor =
    Line.Accessor .groupLabel .x .y


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


doubleLine : Html msg
doubleLine =
    Line.init
        |> Line.setTitle "A two line chart"
        |> Line.setDesc "A two line chart example to demonstrate the charting library"
        |> Line.setAxisVerticalTickCount 5
        |> Line.setDimensions
            { margin = { top = 10, right = 10, bottom = 30, left = 30 }
            , width = width
            , height = height
            }
        |> Line.render ( data, accessor )


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div attrs [ doubleLine ]
            ]
        ]

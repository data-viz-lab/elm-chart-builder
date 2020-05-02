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
  grid-template-columns: repeat(4, 250px);
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
    { x : String, y : Float, groupLabel : String }


data : List Data
data =
    [ { groupLabel = "A"
      , x = "a"
      , y = 10
      }
    , { groupLabel = "A"
      , x = "b"
      , y = 13
      }
    , { groupLabel = "A"
      , x = "c"
      , y = 16
      }
    , { groupLabel = "B"
      , x = "a"
      , y = 11
      }
    , { groupLabel = "B"
      , x = "b"
      , y = 23
      }
    , { groupLabel = "B"
      , x = "c"
      , y = 16
      }
    , { groupLabel = "B"
      , x = "c"
      , y = 16
      }
    , { groupLabel = "B"
      , x = "c"
      , y = 16
      }
    ]


accessor : Bar.Accessor Data
accessor =
    .y


width : Float
width =
    250


height : Float
height =
    250


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


verticalGrouped : Html msg
verticalGrouped =
    Bar.init
        |> Bar.setHeight height
        |> Bar.setWidth width
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

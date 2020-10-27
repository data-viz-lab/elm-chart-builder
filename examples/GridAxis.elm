module GridAxis exposing (main)

{-| This module shows how to build a simple line chart with a horizontal grid axis
-}

import Axis
import Chart.Line as Line
import Chart.Symbol as Symbol exposing (Symbol)
import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Scale.Color
import Set
import Time exposing (Posix)


css : String
css =
    """
.axis path,
.axis line {
  stroke: #b7b7b7;
}

.axis text {
  fill: #333;
}

.axis--x .domain ,
.axis--y .domain {
  stroke: none;
}

.axis--y-right .tick {
  stroke-dasharray : 6 6;
  stroke-width: 0.5px;
}

.axis--y-left text {
  font-size: 16px;
}

figure {
  margin: 0;
}
"""


type alias TimeData =
    { x : Posix, y : Float, groupLabel : String }


timeAccessor : Line.Accessor TimeData
timeAccessor =
    Line.time (Line.AccessorTime (.groupLabel >> Just) .x .y)


timeData : List TimeData
timeData =
    [ { groupLabel = "A"
      , x = Time.millisToPosix 1579275175634
      , y = 10
      }
    , { groupLabel = "A"
      , x = Time.millisToPosix 1579285175634
      , y = 16
      }
    , { groupLabel = "A"
      , x = Time.millisToPosix 1579295175634
      , y = 26
      }
    , { groupLabel = "B"
      , x = Time.millisToPosix 1579275175634
      , y = 13
      }
    , { groupLabel = "B"
      , x = Time.millisToPosix 1579285175634
      , y = 23
      }
    , { groupLabel = "B"
      , x = Time.millisToPosix 1579295175634
      , y = 16
      }
    ]


width : Float
width =
    800


height : Float
height =
    400


requiredConfig : Line.RequiredConfig
requiredConfig =
    { margin = { top = 20, right = 40, bottom = 30, left = 50 }
    , width = width
    , height = height
    }


yAxis : Line.YAxis Float
yAxis =
    Line.axisGrid
        [ Axis.tickCount 5
        , Axis.tickSizeOuter 0
        , Axis.tickPadding 15
        ]


xAxis : Line.XAxis Posix
xAxis =
    Line.axisBottom
        [ Axis.tickCount 5
        ]


line =
    Line.init requiredConfig
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withYAxis yAxis
        |> Line.withXAxisTime xAxis
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.withLabels Line.xGroupLabel
        |> Line.withGroupedLayout
        |> Line.render ( timeData, timeAccessor )


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat (height + 20) ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , Html.Attributes.style "border" "1px solid #c4c4c4"
    ]


main : Html msg
main =
    Html.div [ style "font-family" "Sans-Serif", style "margin" "20px" ]
        [ Html.node "style" [] [ Html.text css ]
        , Html.div []
            [ Html.div attrs [ line ]
            ]
        ]

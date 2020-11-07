module FertilityRate exposing (main)

{-| This module shows the decline of fertility rate as a line chart with a yAxisGrid.
-}

import Axis
import Chart.Line as Line
import Chart.Symbol as Symbol exposing (Symbol)
import Data exposing (FertilityStats, fertilityStats)
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
  stroke-dasharray: 6 6;
  stroke-width: 0.5px;
}

.axis--y-left text {
  font-size: 16px;
}

.series text {
  font-size: 12px;
}

figure {
  margin: 0;
}
"""


symbol : Symbol
symbol =
    Symbol.circle
        |> Symbol.withSize 5


dataAccessor : Line.Accessor FertilityStats
dataAccessor =
    Line.continuous (Line.AccessorContinuous (.country >> Just) .year .liveBirtshPerWoman)


width : Float
width =
    1000


height : Float
height =
    500


requiredConfig : Line.RequiredConfig
requiredConfig =
    { margin = { top = 20, right = 80, bottom = 30, left = 50 }
    , width = width
    , height = height
    }


yAxis : Line.YAxis Float
yAxis =
    Line.axisGrid
        [ Axis.tickCount 10
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
        |> Line.withSymbols [ symbol ]
        |> Line.render ( fertilityStats, dataAccessor )


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat (height + 20) ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , Html.Attributes.style "border" "1px solid #c4c4c4"
    ]


footer : Html msg
footer =
    Html.footer [ style "font-size" "12px", style "margin" "20px 0" ]
        [ Html.a
            [ Html.Attributes.href
                "https://ourworldindata.org/fertility-rate"
            ]
            [ Html.text "Data source" ]
        ]


main : Html msg
main =
    Html.div [ style "font-family" "Sans-Serif", style "margin" "20px" ]
        [ Html.node "style" [] [ Html.text css ]
        , Html.div []
            [ Html.h2 [] [ Html.text "Children per woman" ]
            , Html.div attrs [ line ]
            , footer
            ]
        ]
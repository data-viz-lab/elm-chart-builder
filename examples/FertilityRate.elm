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
.ecb-component text {
  font-size: 12px;
}

.ecb-axis path,
.ecb-axis line {
  stroke: #b7b7b7;
}

.ecb-axis text {
  fill: #333;
}

.ecb-axis-x .domain ,
.ecb-axis-y .domain {
  stroke: none;
}

.ecb-axis-y-right .tick {
  stroke-dasharray: 6 6;
  stroke-width: 0.5px;
}

.ecb-axis-x text {
  font-size: 10px;
}

.ecb-axis-y-left text {
  font-size: 16px;
}

figure {
  margin: 0;
}
"""


symbol : Symbol
symbol =
    Symbol.circle
        |> Symbol.withSize 3


dataAccessor : Line.Accessor FertilityStats
dataAccessor =
    Line.continuous (Line.AccessorContinuous (.country >> Just) .year .liveBirtshPerWoman)


width : Float
width =
    800


height : Float
height =
    400


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


data : List FertilityStats
data =
    fertilityStats
        |> List.filter (\d -> d.country /= "Chile")


line =
    Line.init requiredConfig
        |> Line.withLeftPadding 10
        |> Line.withBottomPadding 20
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withYAxis yAxis
        |> Line.withXAxisTime xAxis
        |> Line.withLineStyle [ ( "stroke-width", "1" ) ]
        |> Line.withLabels Line.xGroupLabel
        |> Line.withGroupedLayout
        |> Line.withSymbols [ symbol ]
        |> Line.render ( data, dataAccessor )


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

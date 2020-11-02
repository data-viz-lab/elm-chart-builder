module CoronavirusDeaths exposing (main)

{-| This module shows how to build a simple line chart with a time scale.
-}

import Axis
import Chart.Bar as Bar
import Chart.Line as Line
import Chart.Symbol as Symbol exposing (Symbol)
import Color
import Data exposing (CoronaData, coronaStats)
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Iso8601
import Numeral
import Scale.Color
import Time exposing (Posix)


css : String
css =
    """
.axis path,
.axis line {
  stroke: #b7b7b7;
}

text {
  fill: #333;
  font-size: 16px;
}

.column text {
  font-size: 12px;
}

figure {
  margin: 0;
}
"""


accessor : Line.Accessor CoronaData
accessor =
    Line.time
        { xGroup = always Nothing
        , xValue = \( date, _, _ ) -> Iso8601.toTime date |> Result.withDefault (Time.millisToPosix 0)
        , yValue = \( _, _, deaths ) -> deaths
        }


valueFormatter : Float -> String
valueFormatter =
    FormatNumber.format { usLocale | decimals = 0 }


width : Float
width =
    1200


height : Float
height =
    600


yAxis : Bar.YAxis Float
yAxis =
    Line.axisLeft
        [ Axis.tickCount 5
        , Axis.tickFormat valueFormatter
        ]


xAxis : Bar.XAxis Posix
xAxis =
    Line.axisBottom
        [ Axis.tickSizeOuter 0
        ]


chart : Html msg
chart =
    Line.init
        { margin = { top = 20, right = 10, bottom = 25, left = 80 }
        , width = width
        , height = height
        }
        |> Line.withColorPalette [ Color.rgb255 209 33 2 ]
        |> Line.withXAxisTime xAxis
        |> Line.withYAxis yAxis
        |> Line.withLineStyle [ ( "stroke-width", "1.5" ) ]
        |> Line.render ( coronaStats, accessor )


attrs : List (Html.Attribute msg)
attrs =
    [ style "height" (String.fromFloat (height + 20) ++ "px")
    , style "width" (String.fromFloat width ++ "px")
    , style "border" "1px solid #c4c4c4"
    ]


footer : Html msg
footer =
    Html.footer
        [ style "margin" "25px"
        ]
        [ Html.a
            [ Html.Attributes.href
                "https://ourworldindata.org/coronavirus"
            ]
            [ Html.text "Data source" ]
        ]


main : Html msg
main =
    Html.div [ style "font-family" "Sans-Serif" ]
        [ Html.node "style" [] [ Html.text css ]
        , Html.h2
            [ style "margin" "25px"
            ]
            [ Html.text
                "Coronavirus, daily number of confirmed deaths"
            ]
        , Html.div
            [ style "background-color" "#fff"
            , style "color" "#444"
            , style "margin" "25px"
            ]
            [ Html.div attrs [ chart ]
            ]
        , footer
        ]

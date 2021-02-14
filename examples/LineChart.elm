module LineChart exposing (main)

{-| This module shows how to build a simple line chart.
-}

import Axis
import Chart.Line as Line
import Chart.Symbol as Symbol exposing (Symbol)
import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Scale.Color
import Set
import Shape
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

figure {
  margin: 0;
}
"""


icons : String -> List Symbol
icons prefix =
    [ Symbol.triangle
        |> Symbol.withIdentifier (prefix ++ "-triangle-symbol")
        |> Symbol.withStyle [ ( "stroke", "white" ) ]
    , Symbol.circle
        |> Symbol.withIdentifier (prefix ++ "-circle-symbol")
        |> Symbol.withStyle [ ( "stroke", "white" ) ]
    , Symbol.corner
        |> Symbol.withIdentifier (prefix ++ "-corner-symbol")
        |> Symbol.withStyle [ ( "stroke", "white" ) ]
    ]


xAxisTicks : List Float
xAxisTicks =
    dataContinuous
        |> List.map .x
        |> Set.fromList
        |> Set.toList
        |> List.sort


requiredConfig : Line.RequiredConfig
requiredConfig =
    { margin = { top = 10, right = 40, bottom = 30, left = 30 }
    , width = width
    , height = height
    }


sharedAttributes : List (Axis.Attribute value)
sharedAttributes =
    [ Axis.tickSizeOuter 0
    , Axis.tickSizeInner 3
    ]


yAxis : Line.YAxis Float
yAxis =
    Line.axisLeft (Axis.tickCount 5 :: sharedAttributes)


xAxis : Line.XAxis Float
xAxis =
    Line.axisBottom
        ([ Axis.ticks xAxisTicks
         , Axis.tickFormat (round >> String.fromInt)
         ]
            ++ sharedAttributes
        )


xAxisTime : Line.XAxis Posix
xAxisTime =
    Line.axisBottom (Axis.tickCount 5 :: sharedAttributes)


sharedStackedLineConfig : Line.Config
sharedStackedLineConfig =
    Line.init requiredConfig
        |> Line.withYAxis yAxis
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.withLabels Line.xGroupLabel
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withStackedLayout Line.drawLine
        |> Line.withSymbols (icons "chart-b")


sharedGroupedLineConfig : Line.Config
sharedGroupedLineConfig =
    Line.init requiredConfig
        |> Line.withYAxis yAxis
        |> Line.withXAxisContinuous xAxis
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.withLabels Line.xGroupLabel
        |> Line.withSymbols (icons "chart-b")


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


type alias DataContinuous =
    { x : Float, y : Float }


accessorContinuous : Line.Accessor DataContinuous
accessorContinuous =
    Line.continuous (Line.AccessorContinuous (always Nothing) .x .y)


dataContinuous : List DataContinuous
dataContinuous =
    [ { x = 1613505600000, y = 97.6826515643056 }, { x = 1613502000000, y = 76.22102437707814 }, { x = 1613498400000, y = 50.18293373733884 }, { x = 1613494800000, y = 69.33929980499407 }, { x = 1613491200000, y = 66.37772354938471 }, { x = 1613487600000, y = 8.05060273867111 }, { x = 1613484000000, y = 72.78164198103998 }, { x = 1613480400000, y = 18.625941283208846 }, { x = 1613476800000, y = 19.41753926472156 }, { x = 1613473200000, y = 17.694144599068796 } ]


groupedTimeLine : Html msg
groupedTimeLine =
    sharedGroupedLineConfig
        |> Line.withXAxisTime xAxisTime
        |> Line.render ( timeData, timeAccessor )


groupedLine : Html msg
groupedLine =
    sharedGroupedLineConfig
        |> Line.withXAxisContinuous xAxis
        |> Line.render ( dataContinuous, accessorContinuous )


stackedTimeLine : Html msg
stackedTimeLine =
    sharedStackedLineConfig
        |> Line.withXAxisTime xAxisTime
        |> Line.render ( timeData, timeAccessor )


stackedLine : Html msg
stackedLine =
    sharedStackedLineConfig
        |> Line.withXAxisContinuous xAxis
        |> Line.render ( dataContinuous, accessorContinuous )


stackedTimeArea : Html msg
stackedTimeArea =
    sharedStackedLineConfig
        |> Line.withXAxisTime xAxisTime
        |> Line.withStackedLayout (Line.drawArea Shape.stackOffsetNone)
        |> Line.render ( timeData, timeAccessor )


stackedArea : Html msg
stackedArea =
    sharedStackedLineConfig
        |> Line.withXAxisContinuous xAxis
        |> Line.withStackedLayout (Line.drawArea Shape.stackOffsetNone)
        |> Line.render ( dataContinuous, accessorContinuous )


width : Float
width =
    400


height : Float
height =
    250


chartTitle : String -> Html msg
chartTitle label =
    Html.div [] [ Html.h5 [ style "margin" "2px" ] [ Html.text label ] ]


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat (height + 20) ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , Html.Attributes.style "border" "1px solid #c4c4c4"
    ]


main : Html msg
main =
    Html.div [ style "font-family" "Sans-Serif" ]
        [ Html.node "style" [] [ Html.text css ]
        , Html.div
            [ style "display" "grid"
            , style "grid-template-columns" "repeat(2, 400px)"
            , style "grid-gap" "20px"
            , style "background-color" "#fff"
            , style "color" "#444"
            , style "margin" "25px"
            ]
            [ Html.div attrs [ chartTitle "grouped", groupedLine ]
            , Html.div attrs [ chartTitle "grouped time", groupedTimeLine ]
            , Html.div attrs [ chartTitle "stacked", stackedLine ]
            , Html.div attrs [ chartTitle "stacked time", stackedTimeLine ]
            , Html.div attrs [ chartTitle "stacked area", stackedArea ]
            , Html.div attrs [ chartTitle "stacked time area", stackedTimeArea ]
            ]
        ]

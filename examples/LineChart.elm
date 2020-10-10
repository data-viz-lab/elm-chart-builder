module LineChart exposing (main)

{-| This module shows how to build a simple line chart.
-}

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

figure {
  margin: 0;
}
"""


icons : String -> List Symbol
icons prefix =
    [ Symbol.triangle
        |> Symbol.withIdentifier (prefix ++ "-triangle-symbol")
    , Symbol.circle
        |> Symbol.withIdentifier (prefix ++ "-circle-symbol")
        |> Symbol.withStyle [ ( "fill", "none" ) ]
    , Symbol.corner
        |> Symbol.withIdentifier (prefix ++ "-corner-symbol")
    ]


sharedStackedLineConfig =
    Line.init
        { margin = { top = 10, right = 40, bottom = 30, left = 30 }
        , width = width
        , height = height
        }
        |> Line.withYAxisTickCount 5
        |> Line.withXAxisTickCount 5
        |> Line.withAxisTickSizeOuter 0
        |> Line.withAxisTickSizeInner 3
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.withGroupLabels
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withStackedLayout
        |> Line.withSymbols (icons "chart-b")


sharedGroupedLineConfig =
    Line.init
        { margin = { top = 10, right = 40, bottom = 30, left = 30 }
        , width = width
        , height = height
        }
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withYAxisTickCount 5
        |> Line.withXAxisTickCount 5
        |> Line.withAxisTickSizeOuter 0
        |> Line.withAxisTickSizeInner 3
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.withGroupLabels
        |> Line.withGroupedLayout
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


type alias DataLinear =
    { x : Float, y : Float, groupLabel : String }


accessorLinear : Line.Accessor DataLinear
accessorLinear =
    Line.linear (Line.AccessorLinear (.groupLabel >> Just) .x .y)


dataLinear : List DataLinear
dataLinear =
    [ { groupLabel = "A"
      , x = 1991
      , y = 10
      }
    , { groupLabel = "A"
      , x = 1992
      , y = 16
      }
    , { groupLabel = "A"
      , x = 1993
      , y = 26
      }
    , { groupLabel = "B"
      , x = 1991
      , y = 13
      }
    , { groupLabel = "B"
      , x = 1992
      , y = 23
      }
    , { groupLabel = "B"
      , x = 1993
      , y = 16
      }
    ]


xAxisTicks : List Float
xAxisTicks =
    dataLinear
        |> List.map .x
        |> Set.fromList
        |> Set.toList
        |> List.sort


groupedTimeLine : Html msg
groupedTimeLine =
    sharedGroupedLineConfig
        |> Line.render ( timeData, timeAccessor )


groupedLine : Html msg
groupedLine =
    sharedGroupedLineConfig
        |> Line.withXAxisTicks xAxisTicks
        |> Line.withXAxisTickFormat (round >> String.fromInt)
        |> Line.render ( dataLinear, accessorLinear )


stackedTimeLine : Html msg
stackedTimeLine =
    sharedStackedLineConfig
        |> Line.render ( timeData, timeAccessor )


stackedLine : Html msg
stackedLine =
    sharedStackedLineConfig
        |> Line.withXAxisTicks xAxisTicks
        |> Line.withXAxisTickFormat (round >> String.fromInt)
        |> Line.render ( dataLinear, accessorLinear )


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
            ]
        ]

module LineChart exposing (data, main)

{-| This module shows how to build a simple line chart.
-}

import Chart.Line as Line
import Chart.Symbol as Symbol exposing (Symbol)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Scale.Color
import Set
import Time exposing (Posix)


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


width : Float
width =
    350


height : Float
height =
    250


type alias Data =
    { x : Posix, y : Float, groupLabel : String }


data : List Data
data =
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


accessor : Line.Accessor Data
accessor =
    Line.time (Line.AccessorTime (.groupLabel >> Just) .x .y)


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


doubleLine : Html msg
doubleLine =
    Line.init
        { margin = { top = 10, right = 20, bottom = 30, left = 30 }
        , width = width
        , height = height
        }
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withYAxisTickCount 5
        |> Line.withXAxisTickCount 5
        |> Line.withGroupedLayout
        |> Line.withSymbols (icons "chart-b")
        |> Line.render ( data, accessor )



-- Linear example


type alias DataLinear =
    { x : Float, y : Float, groupLabel : String }


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


accessorLinear : Line.Accessor DataLinear
accessorLinear =
    Line.linear (Line.AccessorLinear (.groupLabel >> Just) .x .y)


doubleLineStacked =
    Line.init
        { margin = { top = 10, right = 20, bottom = 30, left = 30 }
        , width = width
        , height = height
        }
        |> Line.withYAxisTickCount 5
        |> Line.withXAxisTickCount 5
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withStackedLayout
        |> Line.withSymbols (icons "chart-b")


doubleLineStackedLinear : Html msg
doubleLineStackedLinear =
    doubleLineStacked
        |> Line.withXAxisTicks xAxisTicks
        |> Line.withXAxisTickFormat (round >> String.fromInt)
        |> Line.render ( dataLinear, accessorLinear )


doubleLineStackedTime : Html msg
doubleLineStackedTime =
    doubleLineStacked
        |> Line.render ( data, accessor )


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div [ class "wrapper" ]
            [ Html.h3 [] [ Html.text "time" ], Html.div attrs [ doubleLine ] ]
        , Html.div [ class "wrapper" ]
            [ Html.h3 [] [ Html.text "Stacked time" ], Html.div attrs [ doubleLineStackedTime ] ]
        , Html.div [ class "wrapper" ]
            [ Html.h3 [] [ Html.text "Stacked linear" ], Html.div attrs [ doubleLineStackedLinear ] ]
        ]

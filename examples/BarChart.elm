module BarChart exposing (data, main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.Bar as Bar
import Chart.Symbol as Symbol exposing (Symbol)
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Numeral
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

h5 {
  margin: 2px;
}

.column text {
  font-size: 12px;
}

figure {
    margin: 0;
}
"""


iconsCustom : String -> List Symbol
iconsCustom prefix =
    [ Symbol.custom { viewBoxDimensions = ( 640, 512 ), paths = [ bicycleSymbol ] }
        |> Symbol.withIdentifier (prefix ++ "-bicycle-symbol")
    , Symbol.custom { viewBoxDimensions = ( 640, 512 ), paths = [ carSymbol ] }
        |> Symbol.withIdentifier (prefix ++ "-car-symbol")
    , Symbol.custom { viewBoxDimensions = ( 576, 512 ), paths = [ planeSymbol ] }
        |> Symbol.withIdentifier (prefix ++ "-plane-symbol")
    ]


icons : String -> List Symbol
icons prefix =
    [ Symbol.triangle
        |> Symbol.withIdentifier (prefix ++ "-triangle-symbol")
        |> Symbol.withStyle [ ( "fill", "none" ) ]
    , Symbol.circle
        |> Symbol.withIdentifier (prefix ++ "-circle-symbol")
        |> Symbol.withStyle [ ( "fill", "none" ) ]
    , Symbol.corner
        |> Symbol.withIdentifier (prefix ++ "-corner-symbol")
    ]


type alias Data =
    { x : String, y : Float, groupLabel : String }


data : List Data
data =
    [ { groupLabel = "A"
      , x = "a"
      , y = 1000
      }
    , { groupLabel = "A"
      , x = "b"
      , y = 1300
      }
    , { groupLabel = "A"
      , x = "c"
      , y = 1600
      }
    , { groupLabel = "B"
      , x = "a"
      , y = 1100
      }
    , { groupLabel = "B"
      , x = "b"
      , y = 2300
      }
    , { groupLabel = "B"
      , x = "c"
      , y = 1600
      }
    ]


dataStacked : List Data
dataStacked =
    [ { groupLabel = "A"
      , x = "a"
      , y = 10
      }
    , { groupLabel = "A"
      , x = "b"
      , y = 13
      }
    , { groupLabel = "B"
      , x = "a"
      , y = 11
      }
    , { groupLabel = "B"
      , x = "b"
      , y = 23
      }
    ]


dataStackedDiverging : List Data
dataStackedDiverging =
    [ { groupLabel = "A"
      , x = "a"
      , y = -10
      }
    , { groupLabel = "A"
      , x = "b"
      , y = 13
      }
    , { groupLabel = "B"
      , x = "a"
      , y = -11
      }
    , { groupLabel = "B"
      , x = "b"
      , y = 23
      }
    ]


accessor : Bar.Accessor Data
accessor =
    Bar.Accessor (.groupLabel >> Just) .x .y


width : Float
width =
    250


height : Float
height =
    250


bicycleSymbol : String
bicycleSymbol =
    "M512.509 192.001c-16.373-.064-32.03 2.955-46.436 8.495l-77.68-125.153A24 24 0 0 0 368.001 64h-64c-8.837 0-16 7.163-16 16v16c0 8.837 7.163 16 16 16h50.649l14.896 24H256.002v-16c0-8.837-7.163-16-16-16h-87.459c-13.441 0-24.777 10.999-24.536 24.437.232 13.044 10.876 23.563 23.995 23.563h48.726l-29.417 47.52c-13.433-4.83-27.904-7.483-42.992-7.52C58.094 191.83.412 249.012.002 319.236-.413 390.279 57.055 448 128.002 448c59.642 0 109.758-40.793 123.967-96h52.033a24 24 0 0 0 20.406-11.367L410.37 201.77l14.938 24.067c-25.455 23.448-41.385 57.081-41.307 94.437.145 68.833 57.899 127.051 126.729 127.719 70.606.685 128.181-55.803 129.255-125.996 1.086-70.941-56.526-129.72-127.476-129.996zM186.75 265.772c9.727 10.529 16.673 23.661 19.642 38.228h-43.306l23.664-38.228zM128.002 400c-44.112 0-80-35.888-80-80s35.888-80 80-80c5.869 0 11.586.653 17.099 1.859l-45.505 73.509C89.715 331.327 101.213 352 120.002 352h81.3c-12.37 28.225-40.562 48-73.3 48zm162.63-96h-35.624c-3.96-31.756-19.556-59.894-42.383-80.026L237.371 184h127.547l-74.286 120zm217.057 95.886c-41.036-2.165-74.049-35.692-75.627-76.755-.812-21.121 6.633-40.518 19.335-55.263l44.433 71.586c4.66 7.508 14.524 9.816 22.032 5.156l13.594-8.437c7.508-4.66 9.817-14.524 5.156-22.032l-44.468-71.643a79.901 79.901 0 0 1 19.858-2.497c44.112 0 80 35.888 80 80-.001 45.54-38.252 82.316-84.313 79.885z"


carSymbol : String
carSymbol =
    "M544 192h-16L419.22 56.02A64.025 64.025 0 0 0 369.24 32H155.33c-26.17 0-49.7 15.93-59.42 40.23L48 194.26C20.44 201.4 0 226.21 0 256v112c0 8.84 7.16 16 16 16h48c0 53.02 42.98 96 96 96s96-42.98 96-96h128c0 53.02 42.98 96 96 96s96-42.98 96-96h48c8.84 0 16-7.16 16-16v-80c0-53.02-42.98-96-96-96zM160 432c-26.47 0-48-21.53-48-48s21.53-48 48-48 48 21.53 48 48-21.53 48-48 48zm72-240H116.93l38.4-96H232v96zm48 0V96h89.24l76.8 96H280zm200 240c-26.47 0-48-21.53-48-48s21.53-48 48-48 48 21.53 48 48-21.53 48-48 48z"


planeSymbol : String
planeSymbol =
    "M480 192H365.71L260.61 8.06A16.014 16.014 0 0 0 246.71 0h-65.5c-10.63 0-18.3 10.17-15.38 20.39L214.86 192H112l-43.2-57.6c-3.02-4.03-7.77-6.4-12.8-6.4H16.01C5.6 128-2.04 137.78.49 147.88L32 256 .49 364.12C-2.04 374.22 5.6 384 16.01 384H56c5.04 0 9.78-2.37 12.8-6.4L112 320h102.86l-49.03 171.6c-2.92 10.22 4.75 20.4 15.38 20.4h65.5c5.74 0 11.04-3.08 13.89-8.06L365.71 320H480c35.35 0 96-28.65 96-64s-60.65-64-96-64z"


valueFormatter : Float -> String
valueFormatter =
    FormatNumber.format { usLocale | decimals = 0 }


yLabelFormatter : Float -> String
yLabelFormatter =
    Numeral.format "0.0a"


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat (height + 20) ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


verticalGrouped : Html msg
verticalGrouped =
    Bar.init
        { margin = { top = 10, right = 10, bottom = 25, left = 40 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withTable
        |> Bar.withGroupedLayout
        |> Bar.withSymbols (iconsCustom "chart-a")
        |> Bar.withYAxisTickCount 5
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.render ( data, accessor )


verticalGroupedWithLabels : Html msg
verticalGroupedWithLabels =
    Bar.init
        { margin = { top = 20, right = 10, bottom = 25, left = 40 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withGroupedLayout
        |> Bar.withYLabels yLabelFormatter
        |> Bar.withYAxisTickCount 5
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.render ( data, accessor )


verticalStacked : Html msg
verticalStacked =
    Bar.init
        { margin = { top = 20, right = 10, bottom = 25, left = 40 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withStackedLayout Bar.noDirection
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.withSymbols (icons "chart-b")
        |> Bar.render ( data, accessor )


horizontalGrouped : Html msg
horizontalGrouped =
    Bar.init
        { margin = { top = 10, right = 10, bottom = 32, left = 40 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withGroupedLayout
        |> Bar.withSymbols (icons "chart-b")
        |> Bar.withOrientation Bar.horizontal
        |> Bar.withYAxisTickCount 5
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.render ( data, accessor )


horizontalGroupedWithLabels : Html msg
horizontalGroupedWithLabels =
    Bar.init
        { margin = { top = 10, right = 20, bottom = 32, left = 40 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withGroupedLayout
        |> Bar.withOrientation Bar.horizontal
        |> Bar.withXLabels
        |> Bar.withYAxisTickCount 5
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.render ( data, accessor )


horizontalStacked : Html msg
horizontalStacked =
    Bar.init
        { margin = { top = 20, right = 20, bottom = 30, left = 30 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withStackedLayout Bar.noDirection
        |> Bar.withOrientation Bar.horizontal
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.withYAxisTickCount 5
        |> Bar.render ( data, accessor )


horizontalStackedDiverging : Html msg
horizontalStackedDiverging =
    Bar.init
        { margin = { top = 20, right = 20, bottom = 30, left = 30 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withStackedLayout Bar.diverging
        |> Bar.withOrientation Bar.horizontal
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.withYAxisTickCount 5
        |> Bar.render ( dataStackedDiverging, accessor )


verticalStackedDiverging : Html msg
verticalStackedDiverging =
    Bar.init
        { margin = { top = 20, right = 10, bottom = 30, left = 40 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withStackedLayout Bar.diverging
        |> Bar.withOrientation Bar.vertical
        |> Bar.withYAxisTickFormat valueFormatter
        |> Bar.render ( dataStackedDiverging, accessor )


chartLabel : String -> Html msg
chartLabel label =
    Html.div [] [ Html.h5 [] [ Html.text label ] ]


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div attrs [ chartLabel "vertical grouped with icons", verticalGrouped ]
            , Html.div attrs [ chartLabel "vertical grouped with labels", verticalGroupedWithLabels ]
            , Html.div attrs [ chartLabel "horizontal grouped with icons", horizontalGrouped ]
            , Html.div attrs [ chartLabel "horizontal grouped with labels", horizontalGroupedWithLabels ]
            , Html.div attrs [ chartLabel "vertical stacked", verticalStacked ]
            , Html.div attrs [ chartLabel "horizontal stacked", horizontalStacked ]
            , Html.div attrs [ chartLabel "horizontal stacked diverging", horizontalStackedDiverging ]
            , Html.div attrs [ chartLabel "vertical stacked diverging", verticalStackedDiverging ]
            ]
        ]

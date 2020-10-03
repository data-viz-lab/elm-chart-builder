module ElmVisualization.BarChart exposing (main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.Bar as Bar
import DateFormat
import Html exposing (Html)
import Html.Attributes exposing (class)
import Time


css : String
css =
    """
body {
  font-family: Sans-Serif;
}

.chart-wrapper {
    margin: 20px;
    border: 1px solid #c4c4c4;
}

.column rect {
    fill: #91DE71;
}

.axis path,
.axis line {
    stroke: #b7b7b7;
}

text {
    fill: #333;
}

figure {
    margin: 0;
}
"""


timeSeries : List ( String, Float )
timeSeries =
    [ ( Time.millisToPosix 1448928000000, 2.5 )
    , ( Time.millisToPosix 1451606400000, 2 )
    , ( Time.millisToPosix 1452211200000, 3.5 )
    , ( Time.millisToPosix 1452816000000, 2 )
    , ( Time.millisToPosix 1453420800000, 3 )
    , ( Time.millisToPosix 1454284800000, 1 )
    , ( Time.millisToPosix 1456790400000, 1.2 )
    ]
        |> List.map (\t -> ( dateFormat (Tuple.first t), Tuple.second t ))


dateFormat : Time.Posix -> String
dateFormat =
    DateFormat.format [ DateFormat.dayOfMonthFixed, DateFormat.text " ", DateFormat.monthNameAbbreviated ] Time.utc


accessor : Bar.Accessor ( String, Float )
accessor =
    Bar.Accessor (always Nothing) Tuple.first Tuple.second


chart : Html msg
chart =
    Bar.init
        { margin = { top = 10, right = 10, bottom = 30, left = 30 }
        , width = 600
        , height = 400
        }
        |> Bar.withYDomain ( 0, 5 )
        |> Bar.withYAxisTickCount 5
        |> Bar.withYLabels String.fromFloat
        |> Bar.render ( timeSeries, accessor )


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" "400px"
    , Html.Attributes.style "width" "600px"
    , class "chart-wrapper"
    ]


footer : Html msg
footer =
    Html.footer [ class "footer" ]
        [ Html.ul []
            [ Html.li []
                [ Html.a
                    [ Html.Attributes.href
                        "https://github.com/data-viz-lab/elm-chart-builder/blob/master/examples/ElmVisualization/BarChart.elm"
                    ]
                    [ Html.text "Source Code" ]
                ]
            , Html.li []
                [ Html.a
                    [ Html.Attributes.href
                        "https://code.gampleman.eu/elm-visualization/BarChart/"
                    ]
                    [ Html.text "Original" ]
                ]
            ]
        ]


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div [ class "wrapper" ]
            [ Html.div attrs [ chart ]
            , footer
            ]
        ]

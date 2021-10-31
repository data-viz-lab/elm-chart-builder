module SimpleBarChart exposing (main)

{-| This module shows how to build a simple bar chart.

The example is taken for elm-visualization.

-}

import Axis
import Browser
import Browser.Events
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

.ecb-column rect {
    fill: #91DE71;
}

.ecb-axis path,
.ecb-axis line {
    stroke: #b7b7b7;
}

text {
    fill: #333;
}

figure {
    margin: 0;
}
"""


type alias Model =
    { hinted : Maybe ( Float, Float )
    }


type Msg
    = Hint (Maybe Bar.Hint)


update : Msg -> Model -> Model
update msg model =
    case msg of
        Hint response ->
            model


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
    DateFormat.format
        [ DateFormat.dayOfMonthFixed, DateFormat.text " ", DateFormat.monthNameAbbreviated ]
        Time.utc


accessor : Bar.Accessor ( String, Float )
accessor =
    Bar.Accessor (always Nothing) Tuple.first Tuple.second


chart : Html Msg
chart =
    Bar.init
        { margin = { top = 10, right = 50, bottom = 30, left = 50 }
        , width = 600
        , height = 400
        }
        |> Bar.withYDomain ( 0, 5 )
        |> Bar.withYAxis (Bar.axisLeft [ Axis.tickCount 5 ])
        |> Bar.withLabels (Bar.yLabel String.fromFloat)
        |> Bar.withEvent (Bar.hoverAll Hint)
        |> Bar.render ( timeSeries, accessor )


attrs : List (Html.Attribute Msg)
attrs =
    [ Html.Attributes.style "height" "400px"
    , Html.Attributes.style "width" "600px"
    , class "chart-wrapper"
    ]


footer : Html Msg
footer =
    Html.footer [ class "footer" ]
        [ Html.ul []
            [ Html.li []
                [ Html.a
                    [ Html.Attributes.href
                        "https://github.com/data-viz-lab/elm-ecb/blob/master/examples/ElmVisualization/BarChart.elm"
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


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div [ class "wrapper" ]
            [ Html.div attrs [ chart ]
            , footer
            ]
        ]



-- MAIN


main =
    Browser.sandbox
        { init =
            { hinted = Nothing
            }
        , view = view
        , update = update
        }

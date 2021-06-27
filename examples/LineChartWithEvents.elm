module LineChartWithEvents exposing (main)

{-| A line chart with events and annotations
-}

import Axis
import Browser
import Browser.Events
import Chart.Annotation as Annotation
import Chart.Line as Line
import Chart.Symbol as Symbol exposing (Symbol)
import Color
import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Process
import Scale.Color
import Task
import Time exposing (Posix)



-- STYLING


css : String
css =
    """
.chart-builder__axis path,
.chart-builder__axis line {
  stroke: #b7b7b7;
}

text {
  fill: #333;
  font-size: 16px;
}

.chart-builder__axis--y .domain {
  stroke: none;
}

.chart-builder__axis--y-right .tick {
  stroke-dasharray : 6 6;
  stroke-width: 0.5px;
}

.column text {
  font-size: 12px;
}

figure {
  margin: 0;
}

.pre-chart {
  display: flex;
  justify-content: center;
  align-items: center;
}
"""


pointAnnotationStyle : List ( String, String )
pointAnnotationStyle =
    [ ( "fill", "#fff" )
    , ( "stroke", "#000" )
    , ( "stroke-width", "2" )
    ]


vLineAnnotationStyle : List ( String, String )
vLineAnnotationStyle =
    [ ( "stroke", "#999999" )
    ]



-- MODEL


type alias Datum =
    { x : Posix, y : Float, groupLabel : String }


type alias Data =
    List Datum


type alias Model =
    { hinted : Maybe ( Float, Float )
    , pointAnnotation : Maybe Annotation.Hint
    , vLineAnnotation : Maybe Annotation.Hint
    }



-- UPDATE


type Msg
    = Hint (Maybe Line.Hint)


update : Msg -> Model -> Model
update msg model =
    case msg of
        Hint response ->
            { model
                | pointAnnotation =
                    response
                        |> Maybe.map (\hint -> ( hint, pointAnnotationStyle ))
                , vLineAnnotation =
                    response
                        |> Maybe.map (\hint -> ( hint, vLineAnnotationStyle ))
            }



-- CHART CONFIGURATION


width : Float
width =
    600


height : Float
height =
    300


symbols : List Symbol
symbols =
    [ Symbol.triangle
        |> Symbol.withIdentifier "triangle-symbol"
        |> Symbol.withStyle [ ( "stroke", "white" ) ]
    , Symbol.circle
        |> Symbol.withIdentifier "circle-symbol"
        |> Symbol.withStyle [ ( "stroke", "white" ) ]
    ]


accessor : Line.Accessor Datum
accessor =
    Line.time
        { xGroup = .groupLabel >> Just
        , xValue = .x
        , yValue = .y
        }


data : Data
data =
    [ ( 10, 9 )
    , ( 4, 9 )
    , ( 5, 7 )
    , ( 10, 11 )
    , ( 10, 9 )
    , ( 11, 8 )
    , ( 4, 9 )
    , ( 10, 9 )
    , ( 10, 9 )
    , ( 10, 7 )
    , ( 12, 9 )
    , ( 10, 7 )
    , ( 10, 14 )
    , ( 10, 3 )
    , ( 12, 6 )
    , ( 6, 9 )
    , ( 13, 5 )
    , ( 14, 8 )
    , ( 13, 7 )
    , ( 11, 19 )
    , ( 4, 7 )
    , ( 12, 6 )
    , ( 6, 7 )
    , ( 17, 5 )
    , ( 11, 9 )
    , ( 5, 7 )
    , ( 10, 11 )
    , ( 10, 9 )
    , ( 11, 8 )
    , ( 4, 9 )
    , ( 10, 9 )
    , ( 10, 9 )
    ]
        |> List.indexedMap
            (\i ( a, b ) ->
                let
                    t =
                        1579275170000 + ((i + 1) * 100000000)
                in
                [ { groupLabel = "A"
                  , x = Time.millisToPosix t
                  , y = a
                  }
                , { groupLabel = "B"
                  , x = Time.millisToPosix t
                  , y = b
                  }
                ]
            )
        |> List.concat


sharedAttributes : List (Axis.Attribute value)
sharedAttributes =
    [ Axis.tickSizeOuter 0
    , Axis.tickSizeInner 3
    ]


xAxis : Line.XAxis Posix
xAxis =
    Line.axisBottom (Axis.tickCount 5 :: sharedAttributes)


chart : Model -> Html Msg
chart model =
    Line.init
        { margin = { top = 20, right = 25, bottom = 25, left = 50 }
        , width = width
        , height = height
        }
        |> Line.withXAxisTime xAxis
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.withEvent (Line.hoverAll Hint)
        |> Line.withPointAnnotation model.pointAnnotation
        |> Line.withVLineAnnotation model.vLineAnnotation
        |> Line.withSymbols symbols
        |> Line.withStackedLayout Line.drawLine
        |> Line.render ( data, accessor )



-- VIEW


attrs : List (Html.Attribute Msg)
attrs =
    [ style "height" (String.fromFloat (height + 20) ++ "px")
    , style "width" (String.fromFloat width ++ "px")
    , style "border" "1px solid #c4c4c4"
    ]


view : Model -> Html Msg
view model =
    let
        annotation =
            model.pointAnnotation

        toHumanTime posix =
            (posix |> Time.toHour Time.utc |> String.fromInt)
                ++ ":"
                ++ (posix |> Time.toMinute Time.utc |> String.fromInt)

        time =
            annotation
                |> Maybe.map
                    (Tuple.first
                        >> .selection
                        >> .x
                        >> floor
                        >> Time.millisToPosix
                        >> toHumanTime
                    )
                |> Maybe.andThen (\t -> Just (Html.li [] [ Html.text ("Time: " ++ t) ]))
                |> Maybe.withDefault (Html.text "")

        values =
            annotation
                |> Maybe.map
                    (Tuple.first
                        >> .selection
                        >> .y
                        >> List.map
                            (\{ groupLabel, value } ->
                                (groupLabel
                                    |> Maybe.withDefault ""
                                )
                                    ++ (": " ++ String.fromFloat value)
                            )
                    )
                |> Maybe.withDefault []
    in
    Html.div [ style "font-family" "Sans-Serif" ]
        [ Html.node "style" [] [ Html.text css ]
        , Html.h2
            [ style "margin" "25px"
            , style "font-size" "20px"
            ]
            [ Html.text
                "A line chart with hints and annotations"
            ]
        , Html.div
            [ style "background-color" "#fff"
            , style "color" "#444"
            , style "margin" "25px"
            ]
            [ Html.div attrs
                [ chart model
                ]
            ]
        , Html.div
            [ style "margin" "5px"
            , style "font-size" "14px"
            ]
            [ Html.ul []
                (time
                    :: List.map
                        (\v ->
                            Html.li [] [ Html.text v ]
                        )
                        values
                )
            ]
        ]



-- MAIN


main =
    Browser.sandbox
        { init =
            { hinted = Nothing
            , pointAnnotation = Nothing
            , vLineAnnotation = Nothing
            }
        , view = view
        , update = update
        }

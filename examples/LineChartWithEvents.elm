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
import Html.Attributes exposing (checked, class, for, id, style, type_, value)
import Html.Events
import Process
import Scale.Color
import Shape
import Task
import Time exposing (Posix)



-- STYLING


css : String
css =
    """
ul {
  margin: 5px;
  padding: 5px;
  list-style-type: none;
}

.ecb-axis path,
.ecb-axis line {
  stroke: #b7b7b7;
}

text {
  fill: #333;
  font-size: 16px;
}

.ecb-axis--y .domain {
  stroke: none;
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
    , ( "stroke-width", "1.5" )
    ]


vLineAnnotationStyle : List ( String, String )
vLineAnnotationStyle =
    [ ( "stroke", "#999999" )
    ]



-- MODEL


type AnnotationMode
    = InfoBox
    | Tooltip


annotationModeToString : AnnotationMode -> String
annotationModeToString mode =
    case mode of
        InfoBox ->
            "Info Box"

        Tooltip ->
            "Tooltip"


stringToAnnotationMode : String -> AnnotationMode
stringToAnnotationMode str =
    case str of
        "Info Box" ->
            InfoBox

        "Tooltip" ->
            Tooltip

        _ ->
            InfoBox


type alias Datum =
    { x : Posix, y : Float, groupLabel : String }


type alias Data =
    List Datum


type alias Model =
    { hinted : Maybe ( Float, Float )
    , pointAnnotation : Maybe Annotation.Hint
    , vLineAnnotation : Maybe Annotation.Hint
    , annotationMode : AnnotationMode
    }



-- UPDATE


type Msg
    = Hint (Maybe Line.Hint)
    | OnAnnotationMode String


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

        OnAnnotationMode mode ->
            case stringToAnnotationMode mode of
                InfoBox ->
                    { model | annotationMode = InfoBox }

                Tooltip ->
                    { model | annotationMode = Tooltip }



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
        |> Symbol.withStyle [ ( "stroke", "white" ), ( "stroke-width", "2" ) ]
    , Symbol.circle
        |> Symbol.withIdentifier "circle-symbol"
        |> Symbol.withStyle [ ( "stroke", "white" ), ( "stroke-width", "2" ) ]
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
    , ( 5, 0 )
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


yAxis : Line.YAxis Float
yAxis =
    -- TODO: how to fix redraw tick oscillations?
    --Line.axisLeft sharedAttributes
    Line.axisLeft [ Axis.tickCount 5 ]


margin =
    { top = 20, right = 25, bottom = 25, left = 50 }


chart : Model -> Html Msg
chart model =
    Line.init
        { margin = margin
        , width = width
        , height = height
        }
        |> Line.withXAxisTime xAxis
        |> Line.withYAxis yAxis
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.withEvent (Line.hoverAll Hint)
        |> Line.withPointAnnotation model.pointAnnotation
        |> Line.withLabels Line.xGroupLabel
        |> Line.withVLineAnnotation model.vLineAnnotation
        |> Line.withSymbols symbols
        --|> Line.withCurve Shape.monotoneInXCurve
        |> Line.withStackedLayout Shape.stackOffsetNone
        |> Line.render ( data, accessor )



-- VIEW


attrs : List (Html.Attribute Msg)
attrs =
    [ style "height" (String.fromFloat (height + 20) ++ "px")
    , style "width" (String.fromFloat width ++ "px")
    ]


view : Model -> Html Msg
view model =
    Html.div [ style "font-family" "Sans-Serif" ]
        [ Html.node "style" [] [ Html.text css ]
        , Html.h2
            [ style "margin" "25px"
            , style "font-size" "20px"
            ]
            [ Html.text
                "A line chart with hints and annotations"
            ]
        , Html.div []
            [ Html.div []
                [ Html.input
                    [ type_ "radio"
                    , id "info-box"
                    , value (annotationModeToString InfoBox)
                    , checked (model.annotationMode == InfoBox)
                    , Html.Events.onInput OnAnnotationMode
                    ]
                    []
                , Html.label
                    [ for "info-box" ]
                    [ Html.text (annotationModeToString InfoBox) ]
                ]
            , Html.div []
                [ Html.input
                    [ type_ "radio"
                    , id "tooltip"
                    , value (annotationModeToString Tooltip)
                    , checked (model.annotationMode == Tooltip)
                    , Html.Events.onInput OnAnnotationMode
                    ]
                    []
                , Html.label
                    [ for "tooltip" ]
                    [ Html.text (annotationModeToString Tooltip) ]
                ]
            ]
        , Html.div
            [ style "display" "flex"
            ]
            [ Html.div
                [ style "background-color" "#fff"
                , style "color" "#444"
                , style "margin" "25px"
                , style "position" "relative"
                ]
                [ Html.div attrs
                    [ chart model
                    , tooltip model
                    ]
                ]
            , Html.div
                [ style "margin" "5px"
                , style "font-size" "14px"
                ]
                [ infoBox model ]
            ]
        ]


infoBox : Model -> Html Msg
infoBox model =
    let
        ( time, values ) =
            timeAndValues model
    in
    case model.annotationMode of
        InfoBox ->
            Html.div
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

        Tooltip ->
            Html.text ""


tooltip : Model -> Html Msg
tooltip model =
    let
        ( time, values ) =
            timeAndValues model

        xOffset =
            margin.left + 20

        annotation =
            model.pointAnnotation

        bottom =
            annotation
                |> Maybe.map Tuple.first
                |> Maybe.map
                    (\{ yPosition } -> String.fromFloat (height - yPosition) ++ "px")
                |> Maybe.withDefault ""

        left =
            annotation
                |> Maybe.map Tuple.first
                |> Maybe.map
                    (\{ xPosition } -> String.fromFloat (xPosition + xOffset) ++ "px")
                |> Maybe.withDefault ""

        display =
            annotation
                |> Maybe.map (always "block")
                |> Maybe.withDefault "none"

        --|> Debug.log "left"
    in
    case model.annotationMode of
        InfoBox ->
            Html.div [] []

        Tooltip ->
            Html.div
                [ style "margin" "0"
                , style "font-size" "14px"
                , style "border" "1px #aaa solid"
                , style "position" "absolute"
                , style "bottom" bottom
                , style "left" left
                , style "background" "white"
                , style "opacity" "95%"
                , style "width" "110px"
                , style "display" display
                ]
                [ Html.ul []
                    (time
                        :: (values
                                |> List.reverse
                                |> List.map
                                    (\v ->
                                        Html.li
                                            [ style "margin" "0" ]
                                            [ Html.text v ]
                                    )
                           )
                    )
                ]


timeAndValues : Model -> ( Html msg, List String )
timeAndValues model =
    let
        annotation =
            model.pointAnnotation

        toHumanTime posix =
            (posix |> Time.toHour Time.utc |> String.fromInt)
                ++ ":"
                ++ (posix |> Time.toMinute Time.utc |> String.fromInt)
    in
    ( annotation
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
    , annotation
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
    )



-- MAIN


main =
    Browser.sandbox
        { init =
            { hinted = Nothing
            , pointAnnotation = Nothing
            , vLineAnnotation = Nothing
            , annotationMode = Tooltip
            }
        , view = view
        , update = update
        }

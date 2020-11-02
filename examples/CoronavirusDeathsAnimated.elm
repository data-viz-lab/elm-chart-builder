module CoronavirusDeathsAnimated exposing (main)

{-| This module shows how to build a simple line chart with a time scale.
-}

import Array exposing (Array)
import Axis
import Browser
import Browser.Events
import Chart.Bar as Bar
import Chart.Line as Line
import Chart.Symbol as Symbol exposing (Symbol)
import Color
import Data exposing (CoronaData, coronaStats)
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Interpolation exposing (Interpolator)
import Iso8601
import Numeral
import Process
import Scale.Color
import Task
import Time exposing (Posix)
import Transition exposing (Transition)


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


type alias Datum =
    ( Float, Float )


type alias Data =
    List Datum


type alias Frame =
    Data


type alias Model =
    { transition : Transition Frame
    , idx : Int
    , data : Data
    }


type Msg
    = Tick Int
    | StartAnimation Frame


stats : Data
stats =
    coronaStats
        |> List.indexedMap
            (\idx ( _, _, dead ) ->
                ( idx |> toFloat, dead )
            )


pointsInTime : Array Float
pointsInTime =
    Array.fromList
        (stats
            |> List.map Tuple.first
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick tick ->
            ( { model
                | transition = Transition.step tick model.transition
              }
            , Cmd.none
            )

        StartAnimation to ->
            let
                newIdx =
                    model.idx + 1

                lastIdx =
                    Array.length pointsInTime - 1

                from =
                    Transition.value model.transition

                currentData =
                    model.data

                transition =
                    Transition.for transitionSpeed (interpolateValues from to)
            in
            ( { model
                | transition = transition
                , idx = newIdx
                , data = currentData ++ (transition |> Transition.value)
              }
            , if model.idx == 0 then
                Task.succeed (StartAnimation <| getDataByYear newIdx)
                    |> Task.perform identity

              else if lastIdx >= newIdx then
                Process.sleep transitionStep
                    |> Task.andThen
                        (\_ ->
                            Task.succeed (StartAnimation <| getDataByYear newIdx)
                        )
                    |> Task.perform identity

              else
                Cmd.none
            )


interpolateValues : Data -> Data -> Interpolator Data
interpolateValues from to =
    List.map2 interpolateValue from to
        |> Interpolation.inParallel


interpolateValue : Datum -> Datum -> Interpolator Datum
interpolateValue from to =
    interpolatePosition from to


interpolatePosition : Datum -> Datum -> Interpolator Datum
interpolatePosition =
    Interpolation.tuple Interpolation.float Interpolation.float



--


accessor : Line.Accessor Datum
accessor =
    Line.linear
        (Line.AccessorLinear (always Nothing) Tuple.first Tuple.second)


valueFormatter : Float -> String
valueFormatter =
    FormatNumber.format { usLocale | decimals = 0 }


width : Float
width =
    1200


height : Float
height =
    600


transitionSpeed =
    80


transitionStep =
    85


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


chart : Data -> Html msg
chart data =
    Line.init
        { margin = { top = 20, right = 10, bottom = 25, left = 80 }
        , width = width
        , height = height
        }
        |> Line.withColorPalette [ Color.rgb255 209 33 2 ]
        |> Line.withXAxisTime xAxis
        |> Line.withYAxis yAxis
        |> Line.withXLinearDomain ( 0, Array.length pointsInTime |> toFloat )
        |> Line.withYDomain ( 0, 12000 )
        |> Line.withLineStyle [ ( "stroke-width", "1.5" ) ]
        |> Line.render ( data, accessor )


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


view : Model -> Html msg
view model =
    let
        pointInTime =
            Array.get (model.idx - 1) pointsInTime
                |> Maybe.withDefault 0
    in
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
            [ Html.div attrs [ chart model.data ]
            ]
        , footer
        ]



--


init : () -> ( Model, Cmd Msg )
init () =
    ( { transition = Transition.constant <| getDataByYear 0, idx = 0, data = [] }
    , Task.perform identity (Task.succeed (StartAnimation <| getDataByYear 1))
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    if Transition.isComplete model.transition then
        Sub.none

    else
        Browser.Events.onAnimationFrameDelta (round >> Tick)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- HELPERS


getDataByYear : Int -> Data
getDataByYear idx =
    stats
        |> List.filter (\( time, value ) -> time == (Array.get idx pointsInTime |> Maybe.withDefault 0))

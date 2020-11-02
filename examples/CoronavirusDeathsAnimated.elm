module CoronavirusDeathsAnimated exposing (main)

{-| This module shows how to build an animated line chart with a time scale.
The trick here is to transform the posix values into floats
and then transition these float values.
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
import List.Extra
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

.axis--x .domain ,
.axis--y .domain {
  stroke: none;
}

.axis--y-right .tick {
  stroke-dasharray : 6 6;
  stroke-width: 0.5px;
}

.column text {
  font-size: 12px;
}

figure {
  margin: 0;
}
"""


type alias DatumTime =
    ( Posix, Float )


type alias DataTime =
    List DatumTime


type alias Datum =
    ( Float, Float )


type alias Data =
    List Datum


type alias Frame =
    Data


type alias Model =
    { transition : Transition Frame
    , currentTimeInFloat : Float
    , data : Data
    }


type Msg
    = Tick Int
    | StartAnimation


stats : Data
stats =
    coronaStats
        |> List.map
            (\( timeStr, _, dead ) ->
                ( Iso8601.toTime timeStr
                    |> Result.withDefault (Time.millisToPosix 0)
                    |> Time.posixToMillis
                    |> toFloat
                , dead
                )
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

        StartAnimation ->
            let
                prevIdx : Int
                prevIdx =
                    stats
                        |> List.Extra.findIndex (\( t, _ ) -> t == model.currentTimeInFloat)
                        |> Maybe.withDefault 0

                lastIdx : Int
                lastIdx =
                    Array.length pointsInTime
                        - 1

                currentTimeInFloat =
                    stats
                        |> List.Extra.getAt (prevIdx + 1)
                        |> Maybe.map (Tuple.first >> floor)
                        |> Maybe.withDefault 0

                data =
                    getDataByCurrentTime (prevIdx + 1)

                from =
                    model.data

                to =
                    data
                        |> List.reverse
                        |> List.head
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []

                transition =
                    Transition.for transitionSpeed (interpolateValues from to)
            in
            ( { model
                | transition = transition
                , currentTimeInFloat = currentTimeInFloat |> toFloat
                , data = data
              }
            , if model.currentTimeInFloat == 0 then
                Task.succeed StartAnimation
                    |> Task.perform identity

              else if prevIdx + 1 <= lastIdx then
                Process.sleep transitionStep
                    |> Task.andThen
                        (\_ ->
                            Task.succeed StartAnimation
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


accessor : Line.Accessor DatumTime
accessor =
    Line.time
        (Line.AccessorTime (always Nothing) Tuple.first Tuple.second)


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
    Line.axisGrid
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
        |> Line.withXTimeDomain xTimeDomain
        |> Line.withYDomain ( 0, 12000 )
        |> Line.withLineStyle [ ( "stroke-width", "1.5" ) ]
        |> Line.render ( data |> toTimeData, accessor )


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
    Html.div [ style "font-family" "Sans-Serif" ]
        [ Html.node "style" [] [ Html.text css ]
        , Html.h2
            [ style "margin" "25px"
            ]
            [ Html.text
                "Coronavirus, world daily number of confirmed deaths"
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
    let
        currentTimeInFloat : Float
        currentTimeInFloat =
            Tuple.first xTimeDomain |> Time.posixToMillis |> toFloat

        initialData : Data
        initialData =
            []
    in
    ( { transition = Transition.constant <| initialData
      , currentTimeInFloat = currentTimeInFloat
      , data = initialData
      }
    , Task.perform identity (Task.succeed StartAnimation)
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


getDataByCurrentTime : Int -> Data
getDataByCurrentTime upTo =
    stats
        |> List.take upTo


toTimeData : Data -> DataTime
toTimeData data =
    data
        |> List.map (\( t, v ) -> ( t |> floor |> Time.millisToPosix, v ))


toXDomain : DataTime -> ( Posix, Posix )
toXDomain data =
    ( data |> List.head |> Maybe.map Tuple.first |> Maybe.withDefault (Time.millisToPosix 0)
    , data |> List.reverse |> List.head |> Maybe.map Tuple.first |> Maybe.withDefault (Time.millisToPosix 0)
    )


xTimeDomain : ( Posix, Posix )
xTimeDomain =
    stats
        |> toTimeData
        |> toXDomain

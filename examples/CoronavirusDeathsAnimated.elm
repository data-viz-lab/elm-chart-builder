module CoronavirusDeathsAnimated exposing (main)

{-| This module shows how to build an animated line chart with a time scale.

The trick here is to transform the posix values into floats
and then transition these float values.

TODO: this is not very efficient, because it is the same thing that the
library is doing internally to draw time lines, so the transfromation
between posix and float is happening twice.

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
import Dict exposing (Dict)
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
    -- (date, country, newDeaths)
    ( Posix, String, Float )


type alias Datum =
    -- (dateString, country, newDeaths)
    ( Float, String, Float )


type alias DataTime =
    List DatumTime


type alias Data =
    List Datum


type alias Frame =
    -- List of (dateAsFloat, newDeaths)
    List ( Float, Float )


type alias Model =
    { transitions : List ( String, Transition Frame )
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
            (\( timeStr, country, dead ) ->
                ( Iso8601.toTime timeStr
                    |> Result.withDefault (Time.millisToPosix 0)
                    |> Time.posixToMillis
                    |> toFloat
                , country
                , dead
                )
            )


pointsInTime : Array Float
pointsInTime =
    Array.fromList
        (stats
            |> List.map (\( t, _, _ ) -> t)
        )


lastIdx : Int
lastIdx =
    Array.length pointsInTime
        - 1


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick tick ->
            ( { model | transitions = tickTransitions model tick }
            , Cmd.none
            )

        StartAnimation ->
            let
                prevIdx : Int
                prevIdx =
                    stats
                        |> List.Extra.findIndex (\( t, _, _ ) -> t == model.currentTimeInFloat)
                        |> Maybe.withDefault 0

                currentTimeInFloat =
                    stats
                        |> List.Extra.getAt (prevIdx + 1)
                        |> Maybe.map (\( t, _, _ ) -> floor t)
                        |> Maybe.withDefault 0

                data =
                    getDataByCurrentTime (prevIdx + 1)

                currentTimeData country =
                    getDataByCurrentTime (prevIdx + 1)
                        |> dataForTransitions
                        |> List.filter (\( c, _ ) -> c == country)
                        |> List.reverse
                        |> List.head
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []

                transitions =
                    model.data
                        |> dataForTransitions
                        |> List.map
                            (\( country, frame ) ->
                                let
                                    from =
                                        frame

                                    to =
                                        currentTimeData country
                                in
                                Transition.for transitionSpeed (interpolateValues from to)
                            )
            in
            ( { model
                | transition = transitions
                , currentTimeInFloat = currentTimeInFloat |> toFloat
                , data = data
              }
            , if model.currentTimeInFloat == 0 then
                Task.succeed StartAnimation
                    |> Task.perform identity

              else if prevIdx + 1 <= lastIdx then
                Process.sleep transitionStep
                    |> Task.andThen (\_ -> Task.succeed StartAnimation)
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
        --    (Line.AccessorTime (always Nothing) Tuple.first (Tuple.second >> removeZeros))
        { xGroup = \( _, d, _ ) -> Just d
        , xValue = \( d, _, _ ) -> d
        , yValue = \( _, _, d ) -> removeZeros d
        }


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
        [ Axis.ticks [ 10, 100, 1000, 10000 ]
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
        |> Line.withLineStyle [ ( "stroke-width", "1.5" ) ]
        |> Line.withLogYScale 10
        |> Line.withXAxisTime xAxis
        |> Line.withYAxis yAxis
        |> Line.withXTimeDomain xTimeDomain
        |> Line.withYDomain ( 0, 12000 )
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
        |> List.map (\( t, c, v ) -> ( t |> floor |> Time.millisToPosix, c, v ))


toXDomain : DataTime -> ( Posix, Posix )
toXDomain data =
    ( data
        |> List.head
        |> Maybe.map (\( t, _, _ ) -> t)
        |> Maybe.withDefault (Time.millisToPosix 0)
    , data
        |> List.reverse
        |> List.head
        |> Maybe.map (\( t, _, _ ) -> t)
        |> Maybe.withDefault (Time.millisToPosix 0)
    )


xTimeDomain : ( Posix, Posix )
xTimeDomain =
    stats
        |> toTimeData
        |> toXDomain



-- HELPERS


removeZeros : Float -> Float
removeZeros val =
    -- Needed for the log scale
    if val == 0 then
        1

    else
        val


tickTransitions : Model -> Int -> List ( String, Transition Frame )
tickTransitions model tick =
    model.transitions
        |> List.map
            (\( country, transition ) ->
                ( country, Transition.step tick transition )
            )


dataForTransitions : Data -> List ( String, Frame )
dataForTransitions data =
    data
        |> List.foldr
            (\( time, country, value ) acc ->
                let
                    member =
                        Dict.member country acc
                in
                if member then
                    Dict.update country
                        (\v ->
                            v |> Maybe.map (\v_ -> ( time, value ) :: v_)
                        )
                        acc

                else
                    Dict.insert country [ ( time, value ) ] acc
            )
            Dict.empty
        |> Dict.toList

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
import Set exposing (Set)
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


removeZeros : Float -> Float
removeZeros val =
    -- Needed for the log scale
    if val == 0 then
        1

    else
        val


type alias DatumTime =
    { country : String
    , date : Posix
    , dead : Float
    }


type alias DataTime =
    List DatumTime


type alias Datum =
    { country : String
    , date : Float
    , dead : Float
    }


type alias Data =
    List Datum


type alias Frame =
    -- List (x, y)
    List ( Float, Float )


type alias Model =
    { transition : Transition Data
    , currentTimestamp : Float
    , currentIdx : Int

    --data up to prev transition
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
                { date =
                    Iso8601.toTime timeStr
                        |> Result.withDefault (Time.millisToPosix 0)
                        |> Time.posixToMillis
                        |> toFloat
                , dead = dead
                , country = country
                }
            )


timestamps : Array Float
timestamps =
    stats
        |> Array.fromList
        |> Array.map .date


lastIdx : Int
lastIdx =
    Array.length timestamps
        - 1


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
                nextIdx =
                    model.currentIdx + 1

                nextTimestamp =
                    timestamps
                        |> Array.get nextIdx
                        |> Maybe.withDefault 0

                from =
                    model.data

                to =
                    stats
                        |> List.filter (\s -> s.date == nextTimestamp)

                transition =
                    Transition.for transitionSpeed (interpolateValues from to)
            in
            ( { model
                | transition = transition
                , currentTimestamp = nextTimestamp
                , currentIdx = nextIdx
                , data = from ++ to
              }
            , if model.currentIdx == 0 then
                Task.succeed StartAnimation
                    |> Task.perform identity

              else if nextIdx <= lastIdx then
                Process.sleep transitionStep
                    |> Task.andThen (\_ -> Task.succeed StartAnimation)
                    |> Task.perform identity

              else
                Cmd.none
            )


interpolateValues : Data -> Data -> Interpolator Data
interpolateValues from to =
    coupleFromTo from to
        |> Dict.map
            (\country ( from_, to_ ) ->
                List.map2 interpolateValue from_ to_
                    |> Interpolation.inParallel
                    |> Interpolation.map
                        (\frame ->
                            frame
                                |> List.map
                                    (\( date, dead ) ->
                                        { date = date
                                        , dead = dead
                                        , country = country
                                        }
                                    )
                        )
            )
        |> Dict.toList
        |> List.map Tuple.second
        |> Interpolation.inParallel
        |> Interpolation.map (\l -> List.concat l)


interpolateValue : ( Float, Float ) -> ( Float, Float ) -> Interpolator ( Float, Float )
interpolateValue from to =
    interpolatePosition from to


interpolatePosition : ( Float, Float ) -> ( Float, Float ) -> Interpolator ( Float, Float )
interpolatePosition =
    Interpolation.tuple Interpolation.float Interpolation.float



--


accessor : Line.Accessor DatumTime
accessor =
    Line.time
        (Line.AccessorTime (.country >> Just) .date (.dead >> removeZeros))


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


chart : Model -> Html msg
chart model =
    let
        lastFrame =
            model.currentIdx > lastIdx

        baseLine =
            Line.init
                { margin = { top = 20, right = 175, bottom = 25, left = 80 }
                , width = width
                , height = height
                }
                |> Line.withColorPalette Scale.Color.tableau10
                |> Line.withLineStyle [ ( "stroke-width", "1.5" ) ]
                |> Line.withLogYScale 10
                |> Line.withXAxisTime xAxis
                |> Line.withYAxis yAxis
                |> Line.withXTimeDomain xTimeDomain
                |> Line.withLabels Line.xGroupLabel
                |> Line.withYDomain ( 0, 12000 )
    in
    Line.init
        { margin = { top = 20, right = 175, bottom = 25, left = 80 }
        , width = width
        , height = height
        }
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withLineStyle [ ( "stroke-width", "1.5" ) ]
        |> Line.withLogYScale 10
        |> Line.withXAxisTime xAxis
        |> Line.withYAxis yAxis
        |> Line.withXTimeDomain xTimeDomain
        |> Line.withLabels Line.xGroupLabel
        |> Line.withYDomain ( 0, 12000 )
        |> Line.render ( model.data |> toTimeData, accessor )


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
            [ Html.div attrs [ chart model ]
            ]
        , footer
        ]



--


init : () -> ( Model, Cmd Msg )
init () =
    let
        currentTimestamp : Float
        currentTimestamp =
            Tuple.first xTimeDomain |> Time.posixToMillis |> toFloat

        initialData : Data
        initialData =
            []
    in
    ( { transition = Transition.constant <| initialData
      , currentTimestamp = 0
      , currentIdx = 0
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


toTimeData : Data -> DataTime
toTimeData data =
    data
        |> List.map
            (\{ date, country, dead } ->
                { date =
                    date |> floor |> Time.millisToPosix
                , dead = dead
                , country = country
                }
            )


toXDomain : DataTime -> ( Posix, Posix )
toXDomain data =
    ( data |> List.head |> Maybe.map .date |> Maybe.withDefault (Time.millisToPosix 0)
    , data |> List.reverse |> List.head |> Maybe.map .date |> Maybe.withDefault (Time.millisToPosix 0)
    )


xTimeDomain : ( Posix, Posix )
xTimeDomain =
    stats
        |> toTimeData
        |> toXDomain


dataToFrames : Data -> Dict String Frame
dataToFrames data =
    data
        |> List.foldr
            (\{ date, country, dead } acc ->
                let
                    member =
                        Dict.member country acc
                in
                if member then
                    Dict.update country
                        (\v ->
                            v |> Maybe.map (\v_ -> ( date, dead ) :: v_)
                        )
                        acc

                else
                    Dict.insert country [ ( date, dead ) ] acc
            )
            Dict.empty


coupleFromTo : Data -> Data -> Dict String ( Frame, Frame )
coupleFromTo from to =
    let
        fromDict =
            dataToFrames from

        toDict =
            dataToFrames to
    in
    Dict.foldl
        (\country frame acc ->
            Dict.insert country ( frame, Dict.get country toDict |> Maybe.withDefault [] ) acc
        )
        Dict.empty
        fromDict

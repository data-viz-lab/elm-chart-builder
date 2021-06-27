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
import Color
import Csv exposing (Csv)
import Dict exposing (Dict)
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Http
import Interpolation exposing (Interpolator)
import Iso8601
import List.Extra
import Process
import RemoteData exposing (RemoteData, WebData)
import Scale.Color
import Set exposing (Set)
import Task
import Time exposing (Posix)
import Transition exposing (Transition)



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



-- MODEL


type alias DatumTime =
    { country : String
    , date : Posix
    , value : Float
    }


type alias DataTime =
    List DatumTime


type alias Datum =
    { country : String
    , date : Float
    , value : Float
    }


type alias Data =
    List Datum


type alias Frame =
    -- List (x, y)
    List ( Float, Float )


type alias Model =
    { transition : Transition Data
    , currentTimestamp : Float
    , timestamps : Array Float
    , lastIdx : Int
    , currentIdx : Int
    , xTimeDomain : ( Posix, Posix )
    , yDomain : ( Float, Float )

    --data up to prev transition
    , data : Data
    , allData : Data
    , serverData : WebData String
    }



-- UPDATE


type Msg
    = Tick Int
    | StartAnimation
    | DataResponse (WebData String)


transitionSpeed =
    50


transitionStep =
    50


timestamps : Data -> Array Float
timestamps data =
    data
        |> Array.fromList
        |> Array.map .date


lastIdx : Array Float -> Int
lastIdx timestamps_ =
    timestamps_
        |> (\t -> Array.length t - 1)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DataResponse response ->
            let
                data =
                    prepareData response

                timestamps_ =
                    timestamps data
            in
            ( { model
                | allData = data
                , timestamps = timestamps_
                , lastIdx = lastIdx timestamps_
                , serverData = response
                , xTimeDomain = data |> toTimeData |> toXDomain
                , yDomain = data |> toYDomain
              }
            , Task.perform identity (Task.succeed StartAnimation)
            )

        Tick tick ->
            ( { model
                | transition = Transition.step tick model.transition
              }
            , Cmd.none
            )

        StartAnimation ->
            case model.serverData of
                RemoteData.Success _ ->
                    let
                        nextIdx =
                            model.currentIdx + 1

                        nextTimestamp =
                            model.timestamps
                                |> Array.get nextIdx
                                |> Maybe.withDefault 0

                        from =
                            model.data

                        to =
                            model.allData
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

                      else if nextIdx <= model.lastIdx then
                        Process.sleep transitionStep
                            |> Task.andThen (\_ -> Task.succeed StartAnimation)
                            |> Task.perform identity

                      else
                        Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )


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
                                    (\( date, value ) ->
                                        { date = date
                                        , value = value
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



-- CHART CONFIGURATION


width : Float
width =
    1200


height : Float
height =
    600


accessor : Line.Accessor DatumTime
accessor =
    Line.time
        (Line.AccessorTime (.country >> Just) .date (.value >> removeZeros))


valueFormatter : Float -> String
valueFormatter =
    FormatNumber.format { usLocale | decimals = 0 }


yAxis : Bar.YAxis Float
yAxis =
    Line.axisGrid
        [ Axis.ticks [ 10, 100, 1000, 10000 ]
        , Axis.tickFormat valueFormatter
        , Axis.tickSizeOuter 0
        ]


xAxis : Bar.XAxis Posix
xAxis =
    Line.axisBottom
        [ Axis.tickSizeOuter 0
        ]


chart : Model -> Html msg
chart model =
    Line.init
        { margin = { top = 20, right = 175, bottom = 25, left = 80 }
        , width = width
        , height = height
        }
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.withLogYScale 10
        |> Line.withXAxisTime xAxis
        |> Line.withYAxis yAxis
        |> Line.withXTimeDomain model.xTimeDomain
        |> Line.withLabels Line.xGroupLabel
        |> Line.withYDomain model.yDomain
        -- for performance
        |> Line.withoutTable
        |> Line.render ( model.data |> toTimeData, accessor )



-- VIEW


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
            , style "font-size" "20px"
            ]
            [ Html.text
                "Coronavirus, daily number of confirmed deaths, log scale"
            ]
        , Html.div
            [ style "background-color" "#fff"
            , style "color" "#444"
            , style "margin" "25px"
            ]
            [ Html.div attrs
                [ case model.serverData of
                    RemoteData.Success _ ->
                        chart model

                    RemoteData.Loading ->
                        Html.div ([ class "pre-chart" ] ++ attrs) [ Html.text "Loading data..." ]

                    _ ->
                        Html.div ([ class "pre-chart" ] ++ attrs) [ Html.text "Something went wrong" ]
                ]
            ]
        , footer
        ]



-- REMOTE CORONAVIRUS DATA


fetchData : Cmd Msg
fetchData =
    Http.get
        { url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
        , expect = Http.expectString (RemoteData.fromResult >> DataResponse)
        }


type alias CoronaData =
    -- (date, country, newDeaths)
    ( String, String, Float )


locations : List String
locations =
    --[ "World", "United Kingdom" ]
    --[ "India", "United Kingdom" ]
    [ "United States", "United Kingdom" ]


countryIdx : Int
countryIdx =
    2


dateIdx : Int
dateIdx =
    3


valueIdx : Int
valueIdx =
    -- new_deaths_smoothed_per_million
    --15
    -- new_deaths_smoothed
    9


prepareData rd =
    rd
        |> RemoteData.map
            (\str ->
                let
                    csv =
                        Csv.parse str
                in
                csv.records
                    |> Array.fromList
                    |> Array.map Array.fromList
                    |> Array.filter
                        (\r ->
                            r
                                |> Array.get countryIdx
                                |> Maybe.map (\location -> List.member location locations)
                                |> Maybe.withDefault False
                        )
                    |> Array.map
                        (\r ->
                            { date =
                                Array.get dateIdx r
                                    |> Maybe.withDefault ""
                                    |> Iso8601.toTime
                                    |> Result.withDefault (Time.millisToPosix 0)
                                    |> Time.posixToMillis
                                    |> toFloat
                            , country =
                                Array.get countryIdx r
                                    |> Maybe.withDefault ""
                            , value =
                                Array.get valueIdx r
                                    |> Maybe.andThen String.toFloat
                                    |> Maybe.withDefault 0
                            }
                        )
                    |> Array.toList
            )
        |> RemoteData.withDefault []


removeZeros : Float -> Float
removeZeros val =
    -- Needed for the log scale
    if val < 1 then
        1

    else
        val



-- HELPERS


toTimeData : Data -> DataTime
toTimeData data =
    data
        |> List.map
            (\{ date, country, value } ->
                { date =
                    date |> floor |> Time.millisToPosix
                , value = value
                , country = country
                }
            )


toYDomain : Data -> ( Float, Float )
toYDomain data =
    ( 0
    , data |> List.map .value |> List.maximum |> Maybe.withDefault 0
    )


toXDomain : DataTime -> ( Posix, Posix )
toXDomain data =
    ( data |> List.head |> Maybe.map .date |> Maybe.withDefault (Time.millisToPosix 0)
    , data |> List.reverse |> List.head |> Maybe.map .date |> Maybe.withDefault (Time.millisToPosix 0)
    )


dataToFrames : Data -> Dict String Frame
dataToFrames data =
    data
        |> List.foldr
            (\{ date, country, value } acc ->
                let
                    member =
                        Dict.member country acc
                in
                if member then
                    Dict.update country
                        (\v ->
                            v |> Maybe.map (\v_ -> ( date, value ) :: v_)
                        )
                        acc

                else
                    Dict.insert country [ ( date, value ) ] acc
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



-- INIT


init : () -> ( Model, Cmd Msg )
init () =
    let
        initialData : Data
        initialData =
            []
    in
    ( { transition = Transition.constant <| initialData
      , currentTimestamp = 0
      , timestamps = Array.empty
      , lastIdx = 0
      , currentIdx = 0
      , xTimeDomain = ( Time.millisToPosix 0, Time.millisToPosix 0 )
      , yDomain = ( 0, 0 )
      , data = initialData
      , allData = initialData
      , serverData = RemoteData.Loading
      }
    , fetchData
    )



-- SUSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if Transition.isComplete model.transition then
        Sub.none

    else
        Browser.Events.onAnimationFrameDelta (round >> Tick)



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

module CoronavirusDeaths exposing (main)

{-| This module shows how to request some remote coronavirus data and bild an area chart with it.
-}

import Array exposing (Array)
import Axis
import Browser
import Chart.Bar as Bar
import Chart.Line as Line
import Color exposing (rgb255)
import Csv exposing (Csv)
import Dict
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Http
import Iso8601
import RemoteData exposing (RemoteData, WebData)
import Shape
import Time exposing (Posix)



-- STYLING


css : String
css =
    """
body {
  background-color: #1e1e1e;
  color: #fff;
}

.chart-builder__axis path,
.chart-builder__axis line {
  stroke: #fff;
}

text {
  fill: #fff;
  font-size: 16px;
}

.column text {
  font-size: 12px;
}

figure {
  margin: 0;
}

.label {
  font-size: 14px;
}

.pre-chart {
  display: flex;
  justify-content: center;
  align-items: center;
}
"""



-- MODEL


type alias Datum =
    { country : String
    , date : Posix
    , value : Float
    }


type alias Data =
    List Datum


type alias Model =
    { data : Data
    , serverData : WebData String
    }



-- UPDATE


type Msg
    = DataResponse (WebData String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DataResponse response ->
            let
                data =
                    prepareData response
            in
            ( { model
                | data = data
                , serverData = response
              }
            , Cmd.none
            )



-- CHART CONFIGURATION


width : Float
width =
    1200


height : Float
height =
    600


accessor : Line.Accessor Datum
accessor =
    Line.time
        (Line.AccessorTime (.country >> Just) .date .value)


valueFormatter : Float -> String
valueFormatter =
    FormatNumber.format { usLocale | decimals = 0 }


yAxis : Bar.YAxis Float
yAxis =
    Line.axisLeft
        [ Axis.tickCount 5
        , Axis.tickSizeOuter 0
        , Axis.tickFormat (abs >> valueFormatter)
        ]


xAxis : Bar.XAxis Posix
xAxis =
    Line.axisBottom
        [ Axis.tickSizeOuter 0
        ]


colorPalette =
    [ Color.rgb255 141 211 199
    , Color.rgb255 255 255 179
    , Color.rgb255 190 186 218
    , Color.rgb255 251 128 114
    , Color.rgb255 128 177 211
    , Color.rgb255 253 180 98
    , Color.rgb255 179 222 105
    , Color.rgb255 252 205 229
    , Color.rgb255 217 217 217
    , Color.rgb255 188 128 189
    ]



-- CHART


chart : Data -> Html msg
chart data =
    Line.init
        { margin = { top = 20, right = 175, bottom = 25, left = 80 }
        , width = width
        , height = height
        }
        |> Line.withCurve (Shape.cardinalCurve 0.5)
        |> Line.withStackedLayout (Line.drawArea Shape.stackOffsetSilhouette)
        |> Line.withColorPalette colorPalette
        |> Line.withLabels Line.xGroupLabel
        |> Line.withXAxisTime xAxis
        |> Line.withYAxis yAxis
        |> Line.render ( data, accessor )



-- VIEW


attrs : List (Html.Attribute msg)
attrs =
    [ style "height" (String.fromFloat (height + 20) ++ "px")
    , style "width" (String.fromFloat width ++ "px")
    , style "border" "1px solid #c4c4c4"
    , style "background-color" "#2b2b2b"
    ]


footer : Html msg
footer =
    Html.footer
        [ style "margin" "25px"
        ]
        [ Html.a
            [ Html.Attributes.href
                "https://github.com/owid/covid-19-data/tree/master/public/data"
            , style "color" "#fff"
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
                "Coronavirus, new deaths per million"
            ]
        , Html.div
            [ style "color" "#fff"
            , style "margin" "25px"
            ]
            [ Html.div attrs
                [ case model.serverData of
                    RemoteData.Success _ ->
                        chart model.data

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


locations : List String
locations =
    [ "United States"
    , "United Kingdom"
    , "Italy"
    , "Germany"
    , "Belgium"
    , "Brazil"
    , "France"
    , "Sweden"
    ]


countryIdx : Int
countryIdx =
    2


dateIdx : Int
dateIdx =
    3


valueIdx : Int
valueIdx =
    -- new_deaths_smoothed
    --9
    -- new_deaths_smoothed_per_million
    15


prepareData : WebData String -> Data
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
                            , country =
                                Array.get countryIdx r
                                    |> Maybe.withDefault ""
                            , value =
                                Array.get valueIdx r
                                    |> Maybe.andThen String.toFloat
                                    |> Maybe.withDefault 0
                            }
                        )
                    |> Array.foldl
                        (\r acc ->
                            let
                                k =
                                    r.date |> Time.posixToMillis
                            in
                            case Dict.get k acc of
                                Just v ->
                                    Dict.insert k (r :: v) acc

                                Nothing ->
                                    Dict.insert k [ r ] acc
                        )
                        Dict.empty
                    -- only keep data shared across all countries
                    |> Dict.filter (\k v -> List.length v == List.length locations)
                    |> Dict.toList
                    |> List.map Tuple.second
                    |> List.concat
            )
        |> RemoteData.withDefault []



-- INIT


init : () -> ( Model, Cmd Msg )
init () =
    ( { data = []
      , serverData = RemoteData.Loading
      }
    , fetchData
    )



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

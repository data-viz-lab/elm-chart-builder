module WorldBank.Health exposing (main)

{-| -}

import Axis
import Browser
import Chart.Bar as Bar
import Chart.Symbol as Symbol exposing (Symbol)
import Color
import Html exposing (Html)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Decode
import Numeral
import RemoteData exposing (RemoteData, WebData)
import Scale.Color
import Set exposing (Set)


css : String
css =
    """
body {
  font-family: Sans-Serif;
}

.wrapper {
  display: grid;
  grid-template-rows: 100px 1fr;
  grid-template-columns: repeat(2, 1fr);
  grid-gap: 10px;
  background-color: #fff;
  color: #444;
  margin: 25px;
}

.axis text {
  font-size: 14px;
}

.axis--vertical text {
  font-size: 11px;
}

.axis path,
.axis line {
  stroke: #b7b7b7;
}

text {
  fill: #333;
}

.column text {
  fill: #222;
}

.chart-label {
  grid-column-start: 1;
  grid-column-end: 3;
}

.chart-1 {
  grid-column-start: 1;
  grid-column-end: 2;
}

.chart-2 {
  grid-column-start: 2;
  grid-column-end: 3;
}

h1 {
  font-size: 20px;
  margin: 0;
}

h1:before {
  content: "";
  display: inline-block;
  width: 15px;
  height: 15px;
  margin-right: 5px;
}

.one:before {
  background: #f28e2c;
}

.two:before {
  background: #4E79A7;
}

footer {
  font-size: 12px;
  margin: 20px;
}
"""


width : Float
width =
    840


height : Float
height =
    600


margin =
    { top = 10, right = 100, bottom = 25, left = 255 }


icons : String -> List Symbol
icons prefix =
    [ Symbol.custom
        { viewBoxDimensions = ( 24, 24 )
        , paths =
            [ "M7 13c1.66 0 3-1.34 3-3S8.66 7 7 7s-3 1.34-3 3 1.34 3 3 3zm12-6h-8v7H3V5H1v15h2v-3h18v3h2v-9c0-2.21-1.79-4-4-4z"
            ]
        }
        |> Symbol.withIdentifier (prefix ++ "-bed-symbol")
        |> Symbol.withStyle [ ( "fill", "none" ) ]
    , Symbol.custom
        { viewBoxDimensions = ( 24, 24 )
        , paths =
            [ "M15 11V5l-3-3-3 3v2H3v14h18V11h-6zm-8 8H5v-2h2v2zm0-4H5v-2h2v2zm0-4H5V9h2v2zm6 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V9h2v2zm0-4h-2V5h2v2zm6 12h-2v-2h2v2zm0-4h-2v-2h2v2z"
            ]
        }
        |> Symbol.withIdentifier (prefix ++ "-city-symbol")
        |> Symbol.withStyle [ ( "fill", "none" ) ]
    ]


valueFormatter : Float -> String
valueFormatter =
    (\n -> n / 100)
        >> Numeral.format "0%"


removeZeroes : String -> String
removeZeroes s =
    if s == "0%" then
        ""

    else
        s


type alias ServerData =
    { indicatorValue : String
    , countryValues : List Data
    }


type alias Data =
    { countryId : String
    , countryName : String
    , countryIso3code : String
    , year : String
    , value : Float
    , indicator : String
    }


type alias Model =
    { regionalHealthData : WebData (List Data)
    , serverHealthData : WebData ServerData
    , regionalUrbanData : WebData (List Data)
    , serverUrbanData : WebData ServerData
    , regionalData : WebData (List Data)
    }


type Msg
    = HealthDataResponse (WebData ServerData)
    | UrbanDataResponse (WebData ServerData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HealthDataResponse response ->
            let
                regionalData =
                    calculateRegionalData response
            in
            ( { model
                | regionalHealthData = regionalData
                , serverHealthData = response
                , regionalData =
                    RemoteData.map2 (\a b -> a ++ b) regionalData model.regionalUrbanData
                        |> RemoteData.map (\d -> List.sortBy .indicator d)
              }
            , Cmd.none
            )

        UrbanDataResponse response ->
            let
                regionalData =
                    calculateRegionalData response
            in
            ( { model
                | regionalUrbanData = calculateRegionalData response
                , serverUrbanData = response
                , regionalData =
                    RemoteData.map2 (\a b -> a ++ b) regionalData model.regionalHealthData
                        |> RemoteData.map (\d -> List.sortBy .indicator d)
              }
            , Cmd.none
            )


decodeData : Decode.Decoder ServerData
decodeData =
    Decode.map2 ServerData
        (Decode.index 1 (Decode.index 1 (Decode.at [ "indicator", "value" ] Decode.string)))
        (Decode.index 1 (Decode.list decodeItem))


decodeItem : Decode.Decoder Data
decodeItem =
    Decode.map6 Data
        (Decode.at [ "country", "id" ] Decode.string)
        (Decode.at [ "country", "value" ] Decode.string)
        (Decode.field "countryiso3code" Decode.string)
        (Decode.field "date" Decode.string)
        --TODO this should really be a Maybe
        (Decode.field "value" (Decode.oneOf [ Decode.float, Decode.succeed 0 ]))
        (Decode.at [ "indicator", "value" ] Decode.string)


fetchDatasetHealthData : Cmd Msg
fetchDatasetHealthData =
    Http.get
        { url = "https://api.worldbank.org/v2/country/all/indicator/SH.STA.MALN.ZS?format=json&date=2000&per_page=370"
        , expect = Http.expectJson (RemoteData.fromResult >> HealthDataResponse) decodeData
        }


fetchDatasetUrbanData : Cmd Msg
fetchDatasetUrbanData =
    Http.get
        { url = "https://api.worldbank.org/v2/country/all/indicator/EN.URB.MCTY.TL.ZS?format=json&date=2000&per_page=370"
        , expect = Http.expectJson (RemoteData.fromResult >> UrbanDataResponse) decodeData
        }


calculateRegionalData : WebData ServerData -> WebData (List Data)
calculateRegionalData data =
    data
        |> RemoteData.map .countryValues
        |> RemoteData.withDefault []
        --|> List.filter (\d -> Set.member d.countryName regionsByIncom)
        |> List.sortBy .value
        |> RemoteData.succeed


mergeRegionalData : List Data -> List Data -> List Data
mergeRegionalData a b =
    a ++ b


init : () -> ( Model, Cmd Msg )
init () =
    ( { regionalUrbanData = RemoteData.Loading
      , serverUrbanData = RemoteData.Loading
      , regionalHealthData = RemoteData.Loading
      , serverHealthData = RemoteData.Loading
      , regionalData = RemoteData.Loading
      }
    , Cmd.batch [ fetchDatasetHealthData, fetchDatasetUrbanData ]
    )


attrs : String -> List (Html.Attribute msg)
attrs classStr =
    [ Html.Attributes.style "height" (String.fromFloat (height + 20) ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class ("chart-wrapper " ++ classStr)
    ]


accessor : Bar.Accessor Data
accessor =
    --Bar.Accessor (.indicator >> Just) .countryName .value
    Bar.Accessor (.countryName >> Just) .indicator .value


yAxis : Bar.YAxis Float
yAxis =
    Bar.axisLeft
        [ Axis.tickCount 8
        , Axis.tickFormat valueFormatter
        ]


chart : List Data -> Html Msg
chart data =
    Bar.init
        { margin = margin
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withOrientation Bar.horizontal
        |> Bar.withYDomain ( 0, 50 )
        |> Bar.withLabels (Bar.yLabel (valueFormatter >> removeZeroes))
        |> Bar.withSymbols (icons "x")
        |> Bar.withYAxis yAxis
        |> Bar.render ( data, accessor )


chartLabel : Model -> Html msg
chartLabel model =
    RemoteData.map2
        (\a b ->
            Html.div [ class "chart-label" ]
                [ Html.h1 [ class "one" ] [ Html.text a.indicatorValue ]
                , Html.h1 [ class "two" ] [ Html.text b.indicatorValue ]
                ]
        )
        model.serverUrbanData
        model.serverHealthData
        |> RemoteData.withDefault
            (Html.text "TODO")


footer : Html msg
footer =
    Html.footer [ class "footer" ]
        [ Html.a
            [ Html.Attributes.href
                "https://data.worldbank.org/indicator/"
            ]
            [ Html.text "Data source" ]
        ]


view : Model -> Html Msg
view model =
    case ( model.regionalData, model.serverHealthData, model.serverUrbanData ) of
        ( RemoteData.Success data, RemoteData.Success healthData, RemoteData.Success urbanData ) ->
            Html.div []
                [ Html.node "style" [] [ Html.text css ]
                , Html.div
                    [ class "wrapper" ]
                    [ chartLabel model
                    , Html.div (attrs "chart-1")
                        [ chart
                            (data
                                |> List.filter (\d -> Set.member d.countryName regions)
                            )
                        ]
                    , Html.div (attrs "chart-2")
                        [ chart
                            (data
                                |> List.filter (\d -> Set.member d.countryName regionsByIncom)
                            )
                        ]
                    ]
                , footer
                ]

        _ ->
            Html.text "TODO"


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


regions : Set String
regions =
    [ --"Arab World"
      --, "Caribbean small states"
      --, "Central Europe and the Baltics"
      --, "Pacific island small states"
      --, "OECD members"
      "East Asia & Pacific"
    , "Europe & Central Asia"
    , "European Union"
    , "Latin America & Caribbean"
    , "Middle East & North Africa"
    , "North America"
    , "South Asia"
    , "Sub-Saharan Africa"
    , "Sub-Saharan Africa (excluding high income)"
    ]
        |> Set.fromList


regionsByIncom : Set String
regionsByIncom =
    [ "Fragile and conflict affected situations"
    , "Heavily indebted poor countries (HIPC)"
    , "High income"
    , "Least developed countries: UN classification"
    , "Low & middle income"
    , "Low income"
    , "Lower middle income"
    , "Middle income"
    , "Upper middle income"
    ]
        |> Set.fromList

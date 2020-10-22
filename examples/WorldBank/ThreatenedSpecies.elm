module WorldBank.ThreatenedSpecies exposing (main)

{-| -}

import Axis
import Browser
import Chart.Bar as Bar
import Color
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Decode
import RemoteData exposing (RemoteData, WebData)
import Set exposing (Set)


css : String
css =
    """
body {
  font-family: Sans-Serif;
}

.wrapper {
  display: grid;
  grid-template-rows: 50px 1fr;
  grid-template-columns: repeat(1, 1fr);
  grid-gap: 10px;
  background-color: #fff;
  color: #444;
  margin: 25px;
}

.axis text {
  font-size: 14px;
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

h1 {
  font-size: 28px;
}

footer {
    font-size: 12px;
    margin: 20px;
}
"""


width : Float
width =
    1200


height : Float
height =
    700


margin =
    { top = 10, right = 100, bottom = 25, left = 320 }


valueFormatter : Float -> String
valueFormatter =
    FormatNumber.format { usLocale | decimals = 0 }


type alias ServerData =
    { indicatorValue : String
    , countryValues : List Data
    }


type alias Data =
    { countryId : String
    , countryName : String
    , countryIso3code : String
    , year : String
    , value : Int
    }


type alias Model =
    { regionalData : WebData (List Data)
    , serverData : WebData ServerData
    }


type Msg
    = DataResponse (WebData ServerData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DataResponse response ->
            ( { model
                | regionalData = calculateRegionalData response
                , serverData = response
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
    Decode.map5 Data
        (Decode.at [ "country", "id" ] Decode.string)
        (Decode.at [ "country", "value" ] Decode.string)
        (Decode.field "countryiso3code" Decode.string)
        (Decode.field "date" Decode.string)
        --TODO this should really be a Maybe
        (Decode.field "value" (Decode.oneOf [ Decode.int, Decode.succeed 0 ]))


fetchData : Cmd Msg
fetchData =
    Http.get
        { url = "http://api.worldbank.org/v2/country/all/indicator/EN.MAM.THRD.NO?format=json&date=2018&per_page=270"
        , expect = Http.expectJson (RemoteData.fromResult >> DataResponse) decodeData
        }


calculateRegionalData : WebData ServerData -> WebData (List Data)
calculateRegionalData data =
    data
        |> RemoteData.map .countryValues
        |> RemoteData.withDefault []
        |> List.filter (\d -> Set.member d.countryName worldBankRegions)
        |> List.sortBy .value
        |> RemoteData.succeed


init : () -> ( Model, Cmd Msg )
init () =
    ( { regionalData = RemoteData.Loading, serverData = RemoteData.Loading }
    , fetchData
    )


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat (height + 20) ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


accessor : Bar.Accessor Data
accessor =
    Bar.Accessor (always Nothing) .countryName (.value >> toFloat)


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
        |> Bar.withColorPalette [ Color.rgb255 209 33 2 ]
        |> Bar.withOrientation Bar.horizontal
        |> Bar.withLabels (Bar.yLabel valueFormatter)
        |> Bar.withYAxis yAxis
        |> Bar.render ( data, accessor )


chartLabel : String -> Html msg
chartLabel label =
    Html.div [] [ Html.h1 [] [ Html.text label ] ]


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
    case ( model.regionalData, model.serverData ) of
        ( RemoteData.Success data, RemoteData.Success { indicatorValue } ) ->
            Html.div []
                [ Html.node "style" [] [ Html.text css ]
                , Html.div
                    [ class "wrapper" ]
                    [ Html.div [] [ chartLabel indicatorValue ]
                    , Html.div attrs [ chart data ]
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


worldBankRegions : Set String
worldBankRegions =
    [ "Arab World"
    , "Caribbean small states"
    , "Central Europe and the Baltics"
    , "East Asia & Pacific"
    , "Europe & Central Asia"
    , "European Union"
    , "Fragile and conflict affected situations"
    , "Heavily indebted poor countries (HIPC)"
    , "High income"
    , "Latin America & Caribbean"
    , "Least developed countries: UN classification"
    , "Low & middle income"
    , "Low income"
    , "Lower middle income"
    , "Middle East & North Africa"
    , "Middle income"
    , "North America"
    , "OECD members"
    , "Pacific island small states"
    , "South Asia"
    , "Sub-Saharan Africa"
    , "Sub-Saharan Africa (excluding high income)"
    , "Upper middle income"
    ]
        |> Set.fromList

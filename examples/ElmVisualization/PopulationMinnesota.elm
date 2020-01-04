module ElmVisualization.PopulationMinnesota exposing (main)

{-| This module shows how to build a simple population pyramid chart.
-}

import Chart.Bar as Bar
import DateFormat
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class)
import List.Extra
import Time


css : String
css =
    """
body {
  font-family: Sans-Serif;
}

.header {
    font-size: 20px;
    margin: 20px;
}

.footer {
    font-size: 12px;
    margin: 20px;
}

.wrapper {
    position: relative;
}

.chart-wrapper {
    margin: 20px;
    border: 1px solid #c4c4c4;
}

.chart-wrapper,
.wrapper {
    width: 800px;
    height: 500px;
}

.column-0 rect {
    fill: #355F8D;
}

.column-1 rect {
    fill: rgba(26.67%,74.9%,43.92%,1);
}

.axis path,
.axis line {
    stroke: #b7b7b7;
}

text {
    fill: #333;
}

.men {
    position: absolute;
    left: 24%;
    top: 40%;
    font-size: 22px;
}

.women {
    position: absolute;
    left: 75%;
    top: 40%;
    font-size: 22px;
}

.age {
    position: absolute;
    left: 80px;
    top: 20px;
    font-size: 16px;
}

.people {
    position: absolute;
    left: 52%;
    bottom: 10px;
    font-size: 16px;
}
"""


type Gender
    = M
    | F


type alias Population =
    { year : Int, age : Int, gender : Gender, people : Int }


populationMinnesota1850 : List Population
populationMinnesota1850 =
    [ Population 1850 0 M 1483789
    , Population 1850 0 F 1450376
    , Population 1850 5 M 1411067
    , Population 1850 5 F 1359668
    , Population 1850 10 M 1260099
    , Population 1850 10 F 1216114
    , Population 1850 15 M 1077133
    , Population 1850 15 F 1110619
    , Population 1850 20 M 1017281
    , Population 1850 20 F 1003841
    , Population 1850 25 M 862547
    , Population 1850 25 F 799482
    , Population 1850 30 M 730638
    , Population 1850 30 F 639636
    , Population 1850 35 M 588487
    , Population 1850 35 F 505012
    , Population 1850 40 M 475911
    , Population 1850 40 F 428185
    , Population 1850 45 M 384211
    , Population 1850 45 F 341254
    , Population 1850 50 M 321343
    , Population 1850 50 F 286580
    , Population 1850 55 M 194080
    , Population 1850 55 F 187208
    , Population 1850 60 M 174976
    , Population 1850 60 F 162236
    , Population 1850 65 M 106827
    , Population 1850 65 F 105534
    , Population 1850 70 M 73677
    , Population 1850 70 F 71762
    , Population 1850 75 M 40834
    , Population 1850 75 F 40229
    , Population 1850 80 M 23449
    , Population 1850 80 F 22949
    , Population 1850 85 M 8186
    , Population 1850 85 F 10511
    , Population 1850 90 M 5259
    , Population 1850 90 F 6569
    ]


valueFormatter : Float -> String
valueFormatter =
    FormatNumber.format { usLocale | decimals = 0 }


formattedData : List { groupLabel : Maybe String, points : List ( String, Float ) }
formattedData =
    populationMinnesota1850
        |> List.Extra.groupWhile
            (\a b -> a.age == b.age)
        |> List.map
            (\l ->
                let
                    m =
                        Tuple.first l

                    f =
                        l
                            |> Tuple.second
                            |> List.head
                            |> Maybe.withDefault { year = -1, age = -1, gender = F, people = -1 }
                in
                { groupLabel = m.age |> String.fromInt |> Just
                , points =
                    [ ( "Male", toFloat -m.people )
                    , ( "Female", toFloat f.people )
                    ]
                }
            )


data : Bar.Data
data =
    Bar.dataBand formattedData


chart : Html msg
chart =
    Bar.init data
        |> Bar.setLayout (Bar.stackedLayout Bar.divergingDirection)
        |> Bar.setOrientation Bar.horizontalOrientation
        |> Bar.setTitle "Horizontal Stacked Diverging Chart"
        |> Bar.setDesc "A horizontal stacked diverging chart example to demonstrate the charting library"
        |> Bar.setLinearAxisTickCount (Bar.linearAxisCustomTickCount 8)
        |> Bar.setLinearAxisTickFormat (Bar.linearAxisCustomTickFormat (\v -> abs v |> valueFormatter))
        --FIXME
        --|> Bar.setDomainLinear ( -1000000, 1000000 )
        |> Bar.setDimensions
            { margin = { top = 20, right = 20, bottom = 50, left = 50 }
            , width = 800
            , height = 500
            }
        |> Bar.render


footer : Html msg
footer =
    Html.footer [ class "footer" ]
        [ Html.ul []
            [ Html.li []
                [ Html.a
                    [ Html.Attributes.href
                        "https://github.com/data-viz-lab/elm-chart-builder/blob/master/examples/ElmVisualization/PopulationMinnesota.elm"
                    ]
                    [ Html.text "Source Code" ]
                ]
            , Html.li []
                [ Html.a
                    [ Html.Attributes.href
                        "https://code.gampleman.eu/elm-visualization/PopulationMinnesota/"
                    ]
                    [ Html.text "Original" ]
                ]
            ]
        ]


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.header [ class "header" ]
            [ Html.text "Population distribution in Minnesota 1850" ]
        , Html.div [ class "wrapper" ]
            [ Html.div [ class "chart-wrapper" ] [ chart ]
            , Html.div [ class "men" ] [ Html.text "Men" ]
            , Html.div [ class "women" ] [ Html.text "Women" ]
            , Html.div [ class "age" ] [ Html.text "Age" ]
            , Html.div [ class "people" ] [ Html.text "People" ]
            ]
        , footer
        ]

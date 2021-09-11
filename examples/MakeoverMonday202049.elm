module MakeoverMonday202049 exposing (main)

{-| <https://data.world/makeovermonday/2020w49-divergent-opinions-on-transatlantic-alliance>
-}

import Axis
import Chart.Bar as Bar
import Html exposing (Html)
import Html.Attributes exposing (class, style)
import List.Extra
import Numeral
import Scale.Color


css : String
css =
    """
.ecb-axis--y text {
  font-size: 14px;
}

.ecb-axis--x text {
  font-size: 11px;
}

.ecb-axis path,
.ecb-axis line {
 opacity : 0;
}

text {
  fill: #333;
}

.ecb-label {
  font-size: 12px;
}

figure {
  margin: 0;
}

h3 {
  font-size: 16px;
}
"""


type alias Data =
    { label : String, response : String, value : Float, year : String }


type alias DataForChart =
    { label : String, value : Float, year : String }


valueFormatter : Float -> String
valueFormatter v =
    v / 100 |> Numeral.format "0%"


data : List (List Data)
data =
    [ [ { label = "Germany", response = "Good", year = "2017", value = 42 }
      , { label = "United States", response = "Good", year = "2017", value = 68 }
      , { label = "Germany", response = "Bad", year = "2017", value = -56 }
      , { label = "United States", response = "Bad", year = "2017", value = -22 }
      ]
    , [ { label = "Germany", response = "Good", year = "2018", value = 24 }
      , { label = "United States", response = "Good", year = "2018", value = 70 }
      , { label = "Germany", response = "Bad", year = "2018", value = -73 }
      , { label = "United States", response = "Bad", year = "2018", value = -25 }
      ]
    , [ { label = "Germany", response = "Good", year = "2019", value = 34 }
      , { label = "United States", response = "Good", year = "2019", value = 75 }
      , { label = "Germany", response = "Bad", year = "2019", value = -64 }
      , { label = "United States", response = "Bad", year = "2019", value = -17 }
      ]
    , [ { label = "Germany", response = "Good", year = "2020", value = 18 }
      , { label = "United States", response = "Good", year = "2020", value = 74 }
      , { label = "Germany", response = "Bad", year = "2020", value = -79 }
      , { label = "United States", response = "Bad", year = "2020", value = -21 }
      ]
    ]


accessor : Bar.Accessor Data
accessor =
    Bar.Accessor (.label >> Just) .response .value


width : Float
width =
    150


height : Float
height =
    250


axisChart : Html msg
axisChart =
    let
        ( xAxis, yAxis ) =
            ( Bar.hideXAxis
            , Bar.withYAxis
                (Bar.axisLeft
                    [ Axis.tickFormat (abs >> valueFormatter)
                    , Axis.tickCount 6
                    , Axis.tickSizeOuter 0
                    ]
                )
            )

        d =
            []
    in
    Bar.init
        { margin = { top = 30, right = 0, bottom = 0, left = 60 }
        , width = 60
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withOrientation Bar.vertical
        |> Bar.withStackedLayout Bar.diverging
        |> Bar.withYDomain ( -75, 75 )
        |> xAxis
        |> yAxis
        |> Bar.render ( d, accessor )


chart : List Data -> Html msg
chart d =
    Bar.init
        { margin = { top = 30, right = 0, bottom = 0, left = 0 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette Scale.Color.tableau10
        |> Bar.withOrientation Bar.vertical
        |> Bar.withStackedLayout Bar.diverging
        |> Bar.withYDomain ( -75, 75 )
        |> Bar.hideYAxis
        |> Bar.withXAxis (Bar.axisTop [])
        |> Bar.render ( d, accessor )


attrs : List (Html.Attribute msg)
attrs =
    [ style "height" (String.fromFloat (height + 60) ++ "px")
    , style "width" (String.fromFloat (width * 5 + 30 + 20 * 4) ++ "px")
    ]


chartTitle : String -> Html msg
chartTitle label =
    Html.div
        [ style "margin" "25px 0"
        ]
        [ Html.h4 [ style "margin" "2px" ] [ Html.text label ] ]


main : Html msg
main =
    Html.div [ style "font-family" "Sans-Serif" ]
        [ Html.node "style" [] [ Html.text css ]
        , Html.div
            [ style "background-color" "#fff"
            , style "color" "#444"
            , style "margin" "25px"
            ]
            [ Html.div attrs
                [ chartTitle "% who say relations today between the US and Germany are..."
                , Html.div
                    [ style "display" "grid"
                    , style "grid-template-columns" "60px 150px 150px 150px 150px 80px"
                    , style "grid-gap" "20px"
                    , style "border" "1px solid #c4c4c4"
                    ]
                    (axisChart
                        :: (data
                                |> List.indexedMap
                                    (\idx d ->
                                        let
                                            txt =
                                                data
                                                    |> List.Extra.getAt idx
                                                    |> Maybe.withDefault []
                                                    |> List.head
                                                    |> Maybe.map .year
                                                    |> Maybe.withDefault ""
                                        in
                                        Html.div
                                            [ style "display" "flex"
                                            , style "justify-content" "center"
                                            , style "align-items" "center"
                                            , style "flex-direction" "column"
                                            ]
                                            [ chart d, Html.h3 [] [ Html.text txt ] ]
                                    )
                           )
                        ++ [ Html.div
                                [ style "height" (String.fromFloat (height - 30) ++ "px")
                                , style "margin-top" "30px"
                                ]
                                [ Html.div
                                    [ style "display" "flex"
                                    , style "justify-content" "space-around"
                                    , style "align-items" "center"
                                    , style "flex-direction" "column"
                                    , style "height" "100%"
                                    ]
                                    [ Html.h2
                                        [ style "color" "rgba(30.59%,47.45%,65.49%,1)"
                                        ]
                                        [ Html.text "Good" ]
                                    , Html.h2
                                        [ style "color" "rgba(94.9%,55.69%,17.25%,1)"
                                        ]
                                        [ Html.text "Bad" ]
                                    ]
                                ]
                           ]
                    )
                ]
            ]
        ]

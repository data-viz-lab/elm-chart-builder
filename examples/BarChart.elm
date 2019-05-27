module Examples.BarChart exposing (data, main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.Bar as Bar
import Chart.Type exposing (..)
import Html exposing (Html)
import Html.Attributes
import Svg exposing (..)
import Svg.Attributes exposing (..)


data : Data
data =
    [ [ { point = PointBand ( "a", 10 )
        , group = Nothing
        }
      , { point = PointBand ( "b", 13 )
        , group = Nothing
        }
      ]
    ]


main : Html msg
main =
    Html.div
        []
        [ Html.div
            [ Html.Attributes.style "height" "400px"
            , Html.Attributes.style "width" "600px"
            , Html.Attributes.style "background-color" "red"
            ]
            [ Bar.init data
                |> Bar.setHeight 400
                |> Bar.setWidth 600
                |> Bar.render
            ]
        ]

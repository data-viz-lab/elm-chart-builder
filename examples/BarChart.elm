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


width : Float
width =
    600


height : Float
height =
    400


main : Html msg
main =
    Html.div
        []
        [ Html.div
            [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
            , Html.Attributes.style "width" (String.fromFloat width ++ "px")
            , Html.Attributes.style "background-color" "red"
            ]
            [ Bar.init data
                |> Bar.setHeight height
                |> Bar.setWidth width
                |> Bar.render
            ]
        ]

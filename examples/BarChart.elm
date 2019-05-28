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
    [ { groupLabel = Just "A"
      , points =
            [ { point = PointBand ( "a", 10 )
              }
            , { point = PointBand ( "b", 13 )
              }
            ]
      }
    , { groupLabel = Just "B"
      , points =
            [ { point = PointBand ( "a", 11 )
              }
            , { point = PointBand ( "b", 23 )
              }
            ]
      }
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

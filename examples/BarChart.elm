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
    DataBand
        [ { groupLabel = Just "A"
          , points =
                [ ( "a", 10 )
                , ( "b", 13 )
                ]
          }
        , { groupLabel = Just "B"
          , points =
                [ ( "a", 11 )
                , ( "b", 23 )
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
                |> Bar.setShowColumnLabels True
                |> Bar.setDimensions
                    { margin = { top = 20, right = 20, bottom = 20, left = 30 }
                    , width = width
                    , height = height
                    }
                |> Bar.render
            ]
        ]

module Examples.BarChart exposing (data, main)

{-| This module shows how to build a simple bar chart.
-}

import Chart.Bar as Bar
import Chart.Type exposing (..)
import Html exposing (Html)
import Html.Attributes
import Svg exposing (..)
import Svg.Attributes exposing (..)


css : String
css =
    """
.chart-wrapper {
    border: 1px solid #666;
    margin-top: 10px;
}

.column-0 rect {
    fill: #70728c;
}

.column-1 rect {
    fill: #d8165e;
}
"""


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
        , { groupLabel = Just "C"
          , points =
                [ ( "a", 13 )
                , ( "b", 18 )
                ]
          }
        ]


dataSmall : Data
dataSmall =
    DataBand
        [ { groupLabel = Nothing
          , points =
                [ ( "a", 10 )
                , ( "b", 13 )
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
    Html.div []
        [ Html.node "style" [] [ text css ]
        , Html.div
            []
            [ Html.div
                [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
                , Html.Attributes.style "width" (String.fromFloat width ++ "px")
                , class "chart-wrapper"
                ]
                [ Bar.init data
                    |> Bar.setShowColumnLabels True
                    |> Bar.setDimensions
                        { margin = { top = 20, right = 20, bottom = 10, left = 20 }
                        , width = width
                        , height = height
                        }
                    |> Bar.render
                ]
            , Html.div
                [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
                , Html.Attributes.style "width" (String.fromFloat width ++ "px")
                , class "chart-wrapper"
                ]
                [ Bar.init data
                    |> Bar.setShowColumnLabels True
                    |> Bar.setOrientation Horizontal
                    |> Bar.setDimensions
                        { margin = { top = 20, right = 20, bottom = 10, left = 20 }
                        , width = width
                        , height = height
                        }
                    |> Bar.render
                ]
            ]
        ]

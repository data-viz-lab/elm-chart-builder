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
.wrapper {
  display: grid;
  grid-template-columns: 350px 350px;
  grid-gap: 20px;
  background-color: #fff;
  color: #444;
}

.chart-wrapper {
    border: 1px solid #666;
}

.column-0 rect {
    fill: #66c2a5;
}

.column-1 rect {
    fill: #fc8d62;
}

.column-2 rect {
    fill: #8da0cb;
}
"""


data : Data
data =
    DataBand
        [ { groupLabel = Just "A"
          , points =
                [ ( "a", 10 )
                , ( "b", 13 )
                , ( "c", 16 )
                ]
          }
        , { groupLabel = Just "B"
          , points =
                [ ( "a", 11 )
                , ( "b", 23 )
                , ( "c", 16 )
                ]
          }
        , { groupLabel = Just "C"
          , points =
                [ ( "a", 13 )
                , ( "b", 18 )
                , ( "c", 21 )
                ]
          }
        ]


dataStacked : Data
dataStacked =
    DataBand
        [ { groupLabel = Nothing
          , points =
                [ ( "a", -10 )
                , ( "b", 13 )
                ]
          }
        , { groupLabel = Nothing
          , points =
                [ ( "a", -12 )
                , ( "b", 16 )
                ]
          }
        , { groupLabel = Nothing
          , points =
                [ ( "a", -11 )
                , ( "b", 13 )
                ]
          }
        ]


width : Float
width =
    350


height : Float
height =
    250


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ text css ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div
                [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
                , Html.Attributes.style "width" (String.fromFloat width ++ "px")
                , class "chart-wrapper"
                ]
                [ Bar.init data
                    --|> Bar.setShowColumnLabels True
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
                    --|> Bar.setShowColumnLabels True
                    |> Bar.setLayout (Stacked NoDirection)
                    |> Bar.setDimensions
                        { margin = { top = 10, right = 20, bottom = 10, left = 20 }
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
                    --|> Bar.setShowColumnLabels True
                    |> Bar.setOrientation Horizontal
                    |> Bar.setDimensions
                        { margin = { top = 20, right = 20, bottom = 20, left = 20 }
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
                    --|> Bar.setShowColumnLabels True
                    |> Bar.setLayout (Stacked NoDirection)
                    |> Bar.setOrientation Horizontal
                    |> Bar.setDimensions
                        { margin = { top = 20, right = 10, bottom = 20, left = 10 }
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
                [ Bar.init dataStacked
                    --|> Bar.setShowColumnLabels True
                    |> Bar.setLayout (Stacked Diverging)
                    |> Bar.setOrientation Horizontal
                    |> Bar.setDimensions
                        { margin = { top = 20, right = 10, bottom = 20, left = 10 }
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
                [ Bar.init dataStacked
                    |> Bar.setLayout (Stacked Diverging)
                    |> Bar.setOrientation Vertical
                    |> Bar.setDimensions
                        { margin = { top = 20, right = 10, bottom = 20, left = 10 }
                        , width = width
                        , height = height
                        }
                    |> Bar.render
                ]
            ]
        ]

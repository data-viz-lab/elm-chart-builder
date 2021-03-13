module SquarePieChart exposing (main)

{-| This module shows how to build a simple squared pie chart
-}

import Chart.SquarePie as Pie
import Html exposing (Html)
import Html.Attributes exposing (class)


css : String
css =
    """
body {
  font-family: Sans-Serif;
}

"""


type alias Data =
    { x : String, y : Float }


data : List Data
data =
    [ { x = "a"
      , y = 10
      }
    , { x = "b"
      , y = 13
      }
    , { x = "c"
      , y = 16
      }
    ]


accessor : Pie.Accessor Data
accessor =
    Pie.Accessor .x .y


chart : Html msg
chart =
    Pie.init
        { width = 600
        }
        |> Pie.render ( data, accessor )


main : Html msg
main =
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div [ class "wrapper" ]
            [ Html.div [] [ chart ]
            ]
        ]

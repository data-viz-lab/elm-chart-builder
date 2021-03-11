module LineChartWithEvents exposing (main)

{-| A simple line chart with events
-}

import Axis
import Browser
import Browser.Events
import Chart.Line as Line
import Color
import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Process
import Scale.Color
import Task



-- STYLING


css : String
css =
    """
.axis path,
.axis line {
  stroke: #b7b7b7;
}

text {
  fill: #333;
  font-size: 16px;
}

.axis--y .domain {
  stroke: none;
}

.axis--y-right .tick {
  stroke-dasharray : 6 6;
  stroke-width: 0.5px;
}

.column text {
  font-size: 12px;
}

figure {
  margin: 0;
}

.pre-chart {
  display: flex;
  justify-content: center;
  align-items: center;
}
"""



-- MODEL


type alias Datum =
    { x : Float
    , y : Float
    }


type alias Data =
    List Datum


type alias Model =
    { hinted : Maybe ( Float, Float ) }



-- UPDATE


type Msg
    = Hint (Maybe ( Float, Float ))


update : Msg -> Model -> Model
update msg model =
    case msg of
        Hint response ->
            let
                _ =
                    Debug.log "hint" response
            in
            model



-- CHART CONFIGURATION


width : Float
width =
    1000


height : Float
height =
    600


accessor : Line.Accessor Datum
accessor =
    Line.continuous
        (Line.AccessorContinuous (always Nothing) .x .y)


data : Data
data =
    [ { x = 1991
      , y = 10
      }
    , { x = 1992
      , y = 16
      }
    , { x = 1993
      , y = 26
      }
    , { x = 1994
      , y = 27
      }
    ]


xAxis : Line.XAxis Float
xAxis =
    Line.axisBottom
        [ Axis.ticks (data |> List.map .x)
        , Axis.tickFormat (round >> String.fromInt)
        ]


chart : Model -> Html Msg
chart model =
    Line.init
        { margin = { top = 20, right = 175, bottom = 25, left = 80 }
        , width = width
        , height = height
        }
        |> Line.withXAxisContinuous xAxis
        |> Line.withColorPalette Scale.Color.tableau10
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.withEvent (Line.hoverOne Hint)
        |> Line.render ( data, accessor )



-- VIEW


attrs : List (Html.Attribute Msg)
attrs =
    [ style "height" (String.fromFloat (height + 20) ++ "px")
    , style "width" (String.fromFloat width ++ "px")
    , style "border" "1px solid #c4c4c4"
    ]


view : Model -> Html Msg
view model =
    Html.div [ style "font-family" "Sans-Serif" ]
        [ Html.node "style" [] [ Html.text css ]
        , Html.h2
            [ style "margin" "25px"
            , style "font-size" "20px"
            ]
            [ Html.text
                "Coronavirus, daily number of confirmed deaths, log scale"
            ]
        , Html.div
            [ style "background-color" "#fff"
            , style "color" "#444"
            , style "margin" "25px"
            ]
            [ Html.div attrs
                [ chart model
                ]
            ]
        ]



-- MAIN


main =
    Browser.sandbox
        { init = { hinted = Nothing }
        , view = view
        , update = update
        }

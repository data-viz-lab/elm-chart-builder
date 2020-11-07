module AnimatedLineChart exposing (main)

{-| This module shows how to build a simple animated line chart.
-}

import Array exposing (Array)
import Axis
import Browser
import Browser.Events
import Chart.Line as Line
import Html exposing (Html)
import Html.Attributes exposing (class, id, name, type_, value)
import Html.Events exposing (onClick)
import Interpolation exposing (Interpolator)
import Process
import Scale.Color
import Set
import Statistics exposing (extent)
import Task
import Time exposing (Posix)
import Transition exposing (Transition)


css : String
css =
    """
.wrapper {
  display: grid;
  grid-template-columns: 350px 350px;
  grid-gap: 20px;
  background-color: #fff;
  color: #444;
  margin: 25px;
}

.chart-wrapper {
    border: 1px solid #c4c4c4;
}

.axis path,
.axis line {
    stroke: #b7b7b7;
}

.axis text {
    fill: #333;
}

.line {
    stroke-width: 2px;
    fill: none;
}

.line-0 {
    stroke: crimson;
}

.line-1 {
    stroke: #3949ab;
}
"""


width : Float
width =
    350


height : Float
height =
    250


transitionSpeed =
    750


type alias Datum =
    { x : Float, y : Float, groupLabel : String }


type alias Data =
    List Datum


getDataByGroup : String -> Data
getDataByGroup group =
    data
        |> List.filter (\{ groupLabel } -> group == groupLabel)


data : Data
data =
    [ { groupLabel = "A"
      , x = 1991
      , y = 2
      }
    , { groupLabel = "A"
      , x = 1992
      , y = 4
      }
    , { groupLabel = "A"
      , x = 1993
      , y = 3
      }
    , { groupLabel = "B"
      , x = 1991
      , y = 8
      }
    , { groupLabel = "B"
      , x = 1992
      , y = 12
      }
    , { groupLabel = "B"
      , x = 1993
      , y = 6
      }
    , { groupLabel = "C"
      , x = 1991
      , y = 14
      }
    , { groupLabel = "C"
      , x = 1992
      , y = 18
      }
    , { groupLabel = "C"
      , x = 1993
      , y = 16
      }
    , { groupLabel = "D"
      , x = 1991
      , y = 16
      }
    , { groupLabel = "D"
      , x = 1992
      , y = 20
      }
    , { groupLabel = "D"
      , x = 1993
      , y = 18
      }
    ]


groups : Array String
groups =
    Array.fromList [ "A", "B", "C", "D" ]


xAxisTicks : List Float
xAxisTicks =
    data
        |> List.map .x
        |> Set.fromList
        |> Set.toList
        |> List.sort


accessor : Line.Accessor Datum
accessor =
    Line.continuous (Line.AccessorContinuous (.groupLabel >> Just) .x .y)


xAxis : Line.XAxis Float
xAxis =
    Line.axisBottom
        [ Axis.ticks xAxisTicks
        , Axis.tickFormat (round >> String.fromInt)
        ]


yAxis : Line.YAxis Float
yAxis =
    Line.axisLeft [ Axis.tickCount 5 ]


lineContinuous : Data -> Html msg
lineContinuous d =
    Line.init
        { margin = { top = 10, right = 40, bottom = 30, left = 30 }
        , width = width
        , height = height
        }
        |> Line.withXAxisContinuous xAxis
        |> Line.withYAxis yAxis
        |> Line.withLabels Line.xGroupLabel
        |> Line.withYDomain ( 0, 20 )
        |> Line.render ( d, accessor )


attrs : List (Html.Attribute msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


type alias Frame =
    Data


type alias Model =
    { transition : Transition Frame
    , currentGroup : String
    }


type Msg
    = Tick Int
    | StartAnimation String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick t ->
            ( { model
                | transition = Transition.step t model.transition
              }
            , Cmd.none
            )

        StartAnimation group ->
            let
                from =
                    getDataByGroup model.currentGroup

                to =
                    getDataByGroup group
            in
            ( { model
                | transition =
                    Transition.for transitionSpeed (interpolateValues from to)
                , currentGroup = group
              }
            , Cmd.none
            )


interpolateValues : Data -> Data -> Interpolator Data
interpolateValues from to =
    List.map2 interpolateValue from to
        |> Interpolation.inParallel


interpolateValue : Datum -> Datum -> Interpolator Datum
interpolateValue from to =
    Interpolation.map (\value -> { to | y = value })
        (Interpolation.float from.y to.y)


view : Model -> Html Msg
view model =
    let
        d =
            model.transition
                |> Transition.value
    in
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div [ class "wrapper" ]
            [ Html.h3 [] [ Html.text "Animated Line Chart" ]
            , Html.div [] (Array.map (\g -> selector (g == model.currentGroup) g) groups |> Array.toList)
            , Html.div attrs [ lineContinuous d ]
            ]
        ]


selector : Bool -> String -> Html Msg
selector checked group =
    Html.div []
        [ Html.input
            [ type_ "radio"
            , id group
            , name "selector"
            , value group
            , Html.Attributes.checked checked
            , Html.Events.onInput StartAnimation
            ]
            []
        , Html.label [] [ Html.text group ]
        ]


init : () -> ( Model, Cmd Msg )
init () =
    ( { transition = Transition.constant <| getDataByGroup "A", currentGroup = "A" }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    if Transition.isComplete model.transition then
        Sub.none

    else
        Browser.Events.onAnimationFrameDelta (round >> Tick)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

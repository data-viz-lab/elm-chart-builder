module AnimatedBarChart exposing (main)

{-| -}

import Array exposing (Array)
import Axis
import Browser
import Browser.Events
import Chart.Bar as Bar
import Color
import Dict exposing (Dict)
import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Interpolation exposing (Interpolator)
import Process
import Scale.Color
import Statistics exposing (extent)
import Task
import Transition exposing (Transition)


css : String
css =
    """
body {
  font-family: Sans-Serif;
}

.wrapper {
  display: grid;
  grid-template-rows: repeat(5, 1fr);
  grid-template-columns: repeat(1, 1fr);
  grid-gap: 20px;
  background-color: #fff;
  color: #444;
  margin: 25px;
}

.chart-wrapper {
  border: 1px solid #c4c4c4;
  grid-column: 1 / 1;
  grid-row: 1 / 5;
}

.header-wrapper {
  grid-column: 1 / 1;
  grid-row: 1 / 2;
  margin-left: 10px;
}

.axis text {
  font-size: 14px;
}

.axis path,
.axis line {
  stroke: #b7b7b7;
}

text {
  fill: #333;
}

h1 {
  font-size: 24px;
}

footer {
    font-size: 12px;
    margin: 20px;
}

figure {
  margin: 0;
}
"""


transitionSpeed =
    750


transitionStep =
    1000


width : Float
width =
    550


height : Float
height =
    350


valueFormatter : Float -> String
valueFormatter =
    FormatNumber.format { usLocale | decimals = 0, thousandSeparator = "," }


type alias Datum =
    { country : String
    , population : Float
    , year : String
    }


type alias Data =
    List Datum


dataBlock : String -> String -> Float -> Datum
dataBlock country year population =
    { country = country
    , population = population * 1000
    , year = year
    }


years : Array String
years =
    Array.fromList
        ([ 0, 1000, 1500, 1600, 1700, 1820, 1870, 1913, 1950, 1973, 1998 ]
            |> List.map String.fromInt
        )


westernEurope : Data
westernEurope =
    List.map2 (dataBlock "westernEurope")
        (Array.toList years)
        [ 24700, 25413, 57268, 73778, 81460, 132888, 187532, 261007, 305060, 358390, 388399 ]


latinAmerica : Data
latinAmerica =
    List.map2 (dataBlock "latinAmerica")
        (Array.toList years)
        [ 5, 600, 11400, 17500, 8600, 12050, 21220, 39973, 80515, 165837, 308450, 507623 ]


africa : Data
africa =
    List.map2 (dataBlock "africa")
        (Array.toList years)
        [ 16500, 33000, 46000, 55000, 61000, 74208, 90466, 124697, 228342, 387645, 759954 ]


data : Data
data =
    westernEurope ++ latinAmerica ++ africa


getDataByYear : Int -> Data
getDataByYear idx =
    data
        |> List.filter (\{ year } -> year == (Array.get idx years |> Maybe.withDefault ""))


domain : ( Float, Float )
domain =
    data
        |> List.map .population
        |> extent
        |> Maybe.withDefault ( 0, 0 )


type alias Frame =
    Data


type alias Model =
    { transition : Transition Frame
    , idx : Int
    }


type Msg
    = Tick Int
    | StartAnimation Frame


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick t ->
            ( { model
                | transition = Transition.step t model.transition
              }
            , Cmd.none
            )

        StartAnimation from ->
            let
                to =
                    Transition.value model.transition

                newIdx =
                    model.idx + 1

                lastIdx =
                    Array.length years - 1
            in
            ( { model
                | transition =
                    Transition.for transitionSpeed (interpolateValues to from)
                , idx = newIdx
              }
            , if model.idx == 0 then
                Task.succeed (StartAnimation <| getDataByYear newIdx)
                    |> Task.perform identity

              else if lastIdx >= newIdx then
                Process.sleep transitionStep
                    |> Task.andThen
                        (\_ ->
                            Task.succeed (StartAnimation <| getDataByYear newIdx)
                        )
                    |> Task.perform identity

              else
                Cmd.none
            )


interpolateValues : Data -> Data -> Interpolator Data
interpolateValues from to =
    List.map2 interpolateValue from to
        |> Interpolation.inParallel


interpolateValue : Datum -> Datum -> Interpolator Datum
interpolateValue from to =
    Interpolation.map (\value -> { to | population = value })
        (Interpolation.float from.population to.population)


accessor : Bar.Accessor Datum
accessor =
    Bar.Accessor (.year >> Just) .country .population


attrs : List (Html.Attribute Msg)
attrs =
    [ Html.Attributes.style "height" (String.fromFloat height ++ "px")
    , Html.Attributes.style "width" (String.fromFloat width ++ "px")
    , class "chart-wrapper"
    ]


yAxis : Bar.YAxis Float
yAxis =
    Bar.axisLeft
        [ Axis.tickCount 5
        , Axis.tickFormat valueFormatter
        ]


horizontalGrouped : Data -> Html Msg
horizontalGrouped d =
    Bar.init
        { margin = { top = 60, right = 20, bottom = 30, left = 125 }
        , width = width
        , height = height
        }
        |> Bar.withColorPalette [ Color.rgb255 166 189 219 ]
        |> Bar.withOrientation Bar.horizontal
        |> Bar.withYAxis yAxis
        |> Bar.withYDomain domain
        |> Bar.render ( d, accessor )


view : Model -> Html Msg
view model =
    let
        d =
            model.transition
                |> Transition.value

        year =
            Array.get (model.idx - 1) years
                |> Maybe.withDefault ""
    in
    Html.div []
        [ Html.node "style" [] [ Html.text css ]
        , Html.div
            [ class "wrapper" ]
            [ Html.div [ class "header-wrapper" ]
                [ Html.h1 []
                    [ Html.text ("World Population in " ++ year)
                    ]
                ]
            , Html.div attrs [ horizontalGrouped d ]
            ]
        , Html.footer []
            [ Html.a
                [ Html.Attributes.href
                    "https://en.wikipedia.org/wiki/World_population"
                ]
                [ Html.text "Data source" ]
            ]

        --https://en.wikipedia.org/wiki/World_population
        ]


init : () -> ( Model, Cmd Msg )
init () =
    ( { transition = Transition.constant <| getDataByYear 0, idx = 0 }
    , Task.perform identity (Task.succeed (StartAnimation <| getDataByYear 1))
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

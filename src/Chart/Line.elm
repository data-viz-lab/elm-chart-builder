module Chart.Line exposing
    ( DataGroupTime, Accessor
    , init
    , render
    , setAxisContinousXTickCount, setAxisContinousXTickFormat, setAxisContinousXTicks, setAxisContinousYTickCount, setAxisContinousYTickFormat, setAxisContinousYTicks, setDesc, setDimensions, setHeight, setMargin, setShowYAxis, setTitle, setWidth
    , setDomain, setShowXAxis
    )

{-| This is the line chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

&#9888; This module is still a work in progress and it has limited funcionality!


# Chart Data Format

@docs DataGroupTime, Accessor


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs setAxisContinousXTickCount, setAxisContinousXTickFormat, setAxisContinousXTicks, setAxisContinousYTickCount, setAxisContinousYTickFormat, setAxisContinousYTicks, setDesc, setDimensions, setHeight, setMargin, setShowContinousXAxis, setShowYAxis, setTitle, setWidth

-}

import Chart.Internal.Line
    exposing
        ( renderLineGrouped
        )
import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type as Type
    exposing
        ( AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , Config
        , DomainTime
        , Layout(..)
        , Margin
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setAxisContinousXTickCount
        , setAxisContinousXTickFormat
        , setAxisContinousXTicks
        , setAxisContinousYTickCount
        , setAxisContinousYTickFormat
        , setAxisContinousYTicks
        , setDimensions
        , setShowXAxis
        , setShowYAxis
        , setTitle
        )
import Html exposing (Html)
import Time exposing (Posix)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| Line chart data format.

    dataGroupTime : Bar.DataGroupTime
    dataGroupTime =
        { groupLabel = Just "A"
        , points =
            [ ( 1, 10 )
            , ( 2, 13 )
            , ( 16, 16 )
            ]
        }

-}
type alias DataGroupTime =
    Type.DataGroupTime


{-| Initializes the line chart with a default config

    Line.init
        |> Line.render data

-}
init : Config
init =
    defaultConfig


{-| Renders the line chart, after initialisation and customisation

    data : List DataGroupTime
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.render data

-}
render : ( List data, Accessor data ) -> Config -> Html msg
render ( externalData, accessor ) config =
    let
        c =
            fromConfig config

        data =
            Type.externalToDataTime (Type.toExternalData externalData) accessor
    in
    case c.layout of
        Grouped _ ->
            renderLineGrouped ( data, config )

        Stacked _ ->
            Html.text "TODO"


{-| Sets the outer height of the line chart
Default value: 400

    Line.init
        |> Line.setHeight 600
        |> Line.render data

-}
setHeight : Float -> Config -> Config
setHeight value config =
    Type.setHeight value config


{-| Sets the outer width of the line chart
Default value: 400

    Line.init
        |> Line.setWidth 600
        |> Line.render data

-}
setWidth : Float -> Config -> Config
setWidth value config =
    Type.setWidth value config


{-| Sets the margin values in the config

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Line.init
        |> Line.setMargin margin
        |> Line.render data

-}
setMargin : Margin -> Config -> Config
setMargin value config =
    Type.setMargin value config


{-| Set the ticks for the horizontal axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setContinousXTicks [ 1, 2, 3 ]
        |> Line.render data

-}
setAxisContinousXTicks : List Float -> Config -> Config
setAxisContinousXTicks ticks config =
    Type.setAxisContinousXTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the horizontal axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setContinousDataTickCount 5
        |> Line.render data

-}
setAxisContinousXTickCount : Int -> Config -> Config
setAxisContinousXTickCount count config =
    Type.setAxisContinousXTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks for the horizontal axis
Defaults to `Scale.tickFormat`

    Line.init
        |> Line.setContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render data

-}
setAxisContinousXTickFormat : (Float -> String) -> Config -> Config
setAxisContinousXTickFormat f config =
    Type.setAxisContinousXTickFormat (Type.CustomTickFormat f) config


{-| Set the ticks for the vertical axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setAxisContinousYDataTicks [ 1, 2, 3 ]
        |> Line.render data

-}
setAxisContinousYTicks : List Float -> Config -> Config
setAxisContinousYTicks ticks config =
    Type.setAxisContinousYTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the vertical axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setContinousDataTickCount 5
        |> Line.render data

-}
setAxisContinousYTickCount : Int -> Config -> Config
setAxisContinousYTickCount count config =
    Type.setAxisContinousYTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks in the vertical axis
Defaults to `Scale.tickFormat`

    Line.init
        |> Line.setContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render data

-}
setAxisContinousYTickFormat : (Float -> String) -> Config -> Config
setAxisContinousYTickFormat f config =
    Type.setAxisContinousYTickFormat (Type.CustomTickFormat f) config


{-| Sets margin, width and height all at once
Prefer this method from the individual ones when you need to set all three at once.

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Line.init
        |> Line.setDimensions
            { margin = margin
            , width = 400
            , height = 400
            }
        |> Line.render data

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions value config =
    Type.setDimensions value config


{-| Sets the domain value in the config
If not set, the domain is calculated from the data

    Line.init
        |> Line.setDomain (DomainTime { horizontal = ( 1, 1 ), vertical = ( 0, 20 ) })
        |> Line.render data

-}
setDomain : DomainTime -> Config -> Config
setDomain value config =
    Type.setDomainTime value config


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    Line.init
        |> Line.setDesc "This is an accessible chart, with a desc element"
        |> Line.render data

-}
setDesc : String -> Config -> Config
setDesc value config =
    Type.setDesc value config


{-| Sets an accessible title for the svg chart.
Default value: ""

    Line.init
        |> Line.setTitle "This is a chart"
        |> Line.render data

-}
setTitle : String -> Config -> Config
setTitle value config =
    Type.setTitle value config


{-| Sets the showContinousXAxis boolean value in the config
Default value: True
This shows the bar's horizontal axis

    Line.init
        |> Bar.setShowXAxis False
        |> Bar.render data

-}
setShowXAxis : Bool -> Config -> Config
setShowXAxis value config =
    Type.setShowXAxis value config


{-| Sets the showYAxis boolean value in the config
Default value: True
This shows the bar's vertical axis

    Line.init
        |> Bar.setShowYAxis False
        |> Bar.render data

-}
setShowYAxis : Bool -> Config -> Config
setShowYAxis value config =
    Type.setShowYAxis value config



-- ACCESSOR


{-| The data accessors

    type alias Accessor data =
        { xGroup : data -> String
        , xValue : data -> String
        , yValue : data -> Float
        }

-}
type alias Accessor data =
    { xGroup : data -> String
    , xValue : data -> Posix
    , yValue : data -> Float
    }

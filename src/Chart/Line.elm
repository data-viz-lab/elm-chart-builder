module Chart.Line exposing
    ( Accessor, AccessorTime, AccessorLinear, time, linear
    , stackedLayout
    , init
    , render
    , setAxisXContinousTickCount, setAxisXContinousTickFormat, setAxisXContinousTicks, setAxisYContinousTickCount, setAxisYContinousTickFormat, setAxisYContinousTicks, setCurve, setDesc, setDimensions, setHeight, setMargin, setShowAxisX, setShowAxisY, setTitle, setWidth, setDomainTimeX, setDomainY, setDomainLinearX, setLayout
    )

{-| This is the line chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

The Line module draws time lines.
It expects the X axis to plot time data and the Y axis to plot linear data.

&#9888; This module is still a work in progress and it has limited funcionality!


# Chart Data Format

@docs Accessor, AccessorTime, AccessorLinear, time, linear


# Chart Layout

@docs stackedLayout


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs setAxisXContinousTickCount, setAxisXContinousTickFormat, setAxisXContinousTicks, setAxisYContinousTickCount, setAxisYContinousTickFormat, setAxisYContinousTicks, setCurve, setDesc, setDimensions, setHeight, setMargin, setShowAxisX, setShowAxisY, setTitle, setWidth, setDomainTimeX, setDomainY, setDomainLinearX, setLayout

-}

import Chart.Internal.Line
    exposing
        ( renderLineGrouped
        , renderLineStacked
        )
import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type as Type
    exposing
        ( AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , Config
        , Direction(..)
        , Layout(..)
        , Margin
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setAxisXContinousTickCount
        , setAxisXContinousTickFormat
        , setAxisXContinousTicks
        , setAxisYContinousTickCount
        , setAxisYContinousTickFormat
        , setAxisYContinousTicks
        , setDimensions
        , setShowAxisX
        , setShowAxisY
        , setTitle
        )
import Html exposing (Html)
import SubPath exposing (SubPath)
import Time exposing (Posix)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| The data accessors

A line chart can have the x axis as linear or time data.

    type Accessor data
        = AccessorLinear (accessorLinear data)
        | AccessorTime (accessorTime data)

-}
type alias Accessor data =
    Type.AccessorLinearGroup data


{-| The accessor structure for x time lines.
-}
type alias AccessorTime data =
    { xGroup : data -> String
    , xValue : data -> Posix
    , yValue : data -> Float
    }


{-| The accessor constructor for x time lines.

    Line.time (Line.AccessorTime .groupLabel .x .y)

-}
time : Type.AccessorTimeStruct data -> Accessor data
time acc =
    Type.AccessorTime acc


{-| The accessor structure for x linear lines.
-}
type alias AccessorLinear data =
    { xGroup : data -> String
    , xValue : data -> Float
    , yValue : data -> Float
    }


{-| The accessor constructor for x linear lines.

    Line.linear (Line.AccessorLinear .groupLabel .x .y)

-}
linear : Type.AccessorLinearStruct data -> Accessor data
linear acc =
    Type.AccessorLinear acc


{-| Initializes the line chart with a default config

    data : List Data
    data =
        [ { groupLabel = "A"
          , x = Time.millisToPosix 1579275175634
          , y = 10
          }
        , { groupLabel = "A"
          , x = Time.millisToPosix 1579285175634
          , y = 16
          }
        , { groupLabel = "B"
          , x = Time.millisToPosix 1579275175634
          , y = 13
          }
        , { groupLabel = "B"
          , x = Time.millisToPosix 1579285175634
          , y = 23
          }
        ]

    accessor : Line.Accessor data
    accessor =
        Line.time (Line.accessorTime .groupLabel .x .y)

    Line.init
        |> Line.render (data, accessor)

-}
init : Config
init =
    defaultConfig


{-| Renders the line chart, after initialisation and customisation

    Line.init
        |> Line.render ( data, accessor )

-}
render : ( List data, Type.AccessorLinearGroup data ) -> Config -> Html msg
render ( externalData, accessor ) config =
    let
        c =
            fromConfig config

        data =
            Type.externalToDataLinearGroup (Type.toExternalData externalData) accessor
    in
    case c.layout of
        Grouped _ ->
            renderLineGrouped ( data, config )

        Stacked _ ->
            renderLineStacked ( data, config )


{-| Sets the outer height of the line chart
Default value: 400

    Line.init
        |> Line.setHeight 600
        |> Line.render ( data, accessor )

-}
setHeight : Float -> Config -> Config
setHeight value config =
    Type.setHeight value config


{-| Sets the outer width of the line chart
Default value: 400

    Line.init
        |> Line.setWidth 600
        |> Line.render ( data, accessor )

-}
setWidth : Float -> Config -> Config
setWidth value config =
    Type.setWidth value config


{-| Sets the margin values in the config

It follows d3s [margin convention](https://bl.ocks.org/mbostock/3019563).

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Line.init
        |> Line.setMargin margin
        |> Line.render (data, accessor)

-}
setMargin : Margin -> Config -> Config
setMargin value config =
    Type.setMargin value config


{-| Set the ticks for the time axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setContinousXTicks [ 1, 2, 3 ]
        |> Line.render ( data, accessor )

-}
setAxisXContinousTicks : List Float -> Config -> Config
setAxisXContinousTicks ticks config =
    Type.setAxisXContinousTicks (Type.CustomTicks ticks) config


{-| Sets the line curve shape
Defaults to `Shape.linearCurve`

See [https://package.elm-lang.org/packages/gampleman/elm-visualization/latest/Shape](elm-visualization/latest/Shape)
for more info.

    Line.init
        |> Line.curve Shape.monotoneInXCurve
        |> Line.render ( data, accessor )

-}
setCurve : (List ( Float, Float ) -> SubPath) -> Config -> Config
setCurve curve config =
    Type.setCurve curve config


{-| Sets the approximate number of ticks for the time axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setContinousDataTickCount 5
        |> Line.render ( data, accessor )

-}
setAxisXContinousTickCount : Int -> Config -> Config
setAxisXContinousTickCount count config =
    Type.setAxisXContinousTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks for the time axis
Defaults to `Scale.tickFormat`

    Line.init
        |> Line.setContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render ( data, accessor )

-}
setAxisXContinousTickFormat : (Float -> String) -> Config -> Config
setAxisXContinousTickFormat f config =
    Type.setAxisXContinousTickFormat (Type.CustomTickFormat f) config


{-| Set the ticks for the y axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setAxisYContinousDataTicks [ 1, 2, 3 ]
        |> Line.render ( data, accessor )

-}
setAxisYContinousTicks : List Float -> Config -> Config
setAxisYContinousTicks ticks config =
    Type.setAxisYContinousTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the y axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setContinousDataTickCount 5
        |> Line.render ( data, accessor )

-}
setAxisYContinousTickCount : Int -> Config -> Config
setAxisYContinousTickCount count config =
    Type.setAxisYContinousTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks in the y axis
Defaults to `Scale.tickFormat`

    Line.init
        |> Line.setContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render ( data, accessor )

-}
setAxisYContinousTickFormat : (Float -> String) -> Config -> Config
setAxisYContinousTickFormat f config =
    Type.setAxisYContinousTickFormat (Type.CustomTickFormat f) config


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
        |> Line.render (data, accessor)

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions value config =
    Type.setDimensions value config


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    Line.init
        |> Line.setDesc "This is an accessible chart, with a desc element"
        |> Line.render ( data, accessor )

-}
setDesc : String -> Config -> Config
setDesc value config =
    Type.setDesc value config


{-| Sets an accessible title for the svg chart.
Default value: ""

    Line.init
        |> Line.setTitle "This is a chart"
        |> Line.render ( data, accessor )

-}
setTitle : String -> Config -> Config
setTitle value config =
    Type.setTitle value config


{-| Sets the showAxisX boolean value in the config.

Default value: True

By convention the X axix is the x one, but
if the layout is changed to y, then the X axis
represents the y one.

    Line.init
        |> Line.setShowAxisX False
        |> Line.render data

-}
setShowAxisX : Bool -> Config -> Config
setShowAxisX value config =
    Type.setShowAxisX value config


{-| Sets the showAxisY boolean value in the config.

Default value: True

By convention the Y axix is the y one, but
if the layout is changed to x, then the Y axis
represents the x one.

    Line.init
        |> Line.setShowAxisY False
        |> Line.render data

-}
setShowAxisY : Bool -> Config -> Config
setShowAxisY value config =
    Type.setShowAxisY value config


{-| Sets the x domain of a time line chart

If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init
        |> Line.setDomainTimeX ( Time.millisToPosix 1579275175634, 10 )
        |> Line.render ( data, accessor )

-}
setDomainTimeX : ( Posix, Posix ) -> Config -> Config
setDomainTimeX value config =
    Type.setDomainTimeX value config


{-| Sets the y domain of a line chart

This is always a linear domain, not a time domain.
If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init
        |> Line.setDomainY ( Time.millisToPosix 1579275175634, Time.millisToPosix 1579375175634 )
        |> Line.render ( data, accessor )

-}
setDomainY : ( Float, Float ) -> Config -> Config
setDomainY value config =
    Type.setDomainLinearAndTimeY value config


{-| Sets the x domain of a linear line chart

If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init
        |> Line.setDomainLinearX ( 0, 10 )
        |> Line.render ( data, accessor )

-}
setDomainLinearX : ( Float, Float ) -> Config -> Config
setDomainLinearX value config =
    Type.setDomainLinearX value config


{-| Sets the line layout.

Values: `Line.stackedLayout` or `Line.groupedLayout`

Default value: Line.groupedLayout

    Line.init
        |> Line.setLayout Line.stackedLayout
        |> Line.render ( data, accessor )

-}
setLayout : Layout -> Config -> Config
setLayout value config =
    Type.setLayout value config


{-| Stacked layout type

    Line.init
        |> Line.setLayout Line.stackedLayout
        |> Line.render ( data, accessor )

-}
stackedLayout : Layout
stackedLayout =
    Stacked NoDirection

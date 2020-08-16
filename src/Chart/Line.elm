module Chart.Line exposing
    ( Accessor, AccessorTime, AccessorLinear, time, linear
    , init
    , render
    , withXAxisContinousTickCount, withColorPalette, withTitle, withDesc, withXAxisContinousTickFormat, withXAxisContinousTicks, withYAxisContinousTickCount, withYAxisContinousTickFormat, withYAxisContinousTicks, withCurve, withXAxis, withYAxis, withXDomainTime, withYDomain, withLinearDomainX, withStackedLayout, withGroupedLayout
    , withSymbols
    )

{-| This is the line chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

I expects the X axis to plot time or linear data and the Y axis to plot linear data.


# Chart Data Format

@docs Accessor, AccessorTime, AccessorLinear, time, linear


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs withXAxisContinousTickCount, withColorPalette, withTitle, withDesc, withXAxisContinousTickFormat, withXAxisContinousTicks, withYAxisContinousTickCount, withYAxisContinousTickFormat, withYAxisContinousTicks, withCurve, withXAxis, withYAxis, withXDomainTime, withYDomain, withLinearDomainX, withStackedLayout, withGroupedLayout

@docs withSymbols

-}

import Chart.Internal.Line
    exposing
        ( renderLineGrouped
        , renderLineStacked
        )
import Chart.Internal.Symbol as InternalSymbol exposing (Symbol(..))
import Chart.Internal.Type as Type
    exposing
        ( AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , ColorResource(..)
        , Config
        , Direction(..)
        , Layout(..)
        , Margin
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setDimensions
        , setLayout
        , setSvgDesc
        , setSvgTitle
        , setXAxis
        , setXAxisContinousTickCount
        , setXAxisContinousTickFormat
        , setXAxisContinousTicks
        , setYAxis
        , setYAxisContinousTickCount
        , setYAxisContinousTickFormat
        , setYAxisContinousTicks
        )
import Color exposing (Color)
import Html exposing (Html)
import SubPath exposing (SubPath)
import Time exposing (Posix)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


type alias RequiredConfig =
    { margin : Margin
    , width : Float
    , height : Float
    }


{-| The data accessors

A line chart can have the X axis as linear or time data.

    type Accessor data
        = AccessorLinear (accessorLinear data)
        | AccessorTime (accessorTime data)

-}
type alias Accessor data =
    Type.AccessorLinearTime data


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
        { margin = margin
        , width = width
        , height = height
        }
        |> Line.render (data, accessor)

-}
init : RequiredConfig -> Config
init c =
    defaultConfig
        |> withGroupedLayout
        |> setDimensions { margin = c.margin, width = c.width, height = c.height }


{-| Renders the line chart, after initialisation and customisation

    Line.init
        |> Line.render ( data, accessor )

-}
render : ( List data, Type.AccessorLinearTime data ) -> Config -> Html msg
render ( externalData, accessor ) config =
    let
        c =
            fromConfig config

        data =
            Type.externalToDataLinearGroup (Type.toExternalData externalData) accessor
    in
    case c.layout of
        GroupedLine ->
            renderLineGrouped ( data, config )

        StackedLine ->
            renderLineStacked ( data, config )

        _ ->
            -- TODO
            Html.text ""


{-| Explicitly sets the ticks for the X axis

Defaults to elm-visualization `Scale.ticks`

    Line.init
        |> Line.withContinousXTicks [ 1, 2, 3 ]
        |> Line.render ( data, accessor )

-}
withXAxisContinousTicks : List Float -> Config -> Config
withXAxisContinousTicks ticks config =
    Type.setXAxisContinousTicks (Type.CustomTicks ticks) config


{-| Sets the line curve shape

Defaults to `Shape.linearCurve`

See [https://package.elm-lang.org/packages/gampleman/elm-visualization/latest/Shape](elm-visualization/latest/Shape)
for more info.

    Line.init
        |> Line.curve Shape.monotoneInXCurve
        |> Line.render ( data, accessor )

-}
withCurve : (List ( Float, Float ) -> SubPath) -> Config -> Config
withCurve curve config =
    Type.setCurve curve config


{-| Sets the approximate number of ticks for the X axis

Defaults to elm-visualization `Scale.ticks`

    Line.init
        |> Line.withContinousDataTickCount 5
        |> Line.render ( data, accessor )

-}
withXAxisContinousTickCount : Int -> Config -> Config
withXAxisContinousTickCount count config =
    Type.setXAxisContinousTickCount (Type.CustomTickCount count) config


{-| Sets the tick formatting for the X axis

Defaults to elm-visualization `Scale.tickFormat`

    Line.init
        |> Line.setXAxisContinousTickFormat (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render ( data, accessor )

-}
withXAxisContinousTickFormat : (Float -> String) -> Config -> Config
withXAxisContinousTickFormat f config =
    Type.setXAxisContinousTickFormat (Type.CustomTickFormat f) config


{-| Explicitly sets the ticks for the Y axis

Defaults to `Scale.ticks`

    Line.init
        |> Line.withYAxisContinousDataTicks [ 1, 2, 3 ]
        |> Line.render ( data, accessor )

-}
withYAxisContinousTicks : List Float -> Config -> Config
withYAxisContinousTicks ticks config =
    Type.setYAxisContinousTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the y axis

Defaults to `Scale.ticks`

    Line.init
        |> Line.withContinousDataTickCount 5
        |> Line.render ( data, accessor )

-}
withYAxisContinousTickCount : Int -> Config -> Config
withYAxisContinousTickCount count config =
    Type.setYAxisContinousTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks in the y axis

Defaults to `Scale.tickFormat`

    Line.init
        |> Line.withContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render ( data, accessor )

-}
withYAxisContinousTickFormat : (Float -> String) -> Config -> Config
withYAxisContinousTickFormat f config =
    Type.setYAxisContinousTickFormat (Type.CustomTickFormat f) config


{-| Show or Hide the X axis

Default value: True

    Line.init
        |> Line.withXAxis False
        |> Line.render data

-}
withXAxis : Bool -> Config -> Config
withXAxis value config =
    Type.setXAxis value config


{-| Show or hide the Y axis.

Default value: True

    Line.init
        |> Line.withYAxis False
        |> Line.render data

-}
withYAxis : Bool -> Config -> Config
withYAxis value config =
    Type.setYAxis value config


{-| Sets the Y domain of a time line chart

If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init
        |> Line.withXDomainTime ( Time.millisToPosix 1579275175634, 10 )
        |> Line.render ( data, accessor )

-}
withXDomainTime : ( Posix, Posix ) -> Config -> Config
withXDomainTime value config =
    Type.setDomainTimeX value config


{-| Sets the Y domain of a line chart

This is always a linear domain, not a time domain.
If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init
        |> Line.withYDomain ( Time.millisToPosix 1579275175634, Time.millisToPosix 1579375175634 )
        |> Line.render ( data, accessor )

-}
withYDomain : ( Float, Float ) -> Config -> Config
withYDomain value config =
    Type.setDomainLinearAndTimeY value config


{-| Sets the Y domain of a linear line chart

If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init
        |> Line.withLinearDomainX ( 0, 10 )
        |> Line.render ( data, accessor )

-}
withLinearDomainX : ( Float, Float ) -> Config -> Config
withLinearDomainX value config =
    Type.setDomainLinearX value config


{-| Sets an accessible, long-text description for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Line.init
        |> Line.withDesc "This is an accessible chart, with a desc element"
        |> Line.render ( data, accessor )

-}
withDesc : String -> Config -> Config
withDesc value config =
    Type.setSvgDesc value config


{-| Sets an accessible title for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Line.init
        |> Line.withTitle "Line chart"
        |> Line.render ( data, accessor )

-}
withTitle : String -> Config -> Config
withTitle value config =
    Type.setSvgTitle value config


{-| Sets the color palette for the chart.

    palette =
        -- From elm-visualization
        Scale.Color.tableau10

    Line.init
        |> Line.withColorPalette palette
        |> Line.render (data, accessor)

-}
withColorPalette : List Color -> Config -> Config
withColorPalette palette config =
    Type.setColorResource (ColorPalette palette) config


{-| Creates a stacked line chart.

It takes a direction: `diverging` or `noDirection`

    Line.init
        |> Line.withStackedLayout
        |> Line.render ( data, accessor )

-}
withStackedLayout : Config -> Config
withStackedLayout config =
    Type.setLayout Type.StackedLine config


{-| Creates a grouped line chart.

    Line.init
        |> Line.withGroupedLayout
        |> Line.render ( data, accessor )

-}
withGroupedLayout : Config -> Config
withGroupedLayout config =
    Type.setLayout GroupedLine config



--SYMBOLS


{-| Pass a list of symbols to the line chart, one per data group.
If the list is empty, no symbols are rendered.

Default value: []

    defaultLayoutConfig
        |> withSymbols [ Circle, Corner, Triangle ]

-}
withSymbols : List Symbol -> Config -> Config
withSymbols =
    Type.setIcons

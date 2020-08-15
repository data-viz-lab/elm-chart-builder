module Chart.Line exposing
    ( Accessor, AccessorTime, AccessorLinear, time, linear
    , init
    , render
    , withAxisXContinousTickCount, withColorPalette, withTitle, withDesc, withAxisXContinousTickFormat, withAxisXContinousTicks, withAxisYContinousTickCount, withAxisYContinousTickFormat, withAxisYContinousTicks, withCurve, withShowAxisX, withShowAxisY, withDomainTimeX, withDomainY, withDomainLinearX, withLayout
    , Symbol, grouped, stacked, withSymbols
    )

{-| This is the line chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

The Line module draws time lines.
I expects the X axis to plot time data and the Y axis to plot linear data.

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

@docs withAxisXContinousTickCount, withColorPalette, withTitle, withDesc, withAxisXContinousTickFormat, withAxisXContinousTicks, withAxisYContinousTickCount, withAxisYContinousTickFormat, withAxisYContinousTicks, withCurve, withShowAxisX, withShowAxisY, withDomainTimeX, withDomainY, withDomainLinearX, withLayout

@docs BarSymbol, symbolCircle, symbolCorner, symbolCustom, symbolTriangle, withSymbolHeight, withSymbolIdentifier, withSymbolPaths, withSymbolUseGap, withSymbolWidth

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
        , setAxisXContinousTickCount
        , setAxisXContinousTickFormat
        , setAxisXContinousTicks
        , setAxisYContinousTickCount
        , setAxisYContinousTickFormat
        , setAxisYContinousTicks
        , setDimensions
        , setLayout
        , setShowAxisX
        , setShowAxisY
        , setSvgDesc
        , setSvgTitle
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
init : RequiredConfig -> Config
init c =
    defaultConfig
        -- TODO: why?
        |> withLayout grouped
        |> setDimensions { margin = c.margin, width = c.width, height = c.height }


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
        GroupedLine ->
            renderLineGrouped ( data, config )

        StackedLine ->
            renderLineStacked ( data, config )

        _ ->
            -- TODO
            Html.text ""


{-| Set the ticks for the time axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.withContinousXTicks [ 1, 2, 3 ]
        |> Line.render ( data, accessor )

-}
withAxisXContinousTicks : List Float -> Config -> Config
withAxisXContinousTicks ticks config =
    Type.setAxisXContinousTicks (Type.CustomTicks ticks) config


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


{-| Sets the approximate number of ticks for the time axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.withContinousDataTickCount 5
        |> Line.render ( data, accessor )

-}
withAxisXContinousTickCount : Int -> Config -> Config
withAxisXContinousTickCount count config =
    Type.setAxisXContinousTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks for the time axis
Defaults to `Scale.tickFormat`

    Line.init
        |> Line.withContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render ( data, accessor )

-}
withAxisXContinousTickFormat : (Float -> String) -> Config -> Config
withAxisXContinousTickFormat f config =
    Type.setAxisXContinousTickFormat (Type.CustomTickFormat f) config


{-| Set the ticks for the y axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.withAxisYContinousDataTicks [ 1, 2, 3 ]
        |> Line.render ( data, accessor )

-}
withAxisYContinousTicks : List Float -> Config -> Config
withAxisYContinousTicks ticks config =
    Type.setAxisYContinousTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the y axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.withContinousDataTickCount 5
        |> Line.render ( data, accessor )

-}
withAxisYContinousTickCount : Int -> Config -> Config
withAxisYContinousTickCount count config =
    Type.setAxisYContinousTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks in the y axis
Defaults to `Scale.tickFormat`

    Line.init
        |> Line.withContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render ( data, accessor )

-}
withAxisYContinousTickFormat : (Float -> String) -> Config -> Config
withAxisYContinousTickFormat f config =
    Type.setAxisYContinousTickFormat (Type.CustomTickFormat f) config


{-| Sets the showAxisX boolean value in the config.

Default value: True

By convention the X axix is the x one, but
if the layout is changed to y, then the X axis
represents the y one.

    Line.init
        |> Line.withShowAxisX False
        |> Line.render data

-}
withShowAxisX : Bool -> Config -> Config
withShowAxisX value config =
    Type.setShowAxisX value config


{-| Sets the showAxisY boolean value in the config.

Default value: True

By convention the Y axix is the y one, but
if the layout is changed to x, then the Y axis
represents the x one.

    Line.init
        |> Line.withShowAxisY False
        |> Line.render data

-}
withShowAxisY : Bool -> Config -> Config
withShowAxisY value config =
    Type.setShowAxisY value config


{-| Sets the x domain of a time line chart

If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init
        |> Line.withDomainTimeX ( Time.millisToPosix 1579275175634, 10 )
        |> Line.render ( data, accessor )

-}
withDomainTimeX : ( Posix, Posix ) -> Config -> Config
withDomainTimeX value config =
    Type.setDomainTimeX value config


{-| Sets the y domain of a line chart

This is always a linear domain, not a time domain.
If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init
        |> Line.withDomainY ( Time.millisToPosix 1579275175634, Time.millisToPosix 1579375175634 )
        |> Line.render ( data, accessor )

-}
withDomainY : ( Float, Float ) -> Config -> Config
withDomainY value config =
    Type.setDomainLinearAndTimeY value config


{-| Sets the x domain of a linear line chart

If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init
        |> Line.withDomainLinearX ( 0, 10 )
        |> Line.render ( data, accessor )

-}
withDomainLinearX : ( Float, Float ) -> Config -> Config
withDomainLinearX value config =
    Type.setDomainLinearX value config


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""
Line.init
|> Line.withDesc "This is an accessible chart, with a desc element"
|> Line.render ( data, accessor )
-}
withDesc : String -> Config -> Config
withDesc value config =
    Type.setSvgDesc value config


{-| Sets an accessible title for the svg chart.
Default value: ""
Line.init
|> Line.withTitle "This is a chart"
|> Line.render ( data, accessor )
-}
withTitle : String -> Config -> Config
withTitle value config =
    Type.setSvgTitle value config


{-| Sets the color palette for the chart.

    palette =
        Scale.Color.tableau10

    Line.init
        |> Line.withColorPalette palette
        |> Line.render (data, accessor)

-}
withColorPalette : List Color -> Config -> Config
withColorPalette palette config =
    Type.setColorResource (ColorPalette palette) config


{-| Sets the line layout.

Values: `Line.stackedLayout` or `Line.groupedLayout`

Default value: Line.groupedLayout

    Line.init
        |> Line.withLayout Line.stackedLayout
        |> Line.render ( data, accessor )

-}
withLayout : Layout -> Config -> Config
withLayout value config =
    Type.setLayout value config


{-| Stacked layout type

    Line.init
        |> Line.withLayout Line.stackedLayout
        |> Line.render ( data, accessor )

-}
stacked : Layout
stacked =
    StackedLine


grouped : Layout
grouped =
    GroupedLine



--SYMBOLS


{-| Sets the Icon Symbols list in the `LayoutConfig`.

Default value: []

These are additional symbols at the end of each line in a group, for facilitating accessibility.

    defaultLayoutConfig
        |> withSymbols [ Circle, Corner, Triangle ]

-}
withSymbols : List Symbol -> Config -> Config
withSymbols =
    Type.setIcons


{-| Line chart symbol type
-}
type alias Symbol =
    InternalSymbol.Symbol

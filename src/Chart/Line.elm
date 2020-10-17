module Chart.Line exposing
    ( Accessor, AccessorLinear, AccessorTime, linear, time
    , init
    , render
    , RequiredConfig
    , withColorPalette, withCurve, withDesc, withLabels, withGroupedLayout, withLineStyle, withStackedLayout, withTable, withTitle, withXLinearDomain, withXTimeDomain, withYDomain
    , XAxis, YAxis, hideAxis, hideXAxis, hideYAxis, withXAxisLinear, withXAxisTime, withYAxisLinear
    , withSymbols
    , axisBottom, axisLeft, axisRight, xGroupLabel
    )

{-| This is the line chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

It expects the X axis to plot time or linear data and the Y axis to plot linear data.


# Chart Data Format

@docs Accessor, AccessorLinear, AccessorTime, linear, time


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Required Configuration

@docs RequiredConfig


# Optional Configuration setters

@docs withColorPalette, withCurve, withDesc, withLabels, withGroupedLayout, withLineStyle, withStackedLayout, withTable, withTitle, withXLinearDomain, withXTimeDomain, withYDomain


# Optional Axis Configuration Setters

@docs XAxis, YAxis, hideAxis, hideXAxis, hideYAxis, withXAxisLinear, withXAxisTime, withYAxisLinear

@docs withSymbols


# Configuration arguments

@docs axisBottom, axisLeft, axisRight, xGroupLabel

-}

import Axis
import Chart.Internal.Axis as ChartAxis
import Chart.Internal.Line
    exposing
        ( renderLineGrouped
        , renderLineStacked
        )
import Chart.Internal.Symbol exposing (Symbol)
import Chart.Internal.Type as Type
    exposing
        ( AccessibilityContent(..)
        , ColorResource(..)
        , Config
        , Direction(..)
        , Label(..)
        , Layout(..)
        , Margin
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setDimensions
        , setLayout
        , setSvgDesc
        , setSvgTitle
        )
import Color exposing (Color)
import Html exposing (Html)
import SubPath exposing (SubPath)
import Time exposing (Posix)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| The required config, passed as an argument to the `init` function
-}
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
    Type.AccessorLinearOrTime data


{-| The accessor structure for x time lines.
-}
type alias AccessorTime data =
    { xGroup : data -> Maybe String
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
    { xGroup : data -> Maybe String
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
        { margin =
            { top = 10
            , right = 10
            , bottom = 30
            , left = 30
            }
        , width = 500
        , height = 200
        }
        |> Line.render (data, accessor)

-}
init : RequiredConfig -> Config
init c =
    defaultConfig
        |> withGroupedLayout
        |> setDimensions { margin = c.margin, width = c.width, height = c.height }


{-| Renders the line chart, after initialisation and customisation

    Line.init requiredConfig
        |> Line.render ( data, accessor )

-}
render : ( List data, Accessor data ) -> Config -> Html msg
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

    Line.init requiredConfig
        |> Line.withXTicks [ 1, 2, 3 ]
        |> Line.render ( data, accessor )

-}
withXAxisTicks : List Float -> Config -> Config
withXAxisTicks ticks config =
    Type.setXAxisTicks (Type.CustomTicks ticks) config


{-| Sets the line curve shape

Defaults to `Shape.linearCurve`

See [elm-visualization/latest/Shape](https://package.elm-lang.org/packages/gampleman/elm-visualization/latest/Shape)
for more info.

    Line.init requiredConfig
        |> Line.withCurve Shape.monotoneInXCurve
        |> Line.render ( data, accessor )

-}
withCurve : (List ( Float, Float ) -> SubPath) -> Config -> Config
withCurve curve config =
    Type.setCurve curve config


{-| Sets the approximate number of ticks for the X axis

Defaults to elm-visualization `Scale.ticks`

    Line.init requiredConfig
        |> Line.withXAxisTickCount 5
        |> Line.render ( data, accessor )

-}
withXAxisTickCount : Int -> Config -> Config
withXAxisTickCount count config =
    Type.setXAxisTickCount (Type.CustomTickCount count) config


{-| Sets the tick formatting for the X axis

Defaults to elm-visualization `Scale.tickFormat`

    Line.init requiredConfig
        |> Line.withXAxisTickFormat (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render ( data, accessor )

-}
withXAxisTickFormat : (Float -> String) -> Config -> Config
withXAxisTickFormat f config =
    Type.setXAxisTickFormat (Type.CustomTickFormat f) config


{-| Explicitly sets the ticks for the Y axis

Defaults to `Scale.ticks`

    Line.init requiredConfig
        |> Line.withYAxisTicks [ 1, 2, 3 ]
        |> Line.render ( data, accessor )

-}
withYAxisTicks : List Float -> Config -> Config
withYAxisTicks ticks config =
    Type.setYAxisTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the y axis

Defaults to `Scale.ticks`

    Line.init requiredConfig
        |> Line.withYAxisTickCount 5
        |> Line.render ( data, accessor )

-}
withYAxisTickCount : Int -> Config -> Config
withYAxisTickCount count config =
    Type.setYAxisTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks in the y axis

Defaults to `Scale.tickFormat`

    Line.init requiredConfig
        |> Line.withYAxisTickFormat (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render ( data, accessor )

-}
withYAxisTickFormat : (Float -> String) -> Config -> Config
withYAxisTickFormat f config =
    Type.setYAxisTickFormat (Type.CustomTickFormat f) config


{-| -}
withXAxisTime : ChartAxis.XAxis Posix -> Config -> Config
withXAxisTime =
    Type.setXAxisTime


{-| -}
withXAxisLinear : ChartAxis.XAxis Float -> Config -> Config
withXAxisLinear =
    Type.setXAxisLinear


{-| -}
withYAxisLinear : ChartAxis.YAxis Float -> Config -> Config
withYAxisLinear =
    Type.setYAxisLinear


{-| -}
axisLeft : List (Axis.Attribute value) -> ChartAxis.YAxis value
axisLeft =
    ChartAxis.Left


{-| -}
axisRight : List (Axis.Attribute value) -> ChartAxis.YAxis value
axisRight =
    ChartAxis.Right


{-| -}
axisBottom : List (Axis.Attribute value) -> ChartAxis.XAxis value
axisBottom =
    ChartAxis.Bottom


{-| Sets the the inner tick size that controls the length of the tick lines, offset from the native position of the axis. Defaults to 6.

    Line.init requiredConfig
        |> Line.withAxisTickSizeInner 10
        |> Line.render ( data, accessor )

-}
withAxisTickSizeInner : Float -> Config -> Config
withAxisTickSizeInner size config =
    Type.setAxisTickSizeInner size config


{-| The outer tick size controls the length of the square ends of the domain path, offset from the native position of the axis. Thus, the “outer ticks” are not actually ticks but part of the domain path, and their position is determined by the associated scale’s domain extent. Thus, outer ticks may overlap with the first or last inner tick. An outer tick size of 0 suppresses the square ends of the domain path, instead producing a straight line. Defaults to 6.

    Line.init requiredConfig
        |> Line.withAxisTickSizeOuter 0
        |> Line.render ( data, accessor )

-}
withAxisTickSizeOuter : Float -> Config -> Config
withAxisTickSizeOuter size config =
    Type.setAxisTickSizeOuter size config


{-| Padding controls the space between tick marks and tick labels. Defaults to 3.

    Line.init requiredConfig
        |> Line.withAxisTickPadding 6
        |> Line.render ( data, accessor )

-}
withAxisTickPadding : Float -> Config -> Config
withAxisTickPadding size config =
    Type.setAxisTickPadding size config


{-| Sets the the inner tick size that controls the length of the tick lines, offset from the native position of the axis. Defaults to 6. Only affects the Y axis.

    Line.init requiredConfig
        |> Line.withYAxisTickSizeInner 10
        |> Line.render ( data, accessor )

-}
withYAxisTickSizeInner : Float -> Config -> Config
withYAxisTickSizeInner size config =
    Type.setYAxisTickSizeInner size config


{-| The outer tick size controls the length of the square ends of the domain path, offset from the native position of the axis. Thus, the “outer ticks” are not actually ticks but part of the domain path, and their position is determined by the associated scale’s domain extent. Thus, outer ticks may overlap with the first or last inner tick. An outer tick size of 0 suppresses the square ends of the domain path, instead producing a straight line. Defaults to 6. Only affects the Y axis.

    Line.init requiredConfig
        |> Line.withYAxisTickSizeOuter 0
        |> Line.render ( data, accessor )

-}
withYAxisTickSizeOuter : Float -> Config -> Config
withYAxisTickSizeOuter size config =
    Type.setYAxisTickSizeOuter size config


{-| Padding controls the space between tick marks and tick labels. Defaults to 3. Only affects the Y axis.

    Line.init requiredConfig
        |> Line.withYAxisTickPadding 6
        |> Line.render ( data, accessor )

-}
withYAxisTickPadding : Float -> Config -> Config
withYAxisTickPadding size config =
    Type.setYAxisTickPadding size config


{-| Sets the the inner tick size that controls the length of the tick lines, offset from the native position of the axis. Defaults to 6. Only affects the X axis.

    Line.init requiredConfig
        |> Line.withXAxisTickSizeInner 10
        |> Line.render ( data, accessor )

-}
withXAxisTickSizeInner : Float -> Config -> Config
withXAxisTickSizeInner size config =
    Type.setXAxisTickSizeInner size config


{-| The outer tick size controls the length of the square ends of the domain path, offset from the native position of the axis. Thus, the “outer ticks” are not actually ticks but part of the domain path, and their position is determined by the associated scale’s domain extent. Thus, outer ticks may overlap with the first or last inner tick. An outer tick size of 0 suppresses the square ends of the domain path, instead producing a straight line. Defaults to 6. Only affects the X axis.

    Line.init requiredConfig
        |> Line.withXAxisTickSizeOuter 0
        |> Line.render ( data, accessor )

-}
withXAxisTickSizeOuter : Float -> Config -> Config
withXAxisTickSizeOuter size config =
    Type.setXAxisTickSizeOuter size config


{-| Padding controls the space between tick marks and tick labels. Defaults to 3. Only affects the X axis.

    Line.init requiredConfig
        |> Line.withXAxisTickPadding 6
        |> Line.render ( data, accessor )

-}
withXAxisTickPadding : Float -> Config -> Config
withXAxisTickPadding size config =
    Type.setXAxisTickPadding size config


{-| Hide all axis

    Line.init requiredConfig
        |> Line.hideAxis
        |> Line.render ( data, accessor )

-}
hideAxis : Config -> Config
hideAxis config =
    Type.setXAxis False config
        |> Type.setYAxis False


{-| Hide the Y aixs

The Y axis depends from the layout:
With a vertical layout the Y axis is the vertical axis.
With a horizontal layout the Y axis is the horizontal axis.

    Line.init
        { margin = margin
        , width = width
        , height = height
        }
        |> Line.hideYAxis
        |> Line.render ( data, accessor )

-}
hideYAxis : Config -> Config
hideYAxis config =
    Type.setYAxis False config


{-| Hide the X aixs

The X axis depends from the layout:
With a vertical layout the X axis is the horizontal axis.
With a horizontal layout the X axis is the vertical axis.

    Line.init requiredConfig
        |> Line.hideXAxis
        |> Line.render ( data, accessor )

-}
hideXAxis : Config -> Config
hideXAxis config =
    Type.setXAxis False config


{-| Sets the Y domain of a time line chart

If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init requiredConfig
        |> Line.withXTimeDomain ( Time.millisToPosix 1579275175634, 10 )
        |> Line.render ( data, accessor )

-}
withXTimeDomain : ( Posix, Posix ) -> Config -> Config
withXTimeDomain value config =
    Type.setDomainTimeX value config


{-| Sets the Y domain of a line chart

This is always a linear domain, not a time domain.
If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init required
        |> Line.withYDomain ( Time.millisToPosix 1579275175634, Time.millisToPosix 1579375175634 )
        |> Line.render ( data, accessor )

-}
withYDomain : ( Float, Float ) -> Config -> Config
withYDomain value config =
    Type.setDomainLinearAndTimeY value config


{-| Sets the Y domain of a linear line chart

If not set, the domain is calculated from the data.
If set on a linear line chart this setting will have no effect.

    Line.init requiredConfig
        |> Line.withXLinearDomain ( 0, 10 )
        |> Line.render ( data, accessor )

-}
withXLinearDomain : ( Float, Float ) -> Config -> Config
withXLinearDomain value config =
    Type.setDomainLinearX value config


{-| Build an alternative table content for accessibility

&#9888; This is still work in progress and only a basic table is rendered with this option.
For now it is best to only use it with a limited number of data points.

    Line.init requiredConfig
        |> Line.withTable
        |> Line.render ( data, accessor )

-}
withTable : Config -> Config
withTable =
    Type.setAccessibilityContent AccessibilityTable


{-| Sets an accessible, long-text description for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Line.init requiredConfig
        |> Line.withDesc "This is an accessible chart"
        |> Line.render ( data, accessor )

-}
withDesc : String -> Config -> Config
withDesc value config =
    Type.setSvgDesc value config


{-| Sets an accessible title for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Line.init required
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

    Line.init requiredConfig
        |> Line.withColorPalette palette
        |> Line.render (data, accessor)

-}
withColorPalette : List Color -> Config -> Config
withColorPalette palette config =
    Type.setColorResource (ColorPalette palette) config


{-| Creates a stacked line chart.

It takes a direction: `diverging` or `noDirection`

    Line.init requiredConfig
        |> Line.withStackedLayout
        |> Line.render ( data, accessor )

-}
withStackedLayout : Config -> Config
withStackedLayout config =
    Type.setLayout Type.StackedLine config


{-| Creates a grouped line chart.

    Line.init requiredConfig
        |> Line.withGroupedLayout
        |> Line.render ( data, accessor )

-}
withGroupedLayout : Config -> Config
withGroupedLayout config =
    Type.setLayout GroupedLine config


{-| Show a label at the end of the lines.

It takes one of: xGroupLabel

&#9888; Use with caution, there is no knowledge of text wrapping!

    defaultLayoutConfig
        |> Line.withLabels Line.xGroupLabel

-}
withLabels : Label -> Config -> Config
withLabels label =
    case label of
        XGroupLabel ->
            Type.showXGroupLabel

        _ ->
            identity


{-| Sets the style for the lines
The styles set here have precedence over `withColorPalette` and css.

    Line.init requiredConfig
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.render ( data, accessor )

-}
withLineStyle : List ( String, String ) -> Config -> Config
withLineStyle styles config =
    Type.setCoreStyles styles config



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



--


{-| -}
xGroupLabel : Label
xGroupLabel =
    XGroupLabel


{-| -}
type alias XAxis value =
    ChartAxis.XAxis value


{-| -}
type alias YAxis value =
    ChartAxis.YAxis value

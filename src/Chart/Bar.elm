module Chart.Bar exposing
    ( Accessor
    , init
    , render
    , RequiredConfig
    , withBarStyle, withColorInterpolator, withColorPalette, withColumnTitle, withDesc, withLabels, withGroupedLayout, withOrientation, withStackedLayout, withSymbols, withTable, withTitle, withXDomain, withXGroupDomain, withYDomain
    , hideAxis, hideXAxis, hideYAxis, withAxisTickPadding, withAxisTickSizeInner, withAxisTickSizeOuter, withXAxisTickPadding, withXAxisTickSizeInner, withXAxisTickSizeOuter, withYAxisTickCount, withYAxisTickFormat, withYAxisTickPadding, withYAxisTickSizeInner, withYAxisTickSizeOuter, withYAxisTicks
    , diverging, horizontal, noDirection, stackedColumnTitle, vertical, xOrdinalColumnTitle, yColumnTitle, yLabel, xLabel, xGroupLabel
    )

{-| This is the bar chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

The Bar module expects the X axis to plot ordinal data and the Y axis to plot linear data. The data can be grouped by passing an `xGroup` accessor, or it can be flat by making the accessor `always Nothing`.

The X and Y axis are determined by the default vertical orientation. If the orientatin changes, X and Y also change.


# Data Format

@docs Accessor


# Initialization

@docs init


# Rendering

@docs render


# Required Configuration

@docs RequiredConfig


# Optional Configuration Setters

@docs withBarStyle, withColorInterpolator, withColorPalette, withColumnTitle, withDesc, withLabels, withGroupedLayout, withOrientation, withStackedLayout, withSymbols, withTable, withTitle, withXDomain, withXGroupDomain, withYDomain


# Optional Axis Configuration Setters

@docs hideAxis, hideXAxis, hideYAxis, withAxisTickPadding, withAxisTickSizeInner, withAxisTickSizeOuter, withXAxisTickPadding, withXAxisTickSizeInner, withXAxisTickSizeOuter, withYAxisTickCount, withYAxisTickFormat, withYAxisTickPadding, withYAxisTickSizeInner, withYAxisTickSizeOuter, withYAxisTicks


# Configuration arguments

@docs diverging, horizontal, noDirection, stackedColumnTitle, vertical, xOrdinalColumnTitle, yColumnTitle, yLabel, xLabel, xGroupLabel

-}

import Axis
import Chart.Internal.Bar
    exposing
        ( renderBandGrouped
        , renderBandStacked
        )
import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type as Type
    exposing
        ( AccessibilityContent(..)
        , AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , ColorResource(..)
        , ColumnTitle(..)
        , Config
        , Direction(..)
        , Label(..)
        , Layout(..)
        , Orientation(..)
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setColorResource
        , setCoreStyles
        , setDimensions
        , setSvgDesc
        , setSvgTitle
        , setXAxis
        , setYAxis
        )
import Color exposing (Color)
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| The data accessors
-}
type alias Accessor data =
    { xGroup : data -> Maybe String
    , xValue : data -> String
    , yValue : data -> Float
    }


{-| The required config, passed as an argument to the `init` function
-}
type alias RequiredConfig =
    { margin :
        { top : Float
        , right : Float
        , bottom : Float
        , left : Float
        }
    , width : Float
    , height : Float
    }


{-| Initializes the bar chart with the required config.

    data :
        List
            { groupLabel : String
            , x : String
            , y : Float
            }
    data =
        [ { groupLabel = "A"
          , x = "a"
          , y = 10
          }
        , { groupLabel = "B"
          , x = "a"
          , y = 11
          }
        ]

    accessor :
        Bar.Accessor
            { groupLabel : String
            , x : String
            , y : Float
            }
    accessor =
        Bar.Accessor .groupLabel .x .y

    Bar.init
        { margin =
            { top = 10
            , right = 10
            , bottom = 30
            , left = 30
            }
        , width = 500
        , height = 200
        }
        |> Bar.render ( data, accessor )

-}
init : RequiredConfig -> Config
init c =
    defaultConfig
        |> setDimensions { margin = c.margin, width = c.width, height = c.height }


{-| Renders the bar chart, after initialisation and optional customisations.

    Bar.init requiredConfig
        |> Bar.render ( data, accessor )

-}
render : ( List data, Accessor data ) -> Config -> Html msg
render ( externalData, accessor ) config =
    let
        c =
            fromConfig config

        data =
            Type.externalToDataBand (Type.toExternalData externalData) accessor
    in
    case c.layout of
        GroupedBar ->
            renderBandGrouped ( data, config )

        StackedBar _ ->
            renderBandStacked ( data, config )

        _ ->
            -- TODO
            Html.text ""


{-| Creates a stacked bar chart.
Stacked Charts do not support symbols.

It takes a direction: `diverging` or `noDirection`.

    Bar.init requiredConfig
        |> Bar.withStackedLayout Bar.diverging
        |> Bar.render ( data, accessor )

-}
withStackedLayout : Direction -> Config -> Config
withStackedLayout direction config =
    Type.setLayout (StackedBar direction) config


{-| Creates a grouped bar chart.

    Bar.init requiredConfig
        |> Bar.withGroupedLayout
        |> Bar.render ( data, accessor )

-}
withGroupedLayout : Config -> Config
withGroupedLayout config =
    Type.setLayout GroupedBar config


{-| Sets the orientation value.

Accepts: `horizontal` or `vertical`.
Default value: `vertical`.

    Bar.init requiredConfig
        |> Bar.withOrientation Bar.horizontal
        |> Bar.render ( data, accessor )

-}
withOrientation : Orientation -> Config -> Config
withOrientation value config =
    Type.setOrientation value config


{-| Sets the style for the bars
The styles set here have precedence over `withColorPalette`, `withColorInterpolator` and css.

    Bar.init requiredConfig
        |> Bar.withBarStyle [ ( "fill", "none" ), ( "stroke-width", "2" ) ]
        |> Bar.render ( data, accessor )

-}
withBarStyle : List ( String, String ) -> Config -> Config
withBarStyle styles config =
    Type.setCoreStyles styles config


{-| Passes the tick values for a bar chart continous axis.

Defaults to elm-visualization `Scale.ticks`.

    Bar.init requiredConfig
        |> Bar.withYAxisTicks [ 1, 2, 3 ]
        |> Bar.render ( data, accessor )

-}
withYAxisTicks : List Float -> Config -> Config
withYAxisTicks ticks config =
    Type.setYAxisTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for a bar chart continous axis.

Defaults to elm-visualization `Scale.tickCount`.

    Bar.init requiredConfig
        |> Bar.withYAxisTickCount 5
        |> Bar.render ( data, accessor )

-}
withYAxisTickCount : Int -> Config -> Config
withYAxisTickCount count config =
    Type.setYAxisTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for the ticks in a bar chart continous axis.

Defaults to elm-visualization `Scale.tickFormat`.

    formatter =
        FormatNumber.format { usLocale | decimals = 0 }

    Bar.init requiredConfig
        |> Bar.withYAxisTickFormat formatter
        |> Bar.render (data, accessor)

-}
withYAxisTickFormat : (Float -> String) -> Config -> Config
withYAxisTickFormat f config =
    Type.setYAxisTickFormat (CustomTickFormat f) config


{-| Sets the the inner tick size that controls the length of the tick lines, offset from the native position of the axis. Defaults to 6.

    Bar.init requiredConfig
        |> Bar.withAxisTickSizeInner 10
        |> Bar.render ( data, accessor )

-}
withAxisTickSizeInner : Float -> Config -> Config
withAxisTickSizeInner size config =
    Type.setAxisTickSizeInner size config


{-| The outer tick size controls the length of the square ends of the domain path, offset from the native position of the axis. Thus, the “outer ticks” are not actually ticks but part of the domain path, and their position is determined by the associated scale’s domain extent. Thus, outer ticks may overlap with the first or last inner tick. An outer tick size of 0 suppresses the square ends of the domain path, instead producing a straight line. Defaults to 6.

    Bar.init requiredConfig
        |> Bar.withAxisTickSizeOuter 0
        |> Bar.render ( data, accessor )

-}
withAxisTickSizeOuter : Float -> Config -> Config
withAxisTickSizeOuter size config =
    Type.setAxisTickSizeOuter size config


{-| Padding controls the space between tick marks and tick labels. Defaults to 3.

    Bar.init requiredConfig
        |> Bar.withAxisTickPadding 6
        |> Bar.render ( data, accessor )

-}
withAxisTickPadding : Float -> Config -> Config
withAxisTickPadding size config =
    Type.setAxisTickPadding size config


{-| Sets the the inner tick size that controls the length of the tick lines, offset from the native position of the axis. Defaults to 6. Only affects the Y axis.

    Bar.init requiredConfig
        |> Bar.withYAxisTickSizeInner 10
        |> Bar.render ( data, accessor )

-}
withYAxisTickSizeInner : Float -> Config -> Config
withYAxisTickSizeInner size config =
    Type.setYAxisTickSizeInner size config


{-| The outer tick size controls the length of the square ends of the domain path, offset from the native position of the axis. Thus, the “outer ticks” are not actually ticks but part of the domain path, and their position is determined by the associated scale’s domain extent. Thus, outer ticks may overlap with the first or last inner tick. An outer tick size of 0 suppresses the square ends of the domain path, instead producing a straight line. Defaults to 6. Only affects the Y axis.

    Bar.init requiredConfig
        |> Bar.withYAxisTickSizeOuter 0
        |> Bar.render ( data, accessor )

-}
withYAxisTickSizeOuter : Float -> Config -> Config
withYAxisTickSizeOuter size config =
    Type.setYAxisTickSizeOuter size config


{-| Padding controls the space between tick marks and tick labels. Defaults to 3. Only affects the Y axis.

    Bar.init requiredConfig
        |> Bar.withYAxisTickPadding 6
        |> Bar.render ( data, accessor )

-}
withYAxisTickPadding : Float -> Config -> Config
withYAxisTickPadding size config =
    Type.setYAxisTickPadding size config


{-| Sets the the inner tick size that controls the length of the tick lines, offset from the native position of the axis. Defaults to 6. Only affects the X axis.

    Bar.init requiredConfig
        |> Bar.withXAxisTickSizeInner 10
        |> Bar.render ( data, accessor )

-}
withXAxisTickSizeInner : Float -> Config -> Config
withXAxisTickSizeInner size config =
    Type.setXAxisTickSizeInner size config


{-| The outer tick size controls the length of the square ends of the domain path, offset from the native position of the axis. Thus, the “outer ticks” are not actually ticks but part of the domain path, and their position is determined by the associated scale’s domain extent. Thus, outer ticks may overlap with the first or last inner tick. An outer tick size of 0 suppresses the square ends of the domain path, instead producing a straight line. Defaults to 6. Only affects the X axis.

    Bar.init requiredConfig
        |> Bar.withXAxisTickSizeOuter 0
        |> Bar.render ( data, accessor )

-}
withXAxisTickSizeOuter : Float -> Config -> Config
withXAxisTickSizeOuter size config =
    Type.setXAxisTickSizeOuter size config


{-| Padding controls the space between tick marks and tick labels. Defaults to 3. Only affects the X axis.

    Bar.init requiredConfig
        |> Bar.withXAxisTickPadding 6
        |> Bar.render ( data, accessor )

-}
withXAxisTickPadding : Float -> Config -> Config
withXAxisTickPadding size config =
    Type.setXAxisTickPadding size config


{-| Sets the color palette for the chart.
If a palette with a single color is passed all bars will have the same colour.
If the bars in a group are more then the colours in the palette, the colours will be repeted.

    palette =
        Scale.Color.tableau10

    Bar.init requiredConfig
        |> Bar.withColorPalette palette
        |> Bar.render (data, accessor)

-}
withColorPalette : List Color -> Config -> Config
withColorPalette palette config =
    Type.setColorResource (ColorPalette palette) config


{-| Sets the color interpolator for the chart.

This option is not supported for stacked bar charts and will have no effect on them.

    Bar.init requiredConfig
        |> Bar.withColorInterpolator Scale.Color.plasmaInterpolator
        |> Bar.render ( data, accessor )

-}
withColorInterpolator : (Float -> Color) -> Config -> Config
withColorInterpolator interpolator config =
    Type.setColorResource (ColorInterpolator interpolator) config


{-| Sets the group band domain explicitly. The group data relates to the `xGoup` accessor.

    Bar.init requiredConfig
        |> Bar.withXGroupDomain [ "0" ]
        |> Bar.render ( data, accessor )

-}
withXGroupDomain : List String -> Config -> Config
withXGroupDomain value config =
    Type.setDomainBandBandGroup value config


{-| Sets the band domain explicitly. The data relates to the `xValue` accessor.

    Bar.init requiredConfig
        |> Bar.withXDomain [ "a", "b" ]
        |> Bar.render ( data, accessor )

-}
withXDomain : List String -> Config -> Config
withXDomain value config =
    Type.setDomainBandBandSingle value config


{-| Sets the linear domain explicitly. The data relates to the `yValue` accessor.

    Bar.init requiredConfig
        |> Bar.withYDomain ( 0, 0.55 )
        |> Bar.render ( data, accessor )

-}
withYDomain : ( Float, Float ) -> Config -> Config
withYDomain value config =
    Type.setDomainBandLinear value config


{-| Hide all axis.

    Bar.init requiredConfig
        |> Bar.hideAxis
        |> Bar.render ( data, accessor )

-}
hideAxis : Config -> Config
hideAxis config =
    Type.setXAxis False config
        |> Type.setYAxis False


{-| Hide the Y aixs.

The Y axis depends from the layout:

  - With a vertical layout the Y axis is the vertical axis.

  - With a horizontal layout the Y axis is the horizontal axis.

```
Bar.init requiredConfig
    |> Bar.hideYAxis
    |> Bar.render ( data, accessor )
```

-}
hideYAxis : Config -> Config
hideYAxis config =
    Type.setYAxis False config


{-| Hide the X aixs.

The X axis depends from the layout:

  - With a vertical layout the X axis is the horizontal axis.

  - With a horizontal layout the X axis is the vertical axis.

```
Bar.init requiredConfig
    |> Bar.hideXAxis
    |> Bar.render ( data, accessor )
```

-}
hideXAxis : Config -> Config
hideXAxis config =
    Type.setXAxis False config


{-| Pass a list of symbols to be rendered at the end of the bars.

Default value: []

Usefull for facilitating accessibility.

    Bar.init requiredConfig
        |> withSymbols [ Circle, Corner, Triangle ]
        |> Bar.render ( data, accessor )

-}
withSymbols : List Symbol -> Config -> Config
withSymbols =
    Type.setIcons


{-| Show the X ordinal values at the end of the bars.

If used together with symbols, the label will be drawn on top of the symbol.

&#9888; Use with caution, there is no knowledge of text wrapping!

    Bar.init requiredConfig
        |> Bar.withXLabels
        |> Bar.render ( data, accessor )

-}
withXLabels : Config -> Config
withXLabels =
    Type.showXOrdinalLabel


{-| Build an alternative table content for accessibility

&#9888; This is still work in progress and only a basic table is rendered with this option.
For now it is best to only use it with a limited number of data points.

    Bar.init requiredConfig
        |> Bar.withTable
        |> Bar.render ( data, accessor )

-}
withTable : Config -> Config
withTable =
    Type.setAccessibilityContent AccessibilityTable


{-| Show a label at the end of the bars.

It takes one of: yLabel, xLabel, xGroupLabel

If used together with symbols, the label will be drawn after the symbol.

&#9888; Use with caution, there is no knowledge of text wrapping!

    defaultLayoutConfig
        |> Bar.withLabels (Bar.yLabel String.fromFloat)

-}
withLabels : Label -> Config -> Config
withLabels label =
    case label of
        YLabel formatter ->
            Type.showYLabel formatter

        XOrdinalLabel ->
            Type.showXOrdinalLabel

        XGroupLabel ->
            Type.showXGroupLabel

        _ ->
            identity


{-| Set the chart columns title value

It takes one of: stackedColumnTitle, xOrdinalColumnTitle, yColumnTitle

    defaultLayoutConfig
        |> Bar.withColumnTitle (Bar.yColumnTitle String.fromFloat)

-}
withColumnTitle : ColumnTitle -> Config -> Config
withColumnTitle title config =
    case title of
        YColumnTitle formatter ->
            Type.showYColumnTitle formatter config

        XOrdinalColumnTitle ->
            Type.showXOrdinalColumnTitle config

        StackedColumnTitle formatter ->
            Type.showStackedColumnTitle formatter config

        NoColumnTitle ->
            config


{-| Sets an accessible, long-text description for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Bar.init requiredConfig
        |> Bar.withDesc "This is an accessible chart, with a desc element"
        |> Bar.render ( data, accessor )

-}
withDesc : String -> Config -> Config
withDesc value config =
    Type.setSvgDesc value config


{-| Sets an accessible title for the whole svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Bar.init requiredConfig
        |> Bar.withTitle "This is a chart"
        |> Bar.render ( data, accessor )

-}
withTitle : String -> Config -> Config
withTitle value config =
    Type.setSvgTitle value config


{-| Horizontal layout type.

Used as argument to `Bar.withOrientation`.

    Bar.init requiredConfig
        |> Bar.withOrientation horizontal
        |> Bar.render ( data, accessor )

-}
horizontal : Orientation
horizontal =
    Horizontal


{-| Vertical layout type.

Used as argument to `Bar.withOrientation`.
This is the default layout.

    Bar.init requiredConfig
        |> Bar.withOrientation vertical
        |> Bar.render ( data, accessor )

-}
vertical : Orientation
vertical =
    Vertical


{-| Diverging layout for stacked bar charts.

An example can be a population pyramid chart.

    Bar.init requiredConfig
        |> Bar.withStackedLayout Bar.diverging
        |> Bar.render ( data, accessor )

-}
diverging : Direction
diverging =
    Type.Diverging


{-| Default layout for stacked bar charts, where the bars are sequentially stacked
one upon another.

    Bar.init requiredConfig
        |> Bar.withStackedLayout Bar.noDirection
        |> Bar.render ( data, accessor )

-}
noDirection : Direction
noDirection =
    Type.NoDirection


{-| -}
xOrdinalColumnTitle : ColumnTitle
xOrdinalColumnTitle =
    XOrdinalColumnTitle


{-| -}
stackedColumnTitle : (Float -> String) -> ColumnTitle
stackedColumnTitle =
    StackedColumnTitle


{-| -}
yColumnTitle : (Float -> String) -> ColumnTitle
yColumnTitle =
    YColumnTitle


{-| -}
yLabel : (Float -> String) -> Label
yLabel =
    YLabel


{-| -}
xLabel : Label
xLabel =
    XOrdinalLabel


{-| -}
xGroupLabel : Label
xGroupLabel =
    XGroupLabel

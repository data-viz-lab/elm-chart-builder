module Chart.Bar exposing
    ( Accessor
    , init
    , render
    , Config, RequiredConfig
    , withBarStyle, withColorInterpolator, withColorPalette, withColumnTitle, withDesc, withGroupedLayout, withLabels, withLogYScale, withOrientation, withStackedLayout, withSymbols, withoutTable, withTitle, withXDomain, withXGroupDomain, withXLabels, withYDomain
    , XAxis, YAxis, axisBottom, axisGrid, axisLeft, axisRight, hideAxis, hideXAxis, hideYAxis, withXAxis, withYAxis
    , diverging, horizontal, noDirection, stackedColumnTitle, vertical, xOrdinalColumnTitle, yColumnTitle, yLabel, xLabel, xGroupLabel
    )

{-| This is the bar chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

The Bar module expects the X axis to plot ordinal data and the Y axis to plot continuous data. The data can be grouped by passing an `xGroup` accessor, or it can be flat by making the accessor `always Nothing`.

The X and Y axis are determined by the default vertical orientation. If the orientatin changes, X and Y also change.


# Data Format

@docs Accessor


# Initialization

@docs init


# Rendering

@docs render


# Configuration

@docs Config, RequiredConfig


# Optional Configuration Setters

@docs withBarStyle, withColorInterpolator, withColorPalette, withColumnTitle, withDesc, withGroupedLayout, withLabels, withLogYScale, withOrientation, withStackedLayout, withSymbols, withoutTable, withTitle, withXDomain, withXGroupDomain, withXLabels, withYDomain


# Axis

&#9888; axisLeft & axisRight apply to a vertical chart context. If you change the chart orientation to horizontal, the axis positioning will always change to bottom.

@docs XAxis, YAxis, axisBottom, axisGrid, axisLeft, axisRight, hideAxis, hideXAxis, hideYAxis, withXAxis, withYAxis


# Configuration arguments

@docs diverging, horizontal, noDirection, stackedColumnTitle, vertical, xOrdinalColumnTitle, yColumnTitle, yLabel, xLabel, xGroupLabel

-}

import Axis
import Chart.Internal.Axis as ChartAxis
import Chart.Internal.Bar
    exposing
        ( renderBandGrouped
        , renderBandStacked
        )
import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type as Type
import Color exposing (Color)
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| The Config opaque type
-}
type alias Config =
    Type.Config


{-| The required config, passed as an argument to the `init` function
-}
type alias RequiredConfig =
    Type.RequiredConfig


{-| The data accessors
-}
type alias Accessor data =
    { xGroup : data -> Maybe String
    , xValue : data -> String
    , yValue : data -> Float
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
    Type.defaultConfig
        |> Type.setDimensions { margin = c.margin, width = c.width, height = c.height }


{-| Renders the bar chart, after initialisation and optional customisations.

    Bar.init requiredConfig
        |> Bar.render ( data, accessor )

-}
render : ( List data, Accessor data ) -> Config -> Html msg
render ( externalData, accessor ) config =
    let
        c =
            Type.fromConfig config

        data =
            Type.externalToDataBand (Type.toExternalData externalData) accessor
    in
    case c.layout of
        Type.GroupedBar ->
            renderBandGrouped ( data, config )

        Type.StackedBar _ ->
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
withStackedLayout : Type.Direction -> Config -> Config
withStackedLayout direction config =
    Type.setLayout (Type.StackedBar direction) config


{-| Creates a grouped bar chart.

    Bar.init requiredConfig
        |> Bar.withGroupedLayout
        |> Bar.render ( data, accessor )

-}
withGroupedLayout : Config -> Config
withGroupedLayout config =
    Type.setLayout Type.GroupedBar config


{-| Sets the orientation value.

Accepts: `horizontal` or `vertical`.
Default value: `vertical`.

    Bar.init requiredConfig
        |> Bar.withOrientation Bar.horizontal
        |> Bar.render ( data, accessor )

-}
withOrientation : Type.Orientation -> Config -> Config
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
    Type.setColorResource (Type.ColorPalette palette) config


{-| Sets the color interpolator for the chart.

This option is not supported for stacked bar charts and will have no effect on them.

    Bar.init requiredConfig
        |> Bar.withColorInterpolator Scale.Color.plasmaInterpolator
        |> Bar.render ( data, accessor )

-}
withColorInterpolator : (Float -> Color) -> Config -> Config
withColorInterpolator interpolator config =
    Type.setColorResource (Type.ColorInterpolator interpolator) config


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


{-| Sets the continuous domain explicitly. The data relates to the `yValue` accessor.

    Bar.init requiredConfig
        |> Bar.withYDomain ( 0, 0.55 )
        |> Bar.render ( data, accessor )

-}
withYDomain : ( Float, Float ) -> Config -> Config
withYDomain value config =
    Type.setDomainBandContinuous value config


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


{-| Do **not** build an alternative table content for accessibility

&#9888; By default an alternative table is always being rendered.
Use this option to not build the table.

    Bar.init requiredConfig
        |> Bar.withoutTable
        |> Bar.render ( data, accessor )

-}
withoutTable : Config -> Config
withoutTable =
    Type.setAccessibilityContent Type.AccessibilityNone


{-| Show a label at the end of the bars.

It takes one of: yLabel, xLabel, xGroupLabel

If used together with symbols, the label will be drawn after the symbol.

&#9888; Use with caution, there is no knowledge of text wrapping!

    defaultLayoutConfig
        |> Bar.withLabels (Bar.yLabel String.fromFloat)

-}
withLabels : Type.Label -> Config -> Config
withLabels label =
    case label of
        Type.YLabel formatter ->
            Type.showYLabel formatter

        Type.XOrdinalLabel ->
            Type.showXOrdinalLabel

        Type.XGroupLabel ->
            Type.showXGroupLabel

        _ ->
            identity


{-| Set the chart columns title value

It takes one of: stackedColumnTitle, xOrdinalColumnTitle, yColumnTitle

    defaultLayoutConfig
        |> Bar.withColumnTitle (Bar.yColumnTitle String.fromFloat)

-}
withColumnTitle : Type.ColumnTitle -> Config -> Config
withColumnTitle title config =
    case title of
        Type.YColumnTitle formatter ->
            Type.showYColumnTitle formatter config

        Type.XOrdinalColumnTitle ->
            Type.showXOrdinalColumnTitle config

        Type.StackedColumnTitle formatter ->
            Type.showStackedColumnTitle formatter config

        Type.NoColumnTitle ->
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
horizontal : Type.Orientation
horizontal =
    Type.Horizontal


{-| Vertical layout type.

Used as argument to `Bar.withOrientation`.
This is the default layout.

    Bar.init requiredConfig
        |> Bar.withOrientation vertical
        |> Bar.render ( data, accessor )

-}
vertical : Type.Orientation
vertical =
    Type.Vertical


{-| Diverging layout for stacked bar charts.

An example can be a population pyramid chart.

    Bar.init requiredConfig
        |> Bar.withStackedLayout Bar.diverging
        |> Bar.render ( data, accessor )

-}
diverging : Type.Direction
diverging =
    Type.Diverging


{-| Default layout for stacked bar charts, where the bars are sequentially stacked
one upon another.

    Bar.init requiredConfig
        |> Bar.withStackedLayout Bar.noDirection
        |> Bar.render ( data, accessor )

-}
noDirection : Type.Direction
noDirection =
    Type.NoDirection


{-| -}
xOrdinalColumnTitle : Type.ColumnTitle
xOrdinalColumnTitle =
    Type.XOrdinalColumnTitle


{-| -}
stackedColumnTitle : (Float -> String) -> Type.ColumnTitle
stackedColumnTitle =
    Type.StackedColumnTitle


{-| -}
yColumnTitle : (Float -> String) -> Type.ColumnTitle
yColumnTitle =
    Type.YColumnTitle


{-| -}
yLabel : (Float -> String) -> Type.Label
yLabel =
    Type.YLabel


{-| -}
xLabel : Type.Label
xLabel =
    Type.XOrdinalLabel


{-| -}
xGroupLabel : Type.Label
xGroupLabel =
    Type.XGroupLabel



-- AXIS


{-| The XAxis type
-}
type alias XAxis value =
    ChartAxis.XAxis value


{-| The YAxis type
-}
type alias YAxis value =
    ChartAxis.YAxis value


{-| It returns an YAxis Left type

Only relevant if the chart orientation is vertical.

    Bar.axisLeft [ Axis.tickCount 5 ]

-}
axisLeft : List (Axis.Attribute value) -> ChartAxis.YAxis value
axisLeft =
    ChartAxis.Left


{-| It returns an YAxis Right type

Only relevant if the chart orientation is vertical.

    Bar.axisRight [ Axis.tickCount 5 ]

-}
axisRight : List (Axis.Attribute value) -> ChartAxis.YAxis value
axisRight =
    ChartAxis.Right


{-| It returns an YAxis Grid type

    Bar.axisGrid [ Axis.tickCount 5 ]

-}
axisGrid : List (Axis.Attribute value) -> ChartAxis.YAxis value
axisGrid =
    ChartAxis.Grid


{-| It returns an XAxis Bottom type

    Bar.axisBottom [ Axis.tickCount 5 ]

-}
axisBottom : List (Axis.Attribute value) -> ChartAxis.XAxis value
axisBottom =
    ChartAxis.Bottom


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


{-| Customise the xAxis

    Bar.init requiredConfig
        |> Bar.withXAxis (Bar.axisBottom [ Axis.tickCount 5 ])
        |> Bar.render ( data, accessor )

-}
withXAxis : ChartAxis.XAxis String -> Config -> Config
withXAxis =
    Type.setXAxisBand


{-| Customise the yAxis

    Bar.init requiredConfig
        |> Bar.withYAxis (Bar.axisRight [ Axis.tickCount 5 ])
        |> Bar.render ( data, accessor )

-}
withYAxis : ChartAxis.YAxis Float -> Config -> Config
withYAxis =
    Type.setYAxisContinuous


{-| Set the Y scale to logaritmic, passing a base

    Bar.init requiredConfig
        |> Bar.withLogYScale 10
        |> Bar.render ( data, accessor )

-}
withLogYScale : Float -> Config -> Config
withLogYScale base =
    Type.setYScale (Type.LogScale base)

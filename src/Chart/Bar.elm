module Chart.Bar exposing
    ( Accessor
    , init
    , render
    , withTitle, withDesc, withColorPalette, withColorInterpolator, withBandGroupDomain, withBandSingleDomain, withLinearDomain, withYAxisTickCount, withYAxisTickFormat, withYAxisTicks, withOrientation, withXAxis, withYAxis, withGroupedLayout, withStackedLayout
    , noDirection, diverging, horizontal, vertical
    , withSymbols, withIndividualLabels
    )

{-| This is the bar chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

The Bar module expects the X axis to plot grouped ordinal data and the Y axis to plot linear data.


# Chart Data Format

@docs Accessor


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration

@docs withTitle, withDesc, withColorPalette, withColorInterpolator, withBandGroupDomain, withBandSingleDomain, withLinearDomain, withYAxisTickCount, withYAxisTickFormat, withYAxisTicks, withOrientation, withXAxis, withYAxis, withGroupedLayout, withStackedLayout


# Configuration arguments

@docs noDirection, diverging, horizontal, vertical


# LayoutConfig

These a specific configurations for the Grouped layout

@docs withSymbols, withIndividualLabels

-}

import Chart.Internal.Bar
    exposing
        ( renderBandGrouped
        , renderBandStacked
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
        , Orientation(..)
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setColorResource
        , setDimensions
        , setHeight
        , setMargin
        , setSvgDesc
        , setSvgTitle
        , setWidth
        , setXAxis
        , setYAxis
        )
import Color exposing (Color)
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| The data accessors
-}
type alias Accessor data =
    { xGroup : data -> String
    , xValue : data -> String
    , yValue : data -> Float
    }


type alias RequiredConfig =
    { margin : Margin
    , width : Float
    , height : Float
    }


{-| Initializes the bar chart passing margin, width and height, whith a default config.

    data : List {groupLabel : String, x : String, y : Float  }
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

    accessor : Bar.Accessor {groupLabel : String, x : String, y : Float  }
    accessor =
        Bar.Accessor .groupLabel .x .y

    Bar.init
        { margin = margin
        , width = width
        , height = height
        }
        |> Bar.render ( data, accessor )

-}
init : RequiredConfig -> Config
init c =
    defaultConfig
        |> setDimensions { margin = c.margin, width = c.width, height = c.height }


{-| Renders the bar chart, after initialisation and customisation.

    Bar.init
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

It takes a direction: `diverging` or `noDirection`

    layout : Config -> Config
    layout =
        Bar.withStackedLayout Bar.diverging

    Bar.init
        |> layout
        |> Bar.render ( data, accessor )

-}
withStackedLayout : Direction -> Config -> Config
withStackedLayout direction config =
    Type.setLayoutRestricted (StackedBar direction) config


{-| Creates a grouped bar chart.

    Bar.init
        |> Bar.withGroupedLayout
        |> Bar.render ( data, accessor )

-}
withGroupedLayout : Config -> Config
withGroupedLayout config =
    Type.setLayout GroupedBar config


{-| Sets the orientation value.

Accepts: horizontal or vertical
Default value: vertical

    Bar.init
        |> Bar.withOrientation horizontal
        |> Bar.render ( data, accessor )

-}
withOrientation : Orientation -> Config -> Config
withOrientation value config =
    Type.setOrientation value config


{-| Passes the tick values for a grouped bar chart continous axis.

Defaults to elm-visualization `Scale.ticks`

    Bar.init
        |> Bar.withYAxisTicks [ 1, 2, 3 ]
        |> Bar.render ( data, accessor )

-}
withYAxisTicks : List Float -> Config -> Config
withYAxisTicks ticks config =
    Type.setYAxisContinousTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for a grouped bar chart continous axis.

Defaults to elm-visualization `Scale.tickCount`

    Bar.init
        |> Bar.withYAxisTickCount 5
        |> Bar.render ( data, accessor )

-}
withYAxisTickCount : Int -> Config -> Config
withYAxisTickCount count config =
    Type.setYAxisContinousTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for the ticks in a grouped bar chart continous axis.

Defaults to elm-visualization `Scale.tickFormat`

    formatter =
        FormatNumber.format { usLocale | decimals = 0 }

    Bar.init
        |> Bar.withYAxisTickFormat formatter
        |> Bar.render (data, accessor)

-}
withYAxisTickFormat : (Float -> String) -> Config -> Config
withYAxisTickFormat f config =
    Type.setYAxisContinousTickFormat (CustomTickFormat f) config


{-| Sets the color palette for the chart.

    palette =
        Scale.Color.tableau10

    Bar.init
        |> Bar.withColorPalette palette
        |> Bar.render (data, accessor)

-}
withColorPalette : List Color -> Config -> Config
withColorPalette palette config =
    Type.setColorResource (ColorPalette palette) config


{-| Sets the color interpolator for the chart.

This option is not supported for stacked bar charts and will have no effect on them.

    Bar.init
        |> Bar.withColorInterpolator Scale.Color.plasmaInterpolator
        |> Bar.render ( data, accessor )

-}
withColorInterpolator : (Float -> Color) -> Config -> Config
withColorInterpolator interpolator config =
    Type.setColorResource (ColorInterpolator interpolator) config


{-| Sets the bandGroup value in the domain, in place of calculating it from the data.

    Bar.init
        |> Bar.withBandGroupDomain [ "0" ]
        |> Bar.render ( data, accessor )

-}
withBandGroupDomain : Type.BandDomain -> Config -> Config
withBandGroupDomain value config =
    Type.setDomainBandBandGroup value config


{-| Sets the bandSingle value in the domain, in place of calculating it from the data.

    Bar.init
        |> Bar.withDomainBandBandSingle [ "a", "b" ]
        |> Bar.render ( data, accessor )

-}
withBandSingleDomain : Type.BandDomain -> Config -> Config
withBandSingleDomain value config =
    Type.setDomainBandBandSingle value config


{-| Sets the bandLinear value in the domain, in place of calculating it from the data.

    Bar.init
        |> Bar.withDomainBandLinear ( 0, 0.55 )
        |> Bar.render ( data, accessor )

-}
withLinearDomain : Type.LinearDomain -> Config -> Config
withLinearDomain value config =
    Type.setDomainBandLinear value config


{-| Show or hide the Y aixs

Default value: True

The Y axis depends from the layout:
With a vertical layout the Y axis is the vertical axis.
With a horizontal layout the Y axis is the horizontal axis.

    Bar.init
        |> Bar.withYAxis False
        |> Bar.render ( data, accessor )

-}
withYAxis : Bool -> Config -> Config
withYAxis value config =
    Type.setYAxis value config


{-| Show or hide the X aixs

Default value: True

The X axis depends from the layout:
With a vertical layout the X axis is the horizontal axis.
With a horizontal layout the X axis is the vertical axis.

    Bar.init
        |> Bar.withXAxis False
        |> Bar.render ( data, accessor )

-}
withXAxis : Bool -> Config -> Config
withXAxis value config =
    Type.setXAxis value config


{-| Sets the Icon Symbols list in the `LayoutConfig`.

Default value: []

These are additional symbols at the end of each bar in a group, for facilitating accessibility.

    defaultLayoutConfig
        |> withSymbols [ Circle, Corner, Triangle ]

-}
withSymbols :
    List Symbol
    -> Config
    -> Config
withSymbols =
    Type.setIcons


{-| Show or hide bar labels in the bar chart groups.

Default value: `False`

This shows the bar's ordinal value at the end of the rect, not the linear value.

If used together with symbols, the label will be drawn on top of the symbol.

&#9888; Use with caution, there is no knowledge of text wrapping!

With a vertical layout the available horizontal space is the width of the rects.

With an horizontal layout the available horizontal space is the right margin.

    defaultLayoutConfig
        |> Bar.withIndividualLabels True

-}
withIndividualLabels : Config -> Config
withIndividualLabels config =
    Type.showIndividualLabels True config


{-| Sets an accessible, long-text description for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Bar.init
        |> Bar.withDesc "This is an accessible chart, with a desc element"
        |> Bar.render ( data, accessor )

-}
withDesc : String -> Config -> Config
withDesc value config =
    Type.setSvgDesc value config


{-| Sets an accessible title for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Bar.init
        |> Bar.withTitle "This is a chart"
        |> Bar.render ( data, accessor )

-}
withTitle : String -> Config -> Config
withTitle value config =
    Type.setSvgTitle value config


{-| Horizontal layout type

Used as argument to Bar.withOrientation

    Bar.init
        |> Bar.withOrientation horizontal
        |> Bar.render ( data, accessor )

-}
horizontal : Orientation
horizontal =
    Horizontal


{-| Vertical layout type

Used as argument to Bar.withOrientation
This is the default layout

    Bar.init
        |> Bar.withOrientation vertical
        |> Bar.render ( data, accessor )

-}
vertical : Orientation
vertical =
    Vertical


{-| Diverging layout for stacked bar charts

An example can be a population pyramid chart.

    Bar.init
        |> Bar.withStackedLayout Bar.diverging
        |> Bar.render ( data, accessor )

-}
diverging : Direction
diverging =
    Type.Diverging


{-| Default layout for stacked bar charts, where tha bars are sequentially stacked
one upon another.

    Bar.init
        |> Bar.withStackedLayout Bar.noDirection
        |> Bar.render ( data, accessor )

-}
noDirection : Direction
noDirection =
    Type.NoDirection

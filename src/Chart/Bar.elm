module Chart.Bar exposing
    ( Accessor
    , init
    , render
    , setColorPalette, setColorInterpolator, setDesc, setDimensions, setDomainBandGroup, setDomainBandSingle, setDomainLinear, setHeight, setLayout, setAxisYTickCount, setAxisYTickFormat, setAxisYTicks, setMargin, setOrientation, showAxisX, showAxisY, setTitle, setWidth
    , groupedConfig, groupedLayout, horizontalOrientation, noDirection, stackedLayout, verticalOrientation
    , setIcons, showIndividualLabels
    , BarSymbol, symbolCircle, symbolCorner, symbolCustom, symbolTriangle, setSymbolHeight, setSymbolIdentifier, setSymbolPaths, setSymbolUseGap, setSymbolWidth
    , diverging, stackedConfig
    )

{-| This is the bar chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

The Bar module expects the X axis to plot grouped ordinal data and the Y axis to plot linear data.


# Chart Data Format

@docs Accessor


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs setColorPalette, setColorInterpolator, setDesc, setDimensions, setDomainBandGroup, setDomainBandSingle, setDomainLinear, setHeight, setLayout, setAxisYTickCount, setAxisYTickFormat, setAxisYTicks, setMargin, setOrientation, showAxisX, showAxisY, setTitle, setWidth


# Configuration setters arguments

@docs groupedConfig, divergingDirection, groupedLayout, horizontalOrientation, noDirection, stackedLayout, verticalOrientation


# GroupedConfig setters

These a specific configurations for the Grouped layout

@docs setIcons, showIndividualLabels


# Chart icons

Icons can be added to grouped bar charts to improve understanding and accessibility.

    iconsCustom : List (Bar.BarSymbol msg)
    iconsCustom =
        [ Bar.symbolCustom
            |> Bar.setSymbolIdentifier "bicycle-symbol"
            |> Bar.setSymbolWidth 640
            |> Bar.setSymbolHeight 512
            |> Bar.setSymbolPaths [ bicycleSymbol ]
        , Bar.symbolCustom
            |> Bar.setSymbolIdentifier "car-symbol"
            |> Bar.setSymbolWidth 640
            |> Bar.setSymbolHeight 512
            |> Bar.setSymbolPaths [ carSymbol ]
        , Bar.symbolCustom
            |> Bar.setSymbolIdentifier "plane-symbol"
            |> Bar.setSymbolWidth 576
            |> Bar.setSymbolHeight 512
            |> Bar.setSymbolPaths [ planeSymbol ]
        ]

    groupedLayout =
        Bar.groupedLayout
            (Bar.groupedConfig
                |> Bar.setIcons
            )

    Bar.init
        |> Bar.setLayout groupedLayout
        |> Bar.render ( data, accessor )

@docs BarSymbol, symbolCircle, symbolCorner, symbolCustom, symbolTriangle, setSymbolHeight, setSymbolIdentifier, setSymbolPaths, setSymbolUseGap, setSymbolWidth

-}

import Chart.Internal.Bar
    exposing
        ( renderBandGrouped
        , renderBandStacked
        )
import Chart.Internal.Symbol as Symbol exposing (Symbol(..))
import Chart.Internal.Type as Type
    exposing
        ( AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , ColorResource(..)
        , Config
        , Direction(..)
        , GroupedConfig
        , Layout(..)
        , Margin
        , Orientation(..)
        , RenderContext(..)
        , StackedConfig
        , defaultConfig
        , fromConfig
        , setColorResource
        , setDimensions
        , setTitle
        , showAxisX
        , showAxisY
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


{-| Initializes the bar chart with a default config.

    Bar.init
        |> Bar.render ( data, accessor )

-}
init : Config
init =
    defaultConfig


{-| Renders the bar chart, after initialisation and customisation.

    data : List data
    data =
        [ { groupLabel = "A"
          , x = "a"
          , y = 10
          }
        , { groupLabel = "A"
          , x = "b"
          , y = 13
          }
        , { groupLabel = "B"
          , x = "a"
          , y = 11
          }
        , { groupLabel = "B"
          , x = "b"
          , y = 23
          }
        ]

    accessor : Accessor data
    accessor =
        Accessor .groupLabel .x .y

    Bar.init
        |> Bar.render (data, accessor)

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
        Grouped _ ->
            renderBandGrouped ( data, config )

        Stacked _ ->
            renderBandStacked ( data, config )


{-| Sets the outer height of the bar chart.

Default value: 400

    Bar.init
        |> Bar.setHeight 600
        |> Bar.render ( data, accessor )

-}
setHeight : Float -> Config -> Config
setHeight value config =
    Type.setHeight value config


{-| Sets the outer width of the bar chart.

Default value: 600

    Bar.init
        |> Bar.setWidth 800
        |> Bar.render ( data, accessor )

-}
setWidth : Float -> Config -> Config
setWidth value config =
    Type.setWidth value config


{-| Sets the chart layout.

Values: `Bar.stackedLayout` or `Bar.groupedLayout`

Default value: Bar.groupedLayout

    Bar.init
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.render ( data, accessor )

-}
setLayout : Layout -> Config -> Config
setLayout value config =
    Type.setLayout value config


{-| Sets an accessible, long-text description for the svg chart.

Default value: ""

    Bar.init
        |> Bar.setDesc "This is an accessible chart, with a desc element"
        |> Bar.render ( data, accessor )

-}
setDesc : String -> Config -> Config
setDesc value config =
    Type.setDesc value config


{-| Sets an accessible title for the svg chart.

Default value: ""

    Bar.init
        |> Bar.setTitle "This is a chart"
        |> Bar.render ( data, accessor )

-}
setTitle : String -> Config -> Config
setTitle value config =
    Type.setTitle value config


{-| Sets the orientation value in the config.

Accepts: horizontalOrientation or verticalOrientation
Default value: verticalOrientation

    Bar.init
        |> Bar.setOrientation horizontalOrientation
        |> Bar.render ( data, accessor )

-}
setOrientation : Orientation -> Config -> Config
setOrientation value config =
    Type.setOrientation value config


{-| Sets the margin values in the config.

It follows d3s [margin convention](https://bl.ocks.org/mbostock/3019563).

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Bar.init
    |> Bar.setMargin margin
    |> Bar.render ( data, accessor )

-}
setMargin : Margin -> Config -> Config
setMargin value config =
    Type.setMargin value config


{-| Passes the tick values for a grouped bar chart continous axis.

Defaults to `Scale.ticks`

    Bar.init
        |> Bar.setAxisYTicks [ 1, 2, 3 ]
        |> Bar.render ( data, accessor )

-}
setAxisYTicks : List Float -> Config -> Config
setAxisYTicks ticks config =
    Type.setAxisYContinousTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for a grouped bar chart continous axis.

Defaults to `Scale.tickCount`

    Bar.init
        |> Bar.setAxisYTickCount 5
        |> Bar.render ( data, accessor )

-}
setAxisYTickCount : Int -> Config -> Config
setAxisYTickCount count config =
    Type.setAxisYContinousTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for the ticks in a grouped bar chart continous axis.

Defaults to `Scale.tickFormat`

    formatter =
        FormatNumber.format { usLocale | decimals = 0 }

    Bar.init
        |> Bar.setAxisYTickFormat formatter
        |> Bar.render (data, accessor)

-}
setAxisYTickFormat : (Float -> String) -> Config -> Config
setAxisYTickFormat f config =
    Type.setAxisYContinousTickFormat (CustomTickFormat f) config


{-| Sets the margin, width and height all at once.
Prefer this method from the individual ones when you need to set all three values at once.

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Bar.init
        |> Bar.setDimensions
            { margin = margin
            , width = 400
            , height = 400
            }
        |> Bar.render (data, accessor)

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions value config =
    Type.setDimensions value config


{-| Sets the color palette for the chart.

    palette =
        Scale.Color.tableau10

    Bar.init
        |> Bar.setColorPalette palette
        |> Bar.render (data, accessor)

-}
setColorPalette : List Color -> Config -> Config
setColorPalette palette config =
    Type.setColorResource (ColorPalette palette) config


{-| Sets the color interpolator for the chart.

This setting is not supported for stacked bar charts and will have no effect on them.

    Bar.init
        |> Bar.setColorInterpolator Scale.Color.plasmaInterpolator
        |> Bar.render ( data, accessor )

-}
setColorInterpolator : (Float -> Color) -> Config -> Config
setColorInterpolator interpolator config =
    Type.setColorResource (ColorInterpolator interpolator) config


{-| Sets the bandGroup value in the domain, in place of calculating it from the data.

    Bar.init
        |> Bar.setDomainBandBandGroup [ "0" ]
        |> Bar.render ( data, accessor )

-}
setDomainBandGroup : Type.BandDomain -> Config -> Config
setDomainBandGroup value config =
    Type.setDomainBandBandGroup value config


{-| Sets the bandSingle value in the domain, in place of calculating it from the data.

    Bar.init
        |> Bar.setDomainBandBandSingle [ "a", "b" ]
        |> Bar.render ( data, accessor )

-}
setDomainBandSingle : Type.BandDomain -> Config -> Config
setDomainBandSingle value config =
    Type.setDomainBandBandSingle value config


{-| Sets the bandLinear value in the domain, in place of calculating it from the data.

    Bar.init
        |> Bar.setDomainBandLinear ( 0, 0.55 )
        |> Bar.render ( data, accessor )

-}
setDomainLinear : Type.LinearDomain -> Config -> Config
setDomainLinear value config =
    Type.setDomainBandLinear value config


{-| Sets the showAxisY boolean value in the config

Default value: True

By convention the Y axix is the vertical one, but
if the layout is changed to horizontal, then the Y axis
represents the horizontal one.

    Bar.init
        |> Bar.showAxisY False
        |> Bar.render ( data, accessor )

-}
showAxisY : Bool -> Config -> Config
showAxisY value config =
    Type.showAxisY value config


{-| Sets the showOrdinalAxis boolean value in the config

Default value: True

By convention the X axix is the horizontal one, but
if the layout is changed to vertical, then the X axis
represents the vertical one.

    Bar.init
        |> Bar.showOrdinalAxis False
        |> Bar.render ( data, accessor )

-}
showAxisX : Bool -> Config -> Config
showAxisX value config =
    Type.showAxisX value config


{-| Sets the Icon Symbols list in the `GroupedConfig`.

Default value: []

These are additional symbols at the end of each bar in a group, for facilitating accessibility.

    groupedConfig
        |> setIcons [ Circle, Corner, Triangle ]

-}
setIcons : List (Symbol String) -> GroupedConfig -> GroupedConfig
setIcons =
    Type.setIcons


{-| Sets the `showIndividualLabels` boolean value in the `GroupedConfig`.

Default value: `False`

This shows the bar's ordinal value at the end of the rect, not the linear value.

If used together with symbols, the label will be drawn on top of the symbol.

&#9888; Use with caution, there is no knowledge of text wrapping!

With a vertical layout the available horizontal space is the width of the rects.

With an horizontal layout the available horizontal space is the right margin.

    groupedConfig
        |> Bar.showIndividualLabels True

-}
showIndividualLabels : Bool -> GroupedConfig -> GroupedConfig
showIndividualLabels =
    Type.showIndividualLabels


{-| Horizontal layout type
Used as argument to Bar.setOrientation

    Bar.init
        |> Bar.setOrientation horizontalOrientation
        |> Bar.render ( data, accessor )

-}
horizontalOrientation : Orientation
horizontalOrientation =
    Horizontal


{-| Vertical layout type
Used as argument to Bar.setOrientation
This is the default layout

    Bar.init
        |> Bar.setOrientation verticalOrientation
        |> Bar.render ( data, accessor )

-}
verticalOrientation : Orientation
verticalOrientation =
    Vertical


{-| Stacked layout type

Beware that stacked layouts do not support icons

`stackedLayout` expects a `noDirection` or a `divergingDirection` argument.

    Bar.init
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.render ( data, accessor )

-}
stackedLayout : StackedConfig -> Layout
stackedLayout config =
    Stacked config


{-| Grouped layout type
This is the default layout type

    groupedLayout =
        Bar.groupedLayout Bar.groupedConfig

    Bar.init
        |> Bar.setLayout groupedLayout
        |> Bar.render (data, accessor)

-}
groupedLayout : GroupedConfig -> Layout
groupedLayout config =
    Grouped config


{-| Bar chart diverging layout
It is only used for stacked layouts
An example can be a population pyramid chart.

    stackedLayout =
        Bar.stackedLayout Bar.divergingDirection

    Bar.init
        |> Bar.setLayout (Bar.stackedLayout (Bar.stackedConfig |> Bar.diverging))
        |> Bar.setLayout stackedLayout
        |> Bar.render (data, accessor)

-}
diverging : StackedConfig -> StackedConfig
diverging config =
    Type.setDirection Diverging config


{-| Bar chart no-direction layout
It is only used for stacked layouts

    Bar.init
        |> Bar.setLayout (Bar.stackedLayout (Bar.stackedConfig |> Bar.noDirection))
        |> Bar.render ( data, accessor )

-}
noDirection : StackedConfig -> StackedConfig
noDirection config =
    Type.setDirection NoDirection config


{-| Default values for the Grouped Layout specific config
Used for initialization purposes

    groupedConfig : GroupedConfig
    groupedConfig =
        Bar.groupedConfig
            |> ChartType.setIcons (icons "chart-a")


    Bar.init
        |> Bar.setLayout (Bar.groupedLayout )
        |> Bar.render (data, accessor)

-}
groupedConfig : GroupedConfig
groupedConfig =
    Type.groupedConfig


{-| Default values for the Grouped Layout specific config
Used for initialization purposes

    stackedConfig : GroupedConfig
    stackedConfig =
        Bar.stackedConfig
            |> ChartType.setIcons (icons "chart-a")


    Bar.init
        |> Bar.setLayout (Bar.stackedLayout )
        |> Bar.render (data, accessor)

-}
stackedConfig : StackedConfig
stackedConfig =
    Type.stackedConfig


{-| Bar chart symbol type
-}
type alias BarSymbol msg =
    Symbol msg


{-| A custom bar chart symbol type
-}
symbolCustom : BarSymbol msg
symbolCustom =
    Custom Symbol.initialCustomSymbolConf


{-| Set the custom symbol identifier
-}
setSymbolIdentifier : String -> BarSymbol msg -> BarSymbol msg
setSymbolIdentifier identifier symbol =
    case symbol of
        Custom conf ->
            Custom { conf | identifier = identifier }

        _ ->
            symbol


{-| Set the custom symbol width
When using a custom svg icon this is the 3rd argument of its viewBox attribute
-}
setSymbolWidth : Float -> BarSymbol msg -> BarSymbol msg
setSymbolWidth width symbol =
    case symbol of
        Custom conf ->
            Custom { conf | width = width }

        _ ->
            symbol


{-| Set the custom symbol height
When using a custom svg icon this is the 4th argument of its viewBox attribute
-}
setSymbolHeight : Float -> BarSymbol msg -> BarSymbol msg
setSymbolHeight height symbol =
    case symbol of
        Custom conf ->
            Custom { conf | height = height }

        _ ->
            symbol


{-| Set the custom symbol paths
When using a custom svg icon these are the d attribute of the path elements
-}
setSymbolPaths : List String -> BarSymbol msg -> BarSymbol msg
setSymbolPaths paths symbol =
    case symbol of
        Custom conf ->
            Custom { conf | paths = paths }

        _ ->
            symbol


{-| Set the useGap boolean flag.

All bar chart icons are drawn with a gap from the bar rectangles,
but, depending on the custom icon shape and on the orientation of the chart,
the icon could already have a gap and we do not want to add other space.

-}
setSymbolUseGap : Bool -> BarSymbol msg -> BarSymbol msg
setSymbolUseGap bool symbol =
    case symbol of
        Custom conf ->
            Custom { conf | useGap = bool }

        _ ->
            symbol


{-| Circle symbol type
-}
symbolCircle : String -> BarSymbol msg
symbolCircle id =
    Circle id


{-| Triangle symbol type
-}
symbolTriangle : String -> BarSymbol msg
symbolTriangle id =
    Triangle id


{-| Corner symbol type
-}
symbolCorner : String -> BarSymbol msg
symbolCorner id =
    Corner id

module Chart.Bar exposing
    ( DataGroupBand, Accessor
    , init
    , render
    , setDesc, setDimensions, setDomainBandGroup, setDomainBandSingle, setDomainLinear, setHeight, setLayout, setMargin, setOrientation, setTitle, setWidth
    , defaultGroupedConfig, divergingDirection, groupedLayout, horizontalOrientation, noDirection, stackedLayout, verticalOrientation
    , setIcons, setShowIndividualLabels
    , BarSymbol, symbolCircle, symbolCorner, symbolCustom, symbolTriangle, setSymbolHeight, setSymbolIdentifier, setSymbolPaths, setSymbolUseGap, setSymbolWidth
    , setAxisYTickCount, setAxisYTickFormat, setAxisYTicks, setShowXAxis, setShowYAxis
    )

{-| This is the bar chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).


# Chart Data Format

@docs DataGroupBand, Accessor


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs setDesc, setDimensions, setDomainBandGroup, setDomainBandSingle, setDomainLinear, setHeight, setLayout, setLinearAxisTickCount, setLinearAxisTickFormat, setLinearAxisTicks, setMargin, setOrientation, setShowContinousAxis, setShowOrdinalAxis, setTitle, setWidth


# Configuration setters arguments

@docs defaultGroupedConfig, divergingDirection, groupedLayout, horizontalOrientation, noDirection, stackedLayout, verticalOrientation


# GroupedConfig setters

These a specific configurations for the Grouped layout

@docs setIcons, setShowIndividualLabels


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
            (Bar.defaultGroupedConfig
                |> Bar.setIcons
            )

    Bar.init data
        |> Bar.setLayout groupedLayout

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
        , Config
        , Direction(..)
        , GroupedConfig
        , Layout(..)
        , Margin
        , Orientation(..)
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setDimensions
        , setShowXAxis
        , setShowYAxis
        , setTitle
        )
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| Bar chart data format.

    dataGroupBand : Bar.DataGroupBand
    dataGroupBand =
        { groupLabel = Just "A"
        , points =
            [ ( "a", 10 )
            , ( "b", 13 )
            , ( "c", 16 )
            ]
        }

-}
type alias DataGroupBand =
    Type.DataGroupBand


{-| Initializes the bar chart with a default config.

    Bar.init
        |> Bar.render data

-}
init : Config
init =
    defaultConfig


{-| Renders the bar chart, after initialisation and customisation.

    data : List DataGroupBand
    data =
        [ { groupLabel = Nothing
          , points = [ ( "a", 10 ) ]
          }
        ]

    Bar.init
        |> Bar.render data

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
        |> Bar.render data

-}
setHeight : Float -> Config -> Config
setHeight value config =
    Type.setHeight value config


{-| Sets the outer width of the bar chart.

Default value: 600

    Bar.init
        |> Bar.setWidth 800
        |> Bar.render data

-}
setWidth : Float -> Config -> Config
setWidth value config =
    Type.setWidth value config


{-| Sets the chart layout.

Values: Bar.stackedLayout or Bar.groupedLayout

Default value: Bar.groupedLayout

    Bar.init
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.render data

-}
setLayout : Layout -> Config -> Config
setLayout value config =
    Type.setLayout value config


{-| Sets an accessible, long-text description for the svg chart.

Default value: ""

    Bar.init
        |> Bar.setDesc "This is an accessible chart, with a desc element"
        |> Bar.render data

-}
setDesc : String -> Config -> Config
setDesc value config =
    Type.setDesc value config


{-| Sets an accessible title for the svg chart.

Default value: ""

    Bar.init
        |> Bar.setTitle "This is a chart"
        |> Bar.render data

-}
setTitle : String -> Config -> Config
setTitle value config =
    Type.setTitle value config


{-| Sets the orientation value in the config.

Default value: Vertical

    Bar.init
        |> Bar.setOrientation horizontalOrientation
        |> Bar.render data

-}
setOrientation : Orientation -> Config -> Config
setOrientation value config =
    Type.setOrientation value config


{-| Sets the margin values in the config.

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Bar.init data
    |> Bar.setMargin margin
    |> Bar.render

-}
setMargin : Margin -> Config -> Config
setMargin value config =
    Type.setMargin value config


{-| Passes the tick values for a grouped bar chart continous axis.

Defaults to `Scale.ticks`

    Bar.init
        |> Bar.setLinearAxisTicks [ 1, 2, 3 ]
        |> Bar.render data

-}
setAxisYTicks : List Float -> Config -> Config
setAxisYTicks ticks config =
    Type.setAxisContinousYTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for a grouped bar chart continous axis.

Defaults to `Scale.tickCount`

    Bar.init
        |> Bar.setLinearAxisTickCount 5
        |> Bar.render data

-}
setAxisYTickCount : Int -> Config -> Config
setAxisYTickCount count config =
    Type.setAxisContinousYTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for the ticks in a grouped bar chart continous axis.

Defaults to `Scale.tickFormat`

    formatter =
        FormatNumber.format { usLocale | decimals = 0 }

    Bar.init
        |> Bar.setLinearAxisTickFormat formatter
        |> Bar.render data

-}
setAxisYTickFormat : (Float -> String) -> Config -> Config
setAxisYTickFormat f config =
    Type.setAxisContinousXTickFormat (CustomTickFormat f) config


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
        |> Bar.render data

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions value config =
    Type.setDimensions value config


{-| Sets the bandGroup value in the domain, in place of calculating it from the data.

    Bar.init
        |> Bar.setDomainBandBandGroup [ "0" ]
        |> Bar.render data

-}
setDomainBandGroup : Type.BandDomain -> Config -> Config
setDomainBandGroup value config =
    Type.setDomainBandBandGroup value config


{-| Sets the bandSingle value in the domain, in place of calculating it from the data.

    Bar.init
        |> Bar.setDomainBandBandSingle [ "a", "b" ]
        |> Bar.render data

-}
setDomainBandSingle : Type.BandDomain -> Config -> Config
setDomainBandSingle value config =
    Type.setDomainBandBandSingle value config


{-| Sets the bandLinear value in the domain, in place of calculating it from the data.

    Bar.init
        |> Bar.setDomainBandLinear ( 0, 0.55 )
        |> Bar.render data

-}
setDomainLinear : Type.LinearDomain -> Config -> Config
setDomainLinear value config =
    Type.setDomainBandLinear value config


{-| Sets the showContinousAxis boolean value in the config
Default value: True
This shows the bar's continous scale axis

    Bar.init
        |> Bar.setShowContinousAxis False
        |> Bar.render data

-}
setShowYAxis : Bool -> Config -> Config
setShowYAxis value config =
    Type.setShowYAxis value config


{-| Sets the showOrdinalAxis boolean value in the config
Default value: True
This shows the bar's ordinal scale axis

    Bar.init
        |> Bar.setShowOrdinalAxis False
        |> Bar.render data

-}
setShowXAxis : Bool -> Config -> Config
setShowXAxis value config =
    Type.setShowXAxis value config


{-| Sets the Icon Symbols list in the `GroupedConfig`.

Default value: []

These are additional symbols at the end of each bar in a group, for facilitating accessibility.

    defaultGroupedConfig
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

    defaultGroupedConfig
        |> Bar.setShowIndividualLabels True

-}
setShowIndividualLabels : Bool -> GroupedConfig -> GroupedConfig
setShowIndividualLabels =
    Type.setShowIndividualLabels


{-| Horizontal layout type
Used as argument to Bar.setOrientation

    Bar.init
        |> Bar.setOrientation horizontalOrientation
        |> Bar.render data

-}
horizontalOrientation : Orientation
horizontalOrientation =
    Horizontal


{-| Vertical layout type
Used as argument to Bar.setOrientation
This is the default layout

    Bar.init
        |> Bar.setOrientation verticalOrientation
        |> Bar.render data

-}
verticalOrientation : Orientation
verticalOrientation =
    Vertical


{-| Stacked layout type
Stacked layouts can not have icons

    Bar.init
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.render data

-}
stackedLayout : Direction -> Layout
stackedLayout direction =
    Stacked direction


{-| Grouped layout type
This is the default layout type

    groupedLayout =
        Bar.groupedLayout Bar.defaultGroupedConfig

    Bar.init
        |> Bar.setLayout groupedLayout
        |> Bar.render data

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
        |> Bar.setLayout stackedLayout
        |> Bar.render data

-}
divergingDirection : Direction
divergingDirection =
    Diverging


{-| Bar chart no-direction layout
It is only used for stacked layouts

    Bar.init
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.render data

-}
noDirection : Direction
noDirection =
    NoDirection


{-| Default values for the Grouped Layout specific config
Used for initialization purposes

    groupedConfig : GroupedConfig
    groupedConfig =
        Bar.defaultGroupedConfig
            |> ChartType.setIcons (icons "chart-a")


    Bar.init
        |> Bar.setLayout (Bar.groupedLayout )
        |> Bar.render data

-}
defaultGroupedConfig : GroupedConfig
defaultGroupedConfig =
    Type.defaultGroupedConfig


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
    , xValue : data -> String
    , yValue : data -> Float
    }



--Type.AccessorBand data

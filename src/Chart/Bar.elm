module Chart.Bar exposing
    ( DataGroupBand
    , init
    , render
    , setDesc, setDimensions, setDomainBandGroup, setDomainBandSingle, setDomainLinear, setHeight, setLayout, setLinearAxisTickCount, setLinearAxisTickFormat, setLinearAxisTicks, setMargin, setOrientation, setShowContinousAxis, setShowOrdinalAxis, setTitle, setWidth
    , defaultGroupedConfig, divergingDirection, domainBand, groupedLayout, horizontalOrientation, noDirection, stackedLayout, verticalOrientation
    , setIcons, setShowIndividualLabels
    , BarSymbol, symbolCircle, symbolCorner, symbolCustom, symbolTriangle, setSymbolHeight, setSymbolIdentifier, setSymbolPaths, setSymbolUseGap, setSymbolWidth
    )

{-| This is the bar chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).


# Chart Data Format

@docs DataGroupBand


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs setDesc, setDimensions, setDomainBandGroup, setDomainBandSingle, setDomainLinear, setHeight, setLayout, setLinearAxisTickCount, setLinearAxisTickFormat, setLinearAxisTicks, setMargin, setOrientation, setShowContinousAxis, setShowOrdinalAxis, setTitle, setWidth


# Configuration setters arguments

@docs defaultGroupedConfig, divergingDirection, Domain, domainBand, groupedLayout, horizontalOrientation, noDirection, stackedLayout, verticalOrientation


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
        , Data
        , Direction(..)
        , Domain
        , DomainBandStruct
        , GroupedConfig
        , Layout(..)
        , Margin
        , Orientation(..)
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setDimensions
        , setShowContinousAxis
        , setShowOrdinalAxis
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


{-| Initializes the bar chart with the data.

    data : List DataGroupBand
    data =
        [ { groupLabel = Nothing
          , points = [ ( "a", 10 ) ]
          }
        ]

    Bar.init data

-}
init : List DataGroupBand -> ( List DataGroupBand, Config )
init data =
    ( data, defaultConfig )


{-| Renders the bar chart, after initialisation and customisation.

    Bar.init data
        |> Bar.render

-}
render : ( List DataGroupBand, Config ) -> Html msg
render ( data, config ) =
    let
        c =
            fromConfig config
    in
    case c.layout of
        Grouped _ ->
            renderBandGrouped ( Type.DataBand data, config )

        Stacked _ ->
            renderBandStacked ( Type.DataBand data, config )


{-| Sets the outer height of the bar chart.

Default value: 400

    Bar.init data
        |> Bar.setHeight 600
        |> Bar.render

-}
setHeight : Float -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setHeight value ( data, config ) =
    Type.setHeight value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the outer width of the bar chart.

Default value: 600

    Bar.init data
        |> Bar.setWidth 800
        |> Bar.render

-}
setWidth : Float -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setWidth value ( data, config ) =
    Type.setWidth value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the chart layout.

Values: Bar.stackedLayout or Bar.groupedLayout

Default value: Bar.groupedLayout

    Bar.init data
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.render

-}
setLayout : Layout -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setLayout value ( data, config ) =
    Type.setLayout value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets an accessible, long-text description for the svg chart.

Default value: ""

    Bar.init data
        |> Bar.setDesc "This is an accessible chart, with a desc element"
        |> Bar.render

-}
setDesc : String -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setDesc value ( data, config ) =
    Type.setDesc value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets an accessible title for the svg chart.

Default value: ""

    Bar.init data
        |> Bar.setTitle "This is a chart"
        |> Bar.render

-}
setTitle : String -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setTitle value ( data, config ) =
    Type.setTitle value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the orientation value in the config.

Default value: Vertical

    Bar.init data
        |> Bar.setOrientation horizontalOrientation
        |> Bar.render

-}
setOrientation : Orientation -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setOrientation value ( data, config ) =
    Type.setOrientation value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the margin values in the config.

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Bar.init data
        |> Bar.setMargin margin
        |> Bar.render

-}
setMargin : Margin -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setMargin value ( data, config ) =
    Type.setMargin value ( Type.DataBand data, config ) |> fromDataBand


{-| Passes the tick values for a grouped bar chart continous axis.

Defaults to `Scale.ticks`

    Bar.init data
        |> Bar.setLinearAxisTicks [ 1, 2, 3 ]
        |> Bar.render

-}
setLinearAxisTicks : List Float -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setLinearAxisTicks ticks ( data, config ) =
    Type.setAxisContinousDataTicks (Type.CustomTicks ticks) ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the approximate number of ticks for a grouped bar chart continous axis.

Defaults to `Scale.tickCount`

    Bar.init data
        |> Bar.setLinearAxisTickCount 5
        |> Bar.render

-}
setLinearAxisTickCount : Int -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setLinearAxisTickCount count ( data, config ) =
    Type.setAxisContinousDataTickCount (Type.CustomTickCount count) ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the formatting for the ticks in a grouped bar chart continous axis.

Defaults to `Scale.tickFormat`

    formatter =
        FormatNumber.format { usLocale | decimals = 0 }


    Bar.init data
        |> Bar.setLinearAxisTickFormat formatter
        |> Bar.render

-}
setLinearAxisTickFormat : (Float -> String) -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setLinearAxisTickFormat f ( data, config ) =
    Type.setAxisContinousDataTickFormat (CustomTickFormat f) ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the margin, width and height all at once.
Prefer this method from the individual ones when you need to set all three values at once.

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Bar.init data
        |> Bar.setDimensions
            { margin = margin
            , width = 400
            , height = 400
            }
        |> Bar.render

-}
setDimensions :
    { margin : Margin, width : Float, height : Float }
    -> ( List DataGroupBand, Config )
    -> ( List DataGroupBand, Config )
setDimensions value ( data, config ) =
    Type.setDimensions value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the bandGroup value in the domain, in place of calculating it from the data.

    Bar.init data
        |> Bar.setDomainBandBandGroup [ "0" ]
        |> Bar.render

-}
setDomainBandGroup : Type.BandDomain -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setDomainBandGroup value ( data, config ) =
    Type.setDomainBandBandGroup value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the bandSingle value in the domain, in place of calculating it from the data.

    Bar.init data
        |> Bar.setDomainBandBandSingle [ "a", "b" ]
        |> Bar.render

-}
setDomainBandSingle : Type.BandDomain -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setDomainBandSingle value ( data, config ) =
    Type.setDomainBandBandSingle value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the bandLinear value in the domain, in place of calculating it from the data.

    Bar.init data
        |> Bar.setDomainBandLinear ( 0, 0.55 )
        |> Bar.render

-}
setDomainLinear : Type.LinearDomain -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setDomainLinear value ( data, config ) =
    Type.setDomainBandLinear value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the showContinousAxis boolean value in the config
Default value: True
This shows the bar's continous scale axis

    Bar.init data
        |> Bar.setShowContinousAxis False
        |> Bar.render

-}
setShowContinousAxis : Bool -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setShowContinousAxis value ( data, config ) =
    Type.setShowContinousAxis value ( Type.DataBand data, config ) |> fromDataBand


{-| Sets the showOrdinalAxis boolean value in the config
Default value: True
This shows the bar's ordinal scale axis

    Bar.init data
        |> Bar.setShowOrdinalAxis False
        |> Bar.render

-}
setShowOrdinalAxis : Bool -> ( List DataGroupBand, Config ) -> ( List DataGroupBand, Config )
setShowOrdinalAxis value ( data, config ) =
    Type.setShowOrdinalAxis value ( Type.DataBand data, config ) |> fromDataBand


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

    data : List DataGroupBand
    data =
        [ { groupLabel = Nothing
          , points = [ ( "a", 10 ) ]
          }
        ]

    Bar.init data
        |> Bar.setOrientation horizontalOrientation

-}
horizontalOrientation : Orientation
horizontalOrientation =
    Horizontal


{-| Vertical layout type
Used as argument to Bar.setOrientation
This is the default layout

    data : List DataGroupBand
    data =
        [ { groupLabel = Nothing
          , points = [ ( "a", 10 ) ]
          }
        ]

    Bar.init data
        |> Bar.setOrientation verticalOrientation

-}
verticalOrientation : Orientation
verticalOrientation =
    Vertical


{-| Stacked layout type
Stacked layouts can not have icons

    data : List DataGroupBand
    data =
        [ { groupLabel = Nothing
          , points = [ ( "a", 10 ) ]
          }
        ]

    Bar.init data
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)

-}
stackedLayout : Direction -> Layout
stackedLayout direction =
    Stacked direction


{-| Grouped layout type
This is the default layout type

    data : List DataGroupBand
    data =
        [ { groupLabel = Nothing
          , points = [ ( "a", 10 ) ]
          }
        ]

    groupedLayout =
        Bar.groupedLayout Bar.defaultGroupedConfig

    Bar.init data
        |> Bar.setLayout groupedLayout

-}
groupedLayout : GroupedConfig -> Layout
groupedLayout config =
    Grouped config


{-| Bar chart diverging layout
It is only used for stacked layouts
An example can be a population pyramid chart.

    data : List DataGroupBand
    data =
        [ { groupLabel = Nothing
          , points = [ ( "a", 10 ) ]
          }
        ]

    stackedLayout =
        Bar.stackedLayout Bar.divergingDirection

    Bar.init data
        |> Bar.setLayout stackedLayout

-}
divergingDirection : Direction
divergingDirection =
    Diverging


{-| Bar chart no-direction layout
It is only used for stacked layouts

    data : List DataGroupBand
    data =
        [ { groupLabel = Nothing
          , points = [ ( "a", 10 ) ]
          }
        ]

    Bar.init data
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)

-}
noDirection : Direction
noDirection =
    NoDirection


{-| Default values for the Grouped Layout specific config
Used for initialization purposes

    data : List DataGroupBand
    data =
        [ { groupLabel = Nothing
          , points = [ ( "a", 10 ) ]
          }
        ]

    groupedConfig : GroupedConfig
    groupedConfig =
        Bar.defaultGroupedConfig
            |> ChartType.setIcons (icons "chart-a")


    Bar.init data
        |> Bar.setLayout (Bar.groupedLayout )

-}
defaultGroupedConfig : GroupedConfig
defaultGroupedConfig =
    Type.defaultGroupedConfig


{-| DomainBand constructor

    dummyDomainBandStruct : DomainBandStruct
    dummyDomainBandStruct =
        { bandGroup = []
        , bandSingle = []
        , linear = ( 0, 0 )
        }

    domain : Domain
    domain =
        domainBand dummyDomainBandStruct

-}
domainBand : DomainBandStruct -> Domain
domainBand struct =
    Type.DomainBand struct


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



--INTERNAL


fromDataBand : ( Data, Config ) -> ( List DataGroupBand, Config )
fromDataBand ( data, config ) =
    ( Type.fromDataBand data, config )

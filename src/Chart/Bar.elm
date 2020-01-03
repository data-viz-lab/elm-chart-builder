module Chart.Bar exposing
    ( BarSymbol
    , Data
    , DataGroupBand
    , Domain
    , dataBand
    , defaultGroupedConfig
    , divergingDirection
    , domainBand
    , getDomainFromData
    , groupedLayout
    , horizontalOrientation
    , init
    , linearAxisCustomTickCount
    , linearAxisCustomTickFormat
    , linearAxisCustomTicks
    , noDirection
    , render
    , setDesc
    , setDimensions
    , setDomain
    , setDomainBandBandGroup
    , setDomainBandBandSingle
    , setDomainBandLinear
    , setHeight
    , setIcons
    , setLayout
    , setLinearAxisTickCount
    , setLinearAxisTickFormat
    , setLinearAxisTicks
    , setMargin
    , setOrientation
    , setShowContinousAxis
    , setShowIndividualLabels
    , setShowOrdinalAxis
    , setSymbolHeight
    , setSymbolIdentifier
    , setSymbolPaths
    , setSymbolUseGap
    , setSymbolWidth
    , setTitle
    , setWidth
    , stackedLayout
    , symbolCircle
    , symbolCorner
    , symbolCustom
    , symbolTriangle
    , verticalOrientation
    )

import Chart.Internal.Bar
    exposing
        ( renderBandGrouped
        , renderBandStacked
        , wrongDataTypeErrorView
        )
import Chart.Internal.Symbol as Symbol exposing (Symbol(..))
import Chart.Internal.Type as Type
    exposing
        ( AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , Config
        , DataGroupBand
        , Direction(..)
        , DomainBandStruct
        , GroupedConfig
        , Layout(..)
        , Margin
        , Orientation(..)
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setDimensions
        , setDomain
        , setShowContinousAxis
        , setShowOrdinalAxis
        , setTitle
        )
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))



-- API METHODS


{-| Format of the data, for bar charts it can only be dataBand

    data : Bar.Data
    data =
        Bar.dataBand
            [ { groupLabel = Just "A"
              , points =
                    [ ( "a", 10 )
                    , ( "b", 13 )
                    , ( "c", 16 )
                    ]
              }
            , { groupLabel = Just "B"
              , points =
                    [ ( "a", 11 )
                    , ( "b", 23 )
                    , ( "c", 16 )
                    ]
              }
            ]

-}
type alias Data =
    Type.Data


{-| dataGroupBand data format

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


{-| dataBand data format constructor

    data : Bar.Data
    data =
        Bar.dataBand
            [ { groupLabel = Just "A"
              , points =
                    [ ( "a", 10 )
                    , ( "b", 13 )
                    , ( "c", 16 )
                    ]
              }
            , { groupLabel = Just "B"
              , points =
                    [ ( "a", 11 )
                    , ( "b", 23 )
                    , ( "c", 16 )
                    ]
              }
            ]

-}
dataBand : List DataGroupBand -> Data
dataBand data =
    Type.DataBand data


{-| Initializes the bar chart

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])

-}
init : Data -> ( Data, Config )
init data =
    ( data, defaultConfig )


{-| Renders the bar chart, after initialisation and customisation

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.render

-}
render : ( Data, Config ) -> Html msg
render ( data, config ) =
    let
        c =
            fromConfig config
    in
    case data of
        Type.DataBand _ ->
            case c.layout of
                Grouped _ ->
                    renderBandGrouped ( data, config )

                Stacked _ ->
                    renderBandStacked ( data, config )

        _ ->
            wrongDataTypeErrorView


{-| Sets the outer height of the bar chart
Default value: 400

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setHeight 600
        |> Bar.render

-}
setHeight : Float -> ( Data, Config ) -> ( Data, Config )
setHeight =
    Type.setHeight


{-| Sets the outer width of the bar chart
Default value: 600

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setWidth 800
        |> Bar.render

-}
setWidth : Float -> ( Data, Config ) -> ( Data, Config )
setWidth =
    Type.setWidth


{-| Sets the chart layout
Values: Bar.stackedLayout or Bar.groupedLayout
Default value: Bar.groupedLayout

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)
        |> Bar.render

-}
setLayout : Layout -> ( Data, Config ) -> ( Data, Config )
setLayout =
    Type.setLayout


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setDesc "This is an accessible chart, with a desc element"
        |> Bar.render

-}
setDesc : String -> ( Data, Config ) -> ( Data, Config )
setDesc =
    Type.setDesc


{-| Sets an accessible title for the svg chart.
Default value: ""

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setTitle "This is a chart"
        |> Bar.render

-}
setTitle : String -> ( Data, Config ) -> ( Data, Config )
setTitle =
    Type.setTitle


{-| Sets the orientation value in the config
Default value: Vertical

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setOrientation Horizontal
        |> Bar.render

-}
setOrientation : Orientation -> ( Data, Config ) -> ( Data, Config )
setOrientation =
    Type.setOrientation


setMargin : Margin -> ( Data, Config ) -> ( Data, Config )
setMargin =
    Type.setMargin


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setContinousDataTicks (CustomTicks <| Scale.ticks linearScale 5)
        |> Bar.render

-}
setLinearAxisTicks : AxisContinousDataTicks -> ( Data, Config ) -> ( Data, Config )
setLinearAxisTicks =
    Type.setAxisContinousDataTicks


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLinearAxisTickCount (CustomTickCount 5)
        |> Bar.render

-}
setLinearAxisTickCount : AxisContinousDataTickCount -> ( Data, Config ) -> ( Data, Config )
setLinearAxisTickCount =
    Type.setAxisContinousDataTickCount


{-| Sets the formatting for ticks in a grouped bar chart continous axis
Defaults to `Scale.tickFormat`

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLinearAxisTickFormat (CustomTickFormat (FormatNumber.format { usLocale | decimals = 0 }))
        |> Bar.render

-}
setLinearAxisTickFormat : AxisContinousDataTickFormat -> ( Data, Config ) -> ( Data, Config )
setLinearAxisTickFormat =
    Type.setAxisContinousDataTickFormat


{-| Sets margin, width and height all at once
Prefer this method from the individual ones when you need to set all three at once.

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setDimensions
            { margin = { top = 30, right = 20, bottom = 30, left = 0 }
            , width = 400
            , height = 400
            }
        |> Bar.render

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> ( Data, Config ) -> ( Data, Config )
setDimensions =
    Type.setDimensions


{-| Sets the domain value in the config
If not set, the domain is calculated from the data
Instead of setDomain, it is usually more convenient use one of the more specific methods:
setDomainBandBandGroup, setDomainBandBandSingle, setDomainBandLinear

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setDomain (domainBand { bandGroup = [ "0" ], bandSingle = [ "a" ], linear = ( 0, 100 ) })
        |> Bar.render

-}
setDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setDomain =
    Type.setDomain


{-| Sets the bandGroup value in the domain directly,
in place of calculating it from the data.

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setDomainBandBandGroup [ "0" ]
        |> Bar.render

-}
setDomainBandBandGroup : Type.BandDomain -> ( Data, Config ) -> ( Data, Config )
setDomainBandBandGroup =
    Type.setDomainBandBandGroup


{-| Sets the bandSingle value in the domain directly,
in place of calculating it from the data.

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setDomainBandBandSingle [ "a", "b" ]
        |> Bar.render

-}
setDomainBandBandSingle : Type.BandDomain -> ( Data, Config ) -> ( Data, Config )
setDomainBandBandSingle =
    Type.setDomainBandBandSingle


{-| Sets the bandLinear value in the domain directly,
in place of calculating it from the data.

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setDomainBandLinear ( 0, 0.55 )
        |> Bar.render

-}
setDomainBandLinear : Type.LinearDomain -> ( Data, Config ) -> ( Data, Config )
setDomainBandLinear =
    Type.setDomainBandLinear


{-| Sets the showContinousAxis boolean value in the config
Default value: True
This shows the bar's continous scale axis

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setShowContinousAxis False
        |> Bar.render

-}
setShowContinousAxis : Bool -> ( Data, Config ) -> ( Data, Config )
setShowContinousAxis =
    Type.setShowContinousAxis


{-| Sets the showOrdinalAxis boolean value in the config
Default value: True
This shows the bar's ordinal scale axis

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setShowOrdinalAxis False
        |> Bar.render

-}
setShowOrdinalAxis : Bool -> ( Data, Config ) -> ( Data, Config )
setShowOrdinalAxis =
    Type.setShowOrdinalAxis


{-| Sets the Icon Symbol list in the grouped config
Default value: []
These are additional symbols at the end of each bar in a group, for facilitating accessibility

    defaultGroupedConfig
        |> setIcons [ Circle, Corner, Triangle ]

-}
setIcons : List (Symbol String) -> GroupedConfig -> GroupedConfig
setIcons =
    Type.setIcons


{-| Sets the showIndividualLabels boolean value in the grouped config
Default value: False
This shows the bar's ordinal value at the end of the rect, not the linear value.
If used together with symbols, the label will be drawn on top of the symbol.
Use with caution, there is no knowledge of text wrapping.
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

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setOrientation horizontalOrientation

-}
horizontalOrientation : Orientation
horizontalOrientation =
    Horizontal


{-| Vertical layout type
Used as argument to Bar.setOrientation
This is the default layout

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setOrientation verticalOrientation

-}
verticalOrientation : Orientation
verticalOrientation =
    Vertical


{-| Stacked layout type
Stacked layouts can not have icons

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)

-}
stackedLayout : Direction -> Layout
stackedLayout direction =
    Stacked direction


{-| Grouped layout type
This is the default layout type

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLayout (Bar.groupedLayout Bar.defaultGroupedConfig)

-}
groupedLayout : GroupedConfig -> Layout
groupedLayout config =
    Grouped config


{-| Bar chart diverging layout
It is only used for stacked layouts
An example can be a population pyramid chart.

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLayout (Bar.stackedLayout Bar.divergingDirection)

-}
divergingDirection : Direction
divergingDirection =
    Diverging


{-| Bar chart no-direction layout
It is only used for stacked layouts

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLayout (Bar.stackedLayout Bar.noDirection)

-}
noDirection : Direction
noDirection =
    NoDirection


{-| Default values for the Grouped Layout specific config
Used for initialization purposes

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLayout (Bar.groupedLayout (Bar.defaultGroupedConfig |> ChartType.setIcons (icons "chart-a")))

-}
defaultGroupedConfig : GroupedConfig
defaultGroupedConfig =
    Type.defaultGroupedConfig


{-| Pass the ticks to Bar.setLinearAxisTicks

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLinearAxisTicks [ 1, 2, 3 ]

-}
linearAxisCustomTicks : List Float -> AxisContinousDataTicks
linearAxisCustomTicks ticks =
    Type.CustomTicks ticks


{-| Pass the number of ticks to Bar.setLinearAxisTickCount

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLinearAxisTickCount (CustomTickCount 5)

-}
linearAxisCustomTickCount : Int -> AxisContinousDataTickCount
linearAxisCustomTickCount count =
    Type.CustomTickCount count


{-| A custom formatter for the continous data axis values

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLinearAxisTickFormat (Bar.linearAxisCustomTickFormat (FormatNumber.format { usLocale | decimals = 0 }))

-}
linearAxisCustomTickFormat : (Float -> String) -> AxisContinousDataTickFormat
linearAxisCustomTickFormat formatter =
    Type.CustomTickFormat formatter


{-| Domain Type
For bar charts this can only be of DomainBand type
-}
type alias Domain =
    Type.Domain


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


{-| Set the useGap boolean flag
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



-- GETTERS


{-| Calculate the domains from the data
This is what happens under the hood when creating a chart without explicitly passig a domain
-}
getDomainFromData : Data -> Domain
getDomainFromData =
    Type.getDomainFromData

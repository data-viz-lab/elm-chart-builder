module Chart.Internal.Type exposing
    ( AccessibilityContent(..)
    , AccessorBand
    , AccessorHistogram(..)
    , AccessorLinearStruct
    , AccessorLinearTime(..)
    , AccessorTimeStruct
    , AxisContinousDataTickCount(..)
    , AxisContinousDataTickFormat(..)
    , AxisContinousDataTicks(..)
    , AxisOrientation(..)
    , AxisTickPadding(..)
    , AxisTickSize(..)
    , BandDomain
    , ColorResource(..)
    , Config
    , ConfigStruct
    , DataBand
    , DataGroupBand
    , DataGroupLinear
    , DataGroupTime
    , DataLinearGroup(..)
    , Direction(..)
    , DomainBand
    , DomainBandStruct
    , DomainLinear
    , DomainLinearStruct
    , DomainTime
    , DomainTimeStruct
    , ExternalData
    , Layout(..)
    , LinearDomain
    , Margin
    , Orientation(..)
    , PointBand
    , PointLinear
    , PointStacked
    , PointTime
    , RenderContext(..)
    , ShowLabel(..)
    , StackedValues
    , Steps
    , adjustLinearRange
    , ariaLabelledby
    , bottomGap
    , calculateHistogramDomain
    , calculateHistogramValues
    , colorCategoricalStyle
    , colorStyle
    , dataBandToDataStacked
    , dataLinearGroupToDataLinear
    , dataLinearGroupToDataLinearStacked
    , dataLinearGroupToDataTime
    , defaultConfig
    , defaultHeight
    , defaultLayout
    , defaultMargin
    , defaultOrientation
    , defaultTicksCount
    , defaultWidth
    , externalToDataBand
    , externalToDataHistogram
    , externalToDataLinearGroup
    , fromConfig
    , fromDataBand
    , fromDomainBand
    , fromDomainLinear
    , fromExternalData
    , getAxisContinousDataFormatter
    , getBandGroupRange
    , getBandSingleRange
    , getDataBandDepth
    , getDataLinearDepth
    , getDomainBand
    , getDomainBandFromData
    , getDomainLinear
    , getDomainLinearFromData
    , getDomainTime
    , getDomainTimeFromData
    , getIcons
    , getLinearRange
    , getOffset
    , getShowLabels
    , getStackedValuesAndGroupes
    , leftGap
    , role
    , setAccessibilityContent
    , setAxisTickPadding
    , setAxisTickSizeInner
    , setAxisTickSizeOuter
    , setColorResource
    , setCoreStyles
    , setCurve
    , setDimensions
    , setDomainBand
    , setDomainBandBandGroup
    , setDomainBandBandSingle
    , setDomainBandLinear
    , setDomainLinear
    , setDomainLinearAndTimeY
    , setDomainLinearX
    , setDomainTime
    , setDomainTimeX
    , setHeight
    , setHistogramDomain
    , setIcons
    , setLayout
    , setLayoutRestricted
    , setMargin
    , setOrientation
    , setShowDataPoints
    , setSvgDesc
    , setSvgTitle
    , setWidth
    , setXAxis
    , setXAxisAttributes
    , setXAxisTickCount
    , setXAxisTickFormat
    , setXAxisTickPadding
    , setXAxisTickSizeInner
    , setXAxisTickSizeOuter
    , setXAxisTicks
    , setYAxis
    , setYAxisAttributes
    , setYAxisTickCount
    , setYAxisTickFormat
    , setYAxisTickPadding
    , setYAxisTickSizeInner
    , setYAxisTickSizeOuter
    , setYAxisTicks
    , showIcons
    , showXGroupLabel
    , showXLinearLabel
    , showXOrdinalLabel
    , showYLabel
    , stackedValuesInverse
    , symbolCustomSpace
    , symbolSpace
    , toConfig
    , toDataBand
    , toExternalData
    )

import Axis
import Chart.Internal.Helpers as Helpers
import Chart.Internal.Symbol as Symbol exposing (Symbol(..), symbolGap)
import Color exposing (Color)
import Histogram
import Html
import Html.Attributes
import List.Extra
import Scale exposing (BandScale)
import Shape
import Statistics
import SubPath exposing (SubPath)
import Time exposing (Posix, Zone)
import TypedSvg.Attributes
import TypedSvg.Core



-- DATA


type ExternalData data
    = ExternalData (List data)


fromExternalData : ExternalData data -> List data
fromExternalData (ExternalData data) =
    data


toExternalData : List data -> ExternalData data
toExternalData data =
    ExternalData data


type alias AccessorBand data =
    { xGroup : data -> Maybe String
    , xValue : data -> String
    , yValue : data -> Float
    }


type alias Steps =
    List Float


type AccessorHistogram data
    = AccessorHistogram Steps (data -> Float)
    | AccessorHistogramPreProcessed (data -> Histogram.Bin Float Float)


type AccessorLinearTime data
    = AccessorLinear (AccessorLinearStruct data)
    | AccessorTime (AccessorTimeStruct data)


type alias AccessorLinearStruct data =
    { xGroup : data -> Maybe String
    , xValue : data -> Float
    , yValue : data -> Float
    }


type alias AccessorTimeStruct data =
    { xGroup : data -> Maybe String
    , xValue : data -> Posix
    , yValue : data -> Float
    }


type DataBand
    = DataBand (List DataGroupBand)


toDataBand : List DataGroupBand -> DataBand
toDataBand dataBand =
    DataBand dataBand


type DataLinearGroup
    = DataTime (List DataGroupTime)
    | DataLinear (List DataGroupLinear)


type alias PointBand =
    ( String, Float )


type alias PointLinear =
    ( Float, Float )


type alias PointTime =
    ( Posix, Float )


type alias PointStacked a =
    ( a, List Float )


type alias DataGroupBand =
    { groupLabel : Maybe String
    , points : List PointBand
    }


type alias DataGroupLinear =
    { groupLabel : Maybe String
    , points : List PointLinear
    }


type alias DataGroupTime =
    { groupLabel : Maybe String
    , points : List PointTime
    }



--------------------------------------------------


type Orientation
    = Vertical
    | Horizontal


type Layout
    = StackedBar Direction
    | StackedLine
    | GroupedBar
    | GroupedLine


type Direction
    = Diverging
    | NoDirection


type AxisOrientation
    = X
    | Y


type alias LinearDomain =
    ( Float, Float )


type alias TimeDomain =
    ( Posix, Posix )


type alias BandDomain =
    List String


type alias DomainBandStruct =
    { bandGroup : Maybe BandDomain
    , bandSingle : Maybe BandDomain
    , linear : Maybe LinearDomain
    }


initialDomainBandStruct : DomainBandStruct
initialDomainBandStruct =
    { bandGroup = Nothing
    , bandSingle = Nothing
    , linear = Nothing
    }


type alias DomainLinearStruct =
    { x : Maybe LinearDomain
    , y : Maybe LinearDomain
    }


initialDomainLinearStruct : DomainLinearStruct
initialDomainLinearStruct =
    { x = Nothing
    , y = Nothing
    }


type alias DomainTimeStruct =
    { x : Maybe TimeDomain
    , y : Maybe LinearDomain
    }


initialDomainTimeStruct : DomainTimeStruct
initialDomainTimeStruct =
    { x = Nothing
    , y = Nothing
    }


type DomainBand
    = DomainBand DomainBandStruct


type DomainLinear
    = DomainLinear DomainLinearStruct


type DomainTime
    = DomainTime DomainTimeStruct


type alias Margin =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }



--ideas on axis: https://codepen.io/deciob/pen/GRgrXgR


type AxisContinousDataTicks
    = DefaultTicks
    | CustomTicks (List Float)
    | CustomTimeTicks (List Posix)


type AxisContinousDataTickCount
    = DefaultTickCount
    | CustomTickCount Int


type AxisTickSize
    = DefaultTickSize
    | CustomTickSize Float


type AxisTickPadding
    = DefaultTickPadding
    | CustomTickPadding Float


type AxisContinousDataTickFormat
    = DefaultTickFormat
    | CustomTickFormat (Float -> String)
    | CustomTimeTickFormat (Posix -> String)


type ColorResource
    = ColorPalette (List Color)
    | ColorInterpolator (Float -> Color)
    | Color Color
    | ColorNone


type AccessibilityContent
    = AccessibilityTable
    | AccessibilityNone



-- CONFIG


type alias ConfigStruct =
    { accessibilityContent : AccessibilityContent
    , axisXTickCount : AxisContinousDataTickCount
    , axisXTickFormat : AxisContinousDataTickFormat
    , axisXTicks : AxisContinousDataTicks
    , axisYTickCount : AxisContinousDataTickCount
    , axisYTickFormat : AxisContinousDataTickFormat
    , axisYTicks : AxisContinousDataTicks
    , axisTickSizeOuter : AxisTickSize
    , axisTickSizeInner : AxisTickSize
    , axisTickPadding : AxisTickPadding
    , axisXTickSizeOuter : AxisTickSize
    , axisXTickSizeInner : AxisTickSize
    , axisXTickPadding : AxisTickPadding
    , axisYTickSizeOuter : AxisTickSize
    , axisYTickSizeInner : AxisTickSize
    , axisYTickPadding : AxisTickPadding
    , colorResource : ColorResource
    , coreStyle : List ( String, String )
    , curve : List ( Float, Float ) -> SubPath
    , domainBand : DomainBand
    , domainLinear : DomainLinear
    , domainTime : DomainTime
    , height : Float
    , histogramDomain : Maybe ( Float, Float )
    , icons : List Symbol
    , layout : Layout
    , margin : Margin
    , orientation : Orientation
    , showDataPoints : Bool
    , showGroupLabels : Bool
    , showLabels : ShowLabel
    , showXAxis : Bool
    , showYAxis : Bool
    , svgDesc : String
    , svgTitle : String
    , width : Float
    , zone : Zone
    }


defaultConfig : Config
defaultConfig =
    toConfig
        { accessibilityContent = AccessibilityNone
        , axisXTickCount = DefaultTickCount
        , axisXTickFormat = DefaultTickFormat
        , axisXTicks = DefaultTicks
        , axisYTickCount = DefaultTickCount
        , axisYTickFormat = DefaultTickFormat
        , axisYTicks = DefaultTicks
        , axisTickSizeOuter = DefaultTickSize
        , axisTickSizeInner = DefaultTickSize
        , axisTickPadding = DefaultTickPadding
        , axisXTickSizeOuter = DefaultTickSize
        , axisXTickSizeInner = DefaultTickSize
        , axisXTickPadding = DefaultTickPadding
        , axisYTickSizeOuter = DefaultTickSize
        , axisYTickSizeInner = DefaultTickSize
        , axisYTickPadding = DefaultTickPadding
        , colorResource = ColorNone
        , coreStyle = []
        , curve = \d -> Shape.linearCurve d
        , domainBand = DomainBand initialDomainBandStruct
        , domainLinear = DomainLinear initialDomainLinearStruct
        , domainTime = DomainTime initialDomainTimeStruct
        , height = defaultHeight
        , histogramDomain = Nothing
        , icons = []
        , layout = defaultLayout
        , margin = defaultMargin
        , orientation = defaultOrientation
        , showXAxis = True
        , showYAxis = True
        , showDataPoints = False
        , showLabels = NoLabel
        , showGroupLabels = False
        , svgDesc = ""
        , svgTitle = ""
        , width = defaultWidth
        , zone = Time.utc
        }


type Config
    = Config ConfigStruct


toConfig : ConfigStruct -> Config
toConfig config =
    Config config


fromConfig : Config -> ConfigStruct
fromConfig (Config config) =
    config


role : String -> Html.Attribute msg
role name =
    Html.Attributes.attribute "role" name


ariaLabelledby : String -> Html.Attribute msg
ariaLabelledby label =
    Html.Attributes.attribute "aria-labelledby" label



-- DEFAULTS


defaultLayout : Layout
defaultLayout =
    GroupedBar


defaultOrientation : Orientation
defaultOrientation =
    Vertical


defaultWidth : Float
defaultWidth =
    600


defaultHeight : Float
defaultHeight =
    400


defaultMargin : Margin
defaultMargin =
    { top = 1
    , right = 20
    , bottom = 20
    , left = 30
    }


defaultTicksCount : Int
defaultTicksCount =
    10



-- CONSTANTS


leftGap : Float
leftGap =
    -- TODO: there should be some notion of padding!
    -- TODO: pass this as an exposed option in config?
    4


bottomGap : Float
bottomGap =
    -- TODO: there should be some notion of padding!
    -- TODO: pass this as an exposed option in config?
    2


showIcons : Config -> Bool
showIcons (Config c) =
    c
        |> .icons
        |> List.length
        |> (\l -> l > 0)


getIcons : Config -> List Symbol
getIcons (Config c) =
    c |> .icons


getShowLabels : Config -> ShowLabel
getShowLabels (Config c) =
    c |> .showLabels


setLayout : Layout -> Config -> Config
setLayout layout (Config c) =
    toConfig { c | layout = layout }


setLayoutRestricted :
    Layout
    -> Config
    -> Config
setLayoutRestricted layout (Config c) =
    toConfig { c | layout = layout }


setIcons :
    List Symbol
    -> Config
    -> Config
setIcons all (Config c) =
    Config { c | icons = all }



-- STACKED


type alias StackedValues =
    List
        { rawValue : Float
        , stackedValue : ( Float, Float )
        }


type alias StackedValuesAndGroupes =
    ( List StackedValues, List String )



-- SETTERS


setXAxisTickCount : AxisContinousDataTickCount -> Config -> Config
setXAxisTickCount count (Config c) =
    toConfig { c | axisXTickCount = count }


setYAxisTickCount : AxisContinousDataTickCount -> Config -> Config
setYAxisTickCount count (Config c) =
    toConfig { c | axisYTickCount = count }


setCurve : (List ( Float, Float ) -> SubPath) -> Config -> Config
setCurve curve (Config c) =
    toConfig { c | curve = curve }


setSvgDesc : String -> Config -> Config
setSvgDesc desc (Config c) =
    toConfig { c | svgDesc = desc }


setSvgTitle : String -> Config -> Config
setSvgTitle title (Config c) =
    toConfig { c | svgTitle = title }


setXAxisTickFormat : AxisContinousDataTickFormat -> Config -> Config
setXAxisTickFormat format (Config c) =
    toConfig { c | axisXTickFormat = format }


setYAxisTickFormat : AxisContinousDataTickFormat -> Config -> Config
setYAxisTickFormat format (Config c) =
    toConfig { c | axisYTickFormat = format }


setXAxisTicks : AxisContinousDataTicks -> Config -> Config
setXAxisTicks ticks (Config c) =
    toConfig { c | axisXTicks = ticks }


setYAxisTicks : AxisContinousDataTicks -> Config -> Config
setYAxisTicks ticks (Config c) =
    toConfig { c | axisYTicks = ticks }


setAxisTickSizeInner : Float -> Config -> Config
setAxisTickSizeInner size (Config c) =
    toConfig { c | axisTickSizeInner = CustomTickSize size }


setAxisTickSizeOuter : Float -> Config -> Config
setAxisTickSizeOuter size (Config c) =
    toConfig { c | axisTickSizeOuter = CustomTickSize size }


setAxisTickPadding : Float -> Config -> Config
setAxisTickPadding size (Config c) =
    toConfig { c | axisTickPadding = CustomTickPadding size }


setXAxisTickSizeInner : Float -> Config -> Config
setXAxisTickSizeInner size (Config c) =
    toConfig { c | axisXTickSizeInner = CustomTickSize size }


setXAxisTickSizeOuter : Float -> Config -> Config
setXAxisTickSizeOuter size (Config c) =
    toConfig { c | axisXTickSizeOuter = CustomTickSize size }


setXAxisTickPadding : Float -> Config -> Config
setXAxisTickPadding size (Config c) =
    toConfig { c | axisXTickPadding = CustomTickPadding size }


setYAxisTickSizeInner : Float -> Config -> Config
setYAxisTickSizeInner size (Config c) =
    toConfig { c | axisYTickSizeInner = CustomTickSize size }


setYAxisTickSizeOuter : Float -> Config -> Config
setYAxisTickSizeOuter size (Config c) =
    toConfig { c | axisYTickSizeOuter = CustomTickSize size }


setYAxisTickPadding : Float -> Config -> Config
setYAxisTickPadding size (Config c) =
    toConfig { c | axisYTickPadding = CustomTickPadding size }


setColorResource : ColorResource -> Config -> Config
setColorResource resource (Config c) =
    toConfig { c | colorResource = resource }


setCoreStyles : List ( String, String ) -> Config -> Config
setCoreStyles styles (Config c) =
    toConfig { c | coreStyle = styles }


setHeight : Float -> Config -> Config
setHeight height (Config c) =
    let
        m =
            c.margin
    in
    toConfig { c | height = height - m.top - m.bottom }


setHistogramDomain : ( Float, Float ) -> Config -> Config
setHistogramDomain domain (Config c) =
    toConfig { c | histogramDomain = Just domain }


setOrientation : Orientation -> Config -> Config
setOrientation orientation (Config c) =
    toConfig { c | orientation = orientation }


setWidth : Float -> Config -> Config
setWidth width (Config c) =
    let
        m =
            c.margin
    in
    toConfig { c | width = width - m.left - m.right }


setMargin : Margin -> Config -> Config
setMargin margin (Config c) =
    let
        left =
            margin.left + leftGap

        bottom =
            margin.bottom + bottomGap
    in
    toConfig { c | margin = { margin | left = left, bottom = bottom } }


setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions { margin, width, height } (Config c) =
    let
        left =
            margin.left + leftGap

        bottom =
            margin.bottom + bottomGap
    in
    toConfig
        { c
            | width = width - left - margin.right
            , height = height - margin.top - bottom
            , margin = { margin | left = left, bottom = bottom }
        }


setDomainLinear : DomainLinear -> Config -> Config
setDomainLinear domain (Config c) =
    toConfig { c | domainLinear = domain }


setDomainTime : DomainTime -> Config -> Config
setDomainTime domain (Config c) =
    toConfig { c | domainTime = domain }


setDomainBand : DomainBand -> Config -> Config
setDomainBand domain (Config c) =
    toConfig { c | domainBand = domain }


setDomainBandBandGroup : BandDomain -> Config -> Config
setDomainBandBandGroup bandDomain (Config c) =
    let
        domain =
            c.domainBand
                |> fromDomainBand

        newDomain =
            { domain | bandGroup = Just bandDomain }
    in
    toConfig { c | domainBand = DomainBand newDomain }


setDomainBandBandSingle : BandDomain -> Config -> Config
setDomainBandBandSingle bandDomain (Config c) =
    let
        domain =
            c.domainBand
                |> fromDomainBand

        newDomain =
            { domain | bandSingle = Just bandDomain }
    in
    toConfig { c | domainBand = DomainBand newDomain }


setDomainBandLinear : LinearDomain -> Config -> Config
setDomainBandLinear linearDomain (Config c) =
    let
        domain =
            c.domainBand
                |> fromDomainBand

        newDomain =
            { domain | linear = Just linearDomain }
    in
    toConfig { c | domainBand = DomainBand newDomain }


setDomainTimeX : TimeDomain -> Config -> Config
setDomainTimeX timeDomain (Config c) =
    let
        domain =
            c.domainTime
                |> fromDomainTime

        newDomain =
            { domain | x = Just timeDomain }
    in
    toConfig { c | domainTime = DomainTime newDomain }


setDomainLinearX : LinearDomain -> Config -> Config
setDomainLinearX linearDomain (Config c) =
    let
        domain =
            c.domainLinear
                |> fromDomainLinear

        newDomain =
            { domain | x = Just linearDomain }
    in
    toConfig { c | domainLinear = DomainLinear newDomain }


setDomainLinearAndTimeY : LinearDomain -> Config -> Config
setDomainLinearAndTimeY linearDomain (Config c) =
    let
        domain =
            c.domainLinear
                |> fromDomainLinear

        newDomain =
            { domain | y = Just linearDomain }

        domainTime =
            c.domainTime
                |> fromDomainTime

        newDomainTime =
            { domainTime | y = Just linearDomain }
    in
    toConfig { c | domainLinear = DomainLinear newDomain, domainTime = DomainTime newDomainTime }


setXAxis : Bool -> Config -> Config
setXAxis bool (Config c) =
    toConfig { c | showXAxis = bool }


setYAxis : Bool -> Config -> Config
setYAxis bool (Config c) =
    toConfig { c | showYAxis = bool }


setShowDataPoints : Bool -> Config -> Config
setShowDataPoints bool (Config c) =
    toConfig { c | showDataPoints = bool }


setAccessibilityContent : AccessibilityContent -> Config -> Config
setAccessibilityContent content (Config c) =
    toConfig { c | accessibilityContent = content }



-- LABELS


type ShowLabel
    = YLabel (Float -> String)
    | XLinearLabel (Float -> String)
    | XOrdinalLabel
    | XGroupLabel
    | NoLabel


showXOrdinalLabel : Config -> Config
showXOrdinalLabel (Config c) =
    toConfig { c | showLabels = XOrdinalLabel }


showXLinearLabel : (Float -> String) -> Config -> Config
showXLinearLabel formatter (Config c) =
    toConfig { c | showLabels = XLinearLabel formatter }


showYLabel : (Float -> String) -> Config -> Config
showYLabel formatter (Config c) =
    toConfig { c | showLabels = YLabel formatter }


showXGroupLabel : Config -> Config
showXGroupLabel (Config c) =
    toConfig { c | showLabels = XGroupLabel }



-- GETTERS


getAxisContinousDataFormatter : AxisContinousDataTickFormat -> Maybe (Float -> String)
getAxisContinousDataFormatter format =
    case format of
        DefaultTickFormat ->
            Just (\f -> String.fromFloat f)

        CustomTickFormat formatter ->
            Just formatter

        CustomTimeTickFormat _ ->
            Nothing


getDomainBand : Config -> DomainBandStruct
getDomainBand config =
    config
        |> fromConfig
        |> .domainBand
        |> fromDomainBand


getDomainLinear : Config -> DomainLinearStruct
getDomainLinear config =
    config
        |> fromConfig
        |> .domainLinear
        |> fromDomainLinear


getDomainTime : Config -> DomainTimeStruct
getDomainTime config =
    config
        |> fromConfig
        |> .domainTime
        |> fromDomainTime


getDomainBandFromData : DataBand -> Config -> DomainBandStruct
getDomainBandFromData data config =
    let
        -- get the domain from config first
        domain =
            getDomainBand config

        d =
            fromDataBand data
    in
    DomainBand
        { bandGroup =
            case domain.bandGroup of
                Just bandGroup ->
                    Just bandGroup

                Nothing ->
                    d
                        |> List.map .groupLabel
                        |> List.indexedMap (\i g -> g |> Maybe.withDefault (String.fromInt i))
                        -- remove duplicates from the data
                        --|> Set.fromList
                        --|> Set.toList
                        |> Just
        , bandSingle =
            case domain.bandSingle of
                Just bandSingle ->
                    Just bandSingle

                Nothing ->
                    d
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.first
                        |> List.foldr
                            (\x acc ->
                                if List.member x acc then
                                    acc

                                else
                                    x :: acc
                            )
                            []
                        |> Just
        , linear =
            case domain.linear of
                Just linear ->
                    Just linear

                Nothing ->
                    d
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.second
                        |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                        |> Just
        }
        |> fromDomainBand


getDomainLinearFromData : Config -> List DataGroupLinear -> DomainLinearStruct
getDomainLinearFromData config data =
    let
        -- get the domain from config first
        -- and use it!
        domain : DomainLinearStruct
        domain =
            getDomainLinear config
    in
    DomainLinear
        { x =
            case domain.x of
                Just _ ->
                    domain.x

                Nothing ->
                    data
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.first
                        |> (\dd -> ( List.minimum dd |> Maybe.withDefault 0, List.maximum dd |> Maybe.withDefault 0 ))
                        |> Just
        , y =
            case domain.y of
                Just _ ->
                    domain.y

                Nothing ->
                    data
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.second
                        |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                        |> Just
        }
        |> fromDomainLinear


getDomainTimeFromData : Config -> List DataGroupTime -> DomainTimeStruct
getDomainTimeFromData config data =
    let
        -- get the domain from config first
        -- and use it!
        domain : DomainTimeStruct
        domain =
            getDomainTime config
    in
    DomainTime
        { x =
            case domain.x of
                Just _ ->
                    domain.x

                Nothing ->
                    data
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.first
                        |> List.map Time.posixToMillis
                        |> (\dd ->
                                ( List.minimum dd |> Maybe.withDefault 0 |> Time.millisToPosix
                                , List.maximum dd |> Maybe.withDefault 0 |> Time.millisToPosix
                                )
                           )
                        |> Just
        , y =
            case domain.y of
                Just _ ->
                    domain.y

                Nothing ->
                    data
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.second
                        |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                        |> Just
        }
        |> fromDomainTime


fromDomainBand : DomainBand -> DomainBandStruct
fromDomainBand (DomainBand d) =
    d


fromDomainLinear : DomainLinear -> DomainLinearStruct
fromDomainLinear (DomainLinear d) =
    d


fromDomainTime : DomainTime -> DomainTimeStruct
fromDomainTime (DomainTime d) =
    d


fromDataBand : DataBand -> List DataGroupBand
fromDataBand (DataBand d) =
    d


getDataBandDepth : DataBand -> Int
getDataBandDepth data =
    data
        |> fromDataBand
        |> List.map .points
        |> List.head
        |> Maybe.withDefault []
        |> List.length


getDataLinearDepth : List DataGroupLinear -> Int
getDataLinearDepth data =
    data
        |> List.map .points
        |> List.head
        |> Maybe.withDefault []
        |> List.length


getBandGroupRange : Config -> Float -> Float -> ( Float, Float )
getBandGroupRange config width height =
    let
        orientation =
            fromConfig config |> .orientation
    in
    case orientation of
        Horizontal ->
            ( height, 0 )

        Vertical ->
            ( 0, width )


getBandSingleRange : Config -> Float -> ( Float, Float )
getBandSingleRange config value =
    let
        orientation =
            fromConfig config |> .orientation
    in
    case orientation of
        Horizontal ->
            ( floor value |> toFloat, 0 )

        Vertical ->
            ( 0, floor value |> toFloat )


type RenderContext
    = RenderChart
    | RenderAxis


getLinearRange : Config -> RenderContext -> Float -> Float -> BandScale String -> ( Float, Float )
getLinearRange config renderContext width height bandScale =
    let
        c =
            fromConfig config

        orientation =
            c.orientation

        layout =
            c.layout
    in
    case orientation of
        Horizontal ->
            case layout of
                GroupedBar ->
                    if showIcons config then
                        -- Here we are leaving space for the symbol
                        ( 0, width - symbolGap - symbolSpace c.orientation bandScale (getIcons config) )

                    else
                        ( 0, width )

                _ ->
                    case renderContext of
                        RenderChart ->
                            ( width, 0 )

                        RenderAxis ->
                            ( 0, width )

        Vertical ->
            case layout of
                GroupedBar ->
                    if showIcons config then
                        -- Here we are leaving space for the symbol
                        ( height - symbolGap - symbolSpace c.orientation bandScale (getIcons config)
                        , 0
                        )

                    else
                        ( height, 0 )

                _ ->
                    ( height, 0 )


adjustLinearRange : Config -> Int -> ( Float, Float ) -> ( Float, Float )
adjustLinearRange config stackedDepth ( a, b ) =
    -- small adjustments related to the whitespace between stacked items?
    let
        c =
            fromConfig config

        orientation =
            c.orientation

        layout =
            c.layout
    in
    case orientation of
        Horizontal ->
            case layout of
                GroupedBar ->
                    ( a, b )

                _ ->
                    ( a + toFloat stackedDepth, b )

        Vertical ->
            ( a - toFloat stackedDepth, b )


getOffset : Config -> List (List ( Float, Float )) -> List (List ( Float, Float ))
getOffset config =
    case fromConfig config |> .layout of
        StackedBar direction ->
            case direction of
                Diverging ->
                    Shape.stackOffsetDiverging

                NoDirection ->
                    Shape.stackOffsetNone

        _ ->
            Shape.stackOffsetNone


symbolSpace : Orientation -> BandScale String -> List Symbol -> Float
symbolSpace orientation bandSingleScale symbols =
    let
        localDimension =
            Scale.bandwidth bandSingleScale |> floor |> toFloat
    in
    symbols
        |> List.map
            (\symbol ->
                case symbol of
                    Circle _ ->
                        localDimension / 2

                    Custom conf ->
                        symbolCustomSpace orientation localDimension conf

                    Corner _ ->
                        localDimension

                    Triangle _ ->
                        localDimension

                    NoSymbol ->
                        0
            )
        |> List.maximum
        |> Maybe.withDefault 0
        |> floor
        |> toFloat


symbolCustomSpace : Orientation -> Float -> Symbol.CustomSymbolConf -> Float
symbolCustomSpace orientation localDimension conf =
    case orientation of
        Horizontal ->
            let
                scalingFactor =
                    localDimension / conf.viewBoxHeight
            in
            scalingFactor * conf.viewBoxWidth

        Vertical ->
            let
                scalingFactor =
                    localDimension / conf.viewBoxWidth
            in
            scalingFactor * conf.viewBoxHeight



-- DATA METHODS


histogramDefaultGenerator : ( Float, Float ) -> List Float -> List (Histogram.Bin Float Float)
histogramDefaultGenerator domain model =
    Histogram.float
        |> Histogram.withDomain domain
        |> Histogram.compute model


histogramCustomGenerator :
    ( Float, Float )
    -> List Float
    -> Histogram.Threshold Float Float
    -> (Float -> Float)
    -> List (Histogram.Bin Float Float)
histogramCustomGenerator domain model threshold mapping =
    Histogram.custom threshold mapping
        |> Histogram.withDomain domain
        |> Histogram.compute model


calculateHistogramValues : List (Histogram.Bin Float Float) -> List Float
calculateHistogramValues histogram =
    histogram
        |> List.map .values
        |> List.concat


calculateHistogramDomain : List (Histogram.Bin Float Float) -> ( Float, Float )
calculateHistogramDomain histogram =
    histogram
        |> List.map (\h -> [ h.x0, h.x1 ])
        |> List.concat
        |> Statistics.extent
        |> Maybe.withDefault ( 0, 0 )


externalToDataHistogram :
    Config
    -> ExternalData data
    -> AccessorHistogram data
    -> List (Histogram.Bin Float Float)
externalToDataHistogram config externalData accessor =
    let
        c =
            fromConfig config

        data =
            fromExternalData externalData
    in
    case accessor of
        AccessorHistogram bins toFloat ->
            let
                floatData =
                    data
                        |> List.map toFloat

                domain : ( Float, Float )
                domain =
                    case c.histogramDomain of
                        Nothing ->
                            floatData
                                |> Statistics.extent
                                |> Maybe.withDefault ( 0, 0 )

                        Just d ->
                            d
            in
            if List.isEmpty bins |> not then
                histogramCustomGenerator domain floatData (Histogram.steps bins) identity

            else
                histogramDefaultGenerator domain floatData

        AccessorHistogramPreProcessed toData ->
            data |> List.map toData


externalToDataBand : ExternalData data -> AccessorBand data -> DataBand
externalToDataBand externalData accessor =
    let
        data =
            fromExternalData externalData
    in
    data
        |> Helpers.sortStrings (accessor.xGroup >> Maybe.withDefault "")
        |> List.Extra.groupWhile
            (\a b ->
                accessor.xGroup a == accessor.xGroup b
            )
        |> List.map
            (\d ->
                let
                    groupLabel =
                        d
                            |> Tuple.first
                            |> accessor.xGroup

                    firstPoint =
                        d
                            |> Tuple.first
                            |> (\p -> ( accessor.xValue p, accessor.yValue p ))

                    points =
                        d
                            |> Tuple.second
                            |> List.map (\p -> ( accessor.xValue p, accessor.yValue p ))
                            |> (::) firstPoint
                in
                { groupLabel = groupLabel
                , points = points
                }
            )
        |> DataBand


externalToDataLinearGroup : ExternalData data -> AccessorLinearTime data -> DataLinearGroup
externalToDataLinearGroup externalData accessorGroup =
    let
        data =
            fromExternalData externalData
    in
    case accessorGroup of
        AccessorLinear accessor ->
            data
                |> List.sortBy (accessor.xGroup >> Maybe.withDefault "")
                |> List.Extra.groupWhile
                    (\a b -> accessor.xGroup a == accessor.xGroup b)
                |> List.map
                    (\d ->
                        let
                            groupLabel =
                                d
                                    |> Tuple.first
                                    |> accessor.xGroup

                            firstPoint =
                                d
                                    |> Tuple.first
                                    |> (\p -> ( accessor.xValue p, accessor.yValue p ))

                            points =
                                d
                                    |> Tuple.second
                                    |> List.map (\p -> ( accessor.xValue p, accessor.yValue p ))
                                    |> (::) firstPoint
                        in
                        { groupLabel = groupLabel
                        , points = points
                        }
                    )
                |> DataLinear

        AccessorTime accessor ->
            data
                |> List.sortBy (accessor.xGroup >> Maybe.withDefault "")
                |> List.Extra.groupWhile
                    (\a b -> accessor.xGroup a == accessor.xGroup b)
                |> List.map
                    (\d ->
                        let
                            groupLabel =
                                d
                                    |> Tuple.first
                                    |> accessor.xGroup

                            firstPoint =
                                d
                                    |> Tuple.first
                                    |> (\p -> ( accessor.xValue p, accessor.yValue p ))

                            points =
                                d
                                    |> Tuple.second
                                    |> List.map (\p -> ( accessor.xValue p, accessor.yValue p ))
                                    |> (::) firstPoint
                        in
                        { groupLabel = groupLabel
                        , points = points
                        }
                    )
                |> DataTime


dataLinearGroupToDataLinear : DataLinearGroup -> List DataGroupLinear
dataLinearGroupToDataLinear data =
    case data of
        DataTime d ->
            d
                |> List.map
                    (\group ->
                        let
                            points =
                                group.points
                        in
                        { groupLabel = group.groupLabel
                        , points =
                            points
                                |> List.map
                                    (\p ->
                                        ( Tuple.first p
                                            |> Time.posixToMillis
                                            |> toFloat
                                        , Tuple.second p
                                        )
                                    )
                        }
                    )

        DataLinear d ->
            d


dataLinearGroupToDataTime : DataLinearGroup -> List DataGroupTime
dataLinearGroupToDataTime data =
    case data of
        DataTime d ->
            d

        _ ->
            []


getStackedValuesAndGroupes : List (List ( Float, Float )) -> DataBand -> StackedValuesAndGroupes
getStackedValuesAndGroupes values data =
    let
        m =
            List.map2
                (\d v ->
                    List.map2 (\stackedValue rawValue -> { rawValue = Tuple.second rawValue, stackedValue = stackedValue })
                        v
                        d.points
                )
    in
    ( List.Extra.transpose values
        |> List.reverse
        |> m (fromDataBand data)
    , data
        |> fromDataBand
        |> List.indexedMap (\idx s -> s.groupLabel |> Maybe.withDefault (String.fromInt idx))
    )


dataLinearGroupToDataLinearStacked : List DataGroupLinear -> List ( String, List Float )
dataLinearGroupToDataLinearStacked data =
    data
        |> List.indexedMap
            (\i d ->
                ( d.groupLabel |> Maybe.withDefault (String.fromInt i), d.points |> List.map Tuple.second )
            )


dataBandToDataStacked : DataBand -> Config -> List ( String, List Float )
dataBandToDataStacked data config =
    let
        seed =
            getDomainBandFromData data config
                |> .bandSingle
                |> Maybe.withDefault []
                |> List.map (\d -> ( d, [] ))
    in
    data
        |> fromDataBand
        |> List.map .points
        |> List.concat
        |> List.foldl
            (\d acc ->
                List.map
                    (\a ->
                        if Tuple.first d == Tuple.first a then
                            ( Tuple.first a, Tuple.second d :: Tuple.second a )

                        else
                            a
                    )
                    acc
            )
            seed


stackedValuesInverse : Float -> StackedValues -> StackedValues
stackedValuesInverse width values =
    values
        |> List.map
            (\v ->
                let
                    ( left, right ) =
                        v.stackedValue
                in
                { v | stackedValue = ( abs <| left - width, abs <| right - width ) }
            )



--  HELPERS


{-| All possible color styles styles
-}
colorStyle : ConfigStruct -> Maybe Int -> Maybe Float -> String
colorStyle c idx interpolatorInput =
    case ( c.colorResource, idx, interpolatorInput ) of
        ( ColorPalette colors, Just i, _ ) ->
            "fill: "
                ++ Helpers.colorPaletteToColor colors i
                ++ ";stroke: "
                ++ Helpers.colorPaletteToColor colors i

        ( ColorInterpolator interpolator, _, Just i ) ->
            "fill: "
                ++ (interpolator i |> Color.toCssString)
                ++ ";stroke: "
                ++ (interpolator i |> Color.toCssString)

        ( Color color, Nothing, Nothing ) ->
            "fill: "
                ++ Color.toCssString color
                ++ ";stroke: "
                ++ Color.toCssString color

        _ ->
            ""


{-| Only categorical styles
-}
colorCategoricalStyle : ConfigStruct -> Int -> String
colorCategoricalStyle c idx =
    case c.colorResource of
        ColorPalette colors ->
            "fill: " ++ Helpers.colorPaletteToColor colors idx

        _ ->
            ""


setXAxisAttributes : ConfigStruct -> List (Maybe (Axis.Attribute data))
setXAxisAttributes c =
    let
        tickCount =
            case c.axisXTickCount of
                DefaultTickCount ->
                    Nothing

                CustomTickCount count ->
                    Just (Axis.tickCount count)

        tickSizeInner =
            case c.axisXTickSizeInner of
                CustomTickSize x ->
                    Just (Axis.tickSizeInner x)

                _ ->
                    case c.axisTickSizeInner of
                        CustomTickSize x ->
                            Just (Axis.tickSizeInner x)

                        _ ->
                            Nothing

        tickSizeOuter =
            case c.axisXTickSizeOuter of
                CustomTickSize x ->
                    Just (Axis.tickSizeOuter x)

                _ ->
                    case c.axisTickSizeOuter of
                        CustomTickSize x ->
                            Just (Axis.tickSizeOuter x)

                        _ ->
                            Nothing

        tickPadding =
            case c.axisXTickPadding of
                CustomTickPadding p ->
                    Just (Axis.tickPadding p)

                _ ->
                    case c.axisTickPadding of
                        CustomTickPadding p ->
                            Just (Axis.tickPadding p)

                        _ ->
                            Nothing
    in
    [ tickCount, tickSizeInner, tickSizeOuter, tickPadding ]


setYAxisAttributes : ConfigStruct -> List (Maybe (Axis.Attribute data))
setYAxisAttributes c =
    let
        tickCount =
            case c.axisYTickCount of
                DefaultTickCount ->
                    Nothing

                CustomTickCount count ->
                    Just (Axis.tickCount count)

        tickSizeInner =
            case c.axisYTickSizeInner of
                CustomTickSize x ->
                    Just (Axis.tickSizeInner x)

                _ ->
                    case c.axisTickSizeInner of
                        CustomTickSize x ->
                            Just (Axis.tickSizeInner x)

                        _ ->
                            Nothing

        tickSizeOuter =
            case c.axisYTickSizeOuter of
                CustomTickSize x ->
                    Just (Axis.tickSizeOuter x)

                _ ->
                    case c.axisTickSizeOuter of
                        CustomTickSize x ->
                            Just (Axis.tickSizeOuter x)

                        _ ->
                            Nothing

        tickPadding =
            case c.axisYTickPadding of
                CustomTickPadding p ->
                    Just (Axis.tickPadding p)

                _ ->
                    case c.axisTickPadding of
                        CustomTickPadding p ->
                            Just (Axis.tickPadding p)

                        _ ->
                            Nothing
    in
    [ tickCount, tickSizeInner, tickSizeOuter, tickPadding ]

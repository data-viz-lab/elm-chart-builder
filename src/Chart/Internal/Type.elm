module Chart.Internal.Type exposing
    ( AccessibilityContent(..)
    , AccessorBand
    , AccessorContinuousOrTime(..)
    , AccessorContinuousStruct
    , AccessorHistogram(..)
    , AccessorTimeStruct
    , Annotation(..)
    , BandDomain
    , ColorResource(..)
    , ColumnTitle(..)
    , Config
    , ConfigStruct
    , ContinuousDomain
    , DataBand
    , DataContinuousGroup(..)
    , DataGroupBand
    , DataGroupContinuous
    , DataGroupContinuousWithStack
    , DataGroupTime
    , Direction(..)
    , DomainBand
    , DomainBandStruct
    , DomainContinuous
    , DomainContinuousStruct
    , DomainTime
    , DomainTimeStruct
    , ExternalData
    , Label(..)
    , Layout(..)
    , LineDraw(..)
    , Margin
    , Orientation(..)
    , Padding
    , PointBand
    , PointContinuous
    , RenderContext(..)
    , RequiredConfig
    , StackOffset
    , StackedValues
    , Steps
    , YScale(..)
    , addEvent
    , adjustContinuousRange
    , ariaHidden
    , ariaLabelledbyContent
    , calculateHistogramDomain
    , colorCategoricalStyle
    , colorStyle
    , dataBandToDataStacked
    , dataContinuousGroupToDataContinuous
    , dataContinuousGroupToDataContinuousStacked
    , dataContinuousGroupToDataTime
    , defaultConfig
    , descAndTitle
    , externalToDataBand
    , externalToDataContinuousGroup
    , externalToDataHistogram
    , fillGapsForStack
    , fromConfig
    , fromDataBand
    , getAnnotationPointHint
    , getAnnotationVLine
    , getBandGroupRange
    , getBandSingleRange
    , getContinuousRange
    , getDataBandDepth
    , getDomainBand
    , getDomainBandFromData
    , getDomainContinuous
    , getDomainContinuousFromData
    , getDomainTime
    , getDomainTimeFromData
    , getOffset
    , getStackedValuesAndGroupes
    , isStackedLine
    , lineDrawLine
    , noGroups
    , role
    , setAccessibilityContent
    , setAnnotiation
    , setBottomPadding
    , setColorResource
    , setCoreStyleFromPointBandX
    , setCoreStyles
    , setCurve
    , setDimensions
    , setDomainBandBandGroup
    , setDomainBandBandSingle
    , setDomainBandContinuous
    , setDomainContinuousAndTimeY
    , setDomainContinuousX
    , setDomainTimeX
    , setHistogramDomain
    , setIcons
    , setLayout
    , setLeftPadding
    , setLineDraw
    , setOrientation
    , setSvgDesc
    , setSvgTitle
    , setTableFloatFormat
    , setTablePosixFormat
    , setXAxis
    , setXAxisBand
    , setXAxisContinuous
    , setXAxisTime
    , setYAxis
    , setYAxisContinuous
    , setYScale
    , showIcons
    , showStackedColumnTitle
    , showXGroupLabel
    , showXOrdinalColumnTitle
    , showXOrdinalLabel
    , showYColumnTitle
    , showYLabel
    , stackedValuesInverse
    , symbolCustomSpace
    , symbolOffset
    , symbolSpace
    , toConfig
    , toContinousScale
    , toDataBand
    , toExternalData
    )

import Chart.Internal.Axis as ChartAxis
import Chart.Internal.Event as Event exposing (Event)
import Chart.Internal.Helpers as Helpers
import Chart.Internal.Symbol as Symbol
    exposing
        ( Symbol(..)
        , symbolGap
        )
import Color exposing (Color)
import Histogram
import Html
import Html.Attributes
import List.Extra
import Scale exposing (BandScale, ContinuousScale)
import Set
import Shape
import Statistics
import SubPath exposing (SubPath)
import Time exposing (Posix, Zone)
import TypedSvg
import TypedSvg.Core exposing (Svg, text)



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


type AccessorContinuousOrTime data
    = AccessorContinuous (AccessorContinuousStruct data)
    | AccessorTime (AccessorTimeStruct data)


type alias AccessorContinuousStruct data =
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


type DataContinuousGroup
    = DataTime (List DataGroupTime)
    | DataContinuous (List DataGroupContinuous)


type alias PointBand =
    ( String, Float )


type alias PointContinuous =
    ( Float, Float )


type alias DataGroup x =
    { groupLabel : Maybe String
    , points : List ( x, Float )
    }


type alias DataGroupBand =
    DataGroup String


type alias DataGroupContinuous =
    DataGroup Float


type alias DataGroupContinuousWithStack =
    { groupLabel : Maybe String
    , points : List ( ( Float, Float ), PointContinuous )
    }


type alias DataGroupTime =
    DataGroup Posix



--------------------------------------------------


type Orientation
    = Vertical
    | Horizontal


type LineDraw
    = Line
    | Area


type alias StackOffset =
    List (List ( Float, Float )) -> List (List ( Float, Float ))


lineDrawLine : LineDraw
lineDrawLine =
    Line


type Layout
    = StackedBar Direction
    | StackedLine StackOffset
    | GroupedBar
    | GroupedLine


type Direction
    = Diverging
    | NoDirection


type alias ContinuousDomain =
    ( Float, Float )


type alias Range =
    ( Float, Float )


type alias TimeDomain =
    ( Posix, Posix )


type alias BandDomain =
    List String


type alias DomainBandStruct =
    { bandGroup : Maybe BandDomain
    , bandSingle : Maybe BandDomain
    , continuous : Maybe ContinuousDomain
    }


initialDomainBandStruct : DomainBandStruct
initialDomainBandStruct =
    { bandGroup = Nothing
    , bandSingle = Nothing
    , continuous = Nothing
    }


type alias DomainContinuousStruct =
    { x : Maybe ContinuousDomain
    , y : Maybe ContinuousDomain
    }


initialDomainContinuousStruct : DomainContinuousStruct
initialDomainContinuousStruct =
    { x = Nothing
    , y = Nothing
    }


type alias DomainTimeStruct =
    { x : Maybe TimeDomain
    , y : Maybe ContinuousDomain
    }


initialDomainTimeStruct : DomainTimeStruct
initialDomainTimeStruct =
    { x = Nothing
    , y = Nothing
    }


type DomainBand
    = DomainBand DomainBandStruct


type DomainContinuous
    = DomainContinuous DomainContinuousStruct


type DomainTime
    = DomainTime DomainTimeStruct


type alias Margin =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


type alias Padding =
    Margin


type YScale
    = LinearScale
    | LogScale Float



--


type ColorResource
    = ColorPalette (List Color)
    | ColorInterpolator (Float -> Color)
    | Color Color
    | ColorNone


type
    AccessibilityContent
    --TODO: AccessibilitySummaryTable
    = AccessibilityTable ( String, String )
    | AccessibilityTableNoLabels
    | AccessibilityNone



-- CONFIG


type alias RequiredConfig =
    { margin : Margin
    , width : Float
    , height : Float
    }


type alias ConfigStruct msg =
    { accessibilityContent : AccessibilityContent
    , annotations : List Annotation
    , axisXBand : ChartAxis.XAxis String
    , axisXContinuous : ChartAxis.XAxis Float
    , axisXTime : ChartAxis.XAxis Posix
    , axisYContinuous : ChartAxis.YAxis Float
    , colorResource : ColorResource
    , coreStyle : List ( String, String )
    , coreStyleFromPointBandX : String -> List ( String, String )
    , curve : List ( Float, Float ) -> SubPath
    , domainBand : DomainBand
    , domainContinuous : DomainContinuous
    , domainTime : DomainTime
    , events : List (Event msg)
    , height : Float
    , histogramDomain : Maybe ( Float, Float )
    , symbols : List Symbol
    , layout : Layout
    , lineDraw : LineDraw
    , margin : Margin
    , orientation : Orientation
    , padding : Padding
    , showColumnTitle : ColumnTitle
    , showDataPoints : Bool
    , showGroupLabels : Bool
    , showLabels : Label
    , showXAxis : Bool
    , showYAxis : Bool
    , svgDesc : String
    , svgTitle : String
    , tableFloatFormat : Float -> String
    , tablePosixFormat : Posix -> String
    , width : Float
    , yScale : YScale
    , zone : Zone
    }


defaultConfig : Config msg validation
defaultConfig =
    toConfig
        { accessibilityContent = AccessibilityTableNoLabels
        , annotations = []
        , axisXBand = ChartAxis.Bottom []
        , axisXContinuous = ChartAxis.Bottom []
        , axisXTime = ChartAxis.Bottom []
        , axisYContinuous = ChartAxis.Left []
        , colorResource = ColorNone
        , coreStyle = []
        , coreStyleFromPointBandX = always []
        , curve = \d -> Shape.linearCurve d
        , domainBand = DomainBand initialDomainBandStruct
        , domainContinuous = DomainContinuous initialDomainContinuousStruct
        , domainTime = DomainTime initialDomainTimeStruct
        , events = []
        , height = defaultHeight
        , histogramDomain = Nothing
        , symbols = []
        , layout = defaultLayout
        , lineDraw = Line
        , margin = defaultMargin
        , orientation = defaultOrientation
        , padding = defaultPadding
        , showColumnTitle = NoColumnTitle
        , showDataPoints = False
        , showGroupLabels = False
        , showLabels = NoLabel
        , showXAxis = True
        , showYAxis = True
        , svgDesc = ""
        , svgTitle = ""
        , tableFloatFormat = String.fromFloat
        , tablePosixFormat = Time.posixToMillis >> String.fromInt
        , width = defaultWidth
        , yScale = LinearScale
        , zone = Time.utc
        }


type Config msg validation
    = Config (ConfigStruct msg)


toConfig : ConfigStruct msg -> Config msg validation
toConfig config =
    Config config


fromConfig : Config msg validation -> ConfigStruct msg
fromConfig (Config config) =
    config


role : String -> Html.Attribute msg
role name =
    Html.Attributes.attribute "role" name


ariaLabelledby : String -> Html.Attribute msg
ariaLabelledby label =
    Html.Attributes.attribute "aria-labelledby" label


ariaHidden : Html.Attribute msg
ariaHidden =
    Html.Attributes.attribute "aria-hidden" "true"



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


defaultPadding : Padding
defaultPadding =
    { top = 0
    , right = 0
    , bottom = 2
    , left = 2
    }



-- STACKED


type alias StackedValues =
    List
        { rawValue : Float
        , stackedValue : ( Float, Float )
        }


type alias StackedValuesAndGroupes =
    ( List StackedValues, List String )



-- SETTERS


addEvent : Event msg -> Config msg validation -> Config msg validation
addEvent event (Config c) =
    let
        updatedEvents =
            event :: c.events
    in
    toConfig { c | events = updatedEvents }


setLayout : Layout -> Config msg validation -> Config msg validation
setLayout layout (Config c) =
    toConfig { c | layout = layout }


setLineDraw : LineDraw -> Config msg validation -> Config msg validation
setLineDraw lineDraw (Config c) =
    toConfig { c | lineDraw = lineDraw }


setIcons : List Symbol -> Config msg validation -> Config msg validation
setIcons all (Config c) =
    Config { c | symbols = all }


setCurve : (List ( Float, Float ) -> SubPath) -> Config msg validation -> Config msg validation
setCurve curve (Config c) =
    toConfig { c | curve = curve }


setSvgDesc : String -> Config msg validation -> Config msg validation
setSvgDesc desc (Config c) =
    toConfig { c | svgDesc = desc }


setSvgTitle : String -> Config msg validation -> Config msg validation
setSvgTitle title (Config c) =
    toConfig { c | svgTitle = title }


setTableFloatFormat : (Float -> String) -> Config msg validation -> Config msg validation
setTableFloatFormat f (Config c) =
    toConfig { c | tableFloatFormat = f }


setTablePosixFormat : (Posix -> String) -> Config msg validation -> Config msg validation
setTablePosixFormat f (Config c) =
    toConfig { c | tablePosixFormat = f }


setXAxisTime : ChartAxis.XAxis Posix -> Config msg validation -> Config msg validation
setXAxisTime orientation (Config c) =
    toConfig { c | axisXTime = orientation }


setXAxisContinuous : ChartAxis.XAxis Float -> Config msg validation -> Config msg validation
setXAxisContinuous orientation (Config c) =
    toConfig { c | axisXContinuous = orientation }


setXAxisBand : ChartAxis.XAxis String -> Config msg validation -> Config msg validation
setXAxisBand orientation (Config c) =
    toConfig { c | axisXBand = orientation }


setYAxisContinuous : ChartAxis.YAxis Float -> Config msg validation -> Config msg validation
setYAxisContinuous orientation (Config c) =
    toConfig { c | axisYContinuous = orientation }


setColorResource : ColorResource -> Config msg validation -> Config msg validation
setColorResource resource (Config c) =
    toConfig { c | colorResource = resource }


setCoreStyles : List ( String, String ) -> Config msg validation -> Config msg validation
setCoreStyles styles (Config c) =
    toConfig { c | coreStyle = styles }


setCoreStyleFromPointBandX : (String -> List ( String, String )) -> Config msg validation -> Config msg validation
setCoreStyleFromPointBandX f (Config c) =
    toConfig { c | coreStyleFromPointBandX = f }


setHistogramDomain : ( Float, Float ) -> Config msg validation -> Config msg validation
setHistogramDomain domain (Config c) =
    toConfig { c | histogramDomain = Just domain }


setOrientation : Orientation -> Config msg validation -> Config msg validation
setOrientation orientation (Config c) =
    toConfig { c | orientation = orientation }


setDimensions :
    { margin : Margin, width : Float, height : Float }
    -> Config msg validation
    -> Config msg validation
setDimensions { margin, width, height } (Config c) =
    let
        left =
            margin.left + c.padding.left

        right =
            margin.right + c.padding.right

        bottom =
            margin.bottom + c.padding.bottom

        top =
            margin.top + c.padding.top
    in
    toConfig
        { c
            | width = width - left - right
            , height = height - top - bottom

            --, margin = { margin | left = left, bottom = bottom }
            , margin = margin
        }


setLeftPadding : Float -> Config msg validation -> Config msg validation
setLeftPadding value (Config c) =
    let
        padding =
            c.padding

        newPadding =
            { padding | left = value }

        newWidth =
            c.width + padding.left - value
    in
    toConfig { c | padding = newPadding, width = newWidth }


setBottomPadding : Float -> Config msg validation -> Config msg validation
setBottomPadding value (Config c) =
    let
        padding =
            c.padding

        newPadding =
            { padding | bottom = value }

        newHeight =
            c.height + padding.bottom - value
    in
    toConfig { c | padding = newPadding, height = newHeight }


setDomainBandBandGroup : BandDomain -> Config msg validation -> Config msg validation
setDomainBandBandGroup bandDomain (Config c) =
    let
        domain =
            c.domainBand
                |> fromDomainBand

        newDomain =
            { domain | bandGroup = Just bandDomain }
    in
    toConfig { c | domainBand = DomainBand newDomain }


setDomainBandBandSingle : BandDomain -> Config msg validation -> Config msg validation
setDomainBandBandSingle bandDomain (Config c) =
    let
        domain =
            c.domainBand
                |> fromDomainBand

        newDomain =
            { domain | bandSingle = Just bandDomain }
    in
    toConfig { c | domainBand = DomainBand newDomain }


setDomainBandContinuous : ContinuousDomain -> Config msg validation -> Config msg validation
setDomainBandContinuous continuousDomain (Config c) =
    let
        domain =
            c.domainBand
                |> fromDomainBand

        newDomain =
            { domain | continuous = Just continuousDomain }
    in
    toConfig { c | domainBand = DomainBand newDomain }


setDomainTimeX : TimeDomain -> Config msg validation -> Config msg validation
setDomainTimeX timeDomain (Config c) =
    let
        domain =
            c.domainTime
                |> fromDomainTime

        newDomain =
            { domain | x = Just timeDomain }
    in
    toConfig { c | domainTime = DomainTime newDomain }


setDomainContinuousX : ContinuousDomain -> Config msg validation -> Config msg validation
setDomainContinuousX continuousDomain (Config c) =
    let
        domain =
            c.domainContinuous
                |> fromDomainContinuous

        newDomain =
            { domain | x = Just continuousDomain }
    in
    toConfig { c | domainContinuous = DomainContinuous newDomain }


setDomainContinuousAndTimeY : ContinuousDomain -> Config msg validation -> Config msg validation
setDomainContinuousAndTimeY continuousDomain (Config c) =
    let
        domain =
            c.domainContinuous
                |> fromDomainContinuous

        newDomain =
            { domain | y = Just continuousDomain }

        domainTime =
            c.domainTime
                |> fromDomainTime

        newDomainTime =
            { domainTime | y = Just continuousDomain }
    in
    toConfig { c | domainContinuous = DomainContinuous newDomain, domainTime = DomainTime newDomainTime }


setXAxis : Bool -> Config msg validation -> Config msg validation
setXAxis bool (Config c) =
    toConfig { c | showXAxis = bool }


setYAxis : Bool -> Config msg validation -> Config msg validation
setYAxis bool (Config c) =
    toConfig { c | showYAxis = bool }


setAnnotiation : Annotation -> Config msg validation -> Config msg validation
setAnnotiation annotation (Config c) =
    let
        a =
            annotation :: c.annotations
    in
    toConfig { c | annotations = a }


setAccessibilityContent : AccessibilityContent -> Config msg validation -> Config msg validation
setAccessibilityContent content (Config c) =
    toConfig { c | accessibilityContent = content }


setYScale : YScale -> Config msg validation -> Config msg validation
setYScale scale (Config c) =
    toConfig { c | yScale = scale }



-- LABELS


type Label
    = YLabel (Float -> String)
    | XOrdinalLabel
    | XGroupLabel
    | NoLabel


showXOrdinalLabel : Config msg validation -> Config msg validation
showXOrdinalLabel (Config c) =
    toConfig { c | showLabels = XOrdinalLabel }


showYLabel : (Float -> String) -> Config msg validation -> Config msg validation
showYLabel formatter (Config c) =
    toConfig { c | showLabels = YLabel formatter }


showXGroupLabel : Config msg validation -> Config msg validation
showXGroupLabel (Config c) =
    toConfig { c | showLabels = XGroupLabel }



-- COLUMN TITLES


type ColumnTitle
    = YColumnTitle (Float -> String)
    | XOrdinalColumnTitle
    | StackedColumnTitle (Float -> String)
    | NoColumnTitle


showXOrdinalColumnTitle : Config msg validation -> Config msg validation
showXOrdinalColumnTitle (Config c) =
    toConfig { c | showColumnTitle = XOrdinalColumnTitle }


showYColumnTitle : (Float -> String) -> Config msg validation -> Config msg validation
showYColumnTitle formatter (Config c) =
    toConfig { c | showColumnTitle = YColumnTitle formatter }


showStackedColumnTitle : (Float -> String) -> Config msg validation -> Config msg validation
showStackedColumnTitle formatter (Config c) =
    toConfig { c | showColumnTitle = StackedColumnTitle formatter }



-- GETTERS


showIcons : Config msg validation -> Bool
showIcons (Config c) =
    c
        |> .symbols
        |> List.length
        |> (\l -> l > 0)


getDomainBand : Config msg validation -> DomainBandStruct
getDomainBand config =
    config
        |> fromConfig
        |> .domainBand
        |> fromDomainBand


getDomainContinuous : Config msg validation -> DomainContinuousStruct
getDomainContinuous config =
    config
        |> fromConfig
        |> .domainContinuous
        |> fromDomainContinuous


getDomainTime : Config msg validation -> DomainTimeStruct
getDomainTime config =
    config
        |> fromConfig
        |> .domainTime
        |> fromDomainTime


getDomainBandFromData : DataBand -> Config msg validation -> DomainBandStruct
getDomainBandFromData data config =
    let
        -- get the domain from config first
        domain =
            getDomainBand config

        d =
            fromDataBand data

        c =
            fromConfig config
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
        , continuous =
            case domain.continuous of
                Just continuous ->
                    Just continuous

                Nothing ->
                    d
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.second
                        |> (\dd ->
                                case c.layout of
                                    StackedBar Diverging ->
                                        ( List.minimum dd |> Maybe.withDefault 0
                                        , List.maximum dd |> Maybe.withDefault 0
                                        )

                                    _ ->
                                        ( 0, List.maximum dd |> Maybe.withDefault 0 )
                           )
                        |> Just
        }
        |> fromDomainBand


getDomainContinuousFromData :
    Maybe ( Float, Float )
    -> DomainContinuousStruct
    -> List DataGroupContinuous
    -> DomainContinuousStruct
getDomainContinuousFromData extent domain data =
    DomainContinuous
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
                    case extent of
                        Just _ ->
                            extent

                        Nothing ->
                            data
                                |> List.map .points
                                |> List.concat
                                |> List.map Tuple.second
                                |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                                |> Just
        }
        |> fromDomainContinuous


getDomainTimeFromData : Maybe ( Float, Float ) -> DomainTimeStruct -> List DataGroupTime -> DomainTimeStruct
getDomainTimeFromData extent domain data =
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
                    case extent of
                        Just _ ->
                            extent

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


fromDomainContinuous : DomainContinuous -> DomainContinuousStruct
fromDomainContinuous (DomainContinuous d) =
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


getBandGroupRange : Config msg validation -> Float -> Float -> ( Float, Float )
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


getBandSingleRange : Config msg validation -> Float -> ( Float, Float )
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


getContinuousRange : Config msg validation -> RenderContext -> Float -> Float -> BandScale String -> ( Float, Float )
getContinuousRange config renderContext width height bandScale =
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
                        ( 0, width - symbolGap - symbolSpace c.orientation bandScale c.symbols )

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
                        ( height - symbolGap - symbolSpace c.orientation bandScale c.symbols
                        , 0
                        )

                    else
                        ( height, 0 )

                _ ->
                    ( height, 0 )


adjustContinuousRange : Config msg validation -> Int -> ( Float, Float ) -> ( Float, Float )
adjustContinuousRange config stackedDepth ( a, b ) =
    -- small adjustments related to the whitespace between stacked items?
    -- FIXME: needs removing?
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


getOffset : Config msg validation -> List (List ( Float, Float )) -> List (List ( Float, Float ))
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


symbolOffset : Scale.BandScale String -> List Symbol -> Float
symbolOffset bandSingleScale symbols =
    if List.isEmpty symbols then
        0

    else
        symbolSpace Vertical bandSingleScale symbols + Symbol.symbolGap



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


calculateHistogramDomain : List (Histogram.Bin Float Float) -> ( Float, Float )
calculateHistogramDomain histogram =
    histogram
        |> List.map (\h -> [ h.x0, h.x1 ])
        |> List.concat
        |> Statistics.extent
        |> Maybe.withDefault ( 0, 0 )


externalToDataHistogram :
    Config msg validation
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


externalToDataContinuousGroup : ExternalData data -> AccessorContinuousOrTime data -> DataContinuousGroup
externalToDataContinuousGroup externalData accessorGroup =
    let
        data =
            fromExternalData externalData
    in
    case accessorGroup of
        AccessorContinuous accessor ->
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
                |> DataContinuous

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


dataContinuousGroupToDataContinuous : DataContinuousGroup -> List DataGroupContinuous
dataContinuousGroupToDataContinuous data =
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

        DataContinuous d ->
            d


dataContinuousGroupToDataTime : DataContinuousGroup -> List DataGroupTime
dataContinuousGroupToDataTime data =
    case data of
        DataTime d ->
            d

        _ ->
            []


fillGapsForStack : DataBand -> DataBand
fillGapsForStack data =
    let
        d =
            data
                |> fromDataBand

        allStrings =
            d
                |> List.map (.points >> List.map Tuple.first)
                |> List.concat
                |> Set.fromList

        fillGaps dataGroupBand =
            let
                points =
                    dataGroupBand.points
                        |> List.map Tuple.first

                newPoints =
                    allStrings
                        |> Set.foldr
                            (\s acc ->
                                if List.member s points then
                                    acc

                                else
                                    ( s, 0 ) :: acc
                            )
                            []
                        |> List.append dataGroupBand.points
                        |> List.sortBy Tuple.first
            in
            { dataGroupBand | points = newPoints }
    in
    d
        |> List.map fillGaps
        |> toDataBand


getStackedValuesAndGroupes : List (List ( Float, Float )) -> DataBand -> StackedValuesAndGroupes
getStackedValuesAndGroupes values data =
    let
        m =
            List.map2
                (\d v ->
                    List.map2
                        (\stackedValue rawValue ->
                            { rawValue = Tuple.second rawValue
                            , stackedValue = stackedValue
                            }
                        )
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


dataContinuousGroupToDataContinuousStacked : List DataGroupContinuous -> List ( String, List Float )
dataContinuousGroupToDataContinuousStacked data =
    data
        |> List.indexedMap
            (\i d ->
                ( d.groupLabel |> Maybe.withDefault (String.fromInt i), d.points |> List.map Tuple.second )
            )


dataBandToDataStacked : Config msg validation -> DataBand -> List ( String, List Float )
dataBandToDataStacked config data =
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
colorStyle : ConfigStruct msg -> Maybe Int -> Maybe Float -> String
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
            "stroke:grey"


{-| Only categorical styles
-}
colorCategoricalStyle : ConfigStruct msg -> Int -> String
colorCategoricalStyle c idx =
    case c.colorResource of
        ColorPalette colors ->
            "fill: " ++ Helpers.colorPaletteToColor colors idx

        _ ->
            ""


ariaLabelledbyContent : ConfigStruct msg -> List (TypedSvg.Core.Attribute msg)
ariaLabelledbyContent c =
    case c.accessibilityContent of
        AccessibilityNone ->
            if c.svgDesc /= "" && c.svgTitle /= "" then
                [ ariaLabelledby (c.svgDesc ++ " " ++ c.svgTitle) ]

            else if c.svgDesc /= "" then
                [ ariaLabelledby c.svgDesc ]

            else if c.svgTitle /= "" then
                [ ariaLabelledby c.svgTitle ]

            else
                []

        _ ->
            [ ariaHidden ]


noGroups : List { a | groupLabel : Maybe String } -> Bool
noGroups data =
    data
        |> List.map .groupLabel
        |> List.all (\d -> d == Nothing)


toContinousScale : Range -> ContinuousDomain -> YScale -> ContinuousScale Float
toContinousScale range domain scale =
    case scale of
        LogScale base ->
            Scale.log base range (domain |> adjustDomainToLogScale)

        LinearScale ->
            Scale.linear range domain


adjustDomainToLogScale : ContinuousDomain -> ContinuousDomain
adjustDomainToLogScale ( a, b ) =
    if a == 0 then
        ( 1, b )

    else if b == 0 then
        ( a, -1 )

    else
        ( a, b )


descAndTitle : ConfigStruct msg -> List (Svg msg)
descAndTitle c =
    -- https://developer.paciellogroup.com/blog/2013/12/using-aria-enhance-svg-accessibility/
    [ ( TypedSvg.title [], c.svgTitle )
    , ( TypedSvg.desc [], c.svgDesc )
    ]
        |> List.foldr
            (\( el, str ) acc ->
                if str == "" then
                    acc

                else
                    el [ text str ] :: acc
            )
            []


type alias Style =
    List ( String, String )


type Annotation
    = AnnotationPointHint ( Event.Hint, Style )
    | AnnotationXBarHint ( Event.Hint, Style )


getAnnotationPointHint : List Annotation -> Maybe ( Event.Hint, Style )
getAnnotationPointHint annotations =
    --FIXME: this assumes only one point annotation hint per list of annotations.
    -- If this is the case, it should be enforced and not assumed.
    annotations
        |> List.filterMap
            (\annotation ->
                case annotation of
                    AnnotationPointHint p ->
                        Just p

                    _ ->
                        Nothing
            )
        |> List.head


getAnnotationVLine : List Annotation -> Maybe ( Event.Hint, Style )
getAnnotationVLine annotations =
    --FIXME: this assumes only one x-bar annotation hint per list of annotations.
    -- If this is the case, it should be enforced and not assumed.
    annotations
        |> List.filterMap
            (\annotation ->
                case annotation of
                    AnnotationXBarHint p ->
                        Just p

                    _ ->
                        Nothing
            )
        |> List.head


isStackedLine : ConfigStruct msg -> Bool
isStackedLine c =
    case c.layout of
        StackedLine _ ->
            True

        _ ->
            False



--transposeDataGroup : ExternalData data -> AccessorContinuousOrTime data -> DataGroupTransposed comparable
--transposeDataGroup externalData accessorGroup =
--    externalData
--        |> fromExternalData
--        |> List.foldl
--            (\d dict ->
--                let
--                    ( x, y, label ) =
--                        case accessorGroup of
--                            AccessorContinuous accessor ->
--                                ( accessor.xValue d
--                                , accessor.yValue d
--                                , accessor.xGroup d
--                                )
--
--                            AccessorTime accessor ->
--                                ( accessor.xValue d |> Time.posixToMillis |> toFloat
--                                , accessor.yValue d
--                                , accessor.xGroup d
--                                )
--                in
--                dict
--            )
--            Dict.empty

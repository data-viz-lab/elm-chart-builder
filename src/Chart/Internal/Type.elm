module Chart.Internal.Type exposing
    ( AccessorBand
    , AxisContinousDataTickCount(..)
    , AxisContinousDataTickFormat(..)
    , AxisContinousDataTicks(..)
    , AxisOrientation(..)
    , BandDomain
    , Config
    , ConfigStruct
    , DataBand
    , DataGroupBand
    , DataGroupLinear
    , DataGroupTime
    , DataLinear
    , DataTime
    , Direction(..)
    , DomainBand
    , DomainBandStruct
    , DomainLinear
    , DomainLinearStruct
    , DomainTime
    , ExternalData
    , GroupedConfig
    , GroupedConfigStruct
    , Layout(..)
    , LinearDomain
    , Margin
    , Orientation(..)
    , PointBand
    , PointLinear
    , PointTime
    , RenderContext(..)
    , StackedValues
    , StackedValuesAndGroupes
    , adjustLinearRange
    , ariaLabelledby
    , bottomGap
    , defaultConfig
    , defaultGroupedConfig
    , defaultHeight
    , defaultLayout
    , defaultMargin
    , defaultOrientation
    , defaultTicksCount
    , defaultWidth
    , externalToDataBand
    , externalToDataLinear
    , externalToDataTime
    , fromConfig
    , fromDataBand
    , fromDataLinear
    , fromDataTime
    , fromDomainBand
    , fromDomainLinear
    , getAxisContinousDataFormatter
    , getAxisContinousXTickCount
    , getAxisContinousXTickFormat
    , getAxisContinousXTicks
    , getAxisContinousYTickCount
    , getAxisContinousYTickFormat
    , getAxisContinousYTicks
    , getBandGroupRange
    , getBandSingleRange
    , getDataBandDepth
    , getDataLinearDepth
    , getDesc
    , getDomainBand
    , getDomainBandFromData
    , getDomainLinear
    , getDomainLinearFromData
    , getDomainTimeFromData
    , getHeight
    , getIcons
    , getIconsFromLayout
    , getLinearRange
    , getMargin
    , getOffset
    , getShowIndividualLabels
    , getTitle
    , getWidth
    , getZone
    , leftGap
    , role
    , setAxisContinousXTickCount
    , setAxisContinousXTickFormat
    , setAxisContinousXTicks
    , setAxisContinousYTickCount
    , setAxisContinousYTickFormat
    , setAxisContinousYTicks
    , setDesc
    , setDimensions
    , setDomainBand
    , setDomainBandBandGroup
    , setDomainBandBandSingle
    , setDomainBandLinear
    , setDomainLinear
    , setDomainTime
    , setHeight
    , setIcons
    , setLayout
    , setMargin
    , setOrientation
    , setShowIndividualLabels
    , setShowXAxis
    , setShowYAxis
    , setTitle
    , setWidth
    , showIcons
    , showIconsFromLayout
    , symbolCustomSpace
    , symbolSpace
    , toConfig
    , toExternalData
    )

import Chart.Internal.Symbol as Symbol exposing (Symbol(..), symbolGap)
import Html
import Html.Attributes
import List.Extra
import Scale exposing (BandScale)
import Shape
import Time exposing (Posix, Zone)



-- DATA
-- DataOrdinal (List DataGroupOrdinal)
-- DataTime (List DataGroupTime)


type ExternalData data
    = ExternalData (List data)


fromExternalData : ExternalData data -> List data
fromExternalData (ExternalData data) =
    data


toExternalData : List data -> ExternalData data
toExternalData data =
    ExternalData data


type alias AccessorBand data =
    { xGroup : data -> String
    , xValue : data -> String
    , yValue : data -> Float
    }


type alias AccessorLinear data =
    { xGroup : data -> String
    , xValue : data -> Float
    , yValue : data -> Float
    }


type alias AccessorTime data =
    { xGroup : data -> String
    , xValue : data -> Posix
    , yValue : data -> Float
    }


type DataBand
    = DataBand (List DataGroupBand)


type DataLinear
    = DataLinear (List DataGroupLinear)


type DataTime
    = DataTime (List DataGroupTime)


type alias PointBand =
    ( String, Float )


type alias PointLinear =
    ( Float, Float )


type alias PointTime =
    ( Posix, Float )


type alias DataGroupBand =
    { groupLabel : Maybe String
    , points : List PointBand
    }


dummyDataGroupBand : DataGroupBand
dummyDataGroupBand =
    { groupLabel = Nothing
    , points = []
    }


type alias DataGroupLinear =
    { groupLabel : Maybe String
    , points : List PointLinear
    }


dummyDataGroupLinear : DataGroupLinear
dummyDataGroupLinear =
    { groupLabel = Nothing
    , points = []
    }


type alias DataGroupTime =
    { groupLabel : Maybe String
    , points : List PointTime
    }


dummyDataGroupTime : DataGroupTime
dummyDataGroupTime =
    { groupLabel = Nothing
    , points = []
    }



--------------------------------------------------


type Orientation
    = Vertical
    | Horizontal


type Layout
    = Stacked Direction
    | Grouped GroupedConfig


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
    { horizontal : Maybe LinearDomain
    , vertical : Maybe LinearDomain
    }


initialDomainLinearStruct : DomainLinearStruct
initialDomainLinearStruct =
    { horizontal = Nothing
    , vertical = Nothing
    }


type alias DomainTimeStruct =
    { horizontal : Maybe TimeDomain
    , vertical : Maybe LinearDomain
    }


initialDomainTimeStruct : DomainTimeStruct
initialDomainTimeStruct =
    { horizontal = Nothing
    , vertical = Nothing
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


type AxisContinousDataTickFormat
    = DefaultTickFormat
    | CustomTickFormat (Float -> String)
    | CustomTimeTickFormat (Posix -> String)


type alias ConfigStruct =
    { axisContinousXTickCount : AxisContinousDataTickCount
    , axisContinousXTickFormat : AxisContinousDataTickFormat
    , axisContinousXTicks : AxisContinousDataTicks
    , axisContinousYTickCount : AxisContinousDataTickCount
    , axisContinousYTickFormat : AxisContinousDataTickFormat
    , axisContinousYTicks : AxisContinousDataTicks
    , desc : String
    , domainBand : DomainBand
    , domainLinear : DomainLinear
    , domainTime : DomainTime

    --, externalDataBandAccessor : ExternalDataBandAccessor data
    --, externalDataLinearAccessor : ExternalDataLinearAccessor data
    , height : Float
    , layout : Layout
    , margin : Margin
    , orientation : Orientation
    , showXAxis : Bool
    , showYAxis : Bool
    , title : String
    , width : Float
    , zone : Zone
    }


defaultConfig : Config
defaultConfig =
    toConfig
        { axisContinousXTickCount = DefaultTickCount
        , axisContinousXTickFormat = DefaultTickFormat
        , axisContinousXTicks = DefaultTicks
        , axisContinousYTickCount = DefaultTickCount
        , axisContinousYTickFormat = DefaultTickFormat
        , axisContinousYTicks = DefaultTicks
        , desc = ""
        , domainBand = DomainBand initialDomainBandStruct
        , domainLinear = DomainLinear initialDomainLinearStruct
        , domainTime = DomainTime initialDomainTimeStruct

        --, externalDataBandAccessor = toExternalDataBandAccessor accessorsBand
        --, externalDataLinearAccessor = toExternalDataLinearAccessor accessorsLinear
        , height = defaultHeight
        , layout = defaultLayout
        , margin = defaultMargin
        , orientation = defaultOrientation
        , showXAxis = True
        , showYAxis = True
        , title = ""
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
    Grouped defaultGroupedConfig


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



-- GROUPED CONFIG


type GroupedConfig
    = GroupedConfig GroupedConfigStruct


type alias GroupedConfigStruct =
    { icons : List (Symbol String)
    , showIndividualLabels : Bool
    }


toGroupedConfig : GroupedConfigStruct -> GroupedConfig
toGroupedConfig config =
    GroupedConfig config


fromGroupedConfig : GroupedConfig -> GroupedConfigStruct
fromGroupedConfig (GroupedConfig config) =
    config


defaultGroupedConfig : GroupedConfig
defaultGroupedConfig =
    toGroupedConfig
        { icons = []
        , showIndividualLabels = False
        }


showIcons : GroupedConfig -> Bool
showIcons c =
    c
        |> fromGroupedConfig
        |> .icons
        |> List.length
        |> (\l -> l > 0)


showIconsFromLayout : Layout -> Bool
showIconsFromLayout l =
    case l of
        Grouped c ->
            c
                |> showIcons

        Stacked _ ->
            False


getIcons : GroupedConfig -> List (Symbol String)
getIcons c =
    c
        |> fromGroupedConfig
        |> .icons


getShowIndividualLabels : GroupedConfig -> Bool
getShowIndividualLabels c =
    c
        |> fromGroupedConfig
        |> .showIndividualLabels


getIconsFromLayout : Layout -> List (Symbol String)
getIconsFromLayout l =
    case l of
        Grouped c ->
            c
                |> fromGroupedConfig
                |> .icons

        Stacked _ ->
            []


setIcons : List (Symbol String) -> GroupedConfig -> GroupedConfig
setIcons all config =
    let
        c =
            fromGroupedConfig config
    in
    toGroupedConfig { c | icons = all }


setShowIndividualLabels : Bool -> GroupedConfig -> GroupedConfig
setShowIndividualLabels bool config =
    let
        c =
            fromGroupedConfig config
    in
    toGroupedConfig { c | showIndividualLabels = bool }



-- STACKED


type alias StackedValues =
    List
        { rawValue : Float
        , stackedValue : ( Float, Float )
        }


type alias StackedValuesAndGroupes =
    ( List StackedValues, List String )



-- SETTERS


setAxisContinousXTickCount : AxisContinousDataTickCount -> Config -> Config
setAxisContinousXTickCount count config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisContinousXTickCount = count }


setAxisContinousYTickCount : AxisContinousDataTickCount -> Config -> Config
setAxisContinousYTickCount count config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisContinousYTickCount = count }


setDesc : String -> Config -> Config
setDesc desc config =
    let
        c =
            fromConfig config
    in
    toConfig { c | desc = desc }


setTitle : String -> Config -> Config
setTitle title config =
    let
        c =
            fromConfig config
    in
    toConfig { c | title = title }


setAxisContinousXTickFormat : AxisContinousDataTickFormat -> Config -> Config
setAxisContinousXTickFormat format config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisContinousXTickFormat = format }


setAxisContinousYTickFormat : AxisContinousDataTickFormat -> Config -> Config
setAxisContinousYTickFormat format config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisContinousYTickFormat = format }


setAxisContinousXTicks : AxisContinousDataTicks -> Config -> Config
setAxisContinousXTicks ticks config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisContinousXTicks = ticks }


setAxisContinousYTicks : AxisContinousDataTicks -> Config -> Config
setAxisContinousYTicks ticks config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisContinousYTicks = ticks }


setHeight : Float -> Config -> Config
setHeight height config =
    let
        c =
            fromConfig config

        m =
            c.margin
    in
    toConfig { c | height = height - m.top - m.bottom }


setLayout : Layout -> Config -> Config
setLayout layout config =
    let
        c =
            fromConfig config
    in
    toConfig { c | layout = layout }


setOrientation : Orientation -> Config -> Config
setOrientation orientation config =
    let
        c =
            fromConfig config
    in
    toConfig { c | orientation = orientation }


setWidth : Float -> Config -> Config
setWidth width config =
    let
        c =
            fromConfig config

        m =
            c.margin
    in
    toConfig { c | width = width - m.left - m.right }


setMargin : Margin -> Config -> Config
setMargin margin config =
    let
        c =
            fromConfig config

        left =
            margin.left + leftGap

        bottom =
            margin.bottom + bottomGap
    in
    toConfig { c | margin = { margin | left = left, bottom = bottom } }


setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions { margin, width, height } config =
    let
        c =
            fromConfig config

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
setDomainLinear domain config =
    let
        c =
            fromConfig config
    in
    toConfig { c | domainLinear = domain }


setDomainTime : DomainTime -> Config -> Config
setDomainTime domain config =
    let
        c =
            fromConfig config
    in
    toConfig { c | domainTime = domain }


setDomainBand : DomainBand -> Config -> Config
setDomainBand domain config =
    let
        c =
            fromConfig config
    in
    toConfig { c | domainBand = domain }


setDomainBandBandGroup : BandDomain -> Config -> Config
setDomainBandBandGroup bandDomain config =
    let
        c =
            fromConfig config

        domain =
            c.domainBand
                |> fromDomainBand

        newDomain =
            { domain | bandGroup = Just bandDomain }
    in
    toConfig { c | domainBand = DomainBand newDomain }


setDomainBandBandSingle : BandDomain -> Config -> Config
setDomainBandBandSingle bandDomain config =
    let
        c =
            fromConfig config

        domain =
            c.domainBand
                |> fromDomainBand

        newDomain =
            { domain | bandSingle = Just bandDomain }
    in
    toConfig { c | domainBand = DomainBand newDomain }


setDomainBandLinear : LinearDomain -> Config -> Config
setDomainBandLinear linearDomain config =
    let
        c =
            fromConfig config

        domain =
            c.domainBand
                |> fromDomainBand

        newDomain =
            { domain | linear = Just linearDomain }
    in
    toConfig { c | domainBand = DomainBand newDomain }


setShowXAxis : Bool -> Config -> Config
setShowXAxis bool config =
    let
        c =
            fromConfig config
    in
    toConfig { c | showXAxis = bool }


setShowYAxis : Bool -> Config -> Config
setShowYAxis bool config =
    let
        c =
            fromConfig config
    in
    toConfig { c | showYAxis = bool }



-- GETTERS


getZone : Config -> Time.Zone
getZone config =
    fromConfig config |> .zone


getAxisContinousXTickCount : Config -> AxisContinousDataTickCount
getAxisContinousXTickCount config =
    fromConfig config |> .axisContinousXTickCount


getAxisContinousYTickCount : Config -> AxisContinousDataTickCount
getAxisContinousYTickCount config =
    fromConfig config |> .axisContinousYTickCount


getAxisContinousXTickFormat : Config -> AxisContinousDataTickFormat
getAxisContinousXTickFormat config =
    fromConfig config |> .axisContinousXTickFormat


getAxisContinousYTickFormat : Config -> AxisContinousDataTickFormat
getAxisContinousYTickFormat config =
    fromConfig config |> .axisContinousYTickFormat


getAxisContinousYTicks : Config -> AxisContinousDataTicks
getAxisContinousYTicks config =
    fromConfig config |> .axisContinousYTicks


getAxisContinousXTicks : Config -> AxisContinousDataTicks
getAxisContinousXTicks config =
    fromConfig config |> .axisContinousXTicks


getAxisContinousDataFormatter : AxisContinousDataTickFormat -> Maybe (Float -> String)
getAxisContinousDataFormatter format =
    case format of
        DefaultTickFormat ->
            Just (\f -> String.fromFloat f)

        CustomTickFormat formatter ->
            Just formatter

        CustomTimeTickFormat _ ->
            Nothing


getDesc : Config -> String
getDesc config =
    fromConfig config |> .desc


getTitle : Config -> String
getTitle config =
    fromConfig config |> .title


getMargin : Config -> Margin
getMargin config =
    fromConfig config
        |> .margin


getHeight : Config -> Float
getHeight config =
    fromConfig config |> .height


getWidth : Config -> Float
getWidth config =
    fromConfig config |> .width


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


getDomainLinearFromData : DataLinear -> Config -> DomainLinearStruct
getDomainLinearFromData data config =
    let
        -- get the domain from config first
        -- and use it!
        domain =
            getDomainLinear config

        d =
            fromDataLinear data
    in
    DomainLinear
        { horizontal =
            d
                |> List.map .points
                |> List.concat
                |> List.map Tuple.first
                |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                |> Just
        , vertical =
            d
                |> List.map .points
                |> List.concat
                |> List.map Tuple.second
                |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                |> Just
        }
        |> fromDomainLinear


getDomainTimeFromData : DataTime -> Config -> DomainTimeStruct
getDomainTimeFromData data config =
    let
        -- get the domain from config first
        -- and use it!
        domain =
            getDomainTime config

        d =
            fromDataTime data
    in
    DomainTime
        { horizontal =
            d
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
        , vertical =
            d
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


fromDataLinear : DataLinear -> List DataGroupLinear
fromDataLinear (DataLinear d) =
    d


fromDataTime : DataTime -> List DataGroupTime
fromDataTime (DataTime d) =
    d


getDataBandDepth : DataBand -> Int
getDataBandDepth data =
    data
        |> fromDataBand
        |> List.map .points
        |> List.head
        |> Maybe.withDefault []
        |> List.length


getDataLinearDepth : DataLinear -> Int
getDataLinearDepth data =
    data
        |> fromDataLinear
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
                Grouped groupedConfig ->
                    if showIcons groupedConfig then
                        -- Here we are leaving space for the symbol
                        ( 0, width - symbolGap - symbolSpace c.orientation bandScale (getIcons groupedConfig) )

                    else
                        ( 0, width )

                Stacked _ ->
                    case renderContext of
                        RenderChart ->
                            ( width, 0 )

                        RenderAxis ->
                            ( 0, width )

        Vertical ->
            case layout of
                Grouped groupedConfig ->
                    if showIcons groupedConfig then
                        -- Here we are leaving space for the symbol
                        ( height - symbolGap - symbolSpace c.orientation bandScale (getIcons groupedConfig), 0 )

                    else
                        ( height, 0 )

                Stacked _ ->
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
                Grouped _ ->
                    ( a, b )

                Stacked _ ->
                    ( a + toFloat stackedDepth, b )

        Vertical ->
            ( a - toFloat stackedDepth, b )


getOffset : Config -> List (List ( Float, Float )) -> List (List ( Float, Float ))
getOffset config =
    case fromConfig config |> .layout of
        Stacked direction ->
            case direction of
                Diverging ->
                    Shape.stackOffsetDiverging

                NoDirection ->
                    Shape.stackOffsetNone

        Grouped _ ->
            Shape.stackOffsetNone


symbolSpace : Orientation -> BandScale String -> List (Symbol String) -> Float
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
                    localDimension / conf.height
            in
            scalingFactor * conf.width

        Vertical ->
            let
                scalingFactor =
                    localDimension / conf.width
            in
            scalingFactor * conf.height



-- DATA METHODS


externalToDataBand : ExternalData data -> AccessorBand data -> DataBand
externalToDataBand externalData accessor =
    let
        data =
            fromExternalData externalData
    in
    data
        |> List.Extra.groupWhile
            (\a b -> accessor.xGroup a == accessor.xGroup b)
        |> List.map
            (\d ->
                let
                    groupLabel =
                        d
                            |> Tuple.first
                            |> accessor.xGroup
                            |> Just

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


externalToDataLinear : ExternalData data -> AccessorLinear data -> DataLinear
externalToDataLinear externalData accessor =
    let
        data =
            fromExternalData externalData
    in
    data
        |> List.Extra.groupWhile
            (\a b -> accessor.xGroup a == accessor.xGroup b)
        |> List.map
            (\d ->
                let
                    groupLabel =
                        d
                            |> Tuple.first
                            |> accessor.xGroup
                            |> Just

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


externalToDataTime : ExternalData data -> AccessorTime data -> DataTime
externalToDataTime externalData accessor =
    let
        data =
            fromExternalData externalData
    in
    data
        |> List.Extra.groupWhile
            (\a b -> accessor.xGroup a == accessor.xGroup b)
        |> List.map
            (\d ->
                let
                    groupLabel =
                        d
                            |> Tuple.first
                            |> accessor.xGroup
                            |> Just

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

module Chart.Internal.Type exposing
    ( AxisContinousDataTickCount(..)
    , AxisContinousDataTickFormat(..)
    , AxisContinousDataTicks(..)
    , AxisOrientation(..)
    , BandDomain
    , Config
    , ConfigStruct
    , Data(..)
    , DataGroupBand
    , DataGroupLinear
    , Direction(..)
    , DomainBand
    , DomainBandStruct
    , DomainLinear
    , DomainLinearStruct
    , GroupedConfig
    , GroupedConfigStruct
    , Layout(..)
    , LinearDomain
    , Margin
    , Orientation(..)
    , PointBand
    , PointLinear
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
    , fromConfig
    , fromDataBand
    , fromDataLinear
    , fromDomainBand
    , fromDomainLinear
    , getAxisContinousDataFormatter
    , getAxisContinousDataTickCount
    , getAxisContinousDataTickFormat
    , getAxisContinousDataTicks
    , getAxisHorizontalTickCount
    , getAxisHorizontalTickFormat
    , getAxisHorizontalTicks
    , getAxisVerticalTickCount
    , getAxisVerticalTickFormat
    , getAxisVerticalTicks
    , getBandGroupRange
    , getBandSingleRange
    , getDataDepth
    , getDesc
    , getDomainBand
    , getDomainBandFromData
    , getDomainLinear
    , getDomainLinearFromData
    , getHeight
    , getIcons
    , getIconsFromLayout
    , getLinearRange
    , getMargin
    , getOffset
    , getShowIndividualLabels
    , getTitle
    , getWidth
    , leftGap
    , role
    , setAxisContinousDataTickCount
    , setAxisContinousDataTickFormat
    , setAxisContinousDataTicks
    , setAxisHorizontalTickCount
    , setAxisHorizontalTickFormat
    , setAxisHorizontalTicks
    , setAxisVerticalTickCount
    , setAxisVerticalTickFormat
    , setAxisVerticalTicks
    , setDesc
    , setDimensions
    , setDomainBand
    , setDomainBandBandGroup
    , setDomainBandBandSingle
    , setDomainBandLinear
    , setDomainLinear
    , setHeight
    , setIcons
    , setLayout
    , setMargin
    , setOrientation
    , setShowContinousAxis
    , setShowHorizontalAxis
    , setShowIndividualLabels
    , setShowOrdinalAxis
    , setShowVerticalAxis
    , setTitle
    , setWidth
    , showIcons
    , showIconsFromLayout
    , symbolCustomSpace
    , symbolSpace
    , toConfig
    )

import Chart.Internal.Symbol as Symbol exposing (Symbol(..), symbolGap)
import Html
import Html.Attributes
import Scale exposing (BandScale)
import Shape



--ideas on axis: https://codepen.io/deciob/pen/GRgrXgR


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


type DomainBand
    = DomainBand DomainBandStruct


type DomainLinear
    = DomainLinear DomainLinearStruct


type alias PointBand =
    ( String, Float )


type alias PointLinear =
    ( Float, Float )


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


type Data
    = DataBand (List DataGroupBand)
    | DataLinear (List DataGroupLinear)


type alias Margin =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


type AxisContinousDataTicks
    = DefaultTicks
    | CustomTicks (List Float)


type AxisContinousDataTickCount
    = DefaultTickCount
    | CustomTickCount Int


type AxisContinousDataTickFormat
    = DefaultTickFormat
    | CustomTickFormat (Float -> String)


type alias ConfigStruct =
    { axisContinousDataTickCount : AxisContinousDataTickCount
    , axisContinousDataTickFormat : AxisContinousDataTickFormat
    , axisContinousDataTicks : AxisContinousDataTicks
    , axisHorizontalTickCount : AxisContinousDataTickCount
    , axisHorizontalTickFormat : AxisContinousDataTickFormat
    , axisHorizontalTicks : AxisContinousDataTicks
    , axisVerticalTickCount : AxisContinousDataTickCount
    , axisVerticalTickFormat : AxisContinousDataTickFormat
    , axisVerticalTicks : AxisContinousDataTicks
    , desc : String
    , domainBand : DomainBand
    , domainLinear : DomainLinear
    , height : Float
    , layout : Layout
    , margin : Margin
    , orientation : Orientation
    , showContinousAxis : Bool
    , showHorizontalAxis : Bool
    , showOrdinalAxis : Bool
    , showVerticalAxis : Bool
    , title : String
    , width : Float
    }


defaultConfig : Config
defaultConfig =
    toConfig
        { axisContinousDataTickCount = DefaultTickCount
        , axisContinousDataTickFormat = DefaultTickFormat
        , axisContinousDataTicks = DefaultTicks
        , axisHorizontalTickCount = DefaultTickCount
        , axisHorizontalTickFormat = DefaultTickFormat
        , axisHorizontalTicks = DefaultTicks
        , axisVerticalTickCount = DefaultTickCount
        , axisVerticalTickFormat = DefaultTickFormat
        , axisVerticalTicks = DefaultTicks
        , desc = ""
        , domainBand = DomainBand initialDomainBandStruct
        , domainLinear = DomainLinear initialDomainLinearStruct
        , height = defaultHeight
        , layout = defaultLayout
        , margin = defaultMargin
        , orientation = defaultOrientation
        , showContinousAxis = True
        , showHorizontalAxis = True
        , showOrdinalAxis = True
        , showVerticalAxis = True
        , title = ""
        , width = defaultWidth
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
    List { rawValue : Float, stackedValue : ( Float, Float ) }


type alias StackedValuesAndGroupes =
    ( List StackedValues, List String )



-- SETTERS


setAxisContinousDataTickCount : AxisContinousDataTickCount -> Config -> Config
setAxisContinousDataTickCount count config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisContinousDataTickCount = count }


setAxisHorizontalTickCount : AxisContinousDataTickCount -> Config -> Config
setAxisHorizontalTickCount count config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisHorizontalTickCount = count }


setAxisVerticalTickCount : AxisContinousDataTickCount -> Config -> Config
setAxisVerticalTickCount count config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisVerticalTickCount = count }


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


setAxisContinousDataTickFormat : AxisContinousDataTickFormat -> Config -> Config
setAxisContinousDataTickFormat format config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisContinousDataTickFormat = format }


setAxisHorizontalTickFormat : AxisContinousDataTickFormat -> Config -> Config
setAxisHorizontalTickFormat format config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisHorizontalTickFormat = format }


setAxisVerticalTickFormat : AxisContinousDataTickFormat -> Config -> Config
setAxisVerticalTickFormat format config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisVerticalTickFormat = format }


setAxisContinousDataTicks : AxisContinousDataTicks -> Config -> Config
setAxisContinousDataTicks ticks config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisContinousDataTicks = ticks }


setAxisHorizontalTicks : AxisContinousDataTicks -> Config -> Config
setAxisHorizontalTicks ticks config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisHorizontalTicks = ticks }


setAxisVerticalTicks : AxisContinousDataTicks -> Config -> Config
setAxisVerticalTicks ticks config =
    let
        c =
            fromConfig config
    in
    toConfig { c | axisVerticalTicks = ticks }


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


setShowContinousAxis : Bool -> Config -> Config
setShowContinousAxis bool config =
    let
        c =
            fromConfig config
    in
    toConfig { c | showContinousAxis = bool }


setShowOrdinalAxis : Bool -> Config -> Config
setShowOrdinalAxis bool config =
    let
        c =
            fromConfig config
    in
    toConfig { c | showOrdinalAxis = bool }


setShowHorizontalAxis : Bool -> Config -> Config
setShowHorizontalAxis bool config =
    let
        c =
            fromConfig config
    in
    toConfig { c | showHorizontalAxis = bool }


setShowVerticalAxis : Bool -> Config -> Config
setShowVerticalAxis bool config =
    let
        c =
            fromConfig config
    in
    toConfig { c | showVerticalAxis = bool }



-- GETTERS


getAxisContinousDataTickCount : Config -> AxisContinousDataTickCount
getAxisContinousDataTickCount config =
    fromConfig config |> .axisContinousDataTickCount


getAxisHorizontalTickCount : Config -> AxisContinousDataTickCount
getAxisHorizontalTickCount config =
    fromConfig config |> .axisHorizontalTickCount


getAxisVerticalTickCount : Config -> AxisContinousDataTickCount
getAxisVerticalTickCount config =
    fromConfig config |> .axisVerticalTickCount


getAxisContinousDataTickFormat : Config -> AxisContinousDataTickFormat
getAxisContinousDataTickFormat config =
    fromConfig config |> .axisContinousDataTickFormat


getAxisHorizontalTickFormat : Config -> AxisContinousDataTickFormat
getAxisHorizontalTickFormat config =
    fromConfig config |> .axisHorizontalTickFormat


getAxisVerticalTickFormat : Config -> AxisContinousDataTickFormat
getAxisVerticalTickFormat config =
    fromConfig config |> .axisVerticalTickFormat


getAxisContinousDataTicks : Config -> AxisContinousDataTicks
getAxisContinousDataTicks config =
    fromConfig config |> .axisContinousDataTicks


getAxisVerticalTicks : Config -> AxisContinousDataTicks
getAxisVerticalTicks config =
    fromConfig config |> .axisVerticalTicks


getAxisHorizontalTicks : Config -> AxisContinousDataTicks
getAxisHorizontalTicks config =
    fromConfig config |> .axisHorizontalTicks


getAxisContinousDataFormatter : AxisContinousDataTickFormat -> (Float -> String)
getAxisContinousDataFormatter format =
    case format of
        DefaultTickFormat ->
            \f -> String.fromFloat f

        CustomTickFormat formatter ->
            formatter


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


getDomainBandFromData : Data -> Config -> DomainBandStruct
getDomainBandFromData data config =
    let
        domain =
            getDomainBand config
    in
    case data of
        DataBand d ->
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

        _ ->
            --TODO: should data be saparated, like domain?
            domain


getDomainLinearFromData : Data -> Config -> DomainLinearStruct
getDomainLinearFromData data config =
    let
        domain =
            getDomainLinear config
    in
    case data of
        DataLinear d ->
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

        _ ->
            --TODO: should data be saparated, like domain?
            domain


fromDomainBand : DomainBand -> DomainBandStruct
fromDomainBand (DomainBand d) =
    d


fromDomainLinear : DomainLinear -> DomainLinearStruct
fromDomainLinear (DomainLinear d) =
    d


fromDataBand : Data -> List DataGroupBand
fromDataBand data =
    case data of
        DataBand d ->
            d

        _ ->
            [ dummyDataGroupBand ]


fromDataLinear : Data -> List DataGroupLinear
fromDataLinear data =
    case data of
        DataLinear d ->
            d

        _ ->
            [ dummyDataGroupLinear ]


getDataDepth : Data -> Int
getDataDepth data =
    data
        |> fromDataBand
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

module Chart.Type exposing
    ( AxisOrientation(..)
    , Config
    , ConfigStruct
    , ContinousDataTickCount(..)
    , ContinousDataTickFormat(..)
    , ContinousDataTicks(..)
    , Data(..)
    , DataGroupBand
    , DataGroupLinear
    , Direction(..)
    , Domain(..)
    , GroupedConfig
    , GroupedConfigStruct
    , Layout(..)
    , Margin
    , Orientation(..)
    , PointBand
    , PointLinear
    , RenderContext(..)
    , adjustLinearRange
    , ariaLabelledby
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
    , getBandGroupRange
    , getBandSingleRange
    , getContinousDataTickCount
    , getContinousDataTickFormat
    , getContinousDataTicks
    , getDataDepth
    , getDesc
    , getDomain
    , getDomainFromData
    , getHeight
    , getIcons
    , getIconsFromLayout
    , getLinearRange
    , getMargin
    , getOffset
    , getTitle
    , getWidth
    , role
    , setContinousDataTickCount
    , setContinousDataTickFormat
    , setContinousDataTicks
    , setDesc
    , setDimensions
    , setDomain
    , setHeight
    , setIcons
    , setLayout
    , setMargin
    , setOrientation
    , setShowColumnLabels
    , setShowContinousAxis
    , setShowOrdinalAxis
    , setTitle
    , setWidth
    , showIcons
    , showIconsFromLayout
    , symbolCustomSpace
    , symbolSpace
    , toConfig
    )

import Chart.Symbol exposing (Symbol(..), symbolGap)
import Html
import Html.Attributes
import Scale exposing (BandScale)
import Set
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
    { bandGroup : BandDomain
    , bandSingle : BandDomain
    , linear : LinearDomain
    }


dummyDomainBandStruct : DomainBandStruct
dummyDomainBandStruct =
    { bandGroup = []
    , bandSingle = []
    , linear = ( 0, 0 )
    }


type alias DomainLinearStruct =
    { horizontal : LinearDomain
    , vertical : LinearDomain
    }


dummyDomainLinearStruct : DomainLinearStruct
dummyDomainLinearStruct =
    { horizontal = ( 0, 0 )
    , vertical = ( 0, 0 )
    }


type Domain
    = DomainBand DomainBandStruct
    | DomainLinear DomainLinearStruct


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


type alias Range =
    ( Float, Float )


type alias Margin =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


defaultTicksCount : Int
defaultTicksCount =
    10


type ContinousDataTicks
    = DefaultTicks
    | CustomTicks (List Float)


type ContinousDataTickCount
    = DefaultTickCount
    | CustomTickCount Int


type ContinousDataTickFormat
    = DefaultTickFormat
    | CustomTickFormat (Float -> String)


type alias ConfigStruct =
    { continousDataTickCount : ContinousDataTickCount
    , continousDataTickFormat : ContinousDataTickFormat
    , continousDataTicks : ContinousDataTicks
    , desc : String
    , domain : Domain
    , height : Float
    , layout : Layout
    , margin : Margin
    , orientation : Orientation
    , showColumnLabels : Bool
    , showContinousAxis : Bool
    , showOrdinalAxis : Bool
    , title : String
    , width : Float
    }


defaultConfig : Config
defaultConfig =
    toConfig
        { continousDataTickCount = DefaultTickCount
        , continousDataTickFormat = DefaultTickFormat
        , continousDataTicks = DefaultTicks
        , desc = ""
        , domain = DomainBand { bandGroup = [], bandSingle = [], linear = ( 0, 0 ) }
        , height = defaultHeight
        , layout = defaultLayout
        , margin = defaultMargin
        , orientation = defaultOrientation
        , showColumnLabels = False
        , showContinousAxis = True
        , showOrdinalAxis = True
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



-- GROUPED CONFIG


type GroupedConfig
    = GroupedConfig GroupedConfigStruct


type alias GroupedConfigStruct =
    { icons : List (Symbol String)
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



-- SETTERS


setContinousDataTickCount : ContinousDataTickCount -> ( Data, Config ) -> ( Data, Config )
setContinousDataTickCount count ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | continousDataTickCount = count } )


setDesc : String -> ( Data, Config ) -> ( Data, Config )
setDesc desc ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | desc = desc } )


setTitle : String -> ( Data, Config ) -> ( Data, Config )
setTitle title ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | title = title } )


setContinousDataTickFormat : ContinousDataTickFormat -> ( Data, Config ) -> ( Data, Config )
setContinousDataTickFormat format ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | continousDataTickFormat = format } )


setContinousDataTicks : ContinousDataTicks -> ( Data, Config ) -> ( Data, Config )
setContinousDataTicks ticks ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | continousDataTicks = ticks } )


setHeight : Float -> ( Data, Config ) -> ( Data, Config )
setHeight height ( data, config ) =
    let
        c =
            fromConfig config

        m =
            c.margin
    in
    ( data, toConfig { c | height = height - m.top - m.bottom } )


setLayout : Layout -> ( Data, Config ) -> ( Data, Config )
setLayout layout ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | layout = layout } )


setOrientation : Orientation -> ( Data, Config ) -> ( Data, Config )
setOrientation orientation ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | orientation = orientation } )


setWidth : Float -> ( Data, Config ) -> ( Data, Config )
setWidth width ( data, config ) =
    let
        c =
            fromConfig config

        m =
            c.margin
    in
    ( data, toConfig { c | width = width - m.left - m.right } )


setMargin : Margin -> ( Data, Config ) -> ( Data, Config )
setMargin margin ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | margin = margin } )


setDimensions : { margin : Margin, width : Float, height : Float } -> ( Data, Config ) -> ( Data, Config )
setDimensions { margin, width, height } ( data, config ) =
    let
        c =
            fromConfig config

        m =
            margin
    in
    ( data
    , toConfig
        { c
            | width = width - m.left - m.right
            , height = height - m.top - m.bottom
            , margin = margin
        }
    )


setDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setDomain domain ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | domain = domain } )


setShowColumnLabels : Bool -> ( Data, Config ) -> ( Data, Config )
setShowColumnLabels bool ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | showColumnLabels = bool } )


setShowContinousAxis : Bool -> ( Data, Config ) -> ( Data, Config )
setShowContinousAxis bool ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | showContinousAxis = bool } )


setShowOrdinalAxis : Bool -> ( Data, Config ) -> ( Data, Config )
setShowOrdinalAxis bool ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | showOrdinalAxis = bool } )



-- GETTERS


getContinousDataTickCount : Config -> ContinousDataTickCount
getContinousDataTickCount config =
    fromConfig config |> .continousDataTickCount


getDesc : Config -> String
getDesc config =
    fromConfig config |> .desc


getTitle : Config -> String
getTitle config =
    fromConfig config |> .title


getContinousDataTickFormat : Config -> ContinousDataTickFormat
getContinousDataTickFormat config =
    fromConfig config |> .continousDataTickFormat


getContinousDataTicks : Config -> ContinousDataTicks
getContinousDataTicks config =
    fromConfig config |> .continousDataTicks


getMargin : Config -> Margin
getMargin config =
    fromConfig config |> .margin


getHeight : Config -> Float
getHeight config =
    fromConfig config |> .height


getWidth : Config -> Float
getWidth config =
    fromConfig config |> .width


getDomain : Config -> Domain
getDomain config =
    fromConfig config |> .domain


getDomainFromData : Data -> Domain
getDomainFromData data =
    case data of
        DataBand d ->
            DomainBand
                { bandGroup =
                    d
                        |> List.map .groupLabel
                        |> List.indexedMap (\i g -> g |> Maybe.withDefault (String.fromInt i))
                , bandSingle =
                    d
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.first
                        |> Set.fromList
                        |> Set.toList
                , linear =
                    d
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.second
                        |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                }

        DataLinear d ->
            DomainLinear
                { horizontal =
                    d
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.first
                        |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                , vertical =
                    d
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.second
                        |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                }


fromDomainBand : Domain -> DomainBandStruct
fromDomainBand domain =
    case domain of
        DomainBand d ->
            d

        _ ->
            dummyDomainBandStruct


fromDomainLinear : Domain -> DomainLinearStruct
fromDomainLinear domain =
    case domain of
        DomainLinear d ->
            d

        _ ->
            dummyDomainLinearStruct


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


symbolCustomSpace : Orientation -> Float -> Chart.Symbol.CustomSymbolConf -> Float
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

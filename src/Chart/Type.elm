module Chart.Type exposing
    ( Axis(..)
    , Config
    , Data(..)
    , DataGroupBand
    , Direction(..)
    , Domain(..)
    , Layout(..)
    , Margin
    , Orientation(..)
    , PointBand
    , adjustLinearRange
    , defaultConfig
    , defaultHeight
    , defaultLayout
    , defaultMargin
    , defaultOrientation
    , defaultWidth
    , fromConfig
    , fromDataBand
    , fromDomainBand
    , getBandGroupRange
    , getBandSingleRange
    , getDataDepth
    , getDomain
    , getDomainFromData
    , getHeight
    , getLinearRange
    , getMargin
    , getOffset
    , getWidth
    , setDimensions
    , setDomain
    , setHeight
    , setLayout
    , setMargin
    , setOrientation
    , setShowColumnLabels
    , setWidth
    , toConfig
    )

import Set
import Shape exposing (StackConfig, StackResult)


type Orientation
    = Vertical
    | Horizontal


type Layout
    = Stacked Direction
    | Grouped


type Direction
    = Diverging
    | NoDirection


type Axis
    = X
    | Y


type alias LinearDomain =
    ( Float, Float )


type alias BandDomain =
    List String


type alias DomainBandStruct =
    { bandGroup : BandDomain, bandSingle : BandDomain, linear : LinearDomain }


type Domain
    = DomainBand DomainBandStruct


type alias PointBand =
    ( String, Float )


type alias DataGroupBand =
    { groupLabel : Maybe String, points : List PointBand }


type Data
    = DataBand (List DataGroupBand)


type alias Range =
    ( Float, Float )


type alias Margin =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


type alias ConfigStruct =
    { domain : Domain
    , height : Float
    , layout : Layout
    , margin : Margin
    , orientation : Orientation
    , showColumnLabels : Bool
    , width : Float
    }


defaultConfig : Config
defaultConfig =
    toConfig
        { domain = DomainBand { bandGroup = [], bandSingle = [], linear = ( 0, 0 ) }
        , height = defaultHeight
        , layout = defaultLayout
        , margin = defaultMargin
        , orientation = defaultOrientation
        , showColumnLabels = False
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



-- DEFAULTS


defaultLayout : Layout
defaultLayout =
    Grouped


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



-- SETTERS


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



-- GETTERS


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


fromDomainBand : Domain -> DomainBandStruct
fromDomainBand domain =
    case domain of
        DomainBand d ->
            d


fromDataBand : Data -> List DataGroupBand
fromDataBand data =
    case data of
        DataBand d ->
            d


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


getLinearRange : Config -> Float -> Float -> ( Float, Float )
getLinearRange config width height =
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
                Grouped ->
                    ( 0, width )

                Stacked _ ->
                    ( width, 0 )

        Vertical ->
            ( height, 0 )


adjustLinearRange : Config -> Int -> ( Float, Float ) -> ( Float, Float )
adjustLinearRange config stackedDepth ( a, b ) =
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
                Grouped ->
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

        Grouped ->
            Shape.stackOffsetNone

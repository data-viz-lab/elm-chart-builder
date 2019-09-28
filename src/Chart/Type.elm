module Chart.Type exposing
    ( Axis(..)
    , Config
    , Data(..)
    , DataGroupBand
    , Direction
    , Domain(..)
    , Layout(..)
    , Margin
    , Orientation(..)
    , PointBand
    , defaultConfig
    , defaultHeight
    , defaultLayout
    , defaultMargin
    , defaultOrientation
    , defaultWidth
    , fromConfig
    , fromDataBand
    , fromDomainBand
    , fromMargin
    , getDomain
    , getDomainFromData
    , getHeight
    , getMargin
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
    , toMargin
    )

import Set


type Orientation
    = Vertical
    | Horizontal
    | NoOrientation


type Layout
    = Stacked
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


type alias DomainBandStructure =
    { x0 : BandDomain, x1 : BandDomain, y : LinearDomain }


type Domain
    = DomainBand DomainBandStructure


type alias PointBand =
    ( String, Float )


type alias DataGroupBand =
    { groupLabel : Maybe String, points : List PointBand }


type Data
    = DataBand (List DataGroupBand)


type alias Range =
    ( Float, Float )


type alias MarginStructure =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


type Margin
    = Margin MarginStructure


toMargin : MarginStructure -> Margin
toMargin margin =
    Margin margin


fromMargin : Margin -> MarginStructure
fromMargin (Margin margin) =
    margin


type alias ConfigStructure =
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
        { domain = DomainBand { x0 = [], x1 = [], y = ( 0, 0 ) }
        , height = defaultHeight
        , layout = defaultLayout
        , margin = defaultMargin
        , orientation = defaultOrientation
        , showColumnLabels = False
        , width = defaultWidth
        }


type Config
    = Config ConfigStructure


toConfig : ConfigStructure -> Config
toConfig config =
    Config config


fromConfig : Config -> ConfigStructure
fromConfig (Config config) =
    config



-- DEFAULTS


defaultLayout : Layout
defaultLayout =
    Grouped


defaultOrientation : Orientation
defaultOrientation =
    Horizontal


defaultWidth : Float
defaultWidth =
    600


defaultHeight : Float
defaultHeight =
    400


defaultMargin : Margin
defaultMargin =
    Margin
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
            c.margin |> fromMargin
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
            c.margin |> fromMargin
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
            margin |> fromMargin
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


getMargin : Config -> MarginStructure
getMargin config =
    fromConfig config |> .margin |> fromMargin


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
                { x0 =
                    d
                        |> List.map .groupLabel
                        |> List.indexedMap (\i g -> g |> Maybe.withDefault (String.fromInt i))
                , x1 =
                    d
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.first
                        |> Set.fromList
                        |> Set.toList
                , y =
                    d
                        |> List.map .points
                        |> List.concat
                        |> List.map Tuple.second
                        |> (\dd -> ( 0, List.maximum dd |> Maybe.withDefault 0 ))
                }


fromDomainBand : Domain -> DomainBandStructure
fromDomainBand domain =
    case domain of
        DomainBand d ->
            d


fromDataBand : Data -> List DataGroupBand
fromDataBand data =
    case data of
        DataBand d ->
            d

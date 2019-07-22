module Chart.Type exposing
    ( Axis(..)
    , Config
    , Data(..)
    , DataGroupBL
    , DataGroupLL
    , Direction
    , Domain(..)
    , Layout(..)
    , Margin
    , Orientation(..)
    , PointBL
    , PointLL
    , defaultHeight
    , defaultLayout
    , defaultMargin
    , defaultOrientation
    , defaultWidth
    , fromConfig
    , fromDomainBand
    , fromDomainLinear
    , fromMargin
    , getDomain
    , getDomainFromData
    , getDomainX1
    , getHeight
    , getMargin
    , getWidth
    , setHeight
    , setLayout
    , setMargin
    , setOrientation
    , setWidth
    , setXDomain
    , setYDomain
    , toConfig
    , toMargin
    )

import Time exposing (Posix)


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


type Domain
    = DomainLinear LinearDomain
    | DomainBand ( BandDomain, BandDomain )
    | DomainTime TimeDomain
    | NoDomain


type alias PointLL =
    ( Float, Float )


type alias PointBL =
    ( String, Float )


type alias DataGroupLL =
    { groupLabel : Maybe String, points : List PointLL }


type alias DataGroupBL =
    { groupLabel : Maybe String, points : List PointBL }


type Data
    = DataLL (List DataGroupLL)
    | DataBL (List DataGroupBL)


type alias LinearDomain =
    ( Float, Float )


type alias BandDomain =
    List String


type alias TimeDomain =
    ( Posix, Posix )


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
    { height : Float
    , layout : Layout
    , margin : Margin
    , orientation : Orientation
    , width : Float
    , xDomain0 : Domain
    , xDomain1 : Domain
    , yDomain : Domain
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
    NoOrientation


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


setXDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setXDomain domain ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | xDomain0 = domain } )


setYDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setYDomain domain ( data, config ) =
    let
        c =
            fromConfig config
    in
    ( data, toConfig { c | yDomain = domain } )



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


getDomain : Axis -> Config -> Domain
getDomain axis config =
    case axis of
        X ->
            fromConfig config |> .xDomain0

        Y ->
            fromConfig config |> .yDomain


getDomainX1 : Config -> Domain
getDomainX1 config =
    fromConfig config |> .xDomain1


getLinearDomain : Maybe LinearDomain -> List Float -> LinearDomain
getLinearDomain domain data =
    case domain of
        Nothing ->
            ( data
                |> List.minimum
                |> Maybe.withDefault 0
            , data
                |> List.maximum
                |> Maybe.withDefault 0
            )

        Just linearDomain ->
            linearDomain


getBandDomain : Maybe BandDomain -> List DataGroupBL -> BandDomain
getBandDomain domain data =
    case domain of
        Nothing ->
            data
                |> List.map .groupLabel
                |> List.indexedMap
                    (\idx g ->
                        g |> Maybe.withDefault (String.fromInt idx)
                    )

        Just bandDomain ->
            bandDomain


getDomainFromData : Axis -> Data -> Domain
getDomainFromData axis data =
    case ( axis, data ) of
        ( X, DataLL d ) ->
            d
                |> List.map .points
                |> List.concat
                |> List.map Tuple.first
                |> getLinearDomain Nothing
                |> DomainLinear

        ( X, DataBL d ) ->
            d
                |> getBandDomain Nothing
                |> DomainBand

        ( Y, DataLL d ) ->
            d
                |> List.map .points
                |> List.concat
                |> List.map Tuple.second
                |> getLinearDomain Nothing
                |> DomainLinear

        ( Y, DataBL d ) ->
            d
                |> List.map .points
                |> List.concat
                |> List.map Tuple.second
                |> getLinearDomain Nothing
                |> DomainLinear


fromDomainBand : Domain -> BandDomain
fromDomainBand domain =
    case domain of
        DomainBand bandDomain ->
            bandDomain

        _ ->
            []


fromDomainLinear : Domain -> LinearDomain
fromDomainLinear domain =
    case domain of
        DomainLinear linearDomain ->
            linearDomain

        _ ->
            ( 0, 0 )

module Chart.Type exposing
    ( Axis(..)
    , Config
    , Data
    , DataGroup
    , Datum
    , Direction
    , Domain(..)
    , Layout(..)
    , Margin
    , Orientation(..)
    , Point(..)
    , defaultHeight
    , defaultLayout
    , defaultMargin
    , defaultOrientation
    , defaultWidth
    , fromConfig
    , fromDomainBand
    , fromDomainLinear
    , fromMargin
    , getDataPointStructure
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


type Point
    = PointLinear ( Float, Float )
    | PointBand ( String, Float )
    | PointTime ( Posix, Float )
    | NoPoint


type Domain
    = DomainLinear LinearDomain
    | DomainBand BandDomain
    | DomainTime TimeDomain
    | NoDomain


type alias Datum =
    { point : Point
    }


type alias DataGroup =
    { groupLabel : Maybe String, points : List Datum }


type alias Data =
    List DataGroup


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


getTimeDomain : Maybe TimeDomain -> List Posix -> TimeDomain
getTimeDomain domain data =
    case domain of
        Nothing ->
            ( data
                |> List.map Time.posixToMillis
                |> List.minimum
                |> Maybe.withDefault 0
                |> Time.millisToPosix
            , data
                |> List.map Time.posixToMillis
                |> List.maximum
                |> Maybe.withDefault 0
                |> Time.millisToPosix
            )

        Just timeDomain ->
            timeDomain


getBandDomain : Maybe BandDomain -> Data -> BandDomain
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
    let
        concatData =
            data
                |> List.map .points
                |> List.concat
                |> List.map .point

        point =
            concatData
                |> List.head
    in
    case point of
        Nothing ->
            NoDomain

        Just (PointLinear _) ->
            concatData
                |> List.map
                    (\p ->
                        case p of
                            PointLinear ( x, y ) ->
                                case axis of
                                    X ->
                                        x

                                    Y ->
                                        y

                            _ ->
                                0
                    )
                |> getLinearDomain Nothing
                |> DomainLinear

        Just (PointBand _) ->
            data
                |> getBandDomain Nothing
                |> DomainBand

        Just (PointTime _) ->
            concatData
                |> List.map
                    (\p ->
                        case p of
                            PointTime ( x, _ ) ->
                                x

                            _ ->
                                Time.millisToPosix 0
                    )
                |> getTimeDomain Nothing
                |> DomainTime

        Just NoPoint ->
            NoDomain


getDataPointStructure : List DataGroup -> Point
getDataPointStructure data =
    data
        |> List.head
        |> Maybe.map .points
        |> Maybe.andThen List.head
        |> Maybe.map .point
        |> Maybe.withDefault NoPoint


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

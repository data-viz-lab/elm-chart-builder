module Chart.Types exposing
    ( Direction
    , Layout
    , Orientation
    )

import Time exposing (Posix)


type Orientation
    = Vertical
    | Horizontal


type Layout
    = Stacked
    | Grouped


type Direction
    = Diverging
    | None


type Point
    = PointLinear ( Float, Float )
    | PointBand ( String, Float )
    | PointTime ( Posix, Float )
    | NoPoint


type alias Datum =
    { point : Point
    }


type alias Data =
    List (List Datum)


type alias LinearDomain =
    ( Float, Float )


type alias BandDomain =
    List String


type alias TimeDomain =
    ( Posix, Posix )


type alias Range =
    ( Float, Float )


type alias Margin =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


type alias ConfigStructure =
    { height : Maybe Float
    , layout : Maybe Layout
    , margin : Maybe Margin
    , orientation : Maybe Orientation
    , width : Maybe Float
    }


type Config
    = Config ConfigStructure


toConfig : ConfigStructure -> Config
toConfig config =
    Config config


fromConfig : Config -> ConfigStructure
fromConfig (Config config) =
    config

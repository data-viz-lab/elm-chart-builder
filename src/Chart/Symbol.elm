module Chart.Symbol exposing
    ( withIdentifier
    , Symbol, circle, corner, custom, triangle, withGap, withSize, withStyle
    )

{-| Bar chart symbol type

@docs BarSymbol, symbolCircle, symbolCorner, symbolCustom, symbolTriangle, withHeight, withIdentifier, withPaths, withUseGap, withWidth

-}

--SYMBOLS

import Chart.Internal.Symbol as InternalSymbol exposing (Symbol(..))


type alias Symbol =
    InternalSymbol.Symbol


type alias RequiredCustomConfig =
    { viewBoxDimensions : ( Float, Float )
    , paths : List String
    }


{-| A custom bar chart symbol type
-}
custom : RequiredCustomConfig -> Symbol
custom c =
    let
        conf =
            InternalSymbol.initialCustomConf
    in
    { conf
        | viewBoxWidth = c.viewBoxDimensions |> Tuple.first
        , viewBoxHeight = c.viewBoxDimensions |> Tuple.second
        , paths = c.paths
    }
        |> Custom


{-| Circle symbol type
-}
circle : Symbol
circle =
    Circle InternalSymbol.initialConf


{-| Triangle symbol type
-}
triangle : Symbol
triangle =
    Triangle InternalSymbol.initialConf


{-| Corner symbol type
-}
corner : Symbol
corner =
    Corner InternalSymbol.initialConf



-- CONFIGURTION


{-| Set the custom symbol identifier
-}
withIdentifier : String -> Symbol -> Symbol
withIdentifier identifier symbol =
    case symbol of
        Custom conf ->
            Custom { conf | identifier = identifier }

        Circle conf ->
            Circle { conf | identifier = identifier }

        Corner conf ->
            Corner { conf | identifier = identifier }

        Triangle conf ->
            Triangle { conf | identifier = identifier }

        _ ->
            symbol


{-| Set the custom symbol height
When using a custom svg icon this is the 4th argument of its viewBox attribute
-}
withSize : Float -> Symbol -> Symbol
withSize size symbol =
    case symbol of
        Custom conf ->
            Custom conf

        Circle conf ->
            Circle { conf | size = Just size }

        Corner conf ->
            Corner { conf | size = Just size }

        Triangle conf ->
            Triangle { conf | size = Just size }

        _ ->
            symbol


{-| Set the custom symbol height
When using a custom svg icon this is the 4th argument of its viewBox attribute
-}
withStyle : List ( String, String ) -> Symbol -> Symbol
withStyle style symbol =
    case symbol of
        Custom conf ->
            Custom { conf | styles = style }

        Circle conf ->
            Circle { conf | styles = style }

        Corner conf ->
            Corner { conf | styles = style }

        Triangle conf ->
            Triangle { conf | styles = style }

        _ ->
            symbol


{-| Set the useGap boolean flag.

All bar chart icons are drawn with a gap from the bar rectangles,
but, depending on the custom icon shape and on the orientation of the chart,
the icon could already have a gap and we do not want to add other space.

-}
withGap : Bool -> Symbol -> Symbol
withGap bool symbol =
    case symbol of
        Custom conf ->
            Custom { conf | useGap = bool }

        _ ->
            symbol

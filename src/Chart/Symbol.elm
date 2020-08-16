module Chart.Symbol exposing
    ( Symbol
    , circle, corner, custom, triangle
    , withGap, withIdentifier, withSize, withStyle
    )

{-| Symbols can be added to charts to improve understanding and accessibility.
Currently stacked bar charts do not support symbols.


# Symbols

@docs Symbol
@docs circle, corner, custom, triangle


# Customisation

@docs withGap, withIdentifier, withSize, withStyle

-}

--SYMBOLS

import Chart.Internal.Symbol as InternalSymbol exposing (Symbol(..))


{-| The Symbol type
-}
type alias Symbol =
    InternalSymbol.Symbol


type alias RequiredCustomConfig =
    { viewBoxDimensions : ( Float, Float )
    , paths : List String
    }


{-| A custom symbol type
It requires a config where viewBoxDimensions is a tuple with viewBox width and height and paths is a list of strings for the d attribute of an svg path element. These values are usually copied from the 3rd and 4th arguments of the viewBox attribute on the svg icon.

    symbol :
        { viewBoxDimensions : ( Float, Float )
        , paths : List String
        }
        -> Symbol
    symbol =
        Symbol.custom
            { viewBoxDimensions = ( 640, 512 )
            , paths = [ bicycleSymbol ]
            }

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


{-| A circle symbol type

    symbol : Symbol
    symbol =
        Symbol.circle

-}
circle : Symbol
circle =
    Circle InternalSymbol.initialConf


{-| A triangle symbol type

    symbol : Symbol
    symbol =
        Symbol.triangle

-}
triangle : Symbol
triangle =
    Triangle InternalSymbol.initialConf


{-| A corner symbol type

    symbol : Symbol
    symbol =
        Symbol.corner

-}
corner : Symbol
corner =
    Corner InternalSymbol.initialConf



-- CUSTOMISATION


{-| Sets the symbol identifier used in the [xlink:href](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/xlink:href)
It can be omitted if the page has only one chart.

    symbol : String -> Symbol -> Symbol
    symbol =
        Symbol.triangle
            |> Symbol.withIdentifier "chart-a-triangle-symbol"

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


{-| Sets the size of the built-in symbols
It has no effect on custom symbols.

    symbol : Float -> Symbol -> Symbol
    symbol =
        Symbol.triangle
            |> Symbol.withSize

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


{-| Sets additional styles to symbol
The style precedence is: withStyle, withColor in the chart config, css rules.
So passing a color style here will override the chart and css color rules.
There is no compiler level validation here, any tuple of strings can be passed and if invalid will be ignored.

    symbol : List ( String, String ) -> Symbol -> Symbol
    symbol =
        Symbol.triangle
            |> Symbol.withStyle [ ( "fill", "none" ) ]

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


{-| Sets the useGap boolean flag. It defaults to True.
Only for custom symbols on bar charts, where icons are drawn with a gap from the bar rectangles.
Beware that, depending on the custom icon shape and on the orientation of the chart,
the icon could already have a gap and we do not want to add other space.

    symbol : Bool -> Symbol -> Symbol
    symbol =
        Symbol.triangle
            |> Symbol.withGap False

-}
withGap : Bool -> Symbol -> Symbol
withGap bool symbol =
    case symbol of
        Custom conf ->
            Custom { conf | useGap = bool }

        _ ->
            symbol

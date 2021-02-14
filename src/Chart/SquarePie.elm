module Chart.SquarePie exposing
    ( Accessor
    , Config
    , RequiredConfig
    , init
    , render
    , withColorPalette
    , withDesc
    , withTitle
    , withoutTable
    )

{-| This is the square pie chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).
-}

import Chart.Internal.SquarePie
    exposing
        ( renderPie
        )
import Chart.Internal.Type as Type
import Color exposing (Color)
import Html exposing (Html)


{-| The Config opaque type
-}
type alias Config =
    Type.Config


{-| The required config, passed as an argument to the `init` function
-}
type alias RequiredConfig =
    { width : Float }


{-| The data accessors
-}
type alias Accessor data =
    { xGroup : data -> Maybe String
    , xValue : data -> String
    , yValue : data -> Float
    }


{-| Initializes the square pie chart.

    data :
        List
            { groupLabel : String
            , x : String
            , y : Float
            }
    data =
        [ { groupLabel = "A"
          , x = "a"
          , y = 10
          }
        , { groupLabel = "B"
          , x = "a"
          , y = 11
          }
        ]

    accessor :
        Pie.Accessor
            { groupLabel : String
            , x : String
            , y : Float
            }
    accessor =
        Pie.Accessor .groupLabel .x .y

    Pie.init
        { width = 500
        }
        |> Pie.render ( data, accessor )

-}
init : RequiredConfig -> Config
init c =
    Type.defaultConfig
        |> Type.setDimensions
            { margin = { top = 0, right = 0, bottom = 0, left = 0 }
            , width = c.width
            , height = c.width
            }


{-| Renders the square pie chart, after initialisation and optional customisations.

    Pie.init requiredConfig
        |> Pie.render ( data, accessor )

-}
render : ( List data, Accessor data ) -> Config -> Html msg
render ( externalData, accessor ) config =
    let
        c =
            Type.fromConfig config

        data =
            Type.externalToDataBand (Type.toExternalData externalData) accessor
    in
    renderPie ( data, config )


{-| Sets the color palette for the chart.
If a palette with a single color is passed all bars will have the same colour.
If the bars in a group are more then the colours in the palette, the colours will be repeted.

    palette =
        Scale.Color.tableau10

    Pie.init requiredConfig
        |> Pie.withColorPalette palette
        |> Pie.render (data, accessor)

-}
withColorPalette : List Color -> Config -> Config
withColorPalette palette config =
    Type.setColorResource (Type.ColorPalette palette) config


{-| Do **not** build an alternative table content for accessibility

&#9888; By default an alternative table is always being rendered.
Use this option to not build the table.

    Pie.init requiredConfig
        |> Pie.withoutTable
        |> Pie.render ( data, accessor )

-}
withoutTable : Config -> Config
withoutTable =
    Type.setAccessibilityContent Type.AccessibilityNone


{-| Sets an accessible, long-text description for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Pie.init requiredConfig
        |> Pie.withDesc "This is an accessible chart, with a desc element"
        |> Pie.render ( data, accessor )

-}
withDesc : String -> Config -> Config
withDesc value config =
    Type.setSvgDesc value config


{-| Sets an accessible title for the whole svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Pie.init requiredConfig
        |> Pie.withTitle "This is a chart"
        |> Pie.render ( data, accessor )

-}
withTitle : String -> Config -> Config
withTitle value config =
    Type.setSvgTitle value config

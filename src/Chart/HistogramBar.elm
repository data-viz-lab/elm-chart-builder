module Chart.HistogramBar exposing
    ( dataAccessor, preProcessedDataAccessor
    , init
    , render
    , withTable, withDomain, withColor, withTitle, withDesc, withYAxisTickFormat, withYAxisTicks, withYAxisTickCount, hideAxis, hideYAxis, hideXAxis
    )

{-| This is the histogram chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

The histogram bar chart can both generate the histogram data automatically or accept preprocessed data.


# Data Accessors

@docs dataAccessor, preProcessedDataAccessor, initHistogramConfig


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs withTable, withDomain, withSteps, withColor, withTitle, withDesc, withYAxisTickFormat, withYAxisTicks, withYAxisTickCount, hideAxis, hideYAxis, hideXAxis

-}

import Chart.Internal.Bar
    exposing
        ( renderHistogram
        )
import Chart.Internal.Type as Type
    exposing
        ( AccessibilityContent(..)
        , AccessorHistogram(..)
        , AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , ColorResource(..)
        , Config
        , Margin
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setColorResource
        , setDimensions
        , setSvgDesc
        , setSvgTitle
        , setXAxis
        , setYAxis
        )
import Color exposing (Color)
import Histogram
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| The required config, passed as an argument to the `init` function
-}
type alias RequiredConfig =
    { margin : Margin
    , width : Float
    , height : Float
    }


{-| The steps to build the histogram
-}
type alias Steps =
    List Float


{-| The data accessor for generating a histogram.
It takes a config that is separate from the general config,
because it is only used when generating a histogram and not for bucketed pre-processed data.

    steps : Steps
    steps =
        [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 ]

    dataAccessor =
        Histo.dataAccessor steps accessor

-}
dataAccessor : Steps -> (data -> Float) -> AccessorHistogram data
dataAccessor bins acc =
    AccessorHistogram bins acc


{-| The data accessor for generating a histogram from pre-processed data.
Meaning the data has already been bucketed and counted.
`values` here is not used and always passed as an empty array.

    preProcessedDataAccessor =
        Histo.preProcessedDataAccessor
            (\d ->
                { x0 = d.bucket
                , x1 = d.bucket + 0.1
                , values = []
                , length = d.count
                }
            )

-}
preProcessedDataAccessor : (data -> Histogram.Bin Float Float) -> AccessorHistogram data
preProcessedDataAccessor acc =
    AccessorHistogramPreProcessed acc


{-| Initializes the histogram bar chart with a default config.

    Histo.init requiredConfig
        |> Histo.render ( data, accessor )

-}
init : RequiredConfig -> Config
init c =
    defaultConfig
        |> setDimensions { margin = c.margin, width = c.width, height = c.height }


{-| Renders the histogram

    Histo.init requiredConfig
        |> Histo.render ( data, accessor )

-}
render : ( List data, AccessorHistogram data ) -> Config -> Html msg
render ( externalData, acc ) config =
    let
        c =
            fromConfig config

        data =
            Type.externalToDataHistogram config (Type.toExternalData externalData) acc
    in
    renderHistogram ( data, config )


{-| Build an alternative table content for accessibility

&#9888; This is still work in progress and only a basic table is rendered with this option.
For now it is best to only use it with a limited number of data points.

    Histo.init requiredConfig
        |> Histo.withTable
        |> Histo.render ( data, accessor )

-}
withTable : Config -> Config
withTable =
    Type.setAccessibilityContent AccessibilityTable


{-| Set the domain for the HistogramGenerator.
All values falling outside the domain will be ignored.

    Histo.init requiredConfig
        |> Histo.withDomain ( 0, 1 )
        |> Histo.render ( data, accessor )

-}
withDomain : ( Float, Float ) -> Config -> Config
withDomain domain config =
    Type.setHistogramDomain domain config


{-| Set the histogram color

    Histo.init requiredConfig
        |> Histo.withColor (Color.rgb255 240 59 32)
        |> Histo.render ( data, accessor )

-}
withColor : Color -> Config -> Config
withColor color config =
    Type.setColorResource (Color color) config


{-| Passes the tick values for the Y axis.

Defaults to elm-visualization `Scale.ticks`.

    Histo.init requiredConfig
        |> Histo.withYAxisTicks [ 1, 2, 3 ]
        |> Histo.render ( data, accessor )

-}
withYAxisTicks : List Float -> Config -> Config
withYAxisTicks ticks config =
    Type.setYAxisContinousTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the Y axis.

Defaults to elm-visualization `Scale.tickCount`.

    Histo.init requiredConfig
        |> Histo.withYAxisTickCount 5
        |> Histo.render ( data, accessor )

-}
withYAxisTickCount : Int -> Config -> Config
withYAxisTickCount count config =
    Type.setYAxisContinousTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for the Y axis ticks.

Defaults to `Scale.tickFormat`

    formatter =
        Numeral.format "0%"

    Histo.init requiredConfig
        |> Histo.withYAxisTickFormat formatter
        |> Histo.render (data, accessor)

-}
withYAxisTickFormat : (Float -> String) -> Config -> Config
withYAxisTickFormat f config =
    Type.setYAxisContinousTickFormat (CustomTickFormat f) config


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    Histo.init requiredConfig
        |> Histo.withDesc "This is an accessible chart, with a desc element"
        |> Histo.render ( data, accessor )

-}
withDesc : String -> Config -> Config
withDesc value config =
    Type.setSvgDesc value config


{-| Sets an accessible title for the svg chart.
Default value: ""

    Histo.init requiredConfig
        |> Histo.withTitle "This is a chart"
        |> Histo.render ( data, accessor )

-}
withTitle : String -> Config -> Config
withTitle value config =
    Type.setSvgTitle value config


{-| Hide all axis.

    Histo.init requiredConfig
        |> Histo.hideAxis
        |> Histo.render ( data, accessor )

-}
hideAxis : Config -> Config
hideAxis config =
    Type.setXAxis False config
        |> Type.setYAxis False


{-| Hide the Y aixs.

    Histo.init requiredConfig
        |> Histo.hideYAxis
        |> Histo.render ( data, accessor )

-}
hideYAxis : Config -> Config
hideYAxis config =
    Type.setYAxis False config


{-| Hide the X aixs.

    Histo.init requiredConfig
        |> Histo.hideXAxis
        |> Histo.render ( data, accessor )

-}
hideXAxis : Config -> Config
hideXAxis config =
    Type.setXAxis False config

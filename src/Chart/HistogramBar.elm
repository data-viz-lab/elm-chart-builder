module Chart.HistogramBar exposing
    ( dataAccessor, preProcessedDataAccessor, initHistogramConfig
    , init
    , render
    , withDomain, withSteps, withColor, withTitle, withDesc, withYAxisTickFormat
    --, withYAxisTicks
    --, withXAxis
    --, withYAxis
    --, withYAxisTickCount
    )

{-| This is the histogram chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

The histogram bar chart can both generate the histogram data or accept some preprocessed data.


# Data Accessors

@docs dataAccessor, preProcessedDataAccessor, initHistogramConfig


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs withDomain, withSteps, withColor, withTitle, withDesc, withYAxisTickFormat

-}

import Chart.Internal.Bar
    exposing
        ( renderHistogram
        )
import Chart.Internal.Type as Type
    exposing
        ( AccessorHistogram(..)
        , AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , ColorResource(..)
        , Config
        , HistogramConfig
        , Margin
        , RenderContext(..)
        , defaultConfig
        , defaultHistogramConfig
        , fromConfig
        , fromHistogramConfig
        , setColorResource
        , setDimensions
        , setSvgDesc
        , setSvgTitle
        , setXAxis
        , setYAxis
        , toHistogramConfig
        )
import Color exposing (Color)
import Histogram
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


type alias RequiredConfig =
    { margin : Margin
    , width : Float
    , height : Float
    }


{-| The data accessor for generating a histogram.
It takes a config that is separate from the general config, because it is only used when generating a histogram and
not for bucketed pre-processed data.

    histoConfig =
        Histo.initHistogramConfig
            |> Histo.withSteps [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 ]

    dataAccessor =
        Histo.dataAccessor histoConfig accessor

-}
dataAccessor : HistogramConfig -> (data -> Float) -> AccessorHistogram data
dataAccessor config acc =
    AccessorHistogram config acc


{-| Initialises the config for the histogram data accessor.
This is separate from the general config, because it is only used when generating a histogram,
not for pre-processed data that has been already bucketed.

    histoConfig =
        Histo.initHistogramConfig

-}
initHistogramConfig : HistogramConfig
initHistogramConfig =
    defaultHistogramConfig


{-| Set the histogram steps in the config for the histogram data accessor.

    histoConfig =
        Histo.initHistogramConfig
            |> Histo.withSteps [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 ]

-}
withSteps : List Float -> HistogramConfig -> HistogramConfig
withSteps steps config =
    config
        |> fromHistogramConfig
        |> (\c -> { c | histogramSteps = steps })
        |> toHistogramConfig


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

    Histo.init
        |> Histo.render ( data, accessor )

-}
init : RequiredConfig -> Config
init c =
    defaultConfig
        |> setDimensions { margin = c.margin, width = c.width, height = c.height }


{-| Renders the histogram

    Histo.init
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


{-| Set the domain for the HistogramGenerator.
All values falling outside the domain will be ignored.

    Histo.init
        |> Histo.withDomain ( 0, 1 )
        |> Histo.render ( data, accessor )

-}
withDomain : ( Float, Float ) -> Config -> Config
withDomain domain config =
    Type.setHistogramDomain domain config


{-| Set the histogram color

    Histo.init
        |> Histo.withColor (Color.rgb255 240 59 32)
        |> Histo.render ( data, accessor )

-}
withColor : Color -> Config -> Config
withColor color config =
    Type.setColorResource (Color color) config


{-| Sets the formatting for the y axis ticks.

Defaults to `Scale.tickFormat`

    formatter =
        Numeral.format "0%"

    Histo.init
        |> Histo.withYAxisTickFormat formatter
        |> Histo.render (data, accessor)

-}
withYAxisTickFormat : (Float -> String) -> Config -> Config
withYAxisTickFormat f config =
    Type.setYAxisContinousTickFormat (CustomTickFormat f) config


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    Histo.init
        |> Histo.withDesc "This is an accessible chart, with a desc element"
        |> Histo.render ( data, accessor )

-}
withDesc : String -> Config -> Config
withDesc value config =
    Type.setSvgDesc value config


{-| Sets an accessible title for the svg chart.
Default value: ""

    Histo.init
        |> Histo.withTitle "This is a chart"
        |> Histo.render ( data, accessor )

-}
withTitle : String -> Config -> Config
withTitle value config =
    Type.setSvgTitle value config

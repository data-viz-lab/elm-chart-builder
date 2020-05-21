module Chart.HistogramBar exposing
    ( dataAccessor, preProcessedDataAccessor, initHistogramConfig
    , init
    , render
    , setDimensions, setDomain, setHeight, setSteps, setWidth, setColor, setTitle, setDesc, setMargin, setAxisYTickFormat
    --, setAxisYTicks
    --, setShowAxisX
    --, setShowAxisY
    --, setAxisYTickCount
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

@docs setDimensions, setDomain, setHeight, setSteps, setWidth, setColor, setTitle, setDesc, setMargin, setAxisYTickFormat

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
        , setShowAxisX
        , setShowAxisY
        , setTitle
        , toHistogramConfig
        )
import Color exposing (Color)
import Histogram
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| The data accessor for generating a histogram.
It takes a config that is separate from the general config, because it is only used when generating a histogram,
not for pre-processed data that has been already bucketed.

    histoConfig =
        Histo.initHistogramConfig
            |> Histo.setSteps [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 ]

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
            |> Histo.setSteps [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 ]

-}
setSteps : List Float -> HistogramConfig -> HistogramConfig
setSteps steps config =
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
    AccessorHistogramGenerated acc


{-| Initializes the histogram bar chart with a default config.

    Histo.init
        |> Histo.render ( data, accessor )

-}
init : Config
init =
    defaultConfig


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


{-| Sets the outer height of the bar chart.

Default value: 400

    Histo.init
        |> Histo.setHeight 600
        |> Histo.render ( data, accessor )

-}
setHeight : Float -> Config -> Config
setHeight value config =
    Type.setHeight value config


{-| Sets the outer width of the bar chart.

Default value: 600

    Histo.init
        |> Histo.setWidth 800
        |> Histo.render ( data, accessor )

-}
setWidth : Float -> Config -> Config
setWidth value config =
    Type.setWidth value config


{-| Sets the margin, width and height all at once.
Prefer this method from the individual ones when you need to set all three values at once.

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Histo.init
        |> Histo.setDimensions
            { margin = margin
            , width = 400
            , height = 400
            }
        |> Histo.render (data, accessor)

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions value config =
    Type.setDimensions value config


{-| Set the domain for the HistogramGenerator.
All values falling outside the domain will be ignored.

    Histo.init
        |> Histo.setDomain ( 0, 1 )
        |> Histo.render ( data, accessor )

-}
setDomain : ( Float, Float ) -> Config -> Config
setDomain domain config =
    Type.setHistogramDomain domain config


{-| Set the histogram color

    Histo.init
        |> Histo.setColor (Color.rgb255 240 59 32)
        |> Histo.render ( data, accessor )

-}
setColor : Color -> Config -> Config
setColor color config =
    Type.setColorResource (Color color) config


{-| Sets an accessible, long-text description for the svg chart.

Default value: ""

    Histo.init
        |> Histo.setDesc "This is an accessible chart, with a desc element"
        |> Histo.render ( data, accessor )

-}
setDesc : String -> Config -> Config
setDesc value config =
    Type.setDesc value config


{-| Sets an accessible title for the svg chart.

Default value: ""

    Histo.init
        |> Histo.setTitle "This is a chart"
        |> Histo.render ( data, accessor )

-}
setTitle : String -> Config -> Config
setTitle value config =
    Type.setTitle value config


{-| Sets the margin values for the svg chart in the config.

It follows d3s [margin convention](https://bl.ocks.org/mbostock/3019563).

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Histo.init
    |> Histo.setMargin margin
    |> Histo.render ( data, accessor )

-}
setMargin : Margin -> Config -> Config
setMargin value config =
    Type.setMargin value config


{-| Sets the formatting for the y axis ticks.

Defaults to `Scale.tickFormat`

    formatter =
        Numeral.format "0%"

    Histo.init
        |> Histo.setAxisYTickFormat formatter
        |> Histo.render (data, accessor)

-}
setAxisYTickFormat : (Float -> String) -> Config -> Config
setAxisYTickFormat f config =
    Type.setAxisYContinousTickFormat (CustomTickFormat f) config

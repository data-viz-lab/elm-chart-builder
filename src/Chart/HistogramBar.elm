module Chart.HistogramBar exposing
    ( Accessor
    , init
    ,  render
       --, setAxisYTickCount
       --, setAxisYTickFormat
       --, setAxisYTicks
       --, setColorInterpolator
       --, setColorPalette
       --, setDesc
       --, setDimensions

    ,  setHeight
       --, setMargin
       --, setShowAxisX
       --, setShowAxisY
       --, setTitle

    , setWidth
    )

import Chart.Internal.Bar
    exposing
        ( renderHistogram
        )
import Chart.Internal.Type as Type
    exposing
        ( AxisContinousDataTickCount(..)
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
        , setShowAxisX
        , setShowAxisY
        , setTitle
        )
import Color exposing (Color)
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| The data accessor
-}
type alias Accessor data =
    data -> Float


{-| Initializes the histogram bar chart with a default config.

    Bar.init
        |> Bar.render ( data, accessor )

-}
init : Config
init =
    defaultConfig


render : ( List data, Accessor data ) -> Config -> Html msg
render ( externalData, accessor ) config =
    let
        c =
            fromConfig config

        data =
            Type.externalToDataHistogram (Type.toExternalData externalData) accessor
    in
    renderHistogram ( data, config )


{-| Sets the outer height of the bar chart.

Default value: 400

    Bar.init
        |> Bar.setHeight 600
        |> Bar.render ( data, accessor )

-}
setHeight : Float -> Config -> Config
setHeight value config =
    Type.setHeight value config


{-| Sets the outer width of the bar chart.

Default value: 600

    Bar.init
        |> Bar.setWidth 800
        |> Bar.render ( data, accessor )

-}
setWidth : Float -> Config -> Config
setWidth value config =
    Type.setWidth value config

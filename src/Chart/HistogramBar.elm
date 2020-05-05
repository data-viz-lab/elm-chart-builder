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
       --, setMargin
       --, setShowAxisX
       --, setShowAxisY
       --, setTitle

    , setDimensions
    , setDomain
    , setHeight
    , setSteps
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
            []

        --Type.externalToDataHistogram (Type.toExternalData externalData) accessor
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


{-| Sets the margin, width and height all at once.
Prefer this method from the individual ones when you need to set all three values at once.

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Bar.init
        |> Bar.setDimensions
            { margin = margin
            , width = 400
            , height = 400
            }
        |> Bar.render (data, accessor)

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions value config =
    Type.setDimensions value config


{-| Set the domain for the HistogramGenerator.
All values falling outside the domain will be ignored.

    HistogramBar.init
        |> HistogramBar.setDomain ( 0, 1 )
        |> Bar.render ( data, accessor )

-}
setDomain : ( Float, Float ) -> Config -> Config
setDomain domain config =
    Type.setHistogramDomain domain config


{-| For creating an appropriate Threshold value if you already have appropriate Threshold values.

    HistogramBar.init
        |> HistogramBar.setSteps [ 0.2, 0.4, 0.6, 0.8, 1 ]
        |> Bar.render ( data, accessor )

-}
setSteps : List Float -> Config -> Config
setSteps steps config =
    Type.setHistogramSteps steps config

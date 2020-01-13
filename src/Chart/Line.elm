module Chart.Line exposing
    ( DataGroupLinear, Accessor
    , init
    , render
    , setAxisHorizontalTickCount, setAxisHorizontalTickFormat, setAxisHorizontalTicks, setAxisVerticalTickCount, setAxisVerticalTickFormat, setAxisVerticalTicks, setDesc, setDimensions, setHeight, setMargin, setShowHorizontalAxis, setShowVerticalAxis, setTitle, setWidth
    , setDomain
    )

{-| This is the line chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

&#9888; This module is still a work in progress and it has limited funcionality!


# Chart Data Format

@docs DataGroupLinear, Accessor


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs setAxisHorizontalTickCount, setAxisHorizontalTickFormat, setAxisHorizontalTicks, setAxisVerticalTickCount, setAxisVerticalTickFormat, setAxisVerticalTicks, setDesc, setDimensions, setHeight, setMargin, setShowHorizontalAxis, setShowVerticalAxis, setTitle, setWidth

-}

import Chart.Internal.Line
    exposing
        ( renderLineGrouped
        )
import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type as Type
    exposing
        ( AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , Config
        , DomainLinear
        , Layout(..)
        , Margin
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , setAxisHorizontalTickCount
        , setAxisHorizontalTickFormat
        , setAxisHorizontalTicks
        , setAxisVerticalTickCount
        , setAxisVerticalTickFormat
        , setAxisVerticalTicks
        , setDimensions
        , setShowHorizontalAxis
        , setShowVerticalAxis
        , setTitle
        )
import Html exposing (Html)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


{-| Line chart data format.

    dataGroupLinear : Bar.DataGroupLinear
    dataGroupLinear =
        { groupLabel = Just "A"
        , points =
            [ ( 1, 10 )
            , ( 2, 13 )
            , ( 16, 16 )
            ]
        }

-}
type alias DataGroupLinear =
    Type.DataGroupLinear


{-| Initializes the line chart with a default config

    Line.init
        |> Line.render data

-}
init : Config
init =
    defaultConfig


{-| Renders the line chart, after initialisation and customisation

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.render data

-}
render : ( List data, Accessor data ) -> Config -> Html msg
render ( externalData, accessor ) config =
    let
        c =
            fromConfig config

        data =
            Type.externalToDataLinear (Type.toExternalData externalData) accessor
    in
    case c.layout of
        Grouped _ ->
            renderLineGrouped ( data, config )

        Stacked _ ->
            Html.text "TODO"


{-| Sets the outer height of the line chart
Default value: 400

    Line.init
        |> Line.setHeight 600
        |> Line.render data

-}
setHeight : Float -> Config -> Config
setHeight value config =
    Type.setHeight value config


{-| Sets the outer width of the line chart
Default value: 400

    Line.init
        |> Line.setWidth 600
        |> Line.render data

-}
setWidth : Float -> Config -> Config
setWidth value config =
    Type.setWidth value config


{-| Sets the margin values in the config

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Line.init
        |> Line.setMargin margin
        |> Line.render data

-}
setMargin : Margin -> Config -> Config
setMargin value config =
    Type.setMargin value config


{-| Set the ticks for the horizontal axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setHorizontalTicks [ 1, 2, 3 ]
        |> Line.render data

-}
setAxisHorizontalTicks : List Float -> Config -> Config
setAxisHorizontalTicks ticks config =
    Type.setAxisHorizontalTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the horizontal axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setContinousDataTickCount 5
        |> Line.render data

-}
setAxisHorizontalTickCount : Int -> Config -> Config
setAxisHorizontalTickCount count config =
    Type.setAxisHorizontalTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks for the horizontal axis
Defaults to `Scale.tickFormat`

    Line.init
        |> Line.setContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render data

-}
setAxisHorizontalTickFormat : (Float -> String) -> Config -> Config
setAxisHorizontalTickFormat f config =
    Type.setAxisHorizontalTickFormat (Type.CustomTickFormat f) config


{-| Set the ticks for the vertical axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setAxisVerticalDataTicks [ 1, 2, 3 ]
        |> Line.render data

-}
setAxisVerticalTicks : List Float -> Config -> Config
setAxisVerticalTicks ticks config =
    Type.setAxisVerticalTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the vertical axis
Defaults to `Scale.ticks`

    Line.init
        |> Line.setContinousDataTickCount 5
        |> Line.render data

-}
setAxisVerticalTickCount : Int -> Config -> Config
setAxisVerticalTickCount count config =
    Type.setAxisVerticalTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks in the vertical axis
Defaults to `Scale.tickFormat`

    Line.init
        |> Line.setContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render data

-}
setAxisVerticalTickFormat : (Float -> String) -> Config -> Config
setAxisVerticalTickFormat f config =
    Type.setAxisVerticalTickFormat (Type.CustomTickFormat f) config


{-| Sets margin, width and height all at once
Prefer this method from the individual ones when you need to set all three at once.

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Line.init
        |> Line.setDimensions
            { margin = margin
            , width = 400
            , height = 400
            }
        |> Line.render data

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions value config =
    Type.setDimensions value config


{-| Sets the domain value in the config
If not set, the domain is calculated from the data

    Line.init
        |> Line.setDomain (DomainLinear { horizontal = ( 1, 1 ), vertical = ( 0, 20 ) })
        |> Line.render data

-}
setDomain : DomainLinear -> Config -> Config
setDomain value config =
    Type.setDomainLinear value config


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    Line.init
        |> Line.setDesc "This is an accessible chart, with a desc element"
        |> Line.render data

-}
setDesc : String -> Config -> Config
setDesc value config =
    Type.setDesc value config


{-| Sets an accessible title for the svg chart.
Default value: ""

    Line.init
        |> Line.setTitle "This is a chart"
        |> Line.render data

-}
setTitle : String -> Config -> Config
setTitle value config =
    Type.setTitle value config


{-| Sets the showHorizontalAxis boolean value in the config
Default value: True
This shows the bar's horizontal axis

    Line.init
        |> Bar.setShowHorizontalAxis False
        |> Bar.render data

-}
setShowHorizontalAxis : Bool -> Config -> Config
setShowHorizontalAxis value config =
    Type.setShowHorizontalAxis value config


{-| Sets the showVerticalAxis boolean value in the config
Default value: True
This shows the bar's vertical axis

    Line.init
        |> Bar.setShowVerticalAxis False
        |> Bar.render data

-}
setShowVerticalAxis : Bool -> Config -> Config
setShowVerticalAxis value config =
    Type.setShowVerticalAxis value config



-- ACCESSOR


{-| The data accessors

    type alias Accessor data =
        { xGroup : data -> String
        , xValue : data -> String
        , yValue : data -> Float
        }

-}
type alias Accessor data =
    { xGroup : data -> String
    , xValue : data -> Float
    , yValue : data -> Float
    }

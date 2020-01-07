module Chart.Line exposing
    ( DataGroupLinear
    , init
    , render
    , setAxisHorizontalTickCount, setAxisHorizontalTickFormat, setAxisHorizontalTicks, setAxisVerticalTickCount, setAxisVerticalTickFormat, setAxisVerticalTicks, setDesc, setDimensions, setDomain, setHeight, setMargin, setShowHorizontalAxis, setShowVerticalAxis, setTitle, setWidth
    , Domain
    )

{-| This is the line chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

&#9888; This module is still a work in progress and it has limited funcionality!


# Chart Data Format

@docs DataGroupLinear


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration setters

@docs setAxisHorizontalTickCount, setAxisHorizontalTickFormat, setAxisHorizontalTicks, setAxisVerticalTickCount, setAxisVerticalTickFormat, setAxisVerticalTicks, setDesc, setDimensions, setDomain, setHeight, setMargin, setShowHorizontalAxis, setShowVerticalAxis, setTitle, setWidth


# Configuration setters arguments

@docs domainLinear, Domain

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
        , Data(..)
        , DataGroupLinear
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
        , setDomainLinear
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


{-| Initializes the line chart with the data

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data

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
        |> Line.render

-}
render : ( List DataGroupLinear, Config ) -> Html msg
render ( data, config ) =
    let
        c =
            fromConfig config
    in
    case c.layout of
        Grouped _ ->
            renderLineGrouped ( Type.DataLinear data, config )

        Stacked _ ->
            Html.text "TODO"


{-| Sets the outer height of the line chart
Default value: 400

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setHeight 600
        |> Line.render

-}
setHeight : Float -> Config -> Config
setHeight value config =
    Type.setHeight value config


{-| Sets the outer width of the line chart
Default value: 400

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setWidth 600
        |> Line.render

-}
setWidth : Float -> Config -> Config
setWidth value config =
    Type.setWidth value config


{-| Sets the margin values in the config

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Line.init data
        |> Line.setMargin margin
        |> Line.render

-}
setMargin : Margin -> Config -> Config
setMargin value config =
    Type.setMargin value config


{-| Set the ticks for the horizontal axis
Defaults to `Scale.ticks`

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setHorizontalTicks [ 1, 2, 3 ]
        |> Line.render

-}
setAxisHorizontalTicks : List Float -> Config -> Config
setAxisHorizontalTicks ticks config =
    Type.setAxisHorizontalTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the horizontal axis
Defaults to `Scale.ticks`

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setContinousDataTickCount 5
        |> Line.render

-}
setAxisHorizontalTickCount : Int -> Config -> Config
setAxisHorizontalTickCount count config =
    Type.setAxisHorizontalTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks for the horizontal axis
Defaults to `Scale.tickFormat`

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render

-}
setAxisHorizontalTickFormat : (Float -> String) -> Config -> Config
setAxisHorizontalTickFormat f config =
    Type.setAxisHorizontalTickFormat (Type.CustomTickFormat f) config


{-| Set the ticks for the vertical axis
Defaults to `Scale.ticks`

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setAxisVerticalDataTicks [ 1, 2, 3 ]
        |> Line.render

-}
setAxisVerticalTicks : List Float -> Config -> Config
setAxisVerticalTicks ticks config =
    Type.setAxisVerticalTicks (Type.CustomTicks ticks) config


{-| Sets the approximate number of ticks for the vertical axis
Defaults to `Scale.ticks`

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setContinousDataTickCount 5
        |> Line.render

-}
setAxisVerticalTickCount : Int -> Config -> Config
setAxisVerticalTickCount count config =
    Type.setAxisVerticalTickCount (Type.CustomTickCount count) config


{-| Sets the formatting for ticks in the vertical axis
Defaults to `Scale.tickFormat`

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setContinousDataTicks (FormatNumber.format { usLocale | decimals = 0 })
        |> Line.render

-}
setAxisVerticalTickFormat : (Float -> String) -> Config -> Config
setAxisVerticalTickFormat f config =
    Type.setAxisVerticalTickFormat (Type.CustomTickFormat f) config


{-| Sets margin, width and height all at once
Prefer this method from the individual ones when you need to set all three at once.

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    margin =
        { top = 30, right = 20, bottom = 30, left = 0 }

    Line.init data
        |> Line.setDimensions
            { margin = margin
            , width = 400
            , height = 400
            }
        |> Line.render

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> Config -> Config
setDimensions value config =
    Type.setDimensions value config


{-| Sets the domain value in the config
If not set, the domain is calculated from the data

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setDomain (DomainLinear { horizontal = ( 1, 1 ), vertical = ( 0, 20 ) })
        |> Line.render

-}
setDomain : DomainLinear -> Config -> Config
setDomain value config =
    Type.setDomainLinear value config


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setDesc "This is an accessible chart, with a desc element"
        |> Line.render

-}
setDesc : String -> Config -> Config
setDesc value config =
    Type.setDesc value config


{-| Sets an accessible title for the svg chart.
Default value: ""

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Line.setTitle "This is a chart"
        |> Line.render

-}
setTitle : String -> Config -> Config
setTitle value config =
    Type.setTitle value config


{-| Sets the showHorizontalAxis boolean value in the config
Default value: True
This shows the bar's horizontal axis

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Bar.setShowHorizontalAxis False
        |> Bar.render

-}
setShowHorizontalAxis : Bool -> Config -> Config
setShowHorizontalAxis value config =
    Type.setShowHorizontalAxis value config


{-| Sets the showVerticalAxis boolean value in the config
Default value: True
This shows the bar's vertical axis

    data : List DataGroupLinear
    data =
        [ { groupLabel = Nothing
          , points = [ ( 1, 10 ), (2, 20) ]
          }
        ]

    Line.init data
        |> Bar.setShowVerticalAxis False
        |> Bar.render

-}
setShowVerticalAxis : Bool -> Config -> Config
setShowVerticalAxis value config =
    Type.setShowVerticalAxis value config


{-| Domain Type
For line charts this can only be of DomainLinear type
(For now, DomainTime coming soon...)
-}
type alias Domain =
    Type.DomainLinear

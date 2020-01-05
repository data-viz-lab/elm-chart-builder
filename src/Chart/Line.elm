module Chart.Line exposing
    ( DataGroupLinear
    , init
    , render
    , setAxisHorizontalTickCount, setAxisHorizontalTickFormat, setAxisHorizontalTicks, setAxisVerticalTickCount, setAxisVerticalTickFormat, setAxisVerticalTicks, setDesc, setDimensions, setDomain, setHeight, setMargin, setShowHorizontalAxis, setShowVerticalAxis, setTitle, setWidth
    , domainLinear, Domain
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
        , Domain(..)
        , DomainLinearStruct
        , Layout(..)
        , Margin
        , RenderContext(..)
        , defaultConfig
        , fromConfig
        , getDomainFromData
        , setAxisHorizontalTickCount
        , setAxisHorizontalTickFormat
        , setAxisHorizontalTicks
        , setAxisVerticalTickCount
        , setAxisVerticalTickFormat
        , setAxisVerticalTicks
        , setDimensions
        , setDomain
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
init : List DataGroupLinear -> ( List DataGroupLinear, Config )
init data =
    ( data, defaultConfig )


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
setHeight : Float -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setHeight value ( data, config ) =
    Type.setHeight value ( Type.DataLinear data, config ) |> fromDataLinear


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
setWidth : Float -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setWidth value ( data, config ) =
    Type.setWidth value ( Type.DataLinear data, config ) |> fromDataLinear


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
setMargin : Margin -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setMargin value ( data, config ) =
    Type.setMargin value ( Type.DataLinear data, config ) |> fromDataLinear


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
setAxisHorizontalTicks : List Float -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setAxisHorizontalTicks ticks ( data, config ) =
    Type.setAxisHorizontalTicks (Type.CustomTicks ticks) ( Type.DataLinear data, config ) |> fromDataLinear


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
setAxisHorizontalTickCount : Int -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setAxisHorizontalTickCount count ( data, config ) =
    Type.setAxisHorizontalTickCount (Type.CustomTickCount count) ( Type.DataLinear data, config ) |> fromDataLinear


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
setAxisHorizontalTickFormat : (Float -> String) -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setAxisHorizontalTickFormat f ( data, config ) =
    Type.setAxisHorizontalTickFormat (Type.CustomTickFormat f) ( Type.DataLinear data, config ) |> fromDataLinear


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
setAxisVerticalTicks : List Float -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setAxisVerticalTicks ticks ( data, config ) =
    Type.setAxisVerticalTicks (Type.CustomTicks ticks) ( Type.DataLinear data, config ) |> fromDataLinear


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
setAxisVerticalTickCount : Int -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setAxisVerticalTickCount count ( data, config ) =
    Type.setAxisVerticalTickCount (Type.CustomTickCount count) ( Type.DataLinear data, config ) |> fromDataLinear


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
setAxisVerticalTickFormat : (Float -> String) -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setAxisVerticalTickFormat f ( data, config ) =
    Type.setAxisVerticalTickFormat (Type.CustomTickFormat f) ( Type.DataLinear data, config ) |> fromDataLinear


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
setDimensions :
    { margin : Margin, width : Float, height : Float }
    -> ( List DataGroupLinear, Config )
    -> ( List DataGroupLinear, Config )
setDimensions value ( data, config ) =
    Type.setDimensions value ( Type.DataLinear data, config ) |> fromDataLinear


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
setDomain : Domain -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setDomain value ( data, config ) =
    Type.setDomain value ( Type.DataLinear data, config ) |> fromDataLinear


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
setDesc : String -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setDesc value ( data, config ) =
    Type.setDesc value ( Type.DataLinear data, config ) |> fromDataLinear


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
setTitle : String -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setTitle value ( data, config ) =
    Type.setTitle value ( Type.DataLinear data, config ) |> fromDataLinear


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
setShowHorizontalAxis : Bool -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setShowHorizontalAxis value ( data, config ) =
    Type.setShowHorizontalAxis value ( Type.DataLinear data, config ) |> fromDataLinear


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
setShowVerticalAxis : Bool -> ( List DataGroupLinear, Config ) -> ( List DataGroupLinear, Config )
setShowVerticalAxis value ( data, config ) =
    Type.setShowVerticalAxis value ( Type.DataLinear data, config ) |> fromDataLinear


{-| Domain Type
For line charts this can only be of DomainLinear type
(For now, DomainTime coming soon...)
-}
type alias Domain =
    Type.Domain


{-| DomainLinear constructor

    dummyDomainBandStruct : DomainBandStruct
    dummyDomainBandStruct =
        { bandGroup = []
        , bandSingle = []
        , linear = ( 0, 0 )
        }

    domain : Domain
    domain =
        domainBand dummyDomainBandStruct

-}
domainLinear : DomainLinearStruct -> Domain
domainLinear str =
    Type.DomainLinear str



--INTERNAL


fromDataLinear : ( Data, Config ) -> ( List DataGroupLinear, Config )
fromDataLinear ( data, config ) =
    ( Type.fromDataLinear data, config )

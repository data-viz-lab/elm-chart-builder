module Chart.Line exposing
    ( Data
    , Domain
    , dataLinear
    , domainLinear
    , init
    , linearAxisCustomTickCount
    , linearAxisCustomTickFormat
    , linearAxisCustomTicks
    , render
    , setAxisHorizontalTickCount
    , setAxisHorizontalTickFormat
    , setAxisHorizontalTicks
    , setAxisVerticalTickCount
    , setAxisVerticalTickFormat
    , setAxisVerticalTicks
    , setDesc
    , setDimensions
    , setDomain
    , setHeight
    , setMargin
    , setShowHorizontalAxis
    , setShowVerticalAxis
    , setTitle
    , setWidth
    )

{-| This is the line chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

    # Types
    @docs Data , Domain

    # API methods
    @docs dataLinear, domainLinear, init, linearAxisCustomTickCount, linearAxisCustomTickFormat, linearAxisCustomTicks, render, setAxisHorizontalTickCount, setAxisHorizontalTickFormat, setAxisHorizontalTicks, setAxisVerticalTickCount, setAxisVerticalTickFormat, setAxisVerticalTicks, setDesc, setDimensions, setDomain, setHeight, setMargin, setShowHorizontalAxis, setShowVerticalAxis, setTitle, setWidth

-}

import Chart.Internal.Line
    exposing
        ( renderLineGrouped
        , wrongDataTypeErrorView
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


{-| Format of the data

    data : Data
    data =
        DataLinear
            [ { groupLabel = Just "A"
              , points =
                    [ ( 1, 10 )
                    , ( 2, 13 )
                    , ( 16, 16 )
                    ]
              }
            , { groupLabel = Just "B"
              , points =
                    [ ( 1, 11 )
                    , ( 2, 23 )
                    , ( 3, 16 )
                    ]
              }
            ]

-}
type alias Data =
    Type.Data


{-| dataGroupLinear data format

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


{-| dataLinear data format constructor

    data : Data
    data =
        DataLinear
            [ { groupLabel = Just "A"
              , points =
                    [ ( 1, 10 )
                    , ( 2, 13 )
                    , ( 16, 16 )
                    ]
              }
            , { groupLabel = Just "B"
              , points =
                    [ ( 1, 11 )
                    , ( 2, 23 )
                    , ( 3, 16 )
                    ]
              }
            ]

-}
dataLinear : List DataGroupLinear -> Data
dataLinear data =
    Type.DataLinear data


{-| Initializes the line chart

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])

-}
init : Data -> ( Data, Config )
init data =
    ( data, defaultConfig )
        |> setDomain (getDomainFromData data)


{-| Renders the line chart, after initialisation and customisation

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.render

-}
render : ( Data, Config ) -> Html msg
render ( data, config ) =
    let
        c =
            fromConfig config
    in
    case data of
        DataLinear _ ->
            case c.layout of
                Grouped _ ->
                    renderLineGrouped ( data, config )

                Stacked _ ->
                    Html.text "TODO"

        _ ->
            wrongDataTypeErrorView


{-| Sets the outer height of the line chart
Default value: 400

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setHeight 600
        |> Line.render

-}
setHeight : Float -> ( Data, Config ) -> ( Data, Config )
setHeight =
    Type.setHeight


{-| Sets the outer width of the line chart
Default value: 400

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setWidth 600
        |> Line.render

-}
setWidth : Float -> ( Data, Config ) -> ( Data, Config )
setWidth =
    Type.setWidth


{-| Sets the margin values in the config

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setMargin { top = 10, right = 10, bottom = 30, left = 30 }
        |> Line.render

-}
setMargin : Margin -> ( Data, Config ) -> ( Data, Config )
setMargin =
    Type.setMargin


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setHorizontalTicks (CustomTicks <| Scale.ticks linearScale 5)
        |> Line.render

-}
setAxisHorizontalTicks : AxisContinousDataTicks -> ( Data, Config ) -> ( Data, Config )
setAxisHorizontalTicks =
    Type.setAxisHorizontalTicks


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setContinousDataTickCount (CustomTickCount 5)
        |> Line.render

-}
setAxisHorizontalTickCount : AxisContinousDataTickCount -> ( Data, Config ) -> ( Data, Config )
setAxisHorizontalTickCount =
    Type.setAxisHorizontalTickCount


{-| Sets the formatting for ticks in a grouped bar chart continous axis
Defaults to `Scale.tickFormat`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setContinousDataTicks (CustomTickFormat .... TODO)
        |> Line.render

-}
setAxisHorizontalTickFormat : AxisContinousDataTickFormat -> ( Data, Config ) -> ( Data, Config )
setAxisHorizontalTickFormat =
    Type.setAxisHorizontalTickFormat


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setAxisVerticalDataTicks (CustomTicks <| Scale.ticks linearScale 5)
        |> Line.render

-}
setAxisVerticalTicks : AxisContinousDataTicks -> ( Data, Config ) -> ( Data, Config )
setAxisVerticalTicks =
    Type.setAxisVerticalTicks


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setContinousDataTickCount (CustomTickCount 5)
        |> Line.render

-}
setAxisVerticalTickCount : AxisContinousDataTickCount -> ( Data, Config ) -> ( Data, Config )
setAxisVerticalTickCount =
    Type.setAxisVerticalTickCount


{-| Sets the formatting for ticks in a grouped bar chart continous axis
Defaults to `Scale.tickFormat`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setContinousDataTicks (CustomTickFormat .... TODO)
        |> Line.render

-}
setAxisVerticalTickFormat : AxisContinousDataTickFormat -> ( Data, Config ) -> ( Data, Config )
setAxisVerticalTickFormat =
    Type.setAxisVerticalTickFormat


{-| Sets margin, width and height all at once
Prefer this method from the individual ones when you need to set all three at once.

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setDimensions
            { margin = { top = 30, right = 20, bottom = 30, left = 0 }
            , width = 400
            , height = 400
            }
        |> Line.render

-}
setDimensions : { margin : Margin, width : Float, height : Float } -> ( Data, Config ) -> ( Data, Config )
setDimensions =
    Type.setDimensions


{-| Sets the domain value in the config
If not set, the domain is calculated from the data

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setDomain (DomainLinear { horizontal = ( 1, 1 ), vertical = ( 0, 20 ) })
        |> Line.render

-}
setDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setDomain =
    Type.setDomain


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setDesc "This is an accessible chart, with a desc element"
        |> Line.render

-}
setDesc : String -> ( Data, Config ) -> ( Data, Config )
setDesc =
    Type.setDesc


{-| Sets an accessible title for the svg chart.
Default value: ""

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setTitle "This is a chart"
        |> Line.render

-}
setTitle : String -> ( Data, Config ) -> ( Data, Config )
setTitle =
    Type.setTitle


{-| Sets the showHorizontalAxis boolean value in the config
Default value: True
This shows the bar's horizontal axis

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Bar.setShowHorizontalAxis False
        |> Bar.render

-}
setShowHorizontalAxis : Bool -> ( Data, Config ) -> ( Data, Config )
setShowHorizontalAxis =
    Type.setShowHorizontalAxis


{-| Sets the showVerticalAxis boolean value in the config
Default value: True
This shows the bar's vertical axis

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Bar.setShowVerticalAxis False
        |> Bar.render

-}
setShowVerticalAxis : Bool -> ( Data, Config ) -> ( Data, Config )
setShowVerticalAxis =
    Type.setShowVerticalAxis


{-| Pass the ticks to Bar.setLinearAxisTicks

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLinearAxisTicks [ 1, 2, 3 ]

-}
linearAxisCustomTicks : List Float -> AxisContinousDataTicks
linearAxisCustomTicks ticks =
    Type.CustomTicks ticks


{-| Pass the number of ticks to Bar.setLinearAxisTickCount

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLinearAxisTickCount (CustomTickCount 5)

-}
linearAxisCustomTickCount : Int -> AxisContinousDataTickCount
linearAxisCustomTickCount count =
    Type.CustomTickCount count


{-| A custom formatter for the continous data axis values

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setLinearAxisTickFormat (Bar.linearAxisCustomTickFormat (FormatNumber.format { usLocale | decimals = 0 }))

-}
linearAxisCustomTickFormat : (Float -> String) -> AxisContinousDataTickFormat
linearAxisCustomTickFormat formatter =
    Type.CustomTickFormat formatter


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

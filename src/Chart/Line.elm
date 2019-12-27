module Chart.Line exposing
    ( init
    , render
    , setDesc
    , setDimensions
    , setDomain
    , setHeight
    , setTitle
    , setWidth
    )

import Axis
import Chart.Helpers as Helpers exposing (dataBandToDataStacked)
import Chart.Symbol
    exposing
        ( Symbol(..)
        , circle_
        , corner
        , custom
        , getSymbolByIndex
        , symbolGap
        , symbolToId
        , triangle
        )
import Chart.Type
    exposing
        ( AxisOrientation(..)
        , Config
        , ConfigStruct
        , ContinousDataTickCount(..)
        , ContinousDataTickFormat(..)
        , ContinousDataTicks(..)
        , Data(..)
        , DataGroupLinear
        , Domain(..)
        , Layout(..)
        , Margin
        , PointLinear
        , RenderContext(..)
        , ariaLabelledby
        , defaultConfig
        , fromConfig
        , fromDataLinear
        , fromDomainLinear
        , getDomain
        , getDomainFromData
        , getHeight
        , getMargin
        , getWidth
        , role
        , setDimensions
        , setDomain
        , setShowHorizontalAxis
        , setShowVerticalAxis
        , setTitle
        )
import Html exposing (Html)
import Html.Attributes
import Path exposing (Path)
import Scale exposing (ContinuousScale)
import Shape
import TypedSvg exposing (g, rect, svg, text_)
import TypedSvg.Attributes
    exposing
        ( class
        , transform
        , viewBox
        )
import TypedSvg.Attributes.InPx exposing (height, width)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))



-- LOCAL TYPES


type AxisType
    = Vertical
    | Horizontal



-- API METHODS


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


setHeight : Float -> ( Data, Config ) -> ( Data, Config )
setHeight =
    Chart.Type.setHeight


setWidth : Float -> ( Data, Config ) -> ( Data, Config )
setWidth =
    Chart.Type.setWidth


setMargin : Margin -> ( Data, Config ) -> ( Data, Config )
setMargin =
    Chart.Type.setMargin


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setHorizontalDataTicks (CustomTicks <| Scale.ticks linearScale 5)
        |> Line.render

-}
setHorizontalDataTicks : ContinousDataTicks -> ( Data, Config ) -> ( Data, Config )
setHorizontalDataTicks =
    Chart.Type.setHorizontalDataTicks


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setContinousDataTickCount (CustomTickCount 5)
        |> Line.render

-}
setHorizontalDataTickCount : ContinousDataTickCount -> ( Data, Config ) -> ( Data, Config )
setHorizontalDataTickCount =
    Chart.Type.setContinousDataTickCount


{-| Sets the formatting for ticks in a grouped bar chart continous axis
Defaults to `Scale.tickFormat`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setContinousDataTicks (CustomTickFormat .... TODO)
        |> Line.render

-}
setHorizontalDataTickFormat : ContinousDataTickFormat -> ( Data, Config ) -> ( Data, Config )
setHorizontalDataTickFormat =
    Chart.Type.setHorizontalDataTickFormat


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setVerticalDataTicks (CustomTicks <| Scale.ticks linearScale 5)
        |> Line.render

-}
setVerticalDataTicks : ContinousDataTicks -> ( Data, Config ) -> ( Data, Config )
setVerticalDataTicks =
    Chart.Type.setVerticalDataTicks


{-| Sets the approximate number of ticks for a grouped bar chart continous axis
Defaults to `Scale.ticks`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setContinousDataTickCount (CustomTickCount 5)
        |> Line.render

-}
setVerticalDataTickCount : ContinousDataTickCount -> ( Data, Config ) -> ( Data, Config )
setVerticalDataTickCount =
    Chart.Type.setContinousDataTickCount


{-| Sets the formatting for ticks in a grouped bar chart continous axis
Defaults to `Scale.tickFormat`

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setContinousDataTicks (CustomTickFormat .... TODO)
        |> Line.render

-}
setVerticalDataTickFormat : ContinousDataTickFormat -> ( Data, Config ) -> ( Data, Config )
setVerticalDataTickFormat =
    Chart.Type.setVerticalDataTickFormat


setDimensions : { margin : Margin, width : Float, height : Float } -> ( Data, Config ) -> ( Data, Config )
setDimensions =
    Chart.Type.setDimensions


{-| Sets the domain value in the config
If not set, the domain is calculated from the data

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setDomain (DomainLinear { horizontal = ( 1, 1 ), vertical = ( 0, 20 ) })
        |> Line.render

-}
setDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setDomain =
    Chart.Type.setDomain


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setDesc "This is an accessible chart, with a desc element"
        |> Line.render

-}
setDesc : String -> ( Data, Config ) -> ( Data, Config )
setDesc =
    Chart.Type.setDesc


{-| Sets an accessible title for the svg chart.
Default value: ""

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setTitle "This is a chart"
        |> Line.render

-}
setTitle : String -> ( Data, Config ) -> ( Data, Config )
setTitle =
    Chart.Type.setTitle


{-| Sets the showHorizontalAxis boolean value in the config
Default value: True
This shows the bar's horizontal axis

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Bar.setShowHorizontalAxis False
        |> Bar.render

-}
setShowHorizontalAxis : Bool -> ( Data, Config ) -> ( Data, Config )
setShowHorizontalAxis =
    Chart.Type.setShowHorizontalAxis


{-| Sets the showVerticalAxis boolean value in the config
Default value: True
This shows the bar's vertical axis

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Bar.setShowVerticalAxis False
        |> Bar.render

-}
setShowVerticalAxis : Bool -> ( Data, Config ) -> ( Data, Config )
setShowVerticalAxis =
    Chart.Type.setShowVerticalAxis



-- INTERNALS
--


descAndTitle : ConfigStruct -> List (Svg msg)
descAndTitle c =
    -- https://developer.paciellogroup.com/blog/2013/12/using-aria-enhance-svg-accessibility/
    [ TypedSvg.title [] [ text c.title ]
    , TypedSvg.desc [] [ text c.desc ]
    ]


renderLineGrouped : ( Data, Config ) -> Html msg
renderLineGrouped ( data, config ) =
    let
        c =
            fromConfig config

        m =
            getMargin config

        w =
            getWidth config

        h =
            getHeight config

        outerW =
            w + m.left + m.right

        outerH =
            h + m.top + m.bottom

        domain =
            getDomain config
                |> fromDomainLinear

        horizontalRange =
            ( 0, w )

        verticalRange =
            ( h, 0 )

        sortedData =
            data
                |> fromDataLinear
                |> List.sortBy (.points >> List.map Tuple.first)

        horizontalScale : ContinuousScale Float
        horizontalScale =
            Scale.linear horizontalRange domain.horizontal

        verticalScale : ContinuousScale Float
        verticalScale =
            Scale.linear verticalRange domain.vertical

        lineGenerator : PointLinear -> Maybe PointLinear
        lineGenerator ( x, y ) =
            Just ( Scale.convert horizontalScale x, Scale.convert verticalScale y )

        line : DataGroupLinear -> Path
        line dataGroup =
            dataGroup.points
                |> List.map lineGenerator
                |> Shape.line Shape.monotoneInXCurve
    in
    svg
        [ viewBox 0 0 outerW outerH
        , width outerW
        , height outerH
        , role "img"
        , ariaLabelledby "title desc"
        ]
    <|
        descAndTitle c
            ++ axisGenerator c Vertical verticalScale
            ++ axisGenerator c Horizontal horizontalScale
            ++ [ g
                    [ transform [ Translate m.left m.top ]
                    , class [ "series" ]
                    ]
                 <|
                    List.map (\d -> Path.element (line d) []) sortedData
               ]


axisGenerator : ConfigStruct -> AxisType -> ContinuousScale Float -> List (Svg msg)
axisGenerator c axisType scale =
    if c.showContinousAxis == True then
        let
            ticks =
                case c.continousDataTicks of
                    DefaultTicks ->
                        Nothing

                    CustomTicks t ->
                        Just (Axis.ticks t)

            tickCount =
                case c.continousDataTickCount of
                    DefaultTickCount ->
                        Nothing

                    CustomTickCount count ->
                        Just (Axis.tickCount count)

            tickFormat =
                case c.continousDataTickFormat of
                    DefaultTickFormat ->
                        Nothing

                    CustomTickFormat formatter ->
                        Just (Axis.tickFormat formatter)

            attributes =
                [ ticks, tickFormat, tickCount ]
                    |> List.filterMap identity
        in
        case axisType of
            Vertical ->
                let
                    axis =
                        Axis.left attributes scale
                in
                [ g
                    [ transform [ Translate c.margin.left c.margin.top ]
                    , class [ "axis", "axis--vertical" ]
                    ]
                    [ axis ]
                ]

            Horizontal ->
                let
                    axis =
                        Axis.bottom attributes scale
                in
                [ g
                    [ transform [ Translate c.margin.left (c.height + c.margin.top) ]
                    , class [ "axis", "axis--horizontal" ]
                    ]
                    [ axis ]
                ]

    else
        []



-- ERROR VIEWS


wrongDataTypeErrorView : Html msg
wrongDataTypeErrorView =
    Html.div [] [ Html.text "Data type not supported in line charts" ]

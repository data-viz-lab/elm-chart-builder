module Chart.Internal.Line exposing (renderLineGrouped)

import Axis
import Chart.Internal.Helpers as Helpers
import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type
    exposing
        ( AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , Config
        , ConfigStruct
        , DataGroupTime
        , DataTime
        , Layout(..)
        , PointTime
        , RenderContext(..)
        , ariaLabelledby
        , bottomGap
        , fromConfig
        , fromDataTime
        , getDomainTimeFromData
        , getHeight
        , getMargin
        , getWidth
        , leftGap
        , role
        )
import Html exposing (Html)
import Path exposing (Path)
import Scale exposing (ContinuousScale)
import Shape
import Time exposing (Posix)
import TypedSvg exposing (g, svg)
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



-- INTERNALS
--


descAndTitle : ConfigStruct -> List (Svg msg)
descAndTitle c =
    -- https://developer.paciellogroup.com/blog/2013/12/using-aria-enhance-svg-accessibility/
    [ TypedSvg.title [] [ text c.title ]
    , TypedSvg.desc [] [ text c.desc ]
    ]


renderLineGrouped : ( DataTime, Config ) -> Html msg
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
            getDomainTimeFromData data config

        horizontalRange =
            ( 0, w )

        verticalRange =
            ( h, 0 )

        sortedData =
            data
                |> fromDataTime
                |> List.map
                    (\d ->
                        let
                            points =
                                d.points
                        in
                        { d | points = List.sortBy (Tuple.first >> Time.posixToMillis) points }
                    )

        horizontalScale : ContinuousScale Posix
        horizontalScale =
            Scale.time c.zone
                horizontalRange
                (Maybe.withDefault
                    ( Time.millisToPosix 0
                    , Time.millisToPosix 0
                    )
                    domain.horizontal
                )

        verticalScale : ContinuousScale Float
        verticalScale =
            Scale.linear verticalRange (Maybe.withDefault ( 0, 0 ) domain.vertical)

        lineGenerator : PointTime -> Maybe ( Float, Float )
        lineGenerator ( x, y ) =
            Just ( Scale.convert horizontalScale x, Scale.convert verticalScale y )

        line : DataGroupTime -> Path
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
            ++ linearAxisGenerator c Vertical verticalScale
            ++ timeAxisGenerator c Horizontal horizontalScale
            ++ [ g
                    [ transform [ Translate m.left m.top ]
                    , class [ "series" ]
                    ]
                 <|
                    List.indexedMap
                        (\idx d ->
                            Path.element (line d)
                                [ class [ "line", "line-" ++ String.fromInt idx ]
                                ]
                        )
                        sortedData
               ]


timeAxisGenerator : ConfigStruct -> AxisType -> ContinuousScale Posix -> List (Svg msg)
timeAxisGenerator c axisType scale =
    if c.showXAxis == True then
        case axisType of
            Vertical ->
                let
                    --ticks =
                    --    case c.axisVerticalTicks of
                    --        DefaultTicks ->
                    --            Nothing
                    --        CustomTicks t ->
                    --            Just (Axis.ticks t)
                    --tickCount =
                    --    case c.axisVerticalTickCount of
                    --        DefaultTickCount ->
                    --            Nothing
                    --        CustomTickCount count ->
                    --            Just (Axis.tickCount count)
                    --tickFormat =
                    --    case c.axisVerticalTickFormat of
                    --        DefaultTickFormat ->
                    --            Nothing
                    --        CustomTickFormat formatter ->
                    --            Just (Axis.tickFormat formatter)
                    --attributes =
                    --    [ ticks, tickFormat, tickCount ]
                    --        |> List.filterMap identity
                    axis =
                        Axis.left [] scale
                in
                [ g
                    [ transform [ Translate (c.margin.left - leftGap |> Helpers.floorFloat) c.margin.top ]
                    , class [ "axis", "axis--vertical" ]
                    ]
                    [ axis ]
                ]

            Horizontal ->
                let
                    ticks =
                        case c.axisContinousXTicks of
                            CustomTimeTicks t ->
                                Just (Axis.ticks t)

                            _ ->
                                Nothing

                    tickCount =
                        case c.axisContinousXTickCount of
                            DefaultTickCount ->
                                Nothing

                            CustomTickCount count ->
                                Just (Axis.tickCount count)

                    tickFormat =
                        case c.axisContinousXTickFormat of
                            CustomTimeTickFormat formatter ->
                                Just (Axis.tickFormat formatter)

                            _ ->
                                Nothing

                    attributes =
                        [ ticks, tickCount, tickFormat ]
                            |> List.filterMap identity

                    axis =
                        Axis.bottom attributes scale
                in
                [ g
                    [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                    , class [ "axis", "axis--horizontal" ]
                    ]
                    [ axis ]
                ]

    else
        []


linearAxisGenerator : ConfigStruct -> AxisType -> ContinuousScale Float -> List (Svg msg)
linearAxisGenerator c axisType scale =
    if c.showYAxis == True then
        case axisType of
            Vertical ->
                let
                    ticks =
                        case c.axisContinousYTicks of
                            CustomTicks t ->
                                Just (Axis.ticks t)

                            _ ->
                                Nothing

                    tickCount =
                        case c.axisContinousYTickCount of
                            DefaultTickCount ->
                                Nothing

                            CustomTickCount count ->
                                Just (Axis.tickCount count)

                    tickFormat =
                        case c.axisContinousYTickFormat of
                            CustomTickFormat formatter ->
                                Just (Axis.tickFormat formatter)

                            _ ->
                                Nothing

                    attributes =
                        [ ticks, tickFormat, tickCount ]
                            |> List.filterMap identity

                    axis =
                        Axis.left attributes scale
                in
                [ g
                    [ transform [ Translate (c.margin.left - leftGap |> Helpers.floorFloat) c.margin.top ]
                    , class [ "axis", "axis--vertical" ]
                    ]
                    [ axis ]
                ]

            Horizontal ->
                let
                    ticks =
                        case c.axisContinousXTicks of
                            CustomTicks t ->
                                Just (Axis.ticks t)

                            _ ->
                                Nothing

                    tickCount =
                        case c.axisContinousXTickCount of
                            DefaultTickCount ->
                                Nothing

                            CustomTickCount count ->
                                Just (Axis.tickCount count)

                    tickFormat =
                        case c.axisContinousXTickFormat of
                            CustomTickFormat formatter ->
                                Just (Axis.tickFormat formatter)

                            _ ->
                                Nothing

                    attributes =
                        [ ticks, tickFormat, tickCount ]
                            |> List.filterMap identity

                    axis =
                        Axis.bottom attributes scale
                in
                [ g
                    [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                    , class [ "axis", "axis--horizontal" ]
                    ]
                    [ axis ]
                ]

    else
        []

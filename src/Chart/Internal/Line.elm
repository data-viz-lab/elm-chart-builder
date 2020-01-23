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
        , DataGroupLinear
        , DataGroupTime
        , DataLinearGroup
        , Layout(..)
        , PointLinear
        , PointTime
        , RenderContext(..)
        , ariaLabelledby
        , bottomGap
        , dataLinearGroupToDataLinear
        , fromConfig
        , getDomainLinearFromData
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


renderLineGrouped : ( DataLinearGroup, Config ) -> Html msg
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

        linearData =
            data
                |> dataLinearGroupToDataLinear

        linearDomain =
            linearData
                |> getDomainLinearFromData config

        --|> fromDomainLinear
        horizontalRange =
            ( 0, w )

        verticalRange =
            ( h, 0 )

        sortedLinearData =
            linearData
                |> List.map
                    (\d ->
                        let
                            points =
                                d.points
                        in
                        { d | points = List.sortBy Tuple.first points }
                    )

        horizontalLinearScale : ContinuousScale Float
        horizontalLinearScale =
            Scale.linear
                horizontalRange
                (Maybe.withDefault ( 0, 0 ) linearDomain.horizontal)

        --horizontalTimeScale : ContinuousScale Posix
        --horizontalTimeScale =
        --    Scale.time c.zone
        --        horizontalRange
        --        (Maybe.withDefault
        --            ( Time.millisToPosix 0
        --            , Time.millisToPosix 0
        --            )
        --            domain.horizontal
        --        )
        verticalScale : ContinuousScale Float
        verticalScale =
            Scale.linear verticalRange (Maybe.withDefault ( 0, 0 ) linearDomain.vertical)

        lineGenerator : PointLinear -> Maybe ( Float, Float )
        lineGenerator ( x, y ) =
            Just ( Scale.convert horizontalLinearScale x, Scale.convert verticalScale y )

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
            ++ linearAxisGenerator c Vertical verticalScale
            --++ timeAxisGenerator c Horizontal horizontalLinearScale
            ++ linearAxisGenerator c Horizontal horizontalLinearScale
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
                        sortedLinearData
               ]


timeAxisGenerator : ConfigStruct -> AxisType -> ContinuousScale Posix -> List (Svg msg)
timeAxisGenerator c axisType scale =
    if c.showAxisX == True then
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
                        case c.axisXContinousTicks of
                            CustomTimeTicks t ->
                                Just (Axis.ticks t)

                            _ ->
                                Nothing

                    tickCount =
                        case c.axisXContinousTickCount of
                            DefaultTickCount ->
                                Nothing

                            CustomTickCount count ->
                                Just (Axis.tickCount count)

                    tickFormat =
                        case c.axisXContinousTickFormat of
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
    if c.showAxisY == True then
        case axisType of
            Vertical ->
                let
                    ticks =
                        case c.axisYContinousTicks of
                            CustomTicks t ->
                                Just (Axis.ticks t)

                            _ ->
                                Nothing

                    tickCount =
                        case c.axisYContinousTickCount of
                            DefaultTickCount ->
                                Nothing

                            CustomTickCount count ->
                                Just (Axis.tickCount count)

                    tickFormat =
                        case c.axisYContinousTickFormat of
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
                        case c.axisXContinousTicks of
                            CustomTicks t ->
                                Just (Axis.ticks t)

                            _ ->
                                Nothing

                    tickCount =
                        case c.axisXContinousTickCount of
                            DefaultTickCount ->
                                Nothing

                            CustomTickCount count ->
                                Just (Axis.tickCount count)

                    tickFormat =
                        case c.axisXContinousTickFormat of
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

module Chart.Internal.Line exposing
    ( renderLineGrouped
    , renderLineStacked
    )

import Axis
import Chart.Internal.Helpers as Helpers
import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type
    exposing
        ( AccessorLinearGroup(..)
        , AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , Config
        , ConfigStruct
        , DataGroupLinear
        , DataLinearGroup(..)
        , DomainLinearStruct
        , Layout(..)
        , PointLinear
        , PointStacked
        , RenderContext(..)
        , ariaLabelledby
        , bottomGap
        , dataLinearGroupToDataLinear
        , dataLinearGroupToDataTime
        , fromConfig
        , getDomainLinearFromData
        , getDomainTimeFromData
        , getHeight
        , getMargin
        , getOffset
        , getWidth
        , leftGap
        , role
        )
import Html exposing (Html)
import Path exposing (Path)
import Scale exposing (ContinuousScale)
import Shape exposing (StackConfig)
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
    = Y
    | X



-- INTERNALS
--


descAndTitle : ConfigStruct -> List (Svg msg)
descAndTitle c =
    -- https://developer.paciellogroup.com/blog/2013/12/using-aria-enhance-svg-accessibility/
    [ TypedSvg.title [] [ text c.title ]
    , TypedSvg.desc [] [ text c.desc ]
    ]



-- GROUPED


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

        linearData : List DataGroupLinear
        linearData =
            data
                |> dataLinearGroupToDataLinear

        linearDomain : DomainLinearStruct
        linearDomain =
            linearData
                |> getDomainLinearFromData config

        timeData =
            data
                |> dataLinearGroupToDataTime

        timeDomain =
            timeData
                |> getDomainTimeFromData config

        xRange =
            ( 0, w )

        yRange =
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

        xLinearScale : ContinuousScale Float
        xLinearScale =
            Scale.linear
                xRange
                (Maybe.withDefault ( 0, 0 ) linearDomain.x)

        xTimeScale : Maybe (ContinuousScale Posix)
        xTimeScale =
            case data of
                DataTime _ ->
                    Scale.time c.zone
                        xRange
                        (Maybe.withDefault
                            ( Time.millisToPosix 0
                            , Time.millisToPosix 0
                            )
                            timeDomain.x
                        )
                        |> Just

                _ ->
                    Nothing

        yScale : ContinuousScale Float
        yScale =
            Scale.linear yRange (Maybe.withDefault ( 0, 0 ) linearDomain.y)

        lineGenerator : PointLinear -> Maybe ( Float, Float )
        lineGenerator ( x, y ) =
            Just ( Scale.convert xLinearScale x, Scale.convert yScale y )

        line : DataGroupLinear -> Path
        line dataGroup =
            dataGroup.points
                |> List.map lineGenerator
                |> Shape.line c.curve
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
            ++ linearAxisGenerator c Y yScale
            ++ linearOrTimeAxisGenerator xTimeScale xLinearScale ( data, config )
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



-- STACKED


renderLineStacked : ( DataLinearGroup, Config ) -> Html msg
renderLineStacked ( data, config ) =
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

        linearData : List DataGroupLinear
        linearData =
            data
                |> dataLinearGroupToDataLinear

        xLinearData : List (List Float)
        xLinearData =
            linearData
                |> List.map (.points >> List.map Tuple.first)

        linearDomain : DomainLinearStruct
        linearDomain =
            linearData
                |> getDomainLinearFromData config

        dataStacked : List ( String, List Float )
        dataStacked =
            Helpers.dataLinearGroupToDataLinearStacked linearData config

        stackedConfig : StackConfig String
        stackedConfig =
            { data = dataStacked
            , offset = getOffset config
            , order = identity
            }

        { values, labels, extent } =
            Shape.stack stackedConfig

        combinedData : List (List PointLinear)
        combinedData =
            Helpers.combineStakedValuesWithXValues values xLinearData

        timeData =
            data
                |> dataLinearGroupToDataTime

        timeDomain =
            timeData
                |> getDomainTimeFromData config

        xRange =
            ( 0, w )

        yRange =
            ( h, 0 )

        xLinearScale : ContinuousScale Float
        xLinearScale =
            Scale.linear
                xRange
                (Maybe.withDefault ( 0, 0 ) linearDomain.x)

        xTimeScale : Maybe (ContinuousScale Posix)
        xTimeScale =
            case data of
                DataTime _ ->
                    Scale.time c.zone
                        xRange
                        (Maybe.withDefault
                            ( Time.millisToPosix 0
                            , Time.millisToPosix 0
                            )
                            timeDomain.x
                        )
                        |> Just

                _ ->
                    Nothing

        yScale : ContinuousScale Float
        yScale =
            Scale.linear yRange extent

        lineGenerator : PointLinear -> Maybe ( Float, Float )
        lineGenerator ( x, y ) =
            Just ( Scale.convert xLinearScale x, Scale.convert yScale y )

        line : List PointLinear -> Path
        line points =
            points
                |> List.map lineGenerator
                |> Shape.line c.curve
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
            ++ linearAxisGenerator c Y yScale
            ++ linearOrTimeAxisGenerator xTimeScale xLinearScale ( data, config )
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
                        combinedData
               ]


timeAxisGenerator : ConfigStruct -> AxisType -> Maybe (ContinuousScale Posix) -> List (Svg msg)
timeAxisGenerator c axisType scale =
    if c.showAxisX == True then
        case scale of
            Just s ->
                case axisType of
                    Y ->
                        []

                    X ->
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
                                Axis.bottom attributes s
                        in
                        [ g
                            [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                            , class [ "axis", "axis--x" ]
                            ]
                            [ axis ]
                        ]

            _ ->
                []

    else
        []


linearAxisGenerator : ConfigStruct -> AxisType -> ContinuousScale Float -> List (Svg msg)
linearAxisGenerator c axisType scale =
    if c.showAxisY == True then
        case axisType of
            Y ->
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
                    , class [ "axis", "axis--y" ]
                    ]
                    [ axis ]
                ]

            X ->
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
                    , class [ "axis", "axis--x" ]
                    ]
                    [ axis ]
                ]

    else
        []


linearOrTimeAxisGenerator :
    Maybe (ContinuousScale Posix)
    -> ContinuousScale Float
    -> ( DataLinearGroup, Config )
    -> List (Svg msg)
linearOrTimeAxisGenerator xTimeScale xLinearScale ( data, config ) =
    let
        c =
            fromConfig config
    in
    case data of
        DataTime _ ->
            timeAxisGenerator c X xTimeScale

        DataLinear _ ->
            linearAxisGenerator c X xLinearScale

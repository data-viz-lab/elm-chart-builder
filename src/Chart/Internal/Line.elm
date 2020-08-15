module Chart.Internal.Line exposing
    ( renderLineGrouped
    , renderLineStacked
    )

import Axis
import Chart.Internal.Helpers as Helpers
import Chart.Internal.Symbol
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
import Chart.Internal.Type
    exposing
        ( AccessorLinearGroup(..)
        , AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , ColorResource(..)
        , Config
        , ConfigStruct
        , DataGroupLinear
        , DataLinearGroup(..)
        , DomainLinearStruct
        , Layout(..)
        , PointLinear
        , RenderContext(..)
        , ariaLabelledby
        , bottomGap
        , colorCategoricalStyle
        , colorStyle
        , dataLinearGroupToDataLinear
        , dataLinearGroupToDataLinearStacked
        , dataLinearGroupToDataTime
        , fromConfig
        , getDomainLinearFromData
        , getDomainTimeFromData
        , getHeight
        , getIcons
        , getMargin
        , getOffset
        , getWidth
        , leftGap
        , role
        , showIcons
        )
import Color
import Html exposing (Html)
import Html.Attributes
import Path exposing (Path)
import Scale exposing (ContinuousScale)
import Shape exposing (StackConfig)
import Time exposing (Posix)
import TypedSvg exposing (g, svg)
import TypedSvg.Attributes
    exposing
        ( class
        , fill
        , fillOpacity
        , stroke
        , style
        , transform
        , viewBox
        , xlinkHref
        )
import TypedSvg.Attributes.InPx exposing (height, width)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types
    exposing
        ( AlignmentBaseline(..)
        , AnchorAlignment(..)
        , Opacity(..)
        , Paint(..)
        , ShapeRendering(..)
        , Transform(..)
        )



-- LOCAL TYPES


type AxisType
    = Y
    | X



-- INTERNALS
--


descAndTitle : ConfigStruct -> List (Svg msg)
descAndTitle c =
    -- https://developer.paciellogroup.com/blog/2013/12/using-aria-enhance-svg-accessibility/
    [ TypedSvg.title [] [ text c.svgTitle ]
    , TypedSvg.desc [] [ text c.svgDesc ]
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

        colorScale : ContinuousScale Float
        colorScale =
            Scale.linear ( 0, 1 ) (Maybe.withDefault ( 0, 0 ) linearDomain.y)

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

        ( sortedLinearData, sortedPoints ) =
            linearData
                |> List.map
                    (\d ->
                        let
                            points =
                                d.points
                                    |> List.sortBy Tuple.first
                        in
                        ( { d | points = points }, points )
                    )
                |> List.unzip

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

        color idx =
            Helpers.mergeStyles
                [ ( "fill", "none" ) ]
                (colorStyle c (Just idx) Nothing)

        colorSymbol idx =
            colorStyle c (Just idx) Nothing
    in
    svg
        [ viewBox 0 0 outerW outerH
        , width outerW
        , height outerH
        , role "img"
        , ariaLabelledby "title desc"
        ]
    <|
        symbolElements config
            ++ descAndTitle c
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
                                , color idx
                                    |> style
                                ]
                        )
                        sortedLinearData
               ]
            ++ [ g
                    [ transform [ Translate m.left m.top ]
                    , class [ "series" ]
                    ]
                    (sortedLinearData
                        |> List.indexedMap
                            (\idx d ->
                                d.points
                                    |> List.map
                                        (\( x, y ) ->
                                            drawSymbol config
                                                { idx = idx
                                                , x = Scale.convert xLinearScale x
                                                , y = Scale.convert yScale y
                                                , styleStr = colorSymbol idx
                                                }
                                        )
                            )
                        |> List.concat
                        |> List.concat
                    )
               ]



--++ [ g
--        [ transform [ Translate m.left m.top ]
--        , class [ "points" ]
--        ]
--     <|
--        List.indexedMap
--            (\idx d ->
--                g
--                    [ class
--                        [ "line-point"
--                        , "line-point-" ++ String.fromInt idx
--                        ]
--                    ]
--                <|
--                    List.map
--                        (\( dx, dy ) ->
--                            g
--                                [ fillOpacity (Opacity 0)
--                                , stroke (Paint Color.black)
--                                , transform
--                                    [ Translate
--                                        (Scale.convert
--                                            xLinearScale
--                                            dx
--                                            - 6
--                                        )
--                                        (Scale.convert
--                                            yScale
--                                            dy
--                                            - 6
--                                        )
--                                    ]
--                                ]
--                                [ circle_ 6 ]
--                        )
--                        d
--            )
--            sortedPoints
--   ]
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

        colorScale : ContinuousScale Float
        colorScale =
            Scale.linear ( 0, 1 ) (Maybe.withDefault ( 0, 0 ) linearDomain.y)

        color idx =
            Helpers.mergeStyles
                [ ( "fill", "none" ) ]
                (colorStyle c (Just idx) Nothing)

        colorSymbol idx =
            colorStyle c (Just idx) Nothing

        dataStacked : List ( String, List Float )
        dataStacked =
            dataLinearGroupToDataLinearStacked linearData

        stackedConfig : StackConfig String
        stackedConfig =
            { data = dataStacked
            , offset = getOffset config
            , order = identity
            }

        { values, extent } =
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
        symbolElements config
            ++ descAndTitle c
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
                                , color idx
                                    |> style
                                ]
                        )
                        combinedData
               ]
            ++ [ g
                    [ transform [ Translate m.left m.top ]
                    , class [ "series" ]
                    ]
                    (combinedData
                        |> List.indexedMap
                            (\idx d ->
                                d
                                    |> List.map
                                        (\( x, y ) ->
                                            drawSymbol config
                                                { idx = idx
                                                , x = Scale.convert xLinearScale x
                                                , y = Scale.convert yScale y
                                                , styleStr = colorSymbol idx
                                                }
                                        )
                            )
                        |> List.concat
                        |> List.concat
                    )
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


symbolsToSymbolElements : List Symbol -> List (Svg msg)
symbolsToSymbolElements symbols =
    symbols
        |> List.map
            (\symbol ->
                let
                    s =
                        TypedSvg.symbol
                            [ Html.Attributes.id (symbolToId symbol) ]
                in
                case symbol of
                    Circle c ->
                        s [ circle_ (c.size |> Maybe.withDefault defaultSymbolSize) ]

                    Custom c ->
                        --TODO
                        s [ custom 1 c ]

                    Corner c ->
                        s [ corner (c.size |> Maybe.withDefault defaultSymbolSize) ]

                    Triangle c ->
                        s [ triangle (c.size |> Maybe.withDefault defaultSymbolSize) ]

                    NoSymbol ->
                        s []
            )


drawSymbol :
    Config
    -> { idx : Int, x : Float, y : Float, styleStr : String }
    -> List (Svg msg)
drawSymbol config { idx, x, y, styleStr } =
    let
        conf =
            fromConfig config

        symbol =
            getSymbolByIndex conf.icons idx

        symbolRef =
            [ TypedSvg.use [ xlinkHref <| "#" ++ symbolToId symbol ] [] ]

        size c =
            c.size |> Maybe.withDefault defaultSymbolSize

        circleSize c =
            c.size |> Maybe.withDefault defaultSymbolSize

        st styles =
            Helpers.mergeStyles styles styleStr
                |> style
    in
    if showIcons config then
        case symbol of
            Triangle c ->
                [ g
                    [ transform
                        [ Translate (x - size c / 2) (y - size c / 2) ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            Circle c ->
                [ g
                    [ transform [ Translate (x - circleSize c / 2) (y - circleSize c / 2) ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            Corner c ->
                [ g
                    [ transform [ Translate (x - size c / 2) (y - size c / 2) ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            Custom c ->
                let
                    gap =
                        if c.useGap then
                            symbolGap

                        else
                            0
                in
                [ g
                    [ transform [ Translate x y ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            NoSymbol ->
                []

    else
        []



--  HELPERS


symbolElements : Config -> List (Svg msg)
symbolElements config =
    case fromConfig config |> .layout of
        StackedLine ->
            if showIcons config then
                symbolsToSymbolElements (getIcons config)

            else
                []

        GroupedLine ->
            if showIcons config then
                symbolsToSymbolElements (getIcons config)

            else
                []

        _ ->
            []


defaultSymbolSize : Float
defaultSymbolSize =
    10

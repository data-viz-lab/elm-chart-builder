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
        , getSymbolSize
        , symbolToId
        , triangle
        )
import Chart.Internal.Table as Table
import Chart.Internal.TableHelpers as Helpers
import Chart.Internal.Type
    exposing
        ( AccessibilityContent(..)
        , AccessorLinearTime(..)
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
        , ShowLabel(..)
        , ariaLabelledby
        , bottomGap
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
        , getShowLabels
        , getWidth
        , leftGap
        , role
        , showIcons
        )
import Html exposing (Html)
import Html.Attributes
import Path exposing (Path)
import Scale exposing (ContinuousScale)
import Shape exposing (StackConfig)
import Time exposing (Posix)
import TypedSvg exposing (g, svg, text_)
import TypedSvg.Attributes
    exposing
        ( class
        , dominantBaseline
        , style
        , textAnchor
        , transform
        , viewBox
        , xlinkHref
        )
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types
    exposing
        ( AlignmentBaseline(..)
        , AnchorAlignment(..)
        , DominantBaseline(..)
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

        ( sortedLinearData, _ ) =
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

        tableHeadings =
            Helpers.dataLinearGroupToTableHeadings data
                |> Table.ComplexHeadings

        tableData =
            Helpers.dataLinearGroupToTableData data

        table =
            Table.generate tableData
                |> Table.setColumnHeadings tableHeadings
                |> Table.view

        svgEl =
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
                    ++ drawLinearLine config xLinearScale yScale sortedLinearData

        tableEl =
            Helpers.invisibleFigcaption
                [ case table of
                    Ok table_ ->
                        Html.div [] [ table_ ]

                    Err error ->
                        Html.text (Table.errorToString error)
                ]
    in
    case c.accessibilityContent of
        AccessibilityTable ->
            Html.div []
                [ Html.figure
                    []
                    [ svgEl, tableEl ]
                ]

        AccessibilityNone ->
            Html.div [] [ svgEl ]



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

        linearDomain : DomainLinearStruct
        linearDomain =
            linearData
                |> getDomainLinearFromData config

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

        combinedData : List DataGroupLinear
        combinedData =
            Helpers.stackDataGroupLinear values linearData

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

        tableHeadings =
            Helpers.dataLinearGroupToTableHeadings data
                |> Table.ComplexHeadings

        tableData =
            Helpers.dataLinearGroupToTableData data

        table =
            Table.generate tableData
                |> Table.setColumnHeadings tableHeadings
                |> Table.view

        svgEl =
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
                    ++ drawLinearLine config xLinearScale yScale combinedData

        tableEl =
            Helpers.invisibleFigcaption
                [ case table of
                    Ok table_ ->
                        Html.div [] [ table_ ]

                    Err error ->
                        Html.text (Table.errorToString error)
                ]
    in
    case c.accessibilityContent of
        AccessibilityTable ->
            Html.div []
                [ Html.figure
                    []
                    [ svgEl, tableEl ]
                ]

        AccessibilityNone ->
            Html.div [] [ svgEl ]


timeAxisGenerator : ConfigStruct -> AxisType -> Maybe (ContinuousScale Posix) -> List (Svg msg)
timeAxisGenerator c axisType scale =
    if c.showXAxis == True then
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
    if c.showYAxis == True then
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


drawLinearLine :
    Config
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> List DataGroupLinear
    -> List (Svg msg)
drawLinearLine config xScale yScale sortedData =
    let
        c =
            fromConfig config

        m =
            getMargin config

        lineGenerator : PointLinear -> Maybe ( Float, Float )
        lineGenerator ( x, y ) =
            Just ( Scale.convert xScale x, Scale.convert yScale y )

        line : DataGroupLinear -> Path
        line dataGroup =
            dataGroup.points
                |> List.map lineGenerator
                |> Shape.line c.curve

        colorSymbol idx =
            colorStyle c (Just idx) Nothing

        color idx =
            Helpers.mergeStyles
                [ ( "fill", "none" ) ]
                (colorStyle c (Just idx) Nothing)

        label : Int -> Maybe String -> List PointLinear -> Svg msg
        label i s d =
            d
                |> List.reverse
                |> List.head
                |> Maybe.map (horizontalLabel config xScale yScale i s)
                |> Maybe.withDefault (text_ [] [])
    in
    [ g
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
            sortedData
    , g
        [ transform [ Translate m.left m.top ]
        , class [ "series" ]
        ]
      <|
        (sortedData
            |> List.indexedMap
                (\idx { groupLabel, points } ->
                    label idx groupLabel points
                )
        )
    , g
        [ transform [ Translate m.left m.top ]
        , class [ "series" ]
        ]
        (sortedData
            |> List.indexedMap
                (\idx d ->
                    d.points
                        |> List.map
                            (\( x, y ) ->
                                drawSymbol config
                                    { idx = idx
                                    , x = Scale.convert xScale x
                                    , y = Scale.convert yScale y
                                    , styleStr = colorSymbol idx
                                    }
                            )
                )
            |> List.concat
            |> List.concat
        )
    ]



-- LABEL HELPERS


horizontalLabel :
    Config
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Int
    -> Maybe String
    -> PointLinear
    -> Svg msg
horizontalLabel config xScale yScale idx groupLabel point =
    case groupLabel of
        Just label ->
            let
                conf =
                    fromConfig config

                ( xVal, yVal ) =
                    point

                xPos =
                    Scale.convert xScale xVal
                        |> Helpers.floorFloat

                yPos =
                    Scale.convert yScale yVal
                        |> Helpers.floorFloat

                symbol =
                    getSymbolByIndex conf.icons idx

                labelOffset =
                    symbol
                        |> getSymbolSize
                        |> Maybe.withDefault defaultSymbolSize
                        |> (+) labelGap

                showLabels =
                    getShowLabels config

                txt =
                    text_
                        [ y yPos
                        , x (xPos + labelOffset)
                        , textAnchor AnchorStart
                        , dominantBaseline DominantBaselineMiddle
                        ]
            in
            case showLabels of
                XGroupLabel ->
                    txt [ text label ]

                _ ->
                    text_ [] []

        Nothing ->
            text_ [] []



-- CONSTANTS


labelGap : Float
labelGap =
    2

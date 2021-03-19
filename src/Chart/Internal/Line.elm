module Chart.Internal.Line exposing
    ( renderLineGrouped
    , renderLineStacked
    )

import Axis
import Chart.Internal.Axis as ChartAxis
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
        , AccessorContinuousOrTime(..)
        , ColorResource(..)
        , Config
        , ConfigStruct
        , DataContinuousGroup(..)
        , DataGroupContinuous
        , DataGroupContinuousWithStack
        , DomainContinuousStruct
        , DomainTimeStruct
        , Label(..)
        , Layout(..)
        , LineDraw(..)
        , PointContinuous
        , RenderContext(..)
        , ariaLabelledby
        , bottomGap
        , colorStyle
        , dataContinuousGroupToDataContinuous
        , dataContinuousGroupToDataContinuousStacked
        , dataContinuousGroupToDataTime
        , descAndTitle
        , fromConfig
        , getDomainContinuous
        , getDomainContinuousFromData
        , getDomainTime
        , getDomainTimeFromData
        , leftGap
        , role
        , showIcons
        , toContinousScale
        )
import Html exposing (Html)
import Html.Attributes
import List.Extra
import Path exposing (Path)
import Scale exposing (ContinuousScale)
import Shape exposing (StackConfig, StackResult)
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



-- GROUPED


renderLineGrouped : ( DataContinuousGroup, Config ) -> Html msg
renderLineGrouped ( data, config ) =
    let
        c =
            fromConfig config

        m =
            c.margin

        w =
            c.width

        h =
            c.height

        outerW =
            w + m.left + m.right

        outerH =
            h + m.top + m.bottom

        continuousData : List DataGroupContinuous
        continuousData =
            data
                |> dataContinuousGroupToDataContinuous

        timeDomain : DomainTimeStruct
        timeDomain =
            timeData
                |> getDomainTimeFromData Nothing (getDomainTime config)

        continuousDomain : DomainContinuousStruct
        continuousDomain =
            case data of
                DataTime _ ->
                    timeDomainToContinuousDomain timeDomain

                DataContinuous _ ->
                    continuousData
                        |> getDomainContinuousFromData Nothing (getDomainContinuous config)

        timeData =
            data
                |> dataContinuousGroupToDataTime

        xRange =
            ( 0, w )

        yRange =
            ( h, 0 )

        ( sortedContinuousData, _ ) =
            continuousData
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

        xContinuousScale : ContinuousScale Float
        xContinuousScale =
            Scale.linear
                xRange
                (Maybe.withDefault ( 0, 0 ) continuousDomain.x)

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
            toContinousScale yRange (Maybe.withDefault ( 0, 0 ) continuousDomain.y) c.yScale

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
                    ++ continuousYAxis c yScale
                    ++ continuousOrTimeAxisGenerator xTimeScale xContinuousScale ( data, config )
                    ++ drawContinuousLine config xContinuousScale yScale sortedContinuousData
    in
    case c.accessibilityContent of
        AccessibilityNone ->
            Html.div [] [ svgEl ]

        _ ->
            Html.div []
                [ Html.figure
                    []
                    [ svgEl, tableElement config data ]
                ]



-- STACKED


renderLineStacked : LineDraw -> ( DataContinuousGroup, Config ) -> Html msg
renderLineStacked lineDraw ( data, config ) =
    let
        c =
            fromConfig config

        m =
            c.margin

        w =
            c.width

        h =
            c.height

        outerW =
            w + m.left + m.right

        outerH =
            h + m.top + m.bottom

        continuousData : List DataGroupContinuous
        continuousData =
            data
                |> dataContinuousGroupToDataContinuous

        continuousDomain : DomainContinuousStruct
        continuousDomain =
            case data of
                DataTime _ ->
                    timeDomainToContinuousDomain timeDomain

                DataContinuous _ ->
                    continuousData
                        |> getDomainContinuousFromData (Just stackResult.extent) (getDomainContinuous config)

        dataStacked : List ( String, List Float )
        dataStacked =
            dataContinuousGroupToDataContinuousStacked continuousData

        stackedConfig : StackConfig String
        stackedConfig =
            case lineDraw of
                Line ->
                    { data = dataStacked
                    , offset = Shape.stackOffsetNone
                    , order = identity
                    }

                Area stackingMethod ->
                    { data = dataStacked
                    , offset = stackingMethod

                    --TODO: this might need some thinking
                    , order = identity
                    }

        stackResult =
            Shape.stack stackedConfig

        combinedData : List DataGroupContinuous
        combinedData =
            Helpers.stackDataGroupContinuous stackResult.values continuousData

        timeData =
            data
                |> dataContinuousGroupToDataTime

        timeDomain =
            timeData
                |> getDomainTimeFromData (Just stackResult.extent) (getDomainTime config)

        xRange =
            ( 0, w )

        yRange =
            ( h, 0 )

        xContinuousScale : ContinuousScale Float
        xContinuousScale =
            Scale.linear
                xRange
                (Maybe.withDefault ( 0, 0 ) continuousDomain.x)

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
            toContinousScale yRange
                (Maybe.withDefault ( 0, 0 ) continuousDomain.y)
                c.yScale

        draw =
            case lineDraw of
                Line ->
                    drawContinuousLine config xContinuousScale yScale combinedData

                Area _ ->
                    drawAreas config xContinuousScale yScale stackResult combinedData

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
                    ++ continuousYAxis c yScale
                    ++ continuousOrTimeAxisGenerator xTimeScale xContinuousScale ( data, config )
                    ++ draw
    in
    case c.accessibilityContent of
        AccessibilityNone ->
            Html.div [] [ svgEl ]

        _ ->
            Html.div []
                [ Html.figure
                    []
                    [ svgEl, tableElement config data ]
                ]


continuousXAxis : ConfigStruct -> ContinuousScale Float -> List (Svg msg)
continuousXAxis c scale =
    if c.showXAxis == True then
        case c.axisXContinuous of
            ChartAxis.Bottom attributes ->
                [ g
                    [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                    , class [ "axis", "axis--x" ]
                    ]
                    [ Axis.bottom attributes scale ]
                ]

            ChartAxis.Top attributes ->
                [ g
                    [ transform [ Translate c.margin.left c.margin.top ]
                    , class [ "axis", "axis--x" ]
                    ]
                    [ Axis.top attributes scale ]
                ]

    else
        []


timeXAxis : ConfigStruct -> Maybe (ContinuousScale Posix) -> List (Svg msg)
timeXAxis c scale =
    if c.showXAxis == True then
        case scale of
            Just s ->
                case c.axisXTime of
                    ChartAxis.Bottom attributes ->
                        [ g
                            [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                            , class [ "axis", "axis--x" ]
                            ]
                            [ Axis.bottom attributes s ]
                        ]

                    ChartAxis.Top attributes ->
                        --FIXME
                        [ g
                            [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                            , class [ "axis", "axis--x" ]
                            ]
                            [ Axis.top attributes s ]
                        ]

            _ ->
                []

    else
        []


continuousYAxis : ConfigStruct -> ContinuousScale Float -> List (Svg msg)
continuousYAxis c scale =
    if c.showYAxis == True then
        case c.axisYContinuous of
            ChartAxis.Left attributes ->
                [ g
                    [ transform [ Translate (c.margin.left - leftGap |> Helpers.floorFloat) c.margin.top ]
                    , class [ "axis", "axis--y" ]
                    ]
                    [ Axis.left attributes scale ]
                ]

            ChartAxis.Right attributes ->
                [ g
                    [ transform
                        [ Translate
                            (c.width + c.margin.left + leftGap |> Helpers.floorFloat)
                            c.margin.top
                        ]
                    , class [ "axis", "axis--y" ]
                    ]
                    [ Axis.right attributes scale ]
                ]

            ChartAxis.Grid attributes ->
                let
                    rightAttrs =
                        attributes
                            ++ [ Axis.tickSizeInner (c.width |> Helpers.floorFloat)
                               , Axis.tickPadding (c.margin.right + c.margin.left)
                               ]

                    leftAttrs =
                        attributes
                            ++ [ Axis.tickSizeInner 0
                               ]
                in
                [ g
                    [ transform [ Translate (c.margin.left - leftGap |> Helpers.floorFloat) c.margin.top ]
                    , class [ "axis", "axis--y", "axis--y-left" ]
                    ]
                    [ Axis.left leftAttrs scale ]
                , g
                    [ transform [ Translate (c.margin.left - leftGap |> Helpers.floorFloat) c.margin.top ]
                    , class [ "axis", "axis--y", "axis--y-right" ]
                    ]
                    [ Axis.right rightAttrs scale ]
                ]

    else
        []


continuousOrTimeAxisGenerator :
    Maybe (ContinuousScale Posix)
    -> ContinuousScale Float
    -> ( DataContinuousGroup, Config )
    -> List (Svg msg)
continuousOrTimeAxisGenerator xTimeScale xContinuousScale ( data, config ) =
    let
        c =
            fromConfig config
    in
    case data of
        DataTime _ ->
            timeXAxis c xTimeScale

        DataContinuous _ ->
            continuousXAxis c xContinuousScale


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
    let
        c =
            fromConfig config
    in
    case c.layout of
        StackedLine _ ->
            if showIcons config then
                symbolsToSymbolElements c.icons

            else
                []

        GroupedLine ->
            if showIcons config then
                symbolsToSymbolElements c.icons

            else
                []

        _ ->
            []


defaultSymbolSize : Float
defaultSymbolSize =
    10


drawAreas :
    Config
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> StackResult String
    -> List DataGroupContinuous
    -> List (Svg msg)
drawAreas config xScale yScale stackedResult combinedData =
    let
        c =
            fromConfig config

        m =
            c.margin

        values =
            stackedResult.values

        mapper : ( ( Float, Float ), PointContinuous ) -> Maybe ( ( Float, Float ), ( Float, Float ) )
        mapper pointWithStack =
            let
                xCoord =
                    pointWithStack
                        |> Tuple.second
                        |> Tuple.first
                        |> Scale.convert xScale

                ( y1, y2 ) =
                    Tuple.first pointWithStack

                ( low, high ) =
                    if y1 < y2 then
                        ( y1, y2 )

                    else
                        ( y2, y1 )
            in
            Just
                ( ( xCoord, Scale.convert yScale low )
                , ( xCoord, Scale.convert yScale high )
                )

        toArea : DataGroupContinuousWithStack -> Path
        toArea combinedWithStack =
            List.map mapper combinedWithStack.points
                |> Shape.area c.curve

        styles idx =
            colorStyle c (Just idx) Nothing
                |> Helpers.mergeStyles []
                |> Helpers.mergeStyles c.coreStyle
                |> style

        renderStream : Int -> DataGroupContinuousWithStack -> Svg msg
        renderStream idx combinedWithStack =
            Path.element (toArea combinedWithStack)
                [ class [ "area", "area-" ++ String.fromInt idx ]
                , styles idx
                ]

        combinedDataWithStack : List DataGroupContinuousWithStack
        combinedDataWithStack =
            List.map2
                (\v combined ->
                    { groupLabel = combined.groupLabel, points = List.Extra.zip v combined.points }
                )
                values
                combinedData

        paths =
            combinedDataWithStack
                |> List.indexedMap renderStream
    in
    [ g
        [ transform [ Translate m.left m.top ]
        , class [ "series" ]
        ]
        paths
    , g
        [ transform [ Translate m.left m.top ]
        , class [ "series" ]
        ]
      <|
        (combinedDataWithStack
            |> List.indexedMap
                (\idx combinedItem ->
                    areaLabel config xScale yScale idx combinedItem
                )
        )
    , symbolGroup config xScale yScale combinedData
    ]


drawContinuousLine :
    Config
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> List DataGroupContinuous
    -> List (Svg msg)
drawContinuousLine config xScale yScale sortedData =
    let
        c =
            fromConfig config

        m =
            c.margin

        lineGenerator : PointContinuous -> Maybe ( Float, Float )
        lineGenerator ( x, y ) =
            Just ( Scale.convert xScale x, Scale.convert yScale y )

        line : DataGroupContinuous -> Path
        line dataGroup =
            dataGroup.points
                |> List.map lineGenerator
                |> Shape.line c.curve

        styles idx =
            colorStyle c (Just idx) Nothing
                |> Helpers.mergeStyles [ ( "fill", "none" ) ]
                |> Helpers.mergeStyles c.coreStyle
                |> style

        label : Int -> Maybe String -> List PointContinuous -> Svg msg
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
                    , styles idx
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
    , symbolGroup config xScale yScale sortedData
    ]



-- LABEL HELPERS


areaLabel :
    Config
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Int
    -> DataGroupContinuousWithStack
    -> Svg msg
areaLabel config xScale yScale _ item =
    case item.groupLabel of
        Just label ->
            let
                conf =
                    fromConfig config

                ( xVal, yVal ) =
                    item.points
                        |> List.reverse
                        |> List.head
                        |> Maybe.map
                            (\( stack, ( x, _ ) ) ->
                                ( x, (Tuple.second stack - Tuple.first stack) / 2 + Tuple.first stack )
                            )
                        |> Maybe.withDefault ( 0, 0 )

                xPos =
                    Scale.convert xScale xVal
                        |> Helpers.floorFloat

                yPos =
                    Scale.convert yScale yVal
                        |> Helpers.floorFloat

                txt =
                    text_
                        [ y yPos
                        , x (xPos + labelGap)
                        , textAnchor AnchorStart
                        , dominantBaseline DominantBaselineMiddle
                        , class [ "label" ]
                        ]
            in
            case conf.showLabels of
                XGroupLabel ->
                    txt [ text label ]

                _ ->
                    text_ [] []

        Nothing ->
            text_ [] []


horizontalLabel :
    Config
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Int
    -> Maybe String
    -> PointContinuous
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

                txt =
                    text_
                        [ y yPos
                        , x (xPos + labelOffset)
                        , textAnchor AnchorStart
                        , dominantBaseline DominantBaselineMiddle
                        , class [ "label" ]
                        ]
            in
            case conf.showLabels of
                XGroupLabel ->
                    txt [ text label ]

                _ ->
                    text_ [] []

        Nothing ->
            text_ [] []


tableElement : Config -> DataContinuousGroup -> Html msg
tableElement config data =
    let
        c =
            fromConfig config

        tableHeadings =
            Helpers.dataContinuousGroupToTableHeadings data c.accessibilityContent

        tableData =
            Helpers.dataContinuousGroupToTableData c data

        table =
            Table.generate tableData
                |> Table.setColumnHeadings tableHeadings
                |> Table.view
    in
    Helpers.invisibleFigcaption
        [ case table of
            Ok table_ ->
                Html.div [] [ table_ ]

            Err error ->
                Html.text (Table.errorToString error)
        ]


symbolGroup :
    Config
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> List DataGroupContinuous
    -> Svg msg
symbolGroup config xScale yScale combinedData =
    let
        c =
            fromConfig config

        m =
            c.margin

        colorSymbol idx =
            colorStyle c (Just idx) Nothing
    in
    g
        [ transform [ Translate m.left m.top ]
        , class [ "series" ]
        ]
        (combinedData
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



-- CONSTANTS


labelGap : Float
labelGap =
    2



-- HELPERS


timeDomainToContinuousDomain : DomainTimeStruct -> DomainContinuousStruct
timeDomainToContinuousDomain timeDomain =
    timeDomain
        |> (\{ x, y } ->
                { x =
                    x
                        |> Maybe.map
                            (\( a, b ) ->
                                ( a |> Time.posixToMillis |> toFloat
                                , b |> Time.posixToMillis |> toFloat
                                )
                            )
                , y = y
                }
           )

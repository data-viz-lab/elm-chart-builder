module Chart.Internal.Line exposing
    ( renderLineGrouped
    , renderLineStacked
    )

import Axis
import Chart.Internal.Axis as ChartAxis
import Chart.Internal.Constants as Constants
import Chart.Internal.Event as Event
import Chart.Internal.Helpers as Helpers
import Chart.Internal.Symbol as Symbol
    exposing
        ( Symbol(..)
        , SymbolContext(..)
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
        , ariaLabelledbyContent
        , bottomGap
        , colorStyle
        , dataContinuousGroupToDataContinuous
        , dataContinuousGroupToDataContinuousStacked
        , dataContinuousGroupToDataTime
        , descAndTitle
        , fromConfig
        , getAnnotationPointHint
        , getAnnotationVLine
        , getDomainContinuous
        , getDomainContinuousFromData
        , getDomainTime
        , getDomainTimeFromData
        , isStackedLine
        , leftGap
        , role
        , showIcons
        , toContinousScale
        )
import Color
import Html exposing (Html)
import Html.Attributes
import List.Extra
import Path exposing (Path)
import Scale exposing (ContinuousScale)
import Shape exposing (StackConfig, StackResult)
import Time exposing (Posix)
import TypedSvg exposing (g, line, svg, text_)
import TypedSvg.Attributes
    exposing
        ( class
        , dominantBaseline
        , opacity
        , stroke
        , style
        , textAnchor
        , transform
        , viewBox
        , xlinkHref
        )
import TypedSvg.Attributes.InPx
    exposing
        ( height
        , strokeWidth
        , width
        , x
        , x1
        , x2
        , y
        , y1
        , y2
        )
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types
    exposing
        ( AnchorAlignment(..)
        , DominantBaseline(..)
        , Opacity(..)
        , Paint(..)
        , Transform(..)
        )



-- GROUPED


renderLineGrouped : ( DataContinuousGroup, Config msg validation ) -> Html msg
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

        events =
            c.events
                |> List.map
                    (\e ->
                        case e of
                            Event.HoverOne f ->
                                Event.hoverOne c continuousData ( xContinuousScale, yScale ) f

                            Event.HoverAll f ->
                                Event.hoverAll c continuousData ( xContinuousScale, yScale ) f
                    )
                |> List.concat

        svgEl =
            svg
                ([ viewBox 0 0 outerW outerH
                 , width outerW
                 , height outerH
                 , role "img"
                 ]
                    ++ ariaLabelledbyContent c
                    ++ events
                )
            <|
                vLineAnnotation c
                    ++ symbolElements config
                    ++ descAndTitle c
                    ++ continuousYAxis c yScale
                    ++ continuousOrTimeAxisGenerator xTimeScale xContinuousScale ( data, config )
                    ++ drawContinuousLine config xContinuousScale yScale sortedContinuousData

        classNames =
            Html.Attributes.classList
                [ ( Constants.rootClassName, True )
                , ( Constants.lineClassName, True )
                ]
    in
    case c.accessibilityContent of
        AccessibilityNone ->
            Html.div [ classNames ] [ svgEl ]

        _ ->
            Html.div [ classNames ]
                [ Html.figure
                    []
                    [ svgEl, tableElement config data ]
                ]



-- STACKED


renderLineStacked : LineDraw -> ( DataContinuousGroup, Config msg validation ) -> Html msg
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

        events =
            c.events
                |> List.map
                    (\e ->
                        case e of
                            Event.HoverOne f ->
                                Event.hoverOne c continuousData ( xContinuousScale, yScale ) f

                            Event.HoverAll f ->
                                Event.hoverAll c continuousData ( xContinuousScale, yScale ) f
                    )
                |> List.concat

        svgEl =
            svg
                ([ viewBox 0 0 outerW outerH
                 , width outerW
                 , height outerH
                 , role "img"
                 ]
                    ++ ariaLabelledbyContent c
                    ++ events
                )
            <|
                vLineAnnotation c
                    ++ symbolElements config
                    ++ descAndTitle c
                    ++ continuousYAxis c yScale
                    ++ continuousOrTimeAxisGenerator xTimeScale xContinuousScale ( data, config )
                    ++ draw

        classNames =
            Html.Attributes.classList
                [ ( Constants.rootClassName, True )
                , ( Constants.lineClassName, True )
                ]
    in
    case c.accessibilityContent of
        AccessibilityNone ->
            Html.div [ classNames ] [ svgEl ]

        _ ->
            Html.div [ classNames ]
                [ Html.figure
                    []
                    [ svgEl, tableElement config data ]
                ]


continuousXAxis : ConfigStruct msg -> ContinuousScale Float -> List (Svg msg)
continuousXAxis c scale =
    if c.showXAxis == True then
        case c.axisXContinuous of
            ChartAxis.Bottom attributes ->
                [ g
                    [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                    , class
                        [ Constants.axisClassName
                        , Constants.axisXClassName
                        , Constants.componentClassName
                        ]
                    ]
                    [ Axis.bottom attributes scale ]
                ]

            ChartAxis.Top attributes ->
                [ g
                    [ transform [ Translate c.margin.left c.margin.top ]
                    , class
                        [ Constants.axisClassName
                        , Constants.axisXClassName
                        , Constants.componentClassName
                        ]
                    ]
                    [ Axis.top attributes scale ]
                ]

    else
        []


timeXAxis : ConfigStruct msg -> Maybe (ContinuousScale Posix) -> List (Svg msg)
timeXAxis c scale =
    if c.showXAxis == True then
        case scale of
            Just s ->
                case c.axisXTime of
                    ChartAxis.Bottom attributes ->
                        [ g
                            [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                            , class
                                [ Constants.axisClassName
                                , Constants.axisXClassName
                                , Constants.componentClassName
                                ]
                            ]
                            [ Axis.bottom attributes s ]
                        ]

                    ChartAxis.Top attributes ->
                        --FIXME
                        [ g
                            [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                            , class
                                [ Constants.axisClassName
                                , Constants.axisXClassName
                                , Constants.componentClassName
                                ]
                            ]
                            [ Axis.top attributes s ]
                        ]

            _ ->
                []

    else
        []


continuousYAxis : ConfigStruct msg -> ContinuousScale Float -> List (Svg msg)
continuousYAxis c scale =
    if c.showYAxis == True then
        case c.axisYContinuous of
            ChartAxis.Left attributes ->
                [ g
                    [ transform [ Translate (c.margin.left - leftGap |> Helpers.floorFloat) c.margin.top ]
                    , class
                        [ Constants.axisClassName
                        , Constants.axisYClassName
                        , Constants.componentClassName
                        ]
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
                    , class
                        [ Constants.axisClassName
                        , Constants.axisYClassName
                        , Constants.componentClassName
                        ]
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
                    , class
                        [ Constants.axisClassName
                        , Constants.axisYClassName
                        , Constants.axisYLeftClassName
                        , Constants.componentClassName
                        ]
                    ]
                    [ Axis.left leftAttrs scale ]
                , g
                    [ transform [ Translate (c.margin.left - leftGap |> Helpers.floorFloat) c.margin.top ]
                    , class
                        [ Constants.axisClassName
                        , Constants.axisYClassName
                        , Constants.axisYRightClassName
                        , Constants.componentClassName
                        ]
                    ]
                    [ Axis.right rightAttrs scale ]
                ]

    else
        []


continuousOrTimeAxisGenerator :
    Maybe (ContinuousScale Posix)
    -> ContinuousScale Float
    -> ( DataContinuousGroup, Config msg validation )
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


{-| It takes a list of symbols, as defined in the Symbol module and
depending on the symbol context will:

  - Create an svg symbol containing a symbol shape to be referenced at (For a chart symbol)
  - Only create a symbol shape to be drawn directly and not referenced (For an annotatin symbol)

-}
symbolsToSymbolElements : SymbolContext -> List Symbol -> List (Svg msg)
symbolsToSymbolElements symbolContext symbols =
    symbols
        |> List.map
            (\symbol ->
                let
                    s =
                        TypedSvg.symbol
                            [ Html.Attributes.id (symbolToId symbol) ]

                    ( scaler, isAnnotationSymbol ) =
                        case symbolContext of
                            AnnotationSymbol scaler_ ->
                                ( scaler_, True )

                            ChartSymbol ->
                                ( 1, False )

                    size c =
                        c.size |> Maybe.withDefault defaultSymbolSize |> (*) scaler
                in
                case symbol of
                    Circle c ->
                        if isAnnotationSymbol then
                            circle_ (size c)

                        else
                            s [ circle_ (size c) ]

                    Custom c ->
                        if isAnnotationSymbol then
                            --TODO
                            custom scaler c

                        else
                            s [ custom 1 c ]

                    Corner c ->
                        if isAnnotationSymbol then
                            corner (size c)

                        else
                            s [ corner (size c) ]

                    Triangle c ->
                        if isAnnotationSymbol then
                            triangle (size c)

                        else
                            s [ triangle (size c) ]

                    NoSymbol ->
                        s []
            )


drawSymbol :
    Config msg validation
    -> { idx : Int, x : Float, y : Float, styleStr : String, symbolContext : SymbolContext }
    -> List (Svg msg)
drawSymbol config { idx, x, y, styleStr, symbolContext } =
    let
        conf =
            fromConfig config

        symbol =
            getSymbolByIndex conf.symbols idx

        ( scaler, isAnnotationSymbol ) =
            case symbolContext of
                AnnotationSymbol scaler_ ->
                    ( scaler_, True )

                ChartSymbol ->
                    ( 1, False )

        --The size here is used to appropriately transform the symbol shape
        size c =
            c.size
                |> Maybe.withDefault defaultSymbolSize
                |> (*) scaler

        --The size here is used to appropriately transform the symbol shape
        circleSize c =
            c.size
                |> Maybe.withDefault defaultSymbolSize
                |> (*) scaler

        annotationPointHint =
            getAnnotationPointHint conf.annotations

        annotationPointStyle =
            annotationPointHint
                |> Maybe.map Tuple.second
                |> Maybe.withDefault []

        st styles =
            Helpers.mergeStyles styles styleStr
                |> (\s ->
                        if isAnnotationSymbol then
                            Helpers.mergeStyles annotationPointStyle s

                        else
                            s
                   )
                |> style

        symbolEl s =
            if isAnnotationSymbol then
                symbolsToSymbolElements symbolContext [ s ]

            else
                -- if not an annotation symbol we do not build a symbol element,
                -- but we reference one
                [ TypedSvg.use [ xlinkHref <| "#" ++ symbolToId symbol ] [] ]
    in
    if showIcons config then
        case symbol of
            Triangle c ->
                [ g
                    [ transform
                        [ Translate (x - size c / 2) (y - size c / 2) ]
                    , class [ Constants.symbolClassName ]
                    , st c.styles
                    ]
                    (symbolEl symbol)
                ]

            Circle c ->
                [ g
                    [ transform [ Translate (x - circleSize c / 2) (y - circleSize c / 2) ]
                    , class [ Constants.symbolClassName ]
                    , st c.styles
                    ]
                    (symbolEl symbol)
                ]

            Corner c ->
                [ g
                    [ transform [ Translate (x - size c / 2) (y - size c / 2) ]
                    , class [ Constants.symbolClassName ]
                    , st c.styles
                    ]
                    (symbolEl symbol)
                ]

            Custom c ->
                [ g
                    [ transform [ Translate x y ]
                    , class [ Constants.symbolClassName ]
                    , st c.styles
                    ]
                    (symbolEl symbol)
                ]

            NoSymbol ->
                []

    else if isAnnotationSymbol then
        [ g
            [ transform
                [ Translate (x - (defaultSymbolSize * scaler) / 2)
                    (y - (defaultSymbolSize * scaler) / 2)
                ]
            , class [ Constants.symbolClassName ]
            , Helpers.mergeStyles annotationPointStyle ""
                |> style
            ]
            (symbolEl (Circle Symbol.initialConf))
        ]

    else
        []



--  HELPERS


{-| Creates the list of symbol elements to be referenced in the chart.
-}
symbolElements : Config msg validation -> List (Svg msg)
symbolElements config =
    let
        c =
            fromConfig config
    in
    case c.layout of
        StackedLine _ ->
            if showIcons config then
                symbolsToSymbolElements ChartSymbol c.symbols

            else
                []

        GroupedLine ->
            if showIcons config then
                symbolsToSymbolElements ChartSymbol c.symbols

            else
                []

        _ ->
            []


defaultSymbolSize : Float
defaultSymbolSize =
    10


drawAreas :
    Config msg validation
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
                [ class
                    [ Constants.areaShapeClassName
                    , Constants.areaShapeClassName ++ "-" ++ String.fromInt idx
                    ]
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
        , class [ Constants.componentClassName ]
        ]
        paths
    , g
        [ transform [ Translate m.left m.top ]
        , class [ Constants.componentClassName ]
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
    Config msg validation
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
        , class [ Constants.componentClassName ]
        ]
      <|
        List.indexedMap
            (\idx d ->
                Path.element (line d)
                    [ class
                        [ Constants.lineShapeClassName
                        , Constants.lineShapeClassName ++ "-" ++ String.fromInt idx
                        ]
                    , styles idx
                    ]
            )
            sortedData
    , g
        [ transform [ Translate m.left m.top ]
        , class [ Constants.componentClassName ]
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
    Config msg validation
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
                        , class [ Constants.labelClassName ]
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
    Config msg validation
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
                    getSymbolByIndex conf.symbols idx

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
                        , class [ Constants.labelClassName ]
                        ]
            in
            case conf.showLabels of
                XGroupLabel ->
                    txt [ text label ]

                _ ->
                    text_ [] []

        Nothing ->
            text_ [] []


tableElement : Config msg validation -> DataContinuousGroup -> Html msg
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
    Config msg validation
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

        annotationPointHint =
            getAnnotationPointHint c.annotations
                |> Maybe.map Tuple.first

        xMatch val =
            annotationPointHint
                |> Maybe.map (\a -> a.selection.x == val)
                |> Maybe.withDefault False

        yMatch val =
            annotationPointHint
                |> Maybe.map (\a -> List.member val (a.selection.y |> List.map .value))
                |> Maybe.withDefault False

        stackDeltas =
            getStackDeltas c combinedData
    in
    g
        [ transform [ Translate m.left m.top ]
        , class [ Constants.componentClassName ]
        ]
        (combinedData
            |> List.indexedMap
                (\idx d ->
                    let
                        deltas =
                            stackDeltas
                                |> List.Extra.getAt idx
                                |> Maybe.withDefault
                                    (d.points
                                        |> List.map (always ( 0, 0 ))
                                    )
                    in
                    d.points
                        |> List.map2
                            (\( _, delta ) ( x, y ) ->
                                let
                                    params =
                                        { idx = idx
                                        , x = Scale.convert xScale x
                                        , y = Scale.convert yScale y
                                        , styleStr = colorSymbol idx
                                        , symbolContext = ChartSymbol
                                        }
                                in
                                case annotationPointHint of
                                    Just _ ->
                                        if xMatch x && yMatch (y - delta) then
                                            drawSymbol config
                                                { params
                                                    | symbolContext =
                                                        AnnotationSymbol Symbol.annotationScaler
                                                }

                                        else
                                            drawSymbol config params

                                    Nothing ->
                                        drawSymbol config params
                            )
                            deltas
                )
            |> List.concat
            |> List.concat
        )


vLineAnnotation : ConfigStruct msg -> List (Svg msg)
vLineAnnotation c =
    --FIXME
    let
        annotation =
            getAnnotationVLine c.annotations
                |> Maybe.map Tuple.first

        style =
            getAnnotationVLine c.annotations
                |> Maybe.map Tuple.second
                |> Maybe.withDefault []
    in
    case annotation of
        Just a ->
            [ g
                [ transform [ Translate c.margin.left c.margin.top ]
                , class
                    [ Constants.componentClassName
                    , Constants.annotationClassName
                    , Constants.vLineAnnotationClassName
                    ]
                ]
                [ line
                    ((Helpers.mergeStyles style ""
                        |> TypedSvg.Attributes.style
                     )
                        :: [ x1 a.xPosition
                           , x2 a.xPosition
                           , y1 0
                           , y2 c.height
                           , strokeWidth 1
                           , opacity <| Opacity 0.7
                           , stroke <| Paint Color.black
                           ]
                    )
                    []
                ]
            ]

        Nothing ->
            []



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


getStackDeltas : ConfigStruct msg -> List DataGroupContinuous -> List (List ( Float, Float ))
getStackDeltas c data =
    if isStackedLine c then
        data
            |> List.map (.points >> List.map Tuple.second)
            |> List.Extra.transpose
            |> List.map Helpers.stackDeltas
            |> List.Extra.transpose
            |> List.map (\d -> List.map (\dd -> ( 0, dd )) d)

    else
        data
            |> List.map (.points >> List.map (always ( 0, 0 )))

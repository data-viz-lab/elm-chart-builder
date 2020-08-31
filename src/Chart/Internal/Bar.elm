module Chart.Internal.Bar exposing
    ( renderBandGrouped
    , renderBandStacked
    , renderHistogram
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
import Chart.Internal.Table as Table
import Chart.Internal.TableHelpers as Helpers
import Chart.Internal.Type
    exposing
        ( AccessibilityContent(..)
        , AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , ColorResource(..)
        , Config
        , ConfigStruct
        , DataBand
        , DataGroupBand
        , Direction(..)
        , DomainBand(..)
        , DomainBandStruct
        , DomainLinear(..)
        , Layout(..)
        , Orientation(..)
        , PointBand
        , RenderContext(..)
        , ShowLabel(..)
        , StackedValues
        , adjustLinearRange
        , ariaLabelledby
        , bottomGap
        , calculateHistogramDomain
        , calculateHistogramValues
        , colorCategoricalStyle
        , colorStyle
        , dataBandToDataStacked
        , externalToDataHistogram
        , fromConfig
        , fromDataBand
        , getAxisContinousDataFormatter
        , getBandGroupRange
        , getBandSingleRange
        , getDataBandDepth
        , getDomainBand
        , getDomainBandFromData
        , getHeight
        , getIcons
        , getLinearRange
        , getMargin
        , getOffset
        , getShowLabels
        , getStackedValuesAndGroupes
        , getWidth
        , leftGap
        , role
        , showIcons
        , stackedValuesInverse
        , symbolCustomSpace
        , symbolSpace
        , toConfig
        )
import Color
import Histogram exposing (Bin, HistogramGenerator, Threshold)
import Html exposing (Html)
import Html.Attributes
import List.Extra
import Scale exposing (BandScale, ContinuousScale, defaultBandConfig)
import Shape exposing (StackConfig)
import Statistics exposing (extent)
import TypedSvg exposing (g, rect, svg, text_)
import TypedSvg.Attributes
    exposing
        ( class
        , dominantBaseline
        , shapeRendering
        , style
        , textAnchor
        , title
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
        , ShapeRendering(..)
        , Transform(..)
        )


descAndTitle : ConfigStruct -> List (Svg msg)
descAndTitle c =
    -- https://developer.paciellogroup.com/blog/2013/12/using-aria-enhance-svg-accessibility/
    [ TypedSvg.title [] [ text c.svgTitle ]
    , TypedSvg.desc [] [ text c.svgDesc ]
    ]



-- BAND STACKED


renderBandStacked : ( DataBand, Config ) -> Html msg
renderBandStacked ( data, config ) =
    -- based on https://code.gampleman.eu/elm-visualization/StackedBarChart/
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

        dataStacked : List ( String, List Float )
        dataStacked =
            dataBandToDataStacked data config

        stackedConfig : StackConfig String
        stackedConfig =
            { data = dataStacked
            , offset = getOffset config
            , order = identity
            }

        { values, labels, extent } =
            Shape.stack stackedConfig

        stackDepth =
            getDataBandDepth data

        domain : DomainBandStruct
        domain =
            getDomainBandFromData data config

        linearDomain : Maybe Chart.Internal.Type.LinearDomain
        linearDomain =
            domain |> .linear

        linearExtent =
            case linearDomain of
                Just ld ->
                    case c.layout of
                        StackedBar direction ->
                            case direction of
                                Diverging ->
                                    ( Tuple.second ld * -1, Tuple.second ld )

                                _ ->
                                    extent

                        _ ->
                            extent

                Nothing ->
                    extent

        bandGroupRange =
            getBandGroupRange config w h

        bandSingleRange =
            getBandSingleRange config (Scale.bandwidth bandGroupScale)

        bandGroupScale =
            Scale.band { defaultBandConfig | paddingInner = 0.1, paddingOuter = 0.05 }
                bandGroupRange
                (Maybe.withDefault [] domain.bandGroup)

        bandSingleScale =
            Scale.band defaultBandConfig
                bandSingleRange
                (Maybe.withDefault [] domain.bandSingle)

        linearRange =
            getLinearRange config RenderChart w h bandSingleScale
                |> adjustLinearRange config stackDepth

        linearRangeAxis =
            getLinearRange config RenderAxis w h bandSingleScale

        linearScale : ContinuousScale Float
        linearScale =
            -- For stacked scales
            -- |> Scale.nice 4
            Scale.linear linearRange linearExtent

        linearScaleAxis : ContinuousScale Float
        linearScaleAxis =
            -- For stacked scales
            -- |> Scale.nice 4
            Scale.linear linearRangeAxis linearExtent

        ( columnValues, columnGroupes ) =
            getStackedValuesAndGroupes values data

        scaledValues : List StackedValues
        scaledValues =
            columnValues
                |> List.map
                    (List.map
                        (\vals ->
                            let
                                ( a1, a2 ) =
                                    vals.stackedValue
                            in
                            { vals
                                | stackedValue =
                                    ( Scale.convert linearScale a1 |> Helpers.floorFloat
                                    , Scale.convert linearScale a2 |> Helpers.floorFloat
                                    )
                            }
                        )
                    )

        axisBandScale : BandScale String
        axisBandScale =
            bandGroupScale

        svgEl =
            svg
                [ viewBox 0 0 outerW outerH
                , width outerW
                , height outerH
                , role "img"
                , ariaLabelledby "title desc"
                ]
                (descAndTitle c
                    ++ bandXAxis c axisBandScale
                    ++ bandGroupedYAxis c 0 linearScaleAxis
                    ++ [ g
                            [ transform [ stackedContainerTranslate c m.left m.top (toFloat stackDepth) ]
                            , class [ "series" ]
                            ]
                         <|
                            List.map (stackedColumns c bandGroupScale)
                                (List.map2 (\a b -> ( a, b, labels )) columnGroupes scaledValues)
                       ]
                )

        tableHeadings =
            Helpers.dataBandToTableHeadings data
                |> Table.ComplexHeadings

        tableData =
            Helpers.dataBandToTableData data

        table =
            Table.generate tableData
                |> Table.setColumnHeadings tableHeadings
                |> Table.view

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


stackedContainerTranslate : ConfigStruct -> Float -> Float -> Float -> Transform
stackedContainerTranslate config a b offset =
    let
        orientation =
            config |> .orientation
    in
    case orientation of
        Horizontal ->
            Translate (a - offset) b

        Vertical ->
            Translate a (b + offset)


stackedColumns : ConfigStruct -> BandScale String -> ( String, StackedValues, List String ) -> Svg msg
stackedColumns config bandGroupScale payload =
    let
        rects =
            case config.orientation of
                Vertical ->
                    verticalRectsStacked config bandGroupScale payload

                Horizontal ->
                    horizontalRectsStacked config bandGroupScale payload
    in
    g [ class [ "columns" ] ] rects


getLabel : Int -> List String -> String
getLabel idx l =
    List.Extra.getAt idx l
        |> Maybe.withDefault ""


getRectTitleText : AxisContinousDataTickFormat -> Int -> String -> List String -> Float -> String
getRectTitleText tickFormat idx group labels value =
    let
        formatter =
            getAxisContinousDataFormatter tickFormat
                |> Maybe.withDefault (\f -> String.fromFloat f)
    in
    group ++ " - " ++ getLabel idx labels ++ ": " ++ formatter value


verticalRectsStacked :
    ConfigStruct
    -> BandScale String
    -> ( String, StackedValues, List String )
    -> List (Svg msg)
verticalRectsStacked c bandGroupScale ( group, values, labels ) =
    let
        bandValue =
            Scale.convert bandGroupScale group

        block idx { rawValue, stackedValue } =
            let
                ( upper, lower ) =
                    stackedValue
            in
            g [ class [ "column", "column-" ++ String.fromInt idx ] ]
                [ rect
                    [ x <| bandValue
                    , y <| lower - toFloat idx
                    , width <| Scale.bandwidth bandGroupScale
                    , height <| (abs <| upper - lower)
                    , shapeRendering RenderCrispEdges
                    , colorCategoricalStyle c idx
                    ]
                    []
                , TypedSvg.title [] [ text <| getRectTitleText c.axisYContinousTickFormat idx group labels rawValue ]
                ]
    in
    List.indexedMap (\idx -> block idx) values


horizontalRectsStacked :
    ConfigStruct
    -> BandScale String
    -> ( String, StackedValues, List String )
    -> List (Svg msg)
horizontalRectsStacked c bandGroupScale ( group, values, labels ) =
    let
        block idx { rawValue, stackedValue } =
            let
                ( lower, upper ) =
                    stackedValue
            in
            g [ class [ "column", "column-" ++ String.fromInt idx ] ]
                [ rect
                    [ y <| Scale.convert bandGroupScale group
                    , x <| lower + toFloat idx
                    , height <| Scale.bandwidth bandGroupScale
                    , width <| (abs <| upper - lower)
                    , shapeRendering RenderCrispEdges
                    , colorCategoricalStyle c idx
                    ]
                    []
                , TypedSvg.title [] [ text <| getRectTitleText c.axisYContinousTickFormat idx group labels rawValue ]
                ]
    in
    values
        |> stackedValuesInverse c.width
        |> List.indexedMap (\idx -> block idx)



-- BAND GROUPED


renderBandGrouped : ( DataBand, Config ) -> Html msg
renderBandGrouped ( data, config ) =
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

        domain : DomainBandStruct
        domain =
            getDomainBandFromData data config

        bandGroupRange =
            getBandGroupRange config w h

        bandSingleRange =
            getBandSingleRange config (Scale.bandwidth bandGroupScale)

        linearRange =
            getLinearRange config RenderChart w h bandSingleScale

        dataLength =
            data |> fromDataBand |> List.length

        paddingInnerGroup =
            if dataLength == 1 then
                0

            else
                0.1

        bandGroupScale : BandScale String
        bandGroupScale =
            Scale.band { defaultBandConfig | paddingInner = paddingInnerGroup, paddingOuter = paddingInnerGroup }
                bandGroupRange
                (domain.bandGroup |> Maybe.withDefault [])

        bandSingleScale : BandScale String
        bandSingleScale =
            Scale.band { defaultBandConfig | paddingInner = 0.1, paddingOuter = 0.05 }
                bandSingleRange
                (Maybe.withDefault [] domain.bandSingle)

        linearScale : ContinuousScale Float
        linearScale =
            Scale.linear linearRange (Maybe.withDefault ( 0, 0 ) domain.linear)

        colorScale : ContinuousScale Float
        colorScale =
            Scale.linear ( 0, 1 ) (Maybe.withDefault ( 0, 0 ) domain.linear)

        iconOffset : Float
        iconOffset =
            symbolSpace Vertical bandSingleScale (getIcons config) + symbolGap

        symbolElements =
            case c.layout of
                GroupedBar ->
                    if showIcons config then
                        symbolsToSymbolElements c.orientation bandSingleScale (getIcons config)

                    else
                        []

                _ ->
                    []

        axisBandScale : BandScale String
        axisBandScale =
            if List.length (domain.bandGroup |> Maybe.withDefault []) > 1 then
                bandGroupScale

            else
                bandSingleScale

        tableHeadings =
            Helpers.dataBandToTableHeadings data
                |> Table.ComplexHeadings

        tableData =
            Helpers.dataBandToTableData data

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

                --TODO: this should only exist if we have a title and/or a desc
                , ariaLabelledby "title desc"
                ]
            <|
                symbolElements
                    ++ descAndTitle c
                    ++ bandGroupedYAxis c iconOffset linearScale
                    ++ bandXAxis c axisBandScale
                    ++ [ g
                            [ transform [ Translate m.left m.top ]
                            , class [ "series" ]
                            ]
                         <|
                            List.map
                                (columns config iconOffset bandGroupScale bandSingleScale linearScale colorScale)
                                (fromDataBand data)
                       ]

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


columns :
    Config
    -> Float
    -> BandScale String
    -> BandScale String
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> DataGroupBand
    -> Svg msg
columns config iconOffset bandGroupScale bandSingleScale linearScale colorScale dataGroup =
    let
        tr =
            case config |> fromConfig |> .orientation of
                Vertical ->
                    -- https://observablehq.com/@d3/grouped-bar-chart
                    -- .attr("transform", d => `translate(${x0(d[groupKey])},0)`)
                    Translate (dataGroupTranslation bandGroupScale dataGroup |> Helpers.floorFloat) 0

                Horizontal ->
                    Translate 0 (dataGroupTranslation bandGroupScale dataGroup |> Helpers.floorFloat)
    in
    g
        [ transform [ tr ]
        , class [ "data-group" ]
        ]
    <|
        List.indexedMap (column config iconOffset bandSingleScale linearScale colorScale) dataGroup.points


column :
    Config
    -> Float
    -> BandScale String
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Int
    -> PointBand
    -> Svg msg
column config iconOffset bandSingleScale linearScale colorScale idx point =
    let
        rectangle =
            case config |> fromConfig |> .orientation of
                Vertical ->
                    verticalRect config iconOffset bandSingleScale linearScale colorScale idx point

                Horizontal ->
                    horizontalRect config bandSingleScale linearScale colorScale idx point
    in
    g [ class [ "column", "column-" ++ String.fromInt idx ] ] rectangle


verticalRect :
    Config
    -> Float
    -> BandScale String
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Int
    -> PointBand
    -> List (Svg msg)
verticalRect config iconOffset bandSingleScale linearScale colorScale idx point =
    let
        ( x__, y__ ) =
            point

        c =
            fromConfig config

        stl =
            colorStyle c (Just idx) (Scale.convert colorScale y__ |> Just)

        label =
            verticalLabel config (x_ + w / 2) (y_ - labelGap) point

        x_ =
            Helpers.floorFloat <| Scale.convert bandSingleScale x__

        y_ =
            Scale.convert linearScale y__
                + iconOffset
                |> Helpers.floorFloat

        w =
            Helpers.floorFloat <| Scale.bandwidth bandSingleScale

        h =
            getHeight (toConfig c)
                - Scale.convert linearScale y__
                - iconOffset
                |> Helpers.floorFloat

        symbol =
            verticalSymbol config { idx = idx, x_ = x_, y_ = y_, w = w, styleStr = stl }
    in
    rect
        [ x <| x_
        , y <| y_
        , width <| w
        , height <| h
        , shapeRendering RenderCrispEdges
        , style stl
        ]
        []
        :: symbol
        ++ label


horizontalRect :
    Config
    -> BandScale String
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Int
    -> PointBand
    -> List (Svg msg)
horizontalRect config bandSingleScale linearScale colorScale idx point =
    let
        c =
            fromConfig config

        ( x__, y__ ) =
            point

        h =
            Helpers.floorFloat <| Scale.bandwidth bandSingleScale

        w =
            Helpers.floorFloat <| Scale.convert linearScale y__

        y_ =
            Helpers.floorFloat <| Scale.convert bandSingleScale x__

        stl =
            colorStyle c (Just idx) (Scale.convert colorScale y__ |> Just)

        label =
            horizontalLabel config (w + labelGap) (y_ + h / 2) point

        symbol =
            horizontalSymbol config { idx = idx, w = w, y_ = y_, h = h, styleStr = stl }
    in
    rect
        [ x <| 0
        , y y_
        , width w
        , height h
        , shapeRendering RenderCrispEdges
        , stl
            |> style
        ]
        []
        :: symbol
        ++ label


dataGroupTranslation : BandScale String -> DataGroupBand -> Float
dataGroupTranslation bandGroupScale dataGroup =
    case dataGroup.groupLabel of
        Nothing ->
            0

        Just l ->
            Scale.convert bandGroupScale l


verticalLabel : Config -> Float -> Float -> PointBand -> List (Svg msg)
verticalLabel config x_ y_ point =
    let
        c =
            fromConfig config

        ( x__, y__ ) =
            point

        showLabels =
            getShowLabels config

        txt =
            text_
                [ x x_
                , y y_
                , textAnchor AnchorMiddle
                ]
    in
    case showLabels of
        YLabel formatter ->
            [ txt [ text (y__ |> formatter) ] ]

        XOrdinalLabel ->
            [ txt [ text x__ ] ]

        _ ->
            []


horizontalSymbol :
    Config
    -> { idx : Int, w : Float, y_ : Float, h : Float, styleStr : String }
    -> List (Svg msg)
horizontalSymbol config { idx, w, y_, styleStr } =
    let
        symbol =
            getSymbolByIndex (getIcons config) idx

        symbolRef =
            [ TypedSvg.use [ xlinkHref <| "#" ++ symbolToId symbol ] [] ]

        st styles =
            Helpers.mergeStyles styles styleStr
                |> style
    in
    if showIcons config then
        case symbol of
            Triangle c ->
                [ g
                    [ transform [ Translate (w + symbolGap) y_ ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            Circle c ->
                [ g
                    [ transform [ Translate (w + symbolGap) y_ ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            Corner c ->
                [ g
                    [ transform [ Translate (w + symbolGap) y_ ]
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
                    [ transform [ Translate (w + gap) y_ ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            NoSymbol ->
                []

    else
        []


verticalSymbol :
    Config
    -> { idx : Int, w : Float, y_ : Float, x_ : Float, styleStr : String }
    -> List (Svg msg)
verticalSymbol config { idx, w, y_, x_, styleStr } =
    --TODO: merge styles
    let
        symbol =
            getSymbolByIndex (getIcons config) idx

        symbolRef =
            [ TypedSvg.use [ xlinkHref <| "#" ++ symbolToId symbol ] [] ]

        st styles =
            Helpers.mergeStyles styles styleStr
                |> style
    in
    if showIcons config then
        case symbol of
            Triangle c ->
                [ g
                    [ transform [ Translate x_ (y_ - w - symbolGap) ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            Circle c ->
                [ g
                    [ transform [ Translate x_ (y_ - w - symbolGap) ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            Corner c ->
                [ g
                    [ transform [ Translate x_ (y_ - w - symbolGap) ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            Custom c ->
                let
                    space =
                        symbolCustomSpace Vertical w c

                    gap =
                        if c.useGap then
                            symbolGap

                        else
                            0
                in
                [ g
                    [ transform [ Translate x_ (y_ - space - gap) ]
                    , class [ "symbol" ]
                    , st c.styles
                    ]
                    symbolRef
                ]

            NoSymbol ->
                []

    else
        []


horizontalLabel : Config -> Float -> Float -> PointBand -> List (Svg msg)
horizontalLabel config x_ y_ point =
    let
        c =
            fromConfig config

        ( x__, y__ ) =
            point

        showLabels =
            getShowLabels config

        txt =
            text_
                [ y y_
                , x x_
                , textAnchor AnchorStart
                , dominantBaseline DominantBaselineMiddle
                ]
    in
    case showLabels of
        YLabel formatter ->
            [ txt [ text (y__ |> formatter) ] ]

        XOrdinalLabel ->
            [ txt [ text x__ ] ]

        _ ->
            []


symbolsToSymbolElements : Orientation -> BandScale String -> List Symbol -> List (Svg msg)
symbolsToSymbolElements orientation bandSingleScale symbols =
    let
        localDimension =
            Helpers.floorFloat <|
                Scale.bandwidth bandSingleScale
    in
    symbols
        |> List.map
            (\symbol ->
                let
                    s =
                        TypedSvg.symbol
                            [ Html.Attributes.id (symbolToId symbol) ]
                in
                case symbol of
                    Circle conf ->
                        --FIXME
                        s [ circle_ (conf.size |> Maybe.withDefault localDimension) ]

                    Custom conf ->
                        let
                            scaleFactor =
                                case orientation of
                                    Vertical ->
                                        localDimension / conf.viewBoxWidth

                                    Horizontal ->
                                        localDimension / conf.viewBoxHeight
                        in
                        s [ custom scaleFactor conf ]

                    Corner conf ->
                        s [ corner (conf.size |> Maybe.withDefault localDimension) ]

                    Triangle conf ->
                        s [ triangle (conf.size |> Maybe.withDefault localDimension) ]

                    NoSymbol ->
                        s []
            )


bandXAxis : ConfigStruct -> BandScale String -> List (Svg msg)
bandXAxis c bandScale =
    if c.showXAxis == True then
        case c.orientation of
            Vertical ->
                let
                    axis =
                        Axis.bottom [] (Scale.toRenderable identity bandScale)
                in
                [ g
                    [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                    , class [ "axis", "axis--horizontal" ]
                    ]
                    [ axis ]
                ]

            Horizontal ->
                let
                    axis =
                        Axis.left [] (Scale.toRenderable identity bandScale)
                in
                [ g
                    [ transform [ Translate (c.margin.left - leftGap |> Helpers.floorFloat) c.margin.top ]
                    , class [ "axis", "axis--vertical" ]
                    ]
                    [ axis ]
                ]

    else
        []


bandGroupedYAxis : ConfigStruct -> Float -> ContinuousScale Float -> List (Svg msg)
bandGroupedYAxis c iconOffset linearScale =
    if c.showYAxis == True then
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
        in
        case c.orientation of
            Vertical ->
                let
                    axis =
                        Axis.left attributes linearScale
                in
                [ g
                    [ transform [ Translate (c.margin.left - leftGap) (iconOffset + c.margin.top) ]
                    , class [ "axis", "axis--vertical" ]
                    ]
                    [ axis ]
                ]

            Horizontal ->
                let
                    axis =
                        Axis.bottom attributes linearScale
                in
                [ g
                    [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                    , class [ "axis", "axis--horizontal" ]
                    ]
                    [ axis ]
                ]

    else
        []



-- HISTOGRAM


renderHistogram : ( List (Histogram.Bin Float Float), Config ) -> Html msg
renderHistogram ( histogram, config ) =
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

        domain : ( Float, Float )
        domain =
            case c.histogramDomain of
                Just d ->
                    d

                Nothing ->
                    calculateHistogramDomain histogram

        xRange =
            getBandGroupRange config w h

        xScale : ContinuousScale Float
        xScale =
            Scale.linear xRange domain

        yRange =
            ( h, 0 )

        yScaleFromBins : List (Bin Float Float) -> ContinuousScale Float
        yScaleFromBins bins =
            List.map .length bins
                |> List.maximum
                |> Maybe.withDefault 0
                |> toFloat
                |> Tuple.pair 0
                |> Scale.linear yRange

        yTickFormat =
            case c.axisYContinousTickFormat of
                CustomTickFormat formatter ->
                    Just (Axis.tickFormat formatter)

                _ ->
                    Nothing

        yAttributes =
            [ yTickFormat ]
                |> List.filterMap identity

        xAxis : List Float -> List (Svg msg)
        xAxis d =
            [ g
                [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                , class [ "axis", "axis--horizontal" ]
                ]
                [ Axis.bottom [] xScale ]
            ]

        yAxis : List (Bin Float Float) -> List (Svg msg)
        yAxis bins =
            [ g
                [ transform [ Translate (c.margin.left - leftGap) c.margin.top ]
                , class [ "axis", "axis--vertical" ]
                ]
                [ Axis.left yAttributes (yScaleFromBins bins) ]
            ]

        tableHeadings =
            Table.Headings [ "length", "x0", "x1" ]

        tableData =
            histogram
                |> List.map
                    (\d ->
                        [ d.length |> String.fromInt
                        , d.x0 |> String.fromFloat
                        , d.x1 |> String.fromFloat
                        ]
                    )

        table =
            Table.generate tableData
                |> Table.setColumnHeadings tableHeadings
                |> Table.view

        tableEl =
            Helpers.invisibleFigcaption
                [ case table of
                    Ok table_ ->
                        Html.div [] [ table_ ]

                    Err error ->
                        Html.text (Table.errorToString error)
                ]

        svgEl =
            svg
                [ viewBox 0 0 outerW outerH
                , width outerW
                , height outerH
                , role "img"
                , ariaLabelledby "title desc"
                ]
            <|
                descAndTitle c
                    ++ xAxis (calculateHistogramValues histogram)
                    ++ yAxis histogram
                    ++ [ g
                            [ transform [ Translate m.left m.top ]
                            , class [ "series" ]
                            ]
                         <|
                            List.map (histogramColumn c h xScale (yScaleFromBins histogram)) histogram
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


histogramColumn :
    ConfigStruct
    -> Float
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Bin Float Float
    -> Svg msg
histogramColumn c h xScale yScale { length, x0, x1 } =
    let
        styleStr =
            Helpers.mergeStyles
                [ ( "stroke", "#fff" ), ( "stroke-width", String.fromFloat strokeWidth ++ "px" ) ]
                (colorStyle c Nothing Nothing)
    in
    rect
        [ x <| Scale.convert xScale x0
        , y <| Scale.convert yScale (toFloat length)
        , width <| Scale.convert xScale x1 - Scale.convert xScale x0
        , height <| h - Scale.convert yScale (toFloat length)
        , style styleStr
        ]
        []



-- CONSTANTS


labelGap : Float
labelGap =
    2


strokeWidth : Float
strokeWidth =
    0.5

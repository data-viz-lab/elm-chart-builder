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
import Chart.Internal.Type
    exposing
        ( AccessorHistogram
        , AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , ColorResource(..)
        , Config
        , ConfigStruct
        , DataBand
        , DataGroupBand
        , DataHistogram
        , Direction(..)
        , DomainBand(..)
        , DomainBandStruct
        , DomainLinear(..)
        , Layout(..)
        , Orientation(..)
        , PointBand
        , RenderContext(..)
        , StackedValues
        , adjustLinearRange
        , ariaLabelledby
        , bottomGap
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
        , getIconsFromLayout
        , getLinearRange
        , getMargin
        , getOffset
        , getShowIndividualLabels
        , getStackedValuesAndGroupes
        , getWidth
        , leftGap
        , role
        , showIcons
        , showIconsFromLayout
        , stackedValuesInverse
        , symbolCustomSpace
        , symbolSpace
        , toConfig
        )
import Color
import Histogram exposing (Bin, HistogramGenerator)
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
    [ TypedSvg.title [] [ text c.title ]
    , TypedSvg.desc [] [ text c.desc ]
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

        linearDomain =
            config
                |> getDomainBand
                |> .linear

        linearExtent =
            case linearDomain of
                Just ld ->
                    case c.layout of
                        Stacked Diverging ->
                            ( Tuple.second ld * -1, Tuple.second ld )

                        _ ->
                            ld

                Nothing ->
                    extent

        domain : DomainBandStruct
        domain =
            getDomainBandFromData data config

        bandGroupRange =
            getBandGroupRange config w h

        bandSingleRange =
            getBandSingleRange config (Scale.bandwidth bandGroupScale)

        bandGroupScale =
            Scale.band { defaultBandConfig | paddingInner = 0.1 } bandGroupRange (Maybe.withDefault [] domain.bandGroup)

        bandSingleScale =
            Scale.band { defaultBandConfig | paddingInner = 0.05 } bandSingleRange (Maybe.withDefault [] domain.bandSingle)

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
    in
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


verticalRectsStacked : ConfigStruct -> BandScale String -> ( String, StackedValues, List String ) -> List (Svg msg)
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


horizontalRectsStacked : ConfigStruct -> BandScale String -> ( String, StackedValues, List String ) -> List (Svg msg)
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
            Scale.band { defaultBandConfig | paddingInner = paddingInnerGroup }
                bandGroupRange
                (domain.bandGroup |> Maybe.withDefault [])

        bandSingleScale : BandScale String
        bandSingleScale =
            Scale.band { defaultBandConfig | paddingInner = 0.05 }
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
            symbolSpace Vertical bandSingleScale (getIconsFromLayout c.layout) + symbolGap

        symbolElements =
            case c.layout of
                Grouped groupedConfig ->
                    if showIcons groupedConfig then
                        symbolsToSymbolElements c.orientation bandSingleScale (getIcons groupedConfig)

                    else
                        []

                Stacked _ ->
                    []

        axisBandScale : BandScale String
        axisBandScale =
            if dataLength == 1 then
                bandSingleScale

            else
                bandGroupScale
    in
    svg
        [ viewBox 0 0 outerW outerH
        , width outerW
        , height outerH
        , role "img"
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
                        (columns c iconOffset bandGroupScale bandSingleScale linearScale colorScale)
                        (fromDataBand data)
               ]


columns :
    ConfigStruct
    -> Float
    -> BandScale String
    -> BandScale String
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> DataGroupBand
    -> Svg msg
columns c iconOffset bandGroupScale bandSingleScale linearScale colorScale dataGroup =
    let
        tr =
            case c.orientation of
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
        List.indexedMap (column c iconOffset bandSingleScale linearScale colorScale) dataGroup.points


column :
    ConfigStruct
    -> Float
    -> BandScale String
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Int
    -> PointBand
    -> Svg msg
column c iconOffset bandSingleScale linearScale colorScale idx point =
    let
        rectangle =
            case c.orientation of
                Vertical ->
                    verticalRect c iconOffset bandSingleScale linearScale colorScale idx point

                Horizontal ->
                    horizontalRect c bandSingleScale linearScale colorScale idx point
    in
    g [ class [ "column", "column-" ++ String.fromInt idx ] ] rectangle


verticalRect :
    ConfigStruct
    -> Float
    -> BandScale String
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Int
    -> PointBand
    -> List (Svg msg)
verticalRect c iconOffset bandSingleScale linearScale colorScale idx point =
    let
        ( x__, y__ ) =
            point

        style =
            colorStyle c idx (Scale.convert colorScale y__)

        label =
            verticalLabel c (x_ + w / 2) (y_ - labelGap) point

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
            verticalSymbol c { idx = idx, x_ = x_, y_ = y_, w = w, style = style }
    in
    rect
        [ x <| x_
        , y <| y_
        , width <| w
        , height <| h
        , shapeRendering RenderCrispEdges
        , style
        ]
        []
        :: symbol
        ++ label


horizontalRect :
    ConfigStruct
    -> BandScale String
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Int
    -> PointBand
    -> List (Svg msg)
horizontalRect c bandSingleScale linearScale colorScale idx point =
    let
        ( x__, y__ ) =
            point

        h =
            Helpers.floorFloat <| Scale.bandwidth bandSingleScale

        w =
            Helpers.floorFloat <| Scale.convert linearScale y__

        y_ =
            Helpers.floorFloat <| Scale.convert bandSingleScale x__

        style =
            colorStyle c idx (Scale.convert colorScale y__)

        label =
            horizontalLabel c (w + labelGap) (y_ + h / 2) point

        symbol =
            horizontalSymbol c { idx = idx, w = w, y_ = y_, h = h, style = style }
    in
    rect
        [ x <| 0
        , y y_
        , width w
        , height h
        , shapeRendering RenderCrispEdges
        , style
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


verticalLabel : ConfigStruct -> Float -> Float -> PointBand -> List (Svg msg)
verticalLabel c x_ y_ point =
    let
        ( x__, _ ) =
            point

        showIndividualLabels =
            case c.layout of
                Grouped config ->
                    getShowIndividualLabels config

                _ ->
                    False
    in
    if showIndividualLabels then
        [ text_
            [ x x_
            , y y_
            , textAnchor AnchorMiddle
            ]
            [ text <| x__ ]
        ]

    else
        []


horizontalSymbol :
    ConfigStruct
    -> { idx : Int, w : Float, y_ : Float, h : Float, style : TypedSvg.Core.Attribute msg }
    -> List (Svg msg)
horizontalSymbol c { idx, w, y_, style } =
    let
        symbol =
            getSymbolByIndex (getIconsFromLayout c.layout) idx

        symbolRef =
            [ TypedSvg.use [ xlinkHref <| "#" ++ symbolToId symbol ] [] ]
    in
    if showIconsFromLayout c.layout then
        case symbol of
            Triangle _ ->
                [ g
                    [ transform [ Translate (w + symbolGap) y_ ]
                    , class [ "symbol" ]
                    , style
                    ]
                    symbolRef
                ]

            Circle _ ->
                [ g
                    [ transform [ Translate (w + symbolGap) y_ ]
                    , class [ "symbol" ]
                    , style
                    ]
                    symbolRef
                ]

            Corner _ ->
                [ g
                    [ transform [ Translate (w + symbolGap) y_ ]
                    , class [ "symbol" ]
                    , style
                    ]
                    symbolRef
                ]

            Custom c_ ->
                let
                    gap =
                        if c_.useGap then
                            symbolGap

                        else
                            0
                in
                [ g
                    [ transform [ Translate (w + gap) y_ ]
                    , class [ "symbol" ]
                    , style
                    ]
                    symbolRef
                ]

            NoSymbol ->
                []

    else
        []


verticalSymbol :
    ConfigStruct
    -> { idx : Int, w : Float, y_ : Float, x_ : Float, style : TypedSvg.Core.Attribute msg }
    -> List (Svg msg)
verticalSymbol c { idx, w, y_, x_, style } =
    let
        symbol =
            getSymbolByIndex (getIconsFromLayout c.layout) idx

        symbolRef =
            [ TypedSvg.use [ xlinkHref <| "#" ++ symbolToId symbol ] [] ]
    in
    if showIconsFromLayout c.layout then
        case symbol of
            Triangle _ ->
                [ g
                    [ transform [ Translate x_ (y_ - w - symbolGap) ]
                    , class [ "symbol" ]
                    , style
                    ]
                    symbolRef
                ]

            Circle _ ->
                [ g
                    [ transform [ Translate x_ (y_ - w - symbolGap) ]
                    , class [ "symbol" ]
                    , style
                    ]
                    symbolRef
                ]

            Corner _ ->
                [ g
                    [ transform [ Translate x_ (y_ - w - symbolGap) ]
                    , class [ "symbol" ]
                    , style
                    ]
                    symbolRef
                ]

            Custom c_ ->
                let
                    space =
                        symbolCustomSpace Vertical w c_

                    gap =
                        if c_.useGap then
                            symbolGap

                        else
                            0
                in
                [ g
                    [ transform [ Translate x_ (y_ - space - gap) ]
                    , class [ "symbol" ]
                    , style
                    ]
                    symbolRef
                ]

            NoSymbol ->
                []

    else
        []


horizontalLabel : ConfigStruct -> Float -> Float -> PointBand -> List (Svg msg)
horizontalLabel c x_ y_ point =
    let
        ( x__, _ ) =
            point

        showIndividualLabels =
            case c.layout of
                Grouped config ->
                    getShowIndividualLabels config

                _ ->
                    False
    in
    if showIndividualLabels then
        [ text_
            [ y y_
            , x x_
            , textAnchor AnchorStart
            , dominantBaseline DominantBaselineMiddle
            ]
            [ text <| x__ ]
        ]

    else
        []


symbolsToSymbolElements : Orientation -> BandScale String -> List (Symbol String) -> List (Svg msg)
symbolsToSymbolElements orientation bandSingleScale symbols =
    let
        localDimension =
            Helpers.floorFloat <| Scale.bandwidth bandSingleScale
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
                    Circle _ ->
                        --FIXME
                        TypedSvg.symbol
                            [ Html.Attributes.id (symbolToId symbol)
                            ]
                            [ circle_ (localDimension / 2) ]

                    Custom conf ->
                        let
                            scaleFactor =
                                case orientation of
                                    Vertical ->
                                        localDimension / conf.width

                                    Horizontal ->
                                        localDimension / conf.height
                        in
                        s [ custom scaleFactor conf ]

                    Corner _ ->
                        s [ corner localDimension ]

                    Triangle _ ->
                        s [ triangle localDimension ]

                    NoSymbol ->
                        s []
            )


bandXAxis : ConfigStruct -> BandScale String -> List (Svg msg)
bandXAxis c bandScale =
    if c.showAxisX == True then
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
    if c.showAxisY == True then
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


histogramGenerator : ( Float, Float ) -> List Float -> List (Bin Float Float)
histogramGenerator domain model =
    Histogram.float
        |> Histogram.withDomain domain
        |> Histogram.compute model


renderHistogram : ( List Float, Config ) -> Html msg
renderHistogram ( data, config ) =
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
            data
                |> extent
                |> Maybe.withDefault ( 0, 0 )

        histogram : List (Bin Float Float)
        histogram =
            histogramGenerator domain data

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
            ++ [ g
                    [ transform [ Translate m.left m.top ]
                    , class [ "series" ]
                    ]
                 <|
                    List.map (histogramColumn c h xScale (yScaleFromBins histogram)) histogram
               ]


histogramColumn :
    ConfigStruct
    -> Float
    -> ContinuousScale Float
    -> ContinuousScale Float
    -> Bin Float Float
    -> Svg msg
histogramColumn c h xScale yScale { length, x0, x1 } =
    rect
        [ x <| Scale.convert xScale x0
        , y <| Scale.convert yScale (toFloat length)
        , width <| Scale.convert xScale x1 - Scale.convert xScale x0
        , height <| h - Scale.convert yScale (toFloat length)
        ]
        []



-- CONSTANTS


labelGap : Float
labelGap =
    2



--  HELPERS


{-| All possible color styles styles
-}
colorStyle : ConfigStruct -> Int -> Float -> TypedSvg.Core.Attribute msg
colorStyle c idx interpolatorInput =
    case c.colorResource of
        ColorPalette colors ->
            style ("fill: " ++ Helpers.colorPaletteToColor colors idx)

        ColorInterpolator interpolator ->
            style ("fill: " ++ (interpolator interpolatorInput |> Color.toCssString))

        ColorNone ->
            style ""


{-| Only categorical styles
-}
colorCategoricalStyle : ConfigStruct -> Int -> TypedSvg.Core.Attribute msg
colorCategoricalStyle c idx =
    case c.colorResource of
        ColorPalette colors ->
            style ("fill: " ++ Helpers.colorPaletteToColor colors idx)

        _ ->
            style ""

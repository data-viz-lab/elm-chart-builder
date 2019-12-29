module Chart.Internal.Bar exposing
    ( renderBandGrouped
    , renderBandStacked
    , wrongDataTypeErrorView
    )

import Axis
import Chart.Internal.Helpers as Helpers exposing (dataBandToDataStacked)
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
        ( AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , Config
        , ConfigStruct
        , Data(..)
        , DataGroupBand
        , Direction(..)
        , Domain(..)
        , Layout(..)
        , Orientation(..)
        , PointBand
        , RenderContext(..)
        , adjustLinearRange
        , ariaLabelledby
        , bottomGap
        , fromConfig
        , fromDataBand
        , fromDomainBand
        , getBandGroupRange
        , getBandSingleRange
        , getDataDepth
        , getDomain
        , getHeight
        , getIcons
        , getIconsFromLayout
        , getLinearRange
        , getMargin
        , getOffset
        , getWidth
        , leftGap
        , role
        , showIcons
        , showIconsFromLayout
        , symbolCustomSpace
        , symbolSpace
        , toConfig
        )
import Html exposing (Html)
import Html.Attributes
import List.Extra
import Scale exposing (BandScale, ContinuousScale, defaultBandConfig)
import Shape exposing (StackConfig)
import TypedSvg exposing (g, rect, svg, text_)
import TypedSvg.Attributes
    exposing
        ( alignmentBaseline
        , class
        , shapeRendering
        , textAnchor
        , transform
        , viewBox
        , xlinkHref
        )
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


descAndTitle : ConfigStruct -> List (Svg msg)
descAndTitle c =
    -- https://developer.paciellogroup.com/blog/2013/12/using-aria-enhance-svg-accessibility/
    [ TypedSvg.title [] [ text c.title ]
    , TypedSvg.desc [] [ text c.desc ]
    ]



-- BAND STACKED


renderBandStacked : ( Data, Config ) -> Html msg
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
            dataBandToDataStacked data

        stackedConfig : StackConfig String
        stackedConfig =
            { data = dataStacked
            , offset = getOffset config
            , order = identity
            }

        { values, labels, extent } =
            Shape.stack stackedConfig

        stackDepth =
            getDataDepth data

        domain =
            getDomain config
                |> fromDomainBand

        bandGroupRange =
            getBandGroupRange config w h

        bandSingleRange =
            getBandSingleRange config (Scale.bandwidth bandGroupScale)

        bandGroupScale =
            Scale.band { defaultBandConfig | paddingInner = 0.1 } bandGroupRange domain.bandGroup

        bandSingleScale =
            Scale.band { defaultBandConfig | paddingInner = 0.05 } bandSingleRange domain.bandSingle

        linearRange =
            getLinearRange config RenderChart w h bandSingleScale
                |> adjustLinearRange config stackDepth

        linearRangeAxis =
            getLinearRange config RenderAxis w h bandSingleScale

        linearScale : ContinuousScale Float
        linearScale =
            -- For stacked scales
            -- |> Scale.nice 4
            Scale.linear linearRange extent

        linearScaleAxis : ContinuousScale Float
        linearScaleAxis =
            -- For stacked scales
            -- |> Scale.nice 4
            Scale.linear linearRangeAxis extent

        columnValues =
            List.Extra.transpose values

        columnGroupes =
            data
                |> fromDataBand
                |> List.indexedMap (\idx s -> s.groupLabel |> Maybe.withDefault (String.fromInt idx))

        scaledValues =
            List.map (List.map (\( a1, a2 ) -> ( Scale.convert linearScale a1, Scale.convert linearScale a2 ))) columnValues
                |> Helpers.floorValues

        dataLength =
            data |> fromDataBand |> List.length

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
        (descAndTitle c
            ++ bandOrdinalAxis c axisBandScale
            ++ bandGroupedContinousAxis c 0 linearScaleAxis
            ++ [ g
                    [ transform [ stackedContainerTranslate c m.left m.top (toFloat stackDepth) ]
                    , class [ "series" ]
                    ]
                 <|
                    List.map (stackedColumns c bandGroupScale) (List.map2 (\a b -> ( a, b )) columnGroupes scaledValues)
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


stackedColumns : ConfigStruct -> BandScale String -> ( String, List ( Float, Float ) ) -> Svg msg
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


verticalRectsStacked : ConfigStruct -> BandScale String -> ( String, List ( Float, Float ) ) -> List (Svg msg)
verticalRectsStacked config bandGroupScale ( group, values ) =
    let
        block idx ( upper, lower ) =
            g [ class [ "column", "column-" ++ String.fromInt idx ] ]
                [ rect
                    [ x <| Scale.convert bandGroupScale group
                    , y <| lower - toFloat idx
                    , width <| Scale.bandwidth bandGroupScale
                    , height <| (abs <| upper - lower)
                    , shapeRendering RenderCrispEdges
                    ]
                    []
                ]
    in
    List.indexedMap (\idx -> block idx) values


horizontalRectsStacked : ConfigStruct -> BandScale String -> ( String, List ( Float, Float ) ) -> List (Svg msg)
horizontalRectsStacked config bandGroupScale ( group, values ) =
    let
        block idx ( lower, upper ) =
            g [ class [ "column", "column-" ++ String.fromInt idx ] ]
                [ rect
                    [ y <| Scale.convert bandGroupScale group
                    , x <| lower + toFloat idx
                    , height <| Scale.bandwidth bandGroupScale
                    , width <| (abs <| upper - lower)
                    , shapeRendering RenderCrispEdges
                    ]
                    []
                ]
    in
    values
        |> Helpers.stackedValuesInverse config.width
        |> List.indexedMap (\idx -> block idx)



-- BAND GROUPED


renderBandGrouped : ( Data, Config ) -> Html msg
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

        domain =
            getDomain config
                |> fromDomainBand

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
            Scale.band { defaultBandConfig | paddingInner = paddingInnerGroup } bandGroupRange domain.bandGroup

        bandSingleScale : BandScale String
        bandSingleScale =
            Scale.band { defaultBandConfig | paddingInner = 0.05 } bandSingleRange domain.bandSingle

        linearScale : ContinuousScale Float
        linearScale =
            Scale.linear linearRange domain.linear

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
            ++ bandGroupedContinousAxis c iconOffset linearScale
            ++ bandOrdinalAxis c axisBandScale
            ++ [ g
                    [ transform [ Translate m.left m.top ]
                    , class [ "series" ]
                    ]
                 <|
                    List.map (columns c iconOffset bandGroupScale bandSingleScale linearScale) (fromDataBand data)
               ]


columns : ConfigStruct -> Float -> BandScale String -> BandScale String -> ContinuousScale Float -> DataGroupBand -> Svg msg
columns c iconOffset bandGroupScale bandSingleScale linearScale dataGroup =
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
        List.indexedMap (column c iconOffset bandSingleScale linearScale) dataGroup.points


column : ConfigStruct -> Float -> BandScale String -> ContinuousScale Float -> Int -> PointBand -> Svg msg
column c iconOffset bandSingleScale linearScale idx point =
    let
        --label =
        --    case c.orientation of
        --        Horizontal ->
        --            horizontalLabel c bandSingleScale linearScale point
        --        Vertical ->
        --            verticalLabel c bandSingleScale linearScale point
        rectangle =
            case c.orientation of
                Vertical ->
                    verticalRect c iconOffset bandSingleScale linearScale idx point

                Horizontal ->
                    horizontalRect c bandSingleScale linearScale idx point
    in
    g [ class [ "column", "column-" ++ String.fromInt idx ] ] rectangle


verticalRect : ConfigStruct -> Float -> BandScale String -> ContinuousScale Float -> Int -> PointBand -> List (Svg msg)
verticalRect c iconOffset bandSingleScale linearScale idx point =
    let
        ( x__, y__ ) =
            point

        label =
            verticalLabel c bandSingleScale linearScale point

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
            verticalSymbol c { idx = idx, x_ = x_, y_ = y_, w = w }
    in
    [ rect
        [ x <| x_
        , y <| y_
        , width <| w
        , height <| h
        , shapeRendering RenderCrispEdges
        ]
        []
    ]
        ++ symbol
        ++ label


horizontalRect : ConfigStruct -> BandScale String -> ContinuousScale Float -> Int -> PointBand -> List (Svg msg)
horizontalRect c bandSingleScale linearScale idx point =
    let
        ( x__, y__ ) =
            point

        h =
            Helpers.floorFloat <| Scale.bandwidth bandSingleScale

        w =
            Helpers.floorFloat <| Scale.convert linearScale y__

        y_ =
            Helpers.floorFloat <| Scale.convert bandSingleScale x__

        label =
            horizontalLabel c bandSingleScale linearScale point

        symbol =
            horizontalSymbol c { idx = idx, w = w, y_ = y_, h = h }
    in
    [ rect
        [ x <| 0
        , y y_
        , width w
        , height h
        , shapeRendering RenderCrispEdges
        ]
        []
    ]
        ++ symbol
        ++ label


dataGroupTranslation : BandScale String -> DataGroupBand -> Float
dataGroupTranslation bandGroupScale dataGroup =
    case dataGroup.groupLabel of
        Nothing ->
            0

        Just l ->
            Scale.convert bandGroupScale l


verticalLabel : ConfigStruct -> BandScale String -> ContinuousScale Float -> PointBand -> List (Svg msg)
verticalLabel c bandSingleScale linearScale point =
    let
        ( x__, y__ ) =
            point
    in
    if c.showColumnLabels then
        [ text_
            [ x <| Scale.convert (Scale.toRenderable (\s -> s) bandSingleScale) x__
            , y <| Scale.convert linearScale y__ - 2
            , textAnchor AnchorMiddle
            ]
            [ text <| x__ ]
        ]

    else
        []


horizontalSymbol : ConfigStruct -> { idx : Int, w : Float, y_ : Float, h : Float } -> List (Svg msg)
horizontalSymbol c { idx, w, y_, h } =
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
                    ]
                    symbolRef
                ]

            Circle _ ->
                --FIXME
                [ g
                    [ transform [ Translate (w + h / 2 + symbolGap) (y_ + h / 2) ]
                    , class [ "symbol" ]
                    ]
                    symbolRef
                ]

            Corner _ ->
                [ g
                    [ transform [ Translate (w + symbolGap) y_ ]
                    , class [ "symbol" ]
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
                    ]
                    symbolRef
                ]

            NoSymbol ->
                []

    else
        []


verticalSymbol : ConfigStruct -> { idx : Int, w : Float, y_ : Float, x_ : Float } -> List (Svg msg)
verticalSymbol c { idx, w, y_, x_ } =
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
                    ]
                    symbolRef
                ]

            Circle _ ->
                --FIXME
                [ g
                    [ transform [ Translate x_ (y_ - w / 2 - symbolGap) ]
                    , class [ "symbol" ]
                    ]
                    symbolRef
                ]

            Corner _ ->
                [ g
                    [ transform [ Translate x_ (y_ - w - symbolGap) ]
                    , class [ "symbol" ]
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
                    ]
                    symbolRef
                ]

            NoSymbol ->
                []

    else
        []


horizontalLabel : ConfigStruct -> BandScale String -> ContinuousScale Float -> PointBand -> List (Svg msg)
horizontalLabel c bandSingleScale linearScale point =
    let
        ( x__, y__ ) =
            point
    in
    if c.showColumnLabels then
        [ text_
            [ y <| Scale.convert (Scale.toRenderable (\s -> s) bandSingleScale) x__
            , x <| Scale.convert linearScale y__ + 2
            , textAnchor AnchorStart
            , alignmentBaseline AlignmentMiddle
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


bandOrdinalAxis : ConfigStruct -> BandScale String -> List (Svg msg)
bandOrdinalAxis c bandScale =
    if c.showOrdinalAxis == True then
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


bandGroupedContinousAxis : ConfigStruct -> Float -> ContinuousScale Float -> List (Svg msg)
bandGroupedContinousAxis c iconOffset linearScale =
    if c.showContinousAxis == True then
        let
            ticks =
                case c.axisContinousDataTicks of
                    DefaultTicks ->
                        Nothing

                    CustomTicks t ->
                        Just (Axis.ticks t)

            tickCount =
                case c.axisContinousDataTickCount of
                    DefaultTickCount ->
                        Nothing

                    CustomTickCount count ->
                        Just (Axis.tickCount count)

            tickFormat =
                case c.axisContinousDataTickFormat of
                    DefaultTickFormat ->
                        Nothing

                    CustomTickFormat formatter ->
                        Just (Axis.tickFormat formatter)

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



-- ERROR VIEWS


wrongDataTypeErrorView : Html msg
wrongDataTypeErrorView =
    Html.div [] [ Html.text "Data type not supported in bar charts" ]

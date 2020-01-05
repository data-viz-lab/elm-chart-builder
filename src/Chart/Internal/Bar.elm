module Chart.Internal.Bar exposing
    ( getStackedValuesAndGroupes
    , renderBandGrouped
    , renderBandStacked
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
        , StackedValues
        , StackedValuesAndGroupes
        , adjustLinearRange
        , ariaLabelledby
        , bottomGap
        , fromConfig
        , fromDataBand
        , fromDomainBand
        , fromDomainBandInternal
        , getAxisContinousDataFormatter
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
        , getShowIndividualLabels
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
        ( class
        , dominantBaseline
        , shapeRendering
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
            getDataDepth data

        linearDomain =
            c.domain
                |> fromDomainBand
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

        domain =
            getDomain data config
                |> fromDomainBandInternal

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
            ++ bandOrdinalAxis c axisBandScale
            ++ bandGroupedContinousAxis c 0 linearScaleAxis
            ++ [ g
                    [ transform [ stackedContainerTranslate c m.left m.top (toFloat stackDepth) ]
                    , class [ "series" ]
                    ]
                 <|
                    List.map (stackedColumns c bandGroupScale)
                        (List.map2 (\a b -> ( a, b, labels )) columnGroupes scaledValues)
               ]
        )


getStackedValuesAndGroupes : List (List ( Float, Float )) -> Data -> StackedValuesAndGroupes
getStackedValuesAndGroupes values data =
    let
        m =
            List.map2
                (\d v ->
                    List.map2 (\stackedValue rawValue -> { rawValue = Tuple.second rawValue, stackedValue = stackedValue })
                        v
                        d.points
                )
    in
    ( List.Extra.transpose values
        |> List.reverse
        |> m (fromDataBand data)
    , data
        |> fromDataBand
        |> List.indexedMap (\idx s -> s.groupLabel |> Maybe.withDefault (String.fromInt idx))
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
    in
    group ++ " - " ++ getLabel idx labels ++ ": " ++ formatter value


verticalRectsStacked : ConfigStruct -> BandScale String -> ( String, StackedValues, List String ) -> List (Svg msg)
verticalRectsStacked config bandGroupScale ( group, values, labels ) =
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
                    ]
                    []
                , TypedSvg.title [] [ text <| getRectTitleText config.axisContinousDataTickFormat idx group labels rawValue ]
                ]
    in
    List.indexedMap (\idx -> block idx) values


horizontalRectsStacked : ConfigStruct -> BandScale String -> ( String, StackedValues, List String ) -> List (Svg msg)
horizontalRectsStacked config bandGroupScale ( group, values, labels ) =
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
                    ]
                    []
                , TypedSvg.title [] [ text <| getRectTitleText config.axisContinousDataTickFormat idx group labels rawValue ]
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
            getDomain data config
                |> fromDomainBandInternal

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
            horizontalLabel c (w + labelGap) (y_ + h / 2) point

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


verticalLabel : ConfigStruct -> Float -> Float -> PointBand -> List (Svg msg)
verticalLabel c x_ y_ point =
    let
        ( x__, y__ ) =
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
                [ g
                    [ transform [ Translate (w + symbolGap) y_ ]
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
                [ g
                    [ transform [ Translate x_ (y_ - w - symbolGap) ]
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


horizontalLabel : ConfigStruct -> Float -> Float -> PointBand -> List (Svg msg)
horizontalLabel c x_ y_ point =
    let
        ( x__, y__ ) =
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



-- CONSTANTS


labelGap : Float
labelGap =
    2

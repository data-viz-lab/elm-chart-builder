module Chart.Bar exposing
    ( init
    , render
    , setDimensions
    , setDomain
    , setHeight
    , setLayout
    , setMargin
    , setOrientation
    , setShowColumnLabels
    , setShowSymbols
    , setSymbols
    , setWidth
    )

import Chart.Helpers as Helpers exposing (dataBandToDataStacked)
import Chart.Symbol
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
import Chart.Type
    exposing
        ( Axis(..)
        , Config
        , ConfigStruct
        , Data(..)
        , DataGroupBand
        , Domain(..)
        , Layout(..)
        , Margin
        , Orientation(..)
        , PointBand
        , adjustLinearRange
        , chartHasSymbols
        , defaultConfig
        , defaultHeight
        , defaultLayout
        , defaultMargin
        , defaultOrientation
        , defaultWidth
        , fromConfig
        , fromDataBand
        , fromDomainBand
        , getBandGroupRange
        , getBandSingleRange
        , getDataDepth
        , getDomain
        , getDomainFromData
        , getHeight
        , getLinearRange
        , getMargin
        , getOffset
        , getSymbolMoltiplier
        , getWidth
        , setDimensions
        , setDomain
        , setShowColumnLabels
        , setShowSymbols
        , symbolCustomSpace
        , symbolSpace
        , toConfig
        )
import Html exposing (Html)
import Html.Attributes
import List.Extra
import Scale exposing (BandConfig, BandScale, ContinuousScale, defaultBandConfig)
import Shape exposing (StackConfig, StackResult)
import TypedSvg exposing (g, rect, style, svg, text_)
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



-- API METHODS


{-| Initializes the bar chart

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])

-}
init : Data -> ( Data, Config )
init data =
    ( data, defaultConfig )
        |> setDomain (getDomainFromData data)


{-| Renders the bar chart, after initialisation and customisation

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.render

-}
render : ( Data, Config ) -> Html msg
render ( data, config ) =
    let
        c =
            fromConfig config
    in
    case data of
        DataBand d ->
            case c.layout of
                Grouped ->
                    renderBandGrouped ( data, config )

                Stacked _ ->
                    renderBandStacked ( data, config )


setHeight : Float -> ( Data, Config ) -> ( Data, Config )
setHeight =
    Chart.Type.setHeight


setWidth : Float -> ( Data, Config ) -> ( Data, Config )
setWidth =
    Chart.Type.setWidth


setLayout : Layout -> ( Data, Config ) -> ( Data, Config )
setLayout =
    Chart.Type.setLayout


{-| Sets the orientation value in the config
Default value: Vertical

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setOrientation Horizontal
        |> Bar.render

-}
setOrientation : Orientation -> ( Data, Config ) -> ( Data, Config )
setOrientation =
    Chart.Type.setOrientation


setMargin : Margin -> ( Data, Config ) -> ( Data, Config )
setMargin =
    Chart.Type.setMargin


setDimensions : { margin : Margin, width : Float, height : Float } -> ( Data, Config ) -> ( Data, Config )
setDimensions =
    Chart.Type.setDimensions


{-| Sets the domain value in the config
If not set, the domain is calculated from the data

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setDomain { bandGroup = [ "0" ], bandSingle = [ "a" ], linear = ( 0, 100 ) }
        |> Bar.render

-}
setDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setDomain =
    Chart.Type.setDomain


{-| Sets the showColumnLabels boolean value in the config
Default value: False
This shows the bar's ordinal value at the end of the rect, not the linear value

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setShowColumnLabels True
        |> Bar.render

-}
setShowColumnLabels : Bool -> ( Data, Config ) -> ( Data, Config )
setShowColumnLabels =
    Chart.Type.setShowColumnLabels


{-| Sets the showSymbols boolean value in the config
Default value: False
This shows additional symbols at the end of each bar in a group, for facilitating accessibility

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setShowSymbols True
        |> Bar.render

-}
setShowSymbols : Bool -> ( Data, Config ) -> ( Data, Config )
setShowSymbols =
    Chart.Type.setShowSymbols


{-| Sets the Symbol list in the config
Default value: [ Circle, Corner, Triangle ]
These are additional symbols at the end of each bar in a group, for facilitating accessibility

    Bar.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Bar.setSymbols [ Circle, Corner, Triangle ]
        |> Bar.render

-}
setSymbols : List (Symbol String) -> ( Data, Config ) -> ( Data, Config )
setSymbols =
    Chart.Type.setSymbols



-- INTERNALS
--
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

        d =
            data
                |> fromDataBand
                |> List.map .points

        domain =
            getDomain config
                |> fromDomainBand

        bandGroupDomain =
            domain
                |> .bandGroup

        bandGroupRange =
            getBandGroupRange config w h

        bandSingleRange =
            getBandSingleRange config (Scale.bandwidth bandGroupScale)

        bandGroupScale =
            Scale.band { defaultBandConfig | paddingInner = 0.1 } bandGroupRange domain.bandGroup

        bandSingleScale =
            Scale.band { defaultBandConfig | paddingInner = 0.05 } bandSingleRange domain.bandSingle

        linearRange =
            getLinearRange config w h stackDepth bandSingleScale
                |> adjustLinearRange config stackDepth

        linearScale : ContinuousScale Float
        linearScale =
            -- For stacked scales
            -- |> Scale.nice 4
            Scale.linear linearRange extent

        symbolMoltiplier =
            getSymbolMoltiplier c.layout stackDepth

        symbolElements =
            if c.showSymbols && stackDepth < 3 then
                symbolsToSymbolElements c.orientation bandSingleScale symbolMoltiplier c.symbols

            else
                []

        columnValues =
            List.Extra.transpose values

        columnGroupes =
            data
                |> fromDataBand
                |> List.indexedMap (\idx s -> s.groupLabel |> Maybe.withDefault (String.fromInt idx))

        scaledValues =
            List.map (List.map (\( a1, a2 ) -> ( Scale.convert linearScale a1, Scale.convert linearScale a2 ))) columnValues
                |> Helpers.floorValues
    in
    svg
        [ viewBox 0 0 outerW outerH
        , width outerW
        , height outerH
        ]
    <|
        symbolElements
            ++ [ g
                    [ transform [ stackedContainerTranslate c m.left m.top (toFloat stackDepth) ]
                    , class [ "series" ]
                    ]
                 <|
                    List.map (stackedColumns c bandGroupScale stackDepth) (List.map2 (\a b -> ( a, b )) columnGroupes scaledValues)
               ]


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


stackedColumns : ConfigStruct -> BandScale String -> Int -> ( String, List ( Float, Float ) ) -> Svg msg
stackedColumns config bandGroupScale stackDepth payload =
    let
        rects =
            case config.orientation of
                Vertical ->
                    verticalRectsStacked config bandGroupScale stackDepth payload

                Horizontal ->
                    horizontalRectsStacked config bandGroupScale stackDepth payload
    in
    g [ class [ "columns" ] ] rects


verticalRectsStacked : ConfigStruct -> BandScale String -> Int -> ( String, List ( Float, Float ) ) -> List (Svg msg)
verticalRectsStacked c bandGroupScale stackDepth ( group, values ) =
    let
        block idx ( upper, lower ) =
            let
                x_ =
                    Scale.convert bandGroupScale group

                y_ =
                    lower - toFloat idx

                ySymbol =
                    if idx == 0 then
                        upper

                    else
                        lower

                w =
                    Scale.bandwidth bandGroupScale

                symbol : List (Svg msg)
                symbol =
                    verticalSymbol c { idx = idx, x_ = x_, y_ = ySymbol, w = w, stackDepth = stackDepth }

                children =
                    [ rect
                        [ x x_
                        , y y_
                        , width w
                        , height <| (abs <| upper - lower)
                        , shapeRendering RenderCrispEdges
                        ]
                        []
                    ]
                        ++ symbol
            in
            g [ class [ "column", "column-" ++ String.fromInt idx ] ] children
    in
    values
        --|> List.reverse
        |> Debug.log "values"
        |> List.indexedMap (\idx -> block idx)


horizontalRectsStacked : ConfigStruct -> BandScale String -> Int -> ( String, List ( Float, Float ) ) -> List (Svg msg)
horizontalRectsStacked c bandGroupScale stackDepth ( group, values ) =
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
        |> Helpers.stackedValuesInverse c.width
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

        stackDepth =
            getDataDepth data

        linearRange =
            getLinearRange config w h stackDepth bandSingleScale

        bandGroupScale =
            Scale.band { defaultBandConfig | paddingInner = 0.1 } bandGroupRange domain.bandGroup

        bandSingleScale =
            Scale.band { defaultBandConfig | paddingInner = 0.05 } bandSingleRange domain.bandSingle

        linearScale =
            Scale.linear linearRange domain.linear

        symbolMoltiplier =
            getSymbolMoltiplier c.layout stackDepth

        symbolElements =
            if c.showSymbols then
                symbolsToSymbolElements c.orientation bandSingleScale symbolMoltiplier c.symbols

            else
                []
    in
    svg
        [ viewBox 0 0 outerW outerH
        , width outerW
        , height outerH
        ]
    <|
        symbolElements
            ++ [ g
                    [ transform [ Translate m.left m.top ]
                    , class [ "series" ]
                    ]
                 <|
                    List.map (columns c bandGroupScale bandSingleScale linearScale stackDepth) (fromDataBand data)
               ]


columns : ConfigStruct -> BandScale String -> BandScale String -> ContinuousScale Float -> Int -> DataGroupBand -> Svg msg
columns c bandGroupScale bandSingleScale linearScale stackDepth dataGroup =
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
        List.indexedMap (column c bandSingleScale linearScale stackDepth) dataGroup.points


column : ConfigStruct -> BandScale String -> ContinuousScale Float -> Int -> Int -> PointBand -> Svg msg
column c bandSingleScale linearScale stackDepth idx point =
    let
        ( x__, y__ ) =
            point

        label =
            case c.orientation of
                Horizontal ->
                    horizontalLabel c bandSingleScale linearScale point

                Vertical ->
                    verticalLabel c bandSingleScale linearScale point

        rectangle =
            case c.orientation of
                Vertical ->
                    verticalRect c bandSingleScale linearScale stackDepth idx point

                Horizontal ->
                    horizontalRect c bandSingleScale linearScale stackDepth idx point
    in
    g [ class [ "column", "column-" ++ String.fromInt idx ] ] rectangle


verticalRect : ConfigStruct -> BandScale String -> ContinuousScale Float -> Int -> Int -> PointBand -> List (Svg msg)
verticalRect c bandSingleScale linearScale stackDepth idx point =
    let
        ( x__, y__ ) =
            point

        label =
            verticalLabel c bandSingleScale linearScale point

        symbolMoltiplier =
            getSymbolMoltiplier c.layout stackDepth

        iconOffset =
            symbolSpace Vertical bandSingleScale symbolMoltiplier c.symbols + symbolGap

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
            verticalSymbol c { idx = idx, x_ = x_, y_ = y_, w = w, stackDepth = stackDepth }
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


horizontalRect : ConfigStruct -> BandScale String -> ContinuousScale Float -> Int -> Int -> PointBand -> List (Svg msg)
horizontalRect c bandSingleScale linearScale idx stackDepth point =
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
            horizontalSymbol c { idx = idx, w = w, y_ = y_, h = h, stackDepth = stackDepth }
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


horizontalSymbol : ConfigStruct -> { idx : Int, w : Float, y_ : Float, h : Float, stackDepth : Int } -> List (Svg msg)
horizontalSymbol c { idx, w, y_, h, stackDepth } =
    let
        symbol =
            getSymbolByIndex c.symbols idx

        symbolRef =
            [ TypedSvg.use [ xlinkHref <| "#" ++ symbolToId symbol ] [] ]
    in
    if c.showSymbols then
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

    else
        []


verticalSymbol : ConfigStruct -> { idx : Int, w : Float, y_ : Float, x_ : Float, stackDepth : Int } -> List (Svg msg)
verticalSymbol c { idx, w, y_, x_, stackDepth } =
    let
        symbol =
            getSymbolByIndex c.symbols idx

        symbolRef =
            [ TypedSvg.use [ xlinkHref <| "#" ++ symbolToId symbol ] [] ]

        direction =
            case c.layout of
                Stacked _ ->
                    if idx == 0 then
                        (+)

                    else
                        (-)

                Grouped ->
                    (-)

        _ =
            Debug.log "idx" idx
    in
    if chartHasSymbols c stackDepth then
        case symbol of
            Triangle _ ->
                [ g
                    [ transform [ Translate x_ (y_ |> direction w |> direction symbolGap) ]
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
                    [ transform [ Translate x_ (y_ |> direction w |> direction symbolGap) ]
                    , class [ "symbol" ]
                    ]
                    symbolRef
                ]

            Custom c_ ->
                let
                    space =
                        symbolCustomSpace Vertical w c_
                            |> Debug.log "space"

                    off =
                        case c.layout of
                            Stacked _ ->
                                if idx == 0 then
                                    0

                                else
                                    space

                            Grouped ->
                                space

                    gap =
                        if c_.useGap then
                            symbolGap

                        else
                            0
                in
                [ g
                    [ transform [ Translate x_ (y_ |> direction off |> direction gap) ]
                    , class [ "symbol" ]
                    ]
                    symbolRef
                ]

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


symbolsToSymbolElements : Orientation -> BandScale String -> Int -> List (Symbol String) -> List (Svg msg)
symbolsToSymbolElements orientation bandSingleScale moltiplier symbols =
    let
        localDimension =
            Scale.bandwidth bandSingleScale |> floor |> (*) moltiplier |> toFloat

        --Helpers.floorFloat <| Scale.bandwidth bandSingleScale
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
            )

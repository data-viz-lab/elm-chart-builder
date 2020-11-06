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
        , AccessorLinearOrTime(..)
        , ColorResource(..)
        , Config
        , ConfigStruct
        , DataGroupLinear
        , DataLinearGroup(..)
        , DomainLinearStruct
        , Label(..)
        , Layout(..)
        , PointLinear
        , RenderContext(..)
        , ariaLabelledby
        , bottomGap
        , colorStyle
        , dataLinearGroupToDataLinear
        , dataLinearGroupToDataLinearStacked
        , dataLinearGroupToDataTime
        , fromConfig
        , getDomainLinearFromData
        , getDomainTimeFromData
        , getOffset
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



-- INTERNALS


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
            c.margin

        w =
            c.width

        h =
            c.height

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
                    ++ linearYAxis c yScale
                    ++ linearOrTimeAxisGenerator xTimeScale xLinearScale ( data, config )
                    ++ drawLinearLine config xLinearScale yScale sortedLinearData
    in
    case c.accessibilityContent of
        AccessibilityNone ->
            Html.div [] [ svgEl ]

        _ ->
            Html.div []
                [ Html.figure
                    []
                    [ svgEl, tableElement data c.accessibilityContent ]
                ]



-- STACKED


renderLineStacked : ( DataLinearGroup, Config ) -> Html msg
renderLineStacked ( data, config ) =
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
                    ++ linearYAxis c yScale
                    ++ linearOrTimeAxisGenerator xTimeScale xLinearScale ( data, config )
                    ++ drawLinearLine config xLinearScale yScale combinedData
    in
    case c.accessibilityContent of
        AccessibilityNone ->
            Html.div [] [ svgEl ]

        _ ->
            Html.div []
                [ Html.figure
                    []
                    [ svgEl, tableElement data c.accessibilityContent ]
                ]


linearXAxis : ConfigStruct -> ContinuousScale Float -> List (Svg msg)
linearXAxis c scale =
    if c.showXAxis == True then
        case c.axisXLinear of
            ChartAxis.Bottom attributes ->
                [ g
                    [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                    , class [ "axis", "axis--x" ]
                    ]
                    [ Axis.bottom attributes scale ]
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

            _ ->
                []

    else
        []


linearYAxis : ConfigStruct -> ContinuousScale Float -> List (Svg msg)
linearYAxis c scale =
    if c.showYAxis == True then
        case c.axisYLinear of
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
            timeXAxis c xTimeScale

        DataLinear _ ->
            linearXAxis c xLinearScale


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
        StackedLine ->
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
            c.margin

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

        styles idx =
            Helpers.mergeStyles
                [ ( "fill", "none" ) ]
                (colorStyle c (Just idx) Nothing)
                |> Helpers.mergeStyles c.coreStyle
                |> style

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

                txt =
                    text_
                        [ y yPos
                        , x (xPos + labelOffset)
                        , textAnchor AnchorStart
                        , dominantBaseline DominantBaselineMiddle
                        ]
            in
            case conf.showLabels of
                XGroupLabel ->
                    txt [ text label ]

                _ ->
                    text_ [] []

        Nothing ->
            text_ [] []


tableElement : DataLinearGroup -> AccessibilityContent -> Html msg
tableElement data accessibilityContent =
    let
        tableHeadings =
            Helpers.dataLinearGroupToTableHeadings data accessibilityContent

        -- TODO
        --tableRowHeadings =
        --    Helpers.dataLinearGroupToRowHeadings data accessibilityContent
        --        |> Debug.log "rowHeadings"
        tableData =
            Helpers.dataLinearGroupToTableData data

        table =
            Table.generate tableData
                |> Table.setColumnHeadings tableHeadings
                --|> Table.setRowHeadings tableRowHeadings
                |> Table.view
    in
    Helpers.invisibleFigcaption
        [ case table of
            Ok table_ ->
                Html.div [] [ table_ ]

            Err error ->
                Html.text (Table.errorToString error)
        ]



-- CONSTANTS


labelGap : Float
labelGap =
    2

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
    , setWidth
    )

import Chart.Helpers as Helpers exposing (dataBandToDataStacked)
import Chart.Type
    exposing
        ( Axis(..)
        , Config
        , Data(..)
        , DataGroupBand
        , Domain(..)
        , Layout(..)
        , Margin
        , Orientation(..)
        , PointBand
        , adjustLinearRange
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
        , getWidth
        , setDimensions
        , setDomain
        , setShowColumnLabels
        , toConfig
        )
import Html exposing (Html)
import List.Extra
import Scale exposing (BandConfig, BandScale, ContinuousScale, defaultBandConfig)
import Shape exposing (StackConfig, StackResult)
import TypedSvg exposing (g, rect, style, svg, text_)
import TypedSvg.Attributes exposing (alignmentBaseline, class, shapeRendering, textAnchor, transform, viewBox)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))


stackedContainerTranslate : Config -> Float -> Float -> Float -> Transform
stackedContainerTranslate config a b offset =
    let
        orientation =
            fromConfig config |> .orientation
    in
    case orientation of
        Horizontal ->
            Translate (a - offset) b

        Vertical ->
            Translate a (b + offset)


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
            getLinearRange config w h
                |> adjustLinearRange config stackDepth

        linearScale : ContinuousScale Float
        linearScale =
            -- For stacked scales
            -- |> Scale.nice 4
            Scale.linear linearRange extent

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
        [ g
            [ transform [ stackedContainerTranslate config m.left m.top (toFloat stackDepth) ]
            , class [ "series" ]
            ]
          <|
            List.map (stackedColumns config bandGroupScale) (List.map2 (\a b -> ( a, b )) columnGroupes scaledValues)
        ]


stackedColumns : Config -> BandScale String -> ( String, List ( Float, Float ) ) -> Svg msg
stackedColumns config bandGroupScale payload =
    let
        c =
            fromConfig config

        rects =
            case c.orientation of
                Vertical ->
                    verticalRectsStacked config bandGroupScale payload

                Horizontal ->
                    horizontalRectsStacked config bandGroupScale payload
    in
    g [ class [ "columns" ] ] rects


verticalRectsStacked : Config -> BandScale String -> ( String, List ( Float, Float ) ) -> List (Svg msg)
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


horizontalRectsStacked : Config -> BandScale String -> ( String, List ( Float, Float ) ) -> List (Svg msg)
horizontalRectsStacked config bandGroupScale ( group, values ) =
    let
        c =
            fromConfig config

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


renderBand : ( Data, Config ) -> Html msg
renderBand ( data, config ) =
    let
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
            getLinearRange config w h

        bandGroupScale =
            Scale.band { defaultBandConfig | paddingInner = 0.1 } bandGroupRange domain.bandGroup

        bandSingleScale =
            Scale.band { defaultBandConfig | paddingInner = 0.05 } bandSingleRange domain.bandSingle

        linearScale =
            Scale.linear linearRange domain.linear
    in
    svg
        [ viewBox 0 0 outerW outerH
        , width outerW
        , height outerH
        ]
        [ g
            [ transform [ Translate m.left m.top ]
            , class [ "series" ]
            ]
          <|
            List.map (columns config bandGroupScale bandSingleScale linearScale) (fromDataBand data)
        ]


columns : Config -> BandScale String -> BandScale String -> ContinuousScale Float -> DataGroupBand -> Svg msg
columns config bandGroupScale bandSingleScale linearScale dataGroup =
    let
        c =
            fromConfig config

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
        List.indexedMap (column config bandSingleScale linearScale) dataGroup.points


column : Config -> BandScale String -> ContinuousScale Float -> Int -> PointBand -> Svg msg
column config bandSingleScale linearScale idx point =
    let
        ( x__, y__ ) =
            point

        c =
            fromConfig config

        label =
            case c.orientation of
                Horizontal ->
                    horizontalLabel config bandSingleScale linearScale point

                Vertical ->
                    verticalLabel config bandSingleScale linearScale point

        rectangle =
            case c.orientation of
                Vertical ->
                    verticalRect config label bandSingleScale linearScale point

                Horizontal ->
                    horizontalRect config label bandSingleScale linearScale point
    in
    g [ class [ "column", "column-" ++ String.fromInt idx ] ] rectangle


verticalRect : Config -> List (Svg msg) -> BandScale String -> ContinuousScale Float -> PointBand -> List (Svg msg)
verticalRect config label bandSingleScale linearScale point =
    let
        ( x__, y__ ) =
            point
    in
    [ rect
        [ x <| Helpers.floorFloat <| Scale.convert bandSingleScale x__
        , y <| Helpers.floorFloat <| Scale.convert linearScale y__
        , width <| Helpers.floorFloat <| Scale.bandwidth bandSingleScale
        , height <| Helpers.floorFloat <| getHeight config - Scale.convert linearScale y__
        , shapeRendering RenderCrispEdges
        ]
        []
    ]
        ++ label


horizontalRect : Config -> List (Svg msg) -> BandScale String -> ContinuousScale Float -> PointBand -> List (Svg msg)
horizontalRect config label bandSingleScale linearScale point =
    let
        ( x__, y__ ) =
            point
    in
    [ rect
        [ x <| 0
        , y <| Helpers.floorFloat <| Scale.convert bandSingleScale x__
        , width <| Helpers.floorFloat <| Scale.convert linearScale y__
        , height <| Helpers.floorFloat <| Scale.bandwidth bandSingleScale
        , shapeRendering RenderCrispEdges
        ]
        []
    ]
        ++ label


dataGroupTranslation : BandScale String -> DataGroupBand -> Float
dataGroupTranslation bandGroupScale dataGroup =
    case dataGroup.groupLabel of
        Nothing ->
            0

        Just l ->
            Scale.convert bandGroupScale l


verticalLabel : Config -> BandScale String -> ContinuousScale Float -> PointBand -> List (Svg msg)
verticalLabel config bandSingleScale linearScale point =
    let
        ( x__, y__ ) =
            point

        c =
            fromConfig config
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


horizontalLabel : Config -> BandScale String -> ContinuousScale Float -> PointBand -> List (Svg msg)
horizontalLabel config bandSingleScale linearScale point =
    let
        ( x__, y__ ) =
            point

        c =
            fromConfig config
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
                    renderBand ( data, config )

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

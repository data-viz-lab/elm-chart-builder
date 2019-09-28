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
        , getDomain
        , getDomainFromData
        , getHeight
        , getLinearRange
        , getMargin
        , getWidth
        , setDimensions
        , setDomain
        , setShowColumnLabels
        , toConfig
        )
import Html exposing (Html)
import Scale exposing (BandConfig, BandScale, ContinuousScale, defaultBandConfig)
import TypedSvg exposing (g, rect, style, svg, text_)
import TypedSvg.Attributes exposing (alignmentBaseline, class, textAnchor, transform, viewBox)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), Transform(..))


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
                    Translate (dataGroupTranslation bandGroupScale dataGroup |> floor |> toFloat) 0

                Horizontal ->
                    Translate 0 (dataGroupTranslation bandGroupScale dataGroup |> floor |> toFloat)
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
        [ x <| toFloat <| floor <| Scale.convert bandSingleScale x__
        , y <| toFloat <| floor <| Scale.convert linearScale y__
        , width <| toFloat <| floor <| Scale.bandwidth bandSingleScale
        , height <| toFloat <| floor <| getHeight config - Scale.convert linearScale y__
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
        , y <| toFloat <| floor <| Scale.convert bandSingleScale x__
        , width <| toFloat <| floor <| Scale.convert linearScale y__
        , height <| toFloat <| floor <| Scale.bandwidth bandSingleScale
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
    case data of
        DataBand d ->
            renderBand ( data, config )


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

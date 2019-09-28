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
        , getDomain
        , getDomainFromData
        , getHeight
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
import TypedSvg.Attributes exposing (class, textAnchor, transform, viewBox)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))


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
            getDomain config |> fromDomainBand

        x0Range =
            ( 0, w )

        x1Range =
            ( 0, Scale.bandwidth x0Scale )

        yRange =
            ( h, 0 )

        x0Scale =
            Scale.band { defaultBandConfig | paddingInner = 0.1 } x0Range domain.x0

        x1Scale =
            Scale.band { defaultBandConfig | paddingInner = 0.05 } x1Range domain.x1

        yScale =
            Scale.linear yRange domain.y
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
            List.map (columns config x0Scale x1Scale yScale) (fromDataBand data)
        ]


columns : Config -> BandScale String -> BandScale String -> ContinuousScale Float -> DataGroupBand -> Svg msg
columns config x0Scale x1Scale yScale dataGroup =
    let
        left =
            case dataGroup.groupLabel of
                Nothing ->
                    0

                Just l ->
                    Scale.convert x0Scale l
    in
    g
        -- https://observablehq.com/@d3/grouped-bar-chart
        -- .attr("transform", d => `translate(${x0(d[groupKey])},0)`)
        [ transform [ Translate left 0 ]
        , class [ "data-group" ]
        ]
    <|
        List.indexedMap (column config x1Scale yScale) dataGroup.points


column : Config -> BandScale String -> ContinuousScale Float -> Int -> PointBand -> Svg msg
column config x1Scale yScale idx point =
    let
        ( x__, y__ ) =
            point

        c =
            fromConfig config

        label =
            if c.showColumnLabels then
                [ text_
                    [ x <| Scale.convert (Scale.toRenderable (\s -> s) x1Scale) x__
                    , y <| Scale.convert yScale y__ - 2
                    , textAnchor AnchorMiddle
                    ]
                    [ text <| x__ ]
                ]

            else
                []
    in
    g [ class [ "column", "column-" ++ String.fromInt idx ] ]
        ([ rect
            [ x <| Scale.convert x1Scale x__
            , y <| Scale.convert yScale y__
            , width <| Scale.bandwidth x1Scale
            , height <| getHeight config - Scale.convert yScale y__
            ]
            []
         ]
            ++ label
        )



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


setOrientation : Orientation -> ( Data, Config ) -> ( Data, Config )
setOrientation =
    Chart.Type.setOrientation


setMargin : Margin -> ( Data, Config ) -> ( Data, Config )
setMargin =
    Chart.Type.setMargin


setDimensions : { margin : Margin, width : Float, height : Float } -> ( Data, Config ) -> ( Data, Config )
setDimensions =
    Chart.Type.setDimensions


setDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setDomain =
    Chart.Type.setDomain


setShowColumnLabels : Bool -> ( Data, Config ) -> ( Data, Config )
setShowColumnLabels =
    Chart.Type.setShowColumnLabels

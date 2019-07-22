module Chart.Bar exposing
    ( init
    , render
    , setHeight
    , setLayout
    , setMargin
    , setOrientation
    , setWidth
    , setXDomain
    , setYDomain
    )

import Chart.Type
    exposing
        ( Axis(..)
        , Config
        , Data(..)
        , DataGroupBL
        , DataGroupLL
        , Domain(..)
        , Layout(..)
        , Margin
        , Orientation(..)
        , PointBL
        , PointLL
        , defaultHeight
        , defaultLayout
        , defaultMargin
        , defaultOrientation
        , defaultWidth
        , fromConfig
        , fromDomainBand
        , fromDomainLinear
        , fromMargin
        , getDomain
        , getDomainFromData
        , getDomainX1
        , getHeight
        , getMargin
        , getWidth
        , toConfig
        , toMargin
        )
import Html exposing (Html)
import Scale exposing (BandConfig, BandScale, ContinuousScale, defaultBandConfig)
import TypedSvg exposing (g, rect, style, svg, text_)
import TypedSvg.Attributes exposing (class, textAnchor, transform, viewBox)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))


init : Data -> ( Data, Config )
init data =
    ( data, initConfig )
        |> setXDomain (getDomainFromData X data)
        |> setYDomain (getDomainFromData Y data)


initConfig : Config
initConfig =
    toConfig
        { height = defaultHeight
        , layout = defaultLayout
        , margin = defaultMargin
        , orientation = defaultOrientation
        , width = defaultWidth
        , xDomain0 = NoDomain
        , xDomain1 = NoDomain
        , yDomain = NoDomain
        }


render : ( Data, Config ) -> Html msg
render ( data, config ) =
    case data of
        DataBL d ->
            renderBand ( d, config )

        DataLL _ ->
            Html.text "not yet implemented"


renderBand : ( Data, Config ) -> Html msg
renderBand ( data, config ) =
    let
        w =
            getWidth config

        h =
            getHeight config

        m =
            getMargin config

        x0Domain =
            getDomain X config |> fromDomainBand

        x1Domain =
            getDomainX1 config |> fromDomainBand

        yDomain =
            getDomain Y config |> fromDomainLinear

        x0Range =
            ( 0, w )

        yRange =
            ( h, 0 )

        x0Scale =
            Scale.band defaultBandConfig x0Range x0Domain

        x1Range =
            ( 0, Scale.bandwidth x0Scale )

        x1Scale =
            Scale.band defaultBandConfig x1Range x1Domain

        yScale =
            Scale.linear yRange yDomain
    in
    svg
        [ viewBox 0 0 w h
        , width w
        , height h
        ]
        [ g
            [ transform [ Translate m.left m.top ]
            , class [ "series" ]
            ]
          <|
            List.map (columns config x0Scale x1Scale yScale) data
        ]


columns : Config -> BandScale String -> BandScale String -> ContinuousScale Float -> DataGroup -> Svg msg
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
        List.map (column config x1Scale yScale) dataGroup.points


column : Config -> BandScale String -> ContinuousScale Float -> Datum -> Svg msg
column config xScale yScale datum =
    let
        ( x__, y__ ) =
            case datum.point of
                PointBand ( x_, y_ ) ->
                    ( x_, y_ )

                _ ->
                    ( "", 0 )
    in
    g [ class [ "column" ] ]
        [ rect
            [ x <| Scale.convert xScale x__
            , y <| Scale.convert yScale y__
            , width <| Scale.bandwidth xScale
            , height <| getHeight config - Scale.convert yScale y__
            ]
            []
        , text_
            [ x <| Scale.convert (Scale.toRenderable (\s -> s) xScale) x__
            , y <| Scale.convert yScale y__
            , textAnchor AnchorMiddle
            ]
            [ text <| x__ ]
        ]



-- EXPOSED SETTERS


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


setXDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setXDomain =
    Chart.Type.setXDomain


setYDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setYDomain =
    Chart.Type.setYDomain

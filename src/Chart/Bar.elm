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
        , Data
        , Domain(..)
        , Layout(..)
        , Margin
        , Orientation(..)
        , Point(..)
        , defaultHeight
        , defaultLayout
        , defaultMargin
        , defaultOrientation
        , defaultWidth
        , fromConfig
        , fromMargin
        , getDataPointStructure
        , getDomainFromData
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
        , xDomain = NoDomain
        , yDomain = NoDomain
        }


render : ( Data, Config ) -> Html msg
render ( data, config ) =
    case getDataPointStructure data of
        PointBand _ ->
            renderBand ( data, config )

        NoPoint ->
            Html.text "no point struncture"

        _ ->
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

        xRange =
            ( 0, w )

        yRange =
            ( h, 0 )

        xScale =
            Scale.band defaultBandConfig xRange

        yScale =
            Scale.linear yRange
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
            []
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

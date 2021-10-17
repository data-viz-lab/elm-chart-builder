module Chart.Internal.GeometryHelpers exposing (verticalRect)

import Chart.Internal.Symbol as Symbol
import Scale


type alias Rect =
    { x_ : Float, y_ : Float, w : Float, h : Float }


verticalRect :
    Float
    -> Maybe Float
    -> Scale.BandScale String
    -> Scale.ContinuousScale Float
    -> ( String, Float )
    -> Rect
verticalRect height symbolOffset bandSingleScale continuousScale point =
    let
        ( x__, y__ ) =
            point

        labelOffset =
            symbolOffset
                |> Maybe.map (always w)
                |> Maybe.withDefault 0

        w =
            Scale.bandwidth bandSingleScale

        h =
            height
                - Scale.convert continuousScale y__
                - Maybe.withDefault 0 symbolOffset

        x_ =
            Scale.convert bandSingleScale x__

        y_ =
            Scale.convert continuousScale y__
                + Maybe.withDefault 0 symbolOffset
    in
    { x_ = x_, y_ = y_, w = w, h = h }

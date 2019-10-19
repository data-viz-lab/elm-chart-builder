module Chart.Symbol exposing (triangle)

import TypedSvg exposing (polygon)
import TypedSvg.Attributes exposing (points)
import TypedSvg.Core exposing (Svg)


type Symbol
    = Triangle


triangle : Float -> Svg msg
triangle size =
    polygon
        [ points
            [ ( size / 2, 0.0 )
            , ( size, size )
            , ( 0.0, size )
            ]
        ]
        []

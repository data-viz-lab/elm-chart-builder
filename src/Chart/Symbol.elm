module Chart.Symbol exposing
    ( Symbol(..)
    , circle_
    , corner
    , getSymbolByIndex
    , symbolGap
    , triangle
    )

import List.Extra
import TypedSvg exposing (circle, polygon)
import TypedSvg.Attributes exposing (points, r)
import TypedSvg.Attributes.InPx exposing (r)
import TypedSvg.Core exposing (Svg)


type Symbol
    = Circle
    | Corner
    | Triangle


symbolGap : Float
symbolGap =
    2.0


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


circle_ : Float -> Svg msg
circle_ radius =
    circle [ r radius ] []


corner : Float -> Svg msg
corner size =
    polygon
        [ points
            [ ( 0.0, 0.0 )
            , ( size, 0.0 )
            , ( size, size )
            ]
        ]
        []


allSymbols : List Symbol
allSymbols =
    [ Circle, Corner, Triangle ]


getSymbolByIndex : Int -> Symbol
getSymbolByIndex idx =
    allSymbols
        |> List.Extra.getAt (modBy (List.length allSymbols) idx)
        |> Maybe.withDefault Triangle

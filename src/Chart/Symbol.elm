module Chart.Symbol exposing
    ( Symbol(..)
    , allSymbols
    , circle_
    , corner
    , custom
    , getSymbolByIndex
    , symbolGap
    , triangle
    )

import List.Extra
import TypedSvg exposing (circle, path, polygon)
import TypedSvg.Attributes exposing (d, points, r, transform, viewBox)
import TypedSvg.Attributes.InPx exposing (r)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..))


type Symbol msg
    = Circle
    | Custom String
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


custom : String -> Svg msg
custom d_ =
    path
        [ d d_
        , transform [ Scale 0.04 0.04 ]
        ]
        []


allSymbols : List (Symbol msg)
allSymbols =
    [ Circle, Corner, Triangle ]


getSymbolByIndex : List (Symbol msg) -> Int -> Symbol msg
getSymbolByIndex all idx =
    all
        |> List.Extra.getAt (modBy (List.length all) idx)
        |> Maybe.withDefault Triangle

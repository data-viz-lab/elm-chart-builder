module Chart.Internal.Symbol exposing
    ( CustomSymbolConf
    , Symbol(..)
    , circle_
    , corner
    , custom
    , getSymbolByIndex
    , symbolGap
    , symbolToId
    , triangle
    )

import List.Extra
import TypedSvg exposing (circle, g, path, polygon)
import TypedSvg.Attributes exposing (d, points, r, transform)
import TypedSvg.Attributes.InPx as InPx
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..))


type alias CustomSymbolConf =
    { identifier : String
    , width : Float
    , height : Float
    , paths : List String
    , useGap : Bool
    }


type Symbol msg
    = Circle String
    | Custom CustomSymbolConf
    | Corner String
    | Triangle String
    | NoSymbol


symbolToId : Symbol msg -> String
symbolToId symbol =
    case symbol of
        Circle id ->
            id

        Custom { identifier } ->
            identifier

        Corner id ->
            id

        Triangle id ->
            id

        NoSymbol ->
            ""


symbolGap : Float
symbolGap =
    0.0


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
    circle [ InPx.r radius ] []


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


custom : Float -> CustomSymbolConf -> Svg msg
custom scaleFactor conf =
    g [ transform [ Scale scaleFactor scaleFactor ] ] <|
        List.map (\d_ -> path [ d d_ ] []) conf.paths


getSymbolByIndex : List (Symbol msg) -> Int -> Symbol msg
getSymbolByIndex all idx =
    if List.length all > 0 then
        all
            |> List.Extra.getAt (modBy (List.length all) idx)
            |> Maybe.withDefault NoSymbol

    else
        NoSymbol

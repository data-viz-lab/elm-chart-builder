module Chart.Internal.Symbol exposing
    ( CustomSymbolConf
    , Scaler
    , Symbol(..)
    , SymbolConf
    , SymbolContext(..)
    , annotationScaler
    , circle_
    , corner
    , custom
    , getSymbolByIndex
    , getSymbolSize
    , initialConf
    , initialCustomConf
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


type Symbol
    = Circle SymbolConf
    | Custom CustomSymbolConf
    | Corner SymbolConf
    | Triangle SymbolConf
    | NoSymbol


type SymbolContext
    = AnnotationSymbol Scaler
    | ChartSymbol


type alias Scaler =
    Float


annotationScaler : Scaler
annotationScaler =
    1.25



--FIXME: take width, height instead of size


type alias SymbolConf =
    { identifier : String
    , size : Maybe Float
    , styles : List ( String, String )
    }


type alias CustomSymbolConf =
    { identifier : String
    , viewBoxWidth : Float
    , viewBoxHeight : Float
    , paths : List String
    , useGap : Bool
    , styles : List ( String, String )
    }


initialConf : SymbolConf
initialConf =
    { identifier = "symbol"
    , size = Nothing
    , styles = []
    }


initialCustomConf : CustomSymbolConf
initialCustomConf =
    { identifier = "custom-symbol"
    , viewBoxWidth = 0
    , viewBoxHeight = 0
    , paths = []
    , useGap = True
    , styles = []
    }


symbolToId : Symbol -> String
symbolToId symbol =
    case symbol of
        Circle { identifier } ->
            identifier

        Custom { identifier } ->
            identifier

        Corner { identifier } ->
            identifier

        Triangle { identifier } ->
            identifier

        NoSymbol ->
            ""


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
circle_ size =
    circle [ InPx.cx <| size / 2, InPx.cy <| size / 2, InPx.r <| size / 2 ] []


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


getSymbolByIndex : List Symbol -> Int -> Symbol
getSymbolByIndex all idx =
    if List.length all > 0 then
        all
            |> List.Extra.getAt (modBy (List.length all) idx)
            |> Maybe.withDefault NoSymbol

    else
        NoSymbol


getSymbolSize : Symbol -> Maybe Float
getSymbolSize symbol =
    case symbol of
        Triangle c ->
            c.size

        Circle c ->
            c.size

        Custom _ ->
            --TODO
            Nothing

        Corner c ->
            c.size

        NoSymbol ->
            Nothing

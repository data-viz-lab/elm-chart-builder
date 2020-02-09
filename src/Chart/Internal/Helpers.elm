module Chart.Internal.Helpers exposing
    ( dataBandToDataStacked
    , dataLinearGroupToDataLinearStacked
    , dataLinearGroupToDataTimeStacked
    , floorFloat
    , floorValues
    , stackedValuesInverse
    )

import Chart.Internal.Type
    exposing
        ( Config
        , DataBand
        , DataGroupLinear
        , DataGroupTime
        , DataLinearGroup(..)
        , PointStacked
        , StackedValues
        , fromDataBand
        , getDomainBandFromData
        )
import List.Extra
import Time exposing (Posix)


dataBandToDataStacked : DataBand -> Config -> List ( String, List Float )
dataBandToDataStacked data config =
    let
        seed =
            getDomainBandFromData data config
                |> .bandSingle
                |> Maybe.withDefault []
                |> List.map (\d -> ( d, [] ))
    in
    data
        |> fromDataBand
        |> List.map .points
        |> List.concat
        |> List.foldl
            (\d acc ->
                List.map
                    (\a ->
                        if Tuple.first d == Tuple.first a then
                            ( Tuple.first a, Tuple.second d :: Tuple.second a )

                        else
                            a
                    )
                    acc
            )
            seed


stackedValuesInverse : Float -> StackedValues -> StackedValues
stackedValuesInverse width values =
    values
        |> List.map
            (\v ->
                let
                    ( left, right ) =
                        v.stackedValue
                in
                { v | stackedValue = ( abs <| left - width, abs <| right - width ) }
            )


floorFloat : Float -> Float
floorFloat f =
    f |> floor |> toFloat


floorValues : List (List ( Float, Float )) -> List (List ( Float, Float ))
floorValues v =
    v
        |> List.map
            (\d ->
                d
                    |> List.map (\( a, b ) -> ( floorFloat a, floorFloat b ))
            )


reduceLeftStack : List { groupLabel : Maybe String, points : List ( a, Float ) } -> List a
reduceLeftStack d =
    d
        |> List.head
        |> Maybe.map .points
        |> Maybe.withDefault []
        |> List.map Tuple.first


reduceRightStack : List { groupLabel : Maybe String, points : List ( a, Float ) } -> List (List Float)
reduceRightStack d =
    d
        |> List.map .points
        |> List.map
            (\i ->
                i
                    |> List.map Tuple.second
            )
        |> List.reverse
        |> List.Extra.transpose


dataLinearGroupToDataTimeStacked : List DataGroupTime -> Config -> List (PointStacked Posix)
dataLinearGroupToDataTimeStacked d config =
    let
        ( left, right ) =
            ( reduceLeftStack d, reduceRightStack d )

        result =
            List.Extra.zip left right
    in
    result


dataLinearGroupToDataLinearStacked : List DataGroupLinear -> Config -> List (PointStacked Float)
dataLinearGroupToDataLinearStacked d config =
    let
        ( left, right ) =
            ( reduceLeftStack d, reduceRightStack d )

        result =
            List.Extra.zip left right
    in
    result

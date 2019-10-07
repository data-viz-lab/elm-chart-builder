module Chart.Helpers exposing
    ( dataBandToDataStacked
    , floorFloat
    , floorValues
    , stackedValuesInverse
    )

import Chart.Type
    exposing
        ( Data
        , DataGroupBand
        , fromDataBand
        , fromDomainBand
        , getDomainFromData
        )


dataBandToDataStacked : Data -> List ( String, List Float )
dataBandToDataStacked data =
    let
        seed =
            getDomainFromData data
                |> fromDomainBand
                |> .bandSingle
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


stackedValuesInverse : Float -> List ( Float, Float ) -> List ( Float, Float )
stackedValuesInverse width values =
    values |> List.map (\( left, right ) -> ( abs <| left - width, abs <| right - width ))


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

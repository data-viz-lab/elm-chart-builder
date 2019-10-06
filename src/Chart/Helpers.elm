module Chart.Helpers exposing
    ( dataBandToDataStacked
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

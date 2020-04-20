module Chart.Internal.Helpers exposing
    ( combineStakedValuesWithXValues
    , floorFloat
    , floorValues
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


combineStakedValuesWithXValues : List (List ( Float, Float )) -> List (List Float) -> List (List ( Float, Float ))
combineStakedValuesWithXValues values xValues =
    List.map2
        (\lineValues xs ->
            List.map2
                (\value x ->
                    ( x, Tuple.second value )
                )
                lineValues
                xs
        )
        values
        xValues

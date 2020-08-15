module Chart.Internal.Helpers exposing
    ( colorPaletteToColor
    , combineStakedValuesWithXValues
    , floorFloat
    , floorValues
    , mergeStyles
    )

import Color exposing (Color)


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


colorPaletteToColor : List Color -> Int -> String
colorPaletteToColor palette idx =
    let
        moduleIndex =
            modBy (List.length palette) idx
    in
    palette
        |> List.drop moduleIndex
        |> List.head
        |> Maybe.withDefault Color.white
        |> Color.toCssString


mergeStyles : List ( String, String ) -> String -> String
mergeStyles new existing =
    new
        |> List.foldl
            (\newTuple existingStrings ->
                let
                    existingString =
                        String.join ";" existingStrings

                    newString =
                        Tuple.first newTuple ++ ":" ++ Tuple.second newTuple
                in
                if String.contains (Tuple.first newTuple) existingString then
                    --override
                    existingStrings
                        |> List.filter
                            (\s ->
                                s
                                    |> String.split ":"
                                    |> List.head
                                    |> Maybe.withDefault ""
                                    |> (\v -> v /= Tuple.first newTuple)
                            )
                        |> (::) newString

                else
                    newString :: existingStrings
            )
            (String.split ";" existing)
        |> String.join ";"

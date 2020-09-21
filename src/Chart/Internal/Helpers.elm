module Chart.Internal.Helpers exposing
    ( colorPaletteToColor
    , floorFloat
    , floorValues
    , invisibleFigcaption
    , mergeStyles
    , sortStrings
    , stackDataGroupLinear
    , toUtcString
    )

import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes
import Time exposing (toHour, toMinute, toSecond, utc)


type alias DataGroupLinear =
    { groupLabel : Maybe String
    , points : List ( Float, Float )
    }


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


stackDataGroupLinear :
    List (List ( Float, Float ))
    -> List DataGroupLinear
    -> List DataGroupLinear
stackDataGroupLinear values groupData =
    List.map2
        (\vals group ->
            { groupLabel = group.groupLabel
            , points = List.map2 (\( _, y ) ( x, _ ) -> ( x, y )) vals group.points
            }
        )
        values
        groupData


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


invisibleFigcaption : List (Html msg) -> Html msg
invisibleFigcaption content =
    Html.figcaption
        [ Html.Attributes.style "border" "0"
        , Html.Attributes.style "clip" "rect(0 0 0 0)"
        , Html.Attributes.style "height" "1px"
        , Html.Attributes.style "margin" "-1px"
        , Html.Attributes.style "overflow" "hidden"
        , Html.Attributes.style "padding" "0"
        , Html.Attributes.style "position" "absolute"
        , Html.Attributes.style "width" "1px"
        ]
        content


toUtcString : Time.Posix -> String
toUtcString time =
    String.fromInt (toHour utc time)
        ++ ":"
        ++ String.fromInt (toMinute utc time)
        ++ ":"
        ++ String.fromInt (toSecond utc time)
        ++ " (UTC)"


sortStrings : (a -> String) -> List a -> List a
sortStrings accessor strings =
    List.sortWith
        (\a_ b_ ->
            let
                a =
                    accessor a_

                b =
                    accessor b_
            in
            case ( a |> String.toFloat, b |> String.toFloat ) of
                ( Just floatA, Just floatB ) ->
                    compare floatA floatB

                _ ->
                    compare a b
        )
        strings

module Chart.Internal.TableHelpers exposing
    ( dataBandToTableData
    , dataBandToTableHeadings
    , dataLinearGroupToTableData
    , dataLinearGroupToTableHeadings
    )

import Chart.Internal.Helpers as Helpers
import Chart.Internal.Table as Table
import Chart.Internal.Type as Type
import List.Extra


dataBandToTableData : Type.DataBand -> List (List String)
dataBandToTableData data =
    data
        |> Type.fromDataBand
        |> List.map .points
        |> List.Extra.transpose
        |> List.map
            (\points ->
                points
                    |> List.map (\p -> [ Tuple.first p, Tuple.second p |> String.fromFloat ])
                    |> List.concat
            )


dataLinearGroupToTableData : Type.DataLinearGroup -> List (List String)
dataLinearGroupToTableData data =
    case data of
        Type.DataTime data_ ->
            data_
                |> List.map .points
                |> List.Extra.transpose
                |> List.map
                    (\points ->
                        points
                            |> List.map
                                (\p ->
                                    [ Tuple.first p |> Helpers.toUtcString
                                    , Tuple.second p |> String.fromFloat
                                    ]
                                )
                            |> List.concat
                    )

        Type.DataLinear data_ ->
            data_
                |> List.map .points
                |> List.Extra.transpose
                |> List.map
                    (\points ->
                        points
                            |> List.map
                                (\p ->
                                    [ Tuple.first p |> String.fromFloat
                                    , Tuple.second p |> String.fromFloat
                                    ]
                                )
                            |> List.concat
                    )


dataBandToTableHeadings : Type.DataBand -> List Table.ComplexHeading
dataBandToTableHeadings data =
    data
        |> Type.fromDataBand
        |> List.map
            (\d ->
                Table.HeadingAndSubHeadings (Maybe.withDefault "" d.groupLabel) [ "x", "y" ]
            )


dataLinearGroupToTableHeadings : Type.DataLinearGroup -> List Table.ComplexHeading
dataLinearGroupToTableHeadings data =
    let
        toHeading d =
            Table.HeadingAndSubHeadings (Maybe.withDefault "" d.groupLabel) [ "x", "y" ]
    in
    case data of
        Type.DataTime data_ ->
            data_
                |> List.map toHeading

        Type.DataLinear data_ ->
            data_
                |> List.map toHeading

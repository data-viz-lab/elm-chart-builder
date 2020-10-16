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


dataBandToTableHeadings : Type.DataBand -> Table.Headings
dataBandToTableHeadings data =
    data
        |> Type.fromDataBand
        |> (\dataBand ->
                if Type.noGroups dataBand then
                    dataBand
                        |> always (Table.Headings [ "x", "y" ])

                else
                    dataBand
                        |> List.map
                            (\d ->
                                Table.HeadingAndSubHeadings (Maybe.withDefault "" d.groupLabel) [ "x", "y" ]
                            )
                        |> Table.ComplexHeadings
           )


dataLinearGroupToTableHeadings : Type.DataLinearGroup -> Table.Headings
dataLinearGroupToTableHeadings data =
    let
        toHeading d =
            Table.HeadingAndSubHeadings (Maybe.withDefault "" d.groupLabel) [ "x", "y" ]

        toHeadings dd =
            if Type.noGroups dd then
                dd
                    |> always (Table.Headings [ "x", "y" ])

            else
                dd
                    |> List.map toHeading
                    |> Table.ComplexHeadings
    in
    case data of
        Type.DataTime data_ ->
            toHeadings data_

        Type.DataLinear data_ ->
            toHeadings data_

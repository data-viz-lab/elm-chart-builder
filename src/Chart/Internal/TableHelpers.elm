module Chart.Internal.TableHelpers exposing
    ( dataBandToTableData
    , dataBandToTableHeadings
    , dataLinearGroupToRowHeadings
    , dataLinearGroupToTableData
    , dataLinearGroupToTableHeadings
    )

import Chart.Internal.Helpers as Helpers
import Chart.Internal.Table as Table
import Chart.Internal.Type as Type
import LTTB
import List.Extra
import Scale
import Time exposing (Posix)


dataThreshold : List a -> Int
dataThreshold data =
    Scale.convert
        (Scale.linear ( 6, 25 ) ( 0, 500 ) |> Scale.clamp)
        (data |> List.length |> toFloat)
        |> floor


downsampleDataLinear : List ( Float, Float ) -> List ( Float, Float )
downsampleDataLinear data =
    LTTB.downsample
        { data = data
        , threshold = dataThreshold data
        , xGetter = Tuple.first
        , yGetter = Tuple.second
        }


downsampleDataTime : List ( Posix, Float ) -> List ( Posix, Float )
downsampleDataTime data =
    LTTB.downsample
        { data = data
        , threshold = dataThreshold data
        , xGetter = Tuple.first >> Time.posixToMillis >> toFloat
        , yGetter = Tuple.second
        }


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
                |> List.map downsampleDataTime
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
                |> List.map downsampleDataLinear
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


dataBandToTableHeadings : Type.DataBand -> Type.AccessibilityContent -> Table.Headings
dataBandToTableHeadings data content =
    data
        |> Type.fromDataBand
        |> (\dataBand ->
                if Type.noGroups dataBand then
                    dataBand
                        |> always (Table.Headings <| getLabelsFromContent content)

                else
                    dataBand
                        |> List.map
                            (\d ->
                                Table.HeadingAndSubHeadings (Maybe.withDefault "" d.groupLabel)
                                    (getLabelsFromContent content)
                            )
                        |> Table.ComplexHeadings
           )


dataLinearGroupToTableHeadings : Type.DataLinearGroup -> Type.AccessibilityContent -> Table.Headings
dataLinearGroupToTableHeadings data content =
    let
        toHeading d =
            Table.HeadingAndSubHeadings (Maybe.withDefault "" d.groupLabel)
                (getLabelsFromContent content)

        toHeadings dd =
            if Type.noGroups dd then
                dd
                    |> always (Table.Headings <| getLabelsFromContent content)

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


getLabelsFromContent : Type.AccessibilityContent -> List String
getLabelsFromContent content =
    case content of
        Type.AccessibilityTable ( xLabel, yLabel ) ->
            [ xLabel, yLabel ]

        _ ->
            [ "x", "y" ]


getRowLabelsFromContent : Type.AccessibilityContent -> List String
getRowLabelsFromContent content =
    case content of
        Type.AccessibilityTable ( xLabel, yLabel ) ->
            [ xLabel ]

        _ ->
            [ "x" ]


dataLinearGroupToRowHeadings : Type.DataLinearGroup -> Type.AccessibilityContent -> Table.Headings
dataLinearGroupToRowHeadings data content =
    --TODO: this is controvertial and needs more thoughts
    let
        toHeadings dd =
            if Type.noGroups dd then
                dd
                    |> always (Table.Headings <| getRowLabelsFromContent content)

            else
                dd
                    |> List.map .points
                    |> List.map downsampleDataLinear
                    |> List.head
                    |> Maybe.withDefault []
                    |> List.map (Tuple.first >> String.fromFloat)
                    |> Table.Headings
    in
    case data of
        Type.DataTime data_ ->
            Table.Headings []

        Type.DataLinear data_ ->
            toHeadings data_

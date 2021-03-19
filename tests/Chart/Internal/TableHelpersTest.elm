module Chart.Internal.TableHelpersTest exposing (suite)

import Chart.Internal.Table as Table
import Chart.Internal.TableHelpers exposing (..)
import Chart.Internal.Type exposing (..)
import Expect exposing (Expectation)
import Test exposing (..)
import Time exposing (Posix)


suite : Test
suite =
    Test.describe "The table helpers module"
        [ dataBandToTableDataTest
        , dataLinearGroupToRowHeadingsTest
        ]


dataLinearGroupToRowHeadingsTest : Test
dataLinearGroupToRowHeadingsTest =
    describe "dataLinearGroupToRowHeadings"
        [ test "It should return the correct data for the Table row headings" <|
            \_ ->
                let
                    dataLinear =
                        DataContinuous
                            [ { groupLabel = Just "East Midlands Male"
                              , points = [ ( 1998, 30.9 ), ( 1999, 26.2 ) ]
                              }
                            , { groupLabel = Just "London Male"
                              , points = [ ( 1998, 29.8 ), ( 1999, 31.8 ) ]
                              }
                            ]

                    rowHeadings =
                        [ "1998", "1999" ]
                in
                Expect.equal (dataContinuousGroupToRowHeadings dataLinear AccessibilityTableNoLabels)
                    (Table.Headings rowHeadings)
        ]


dataBandToTableDataTest : Test
dataBandToTableDataTest =
    describe "dataBandToTableData"
        [ test "It should return the correct data for the Table module" <|
            \_ ->
                let
                    dataBand =
                        toDataBand
                            [ { groupLabel = Just "A"
                              , points = [ ( "a", 1000 ), ( "b", 1300 ), ( "c", 1600 ) ]
                              }
                            , { groupLabel = Just "B"
                              , points = [ ( "a", 1100 ), ( "b", 2300 ), ( "c", 1600 ) ]
                              }
                            ]

                    dataTable =
                        [ [ "a", "1000", "a", "1100" ]
                        , [ "b", "1300", "b", "2300" ]
                        , [ "c", "1600", "c", "1600" ]
                        ]

                    config =
                        { tableFloatFormat = String.fromFloat }
                in
                Expect.equal (dataBandToTableData config dataBand) dataTable
        ]

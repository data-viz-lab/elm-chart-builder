module Chart.Internal.TableTest exposing (suite)

import Chart.Internal.Table exposing (..)
import Chart.Internal.Type exposing (..)
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "The Table module"
        [ describe "dataBandToTableData"
            [ only <|
                test "It should return the correct data for the Table module" <|
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
                        in
                        Expect.equal (dataBandToTableData dataBand) dataTable
            ]
        ]

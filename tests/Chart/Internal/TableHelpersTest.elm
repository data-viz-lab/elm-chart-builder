module Chart.Internal.TableHelpersTest exposing (suite)

import Chart.Internal.TableHelpers exposing (..)
import Chart.Internal.Type exposing (..)
import Expect exposing (Expectation)
import Test exposing (..)
import Time exposing (Posix)


suite : Test
suite =
    describe "The Helpers module"
        [ describe "dataBandToTableData"
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
                    in
                    Expect.equal (dataBandToTableData dataBand) dataTable
            ]
        ]

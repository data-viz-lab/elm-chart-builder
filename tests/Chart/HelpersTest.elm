module Chart.HelpersTest exposing (suite)

import Chart.Helpers exposing (..)
import Chart.Type exposing (..)
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "The Type module"
        [ describe "getDomainFromData"
            [ test "with DomainBand" <|
                \_ ->
                    let
                        data : Data
                        data =
                            DataBand
                                [ { groupLabel = Just "CA", points = [ ( "a", 10 ), ( "b", 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( "a", 11 ), ( "b", 21 ) ] }
                                ]

                        expected : List ( String, List Float )
                        expected =
                            [ ( "a", [ 11, 10 ] ), ( "b", [ 21, 20 ] ) ]
                    in
                    Expect.equal (dataBandToDataStacked data) expected
            ]
        ]

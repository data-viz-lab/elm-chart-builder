module Chart.TypeTest exposing (suite)

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

                        expected : Domain
                        expected =
                            DomainBand { bandGroup = [ "CA", "TX" ], bandSingle = [ "a", "b" ], linear = ( 0, 21 ) }
                    in
                    Expect.equal (getDomainFromData data) expected
            ]
        ]

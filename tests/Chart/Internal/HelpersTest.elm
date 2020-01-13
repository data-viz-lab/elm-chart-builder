module Chart.Internal.HelpersTest exposing (suite)

import Chart.Internal.Helpers exposing (..)
import Chart.Internal.Type exposing (..)
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "The Helpers module"
        [ describe "dataBandToDataStacked"
            [ test "simple" <|
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
                    Expect.equal (dataBandToDataStacked data defaultConfig) expected
            , test "complex" <|
                \_ ->
                    let
                        data : Data
                        data =
                            DataBand
                                [ { groupLabel = Just "16-24"
                                  , points =
                                        [ ( "once per month", 21.1 )
                                        , ( "once per week", 15 )
                                        , ( "three times per week", 7.8 )
                                        , ( "five times per week", 4.9 )
                                        ]
                                  }
                                , { groupLabel = Just "25-34"
                                  , points =
                                        [ ( "once per month", 19 )
                                        , ( "once per week", 13.1 )
                                        , ( "three times per week", 7 )
                                        , ( "five times per week", 4.5 )
                                        ]
                                  }
                                , { groupLabel = Just "35-44"
                                  , points =
                                        [ ( "once per month", 21.9 )
                                        , ( "once per week", 15.1 )
                                        , ( "three times per week", 7.2 )
                                        , ( "five times per week", 4.2 )
                                        ]
                                  }
                                ]

                        expected : List ( String, List Float )
                        expected =
                            [ ( "once per month", [ 21.9, 19, 21.1 ] )
                            , ( "once per week", [ 15.1, 13.1, 15 ] )
                            , ( "three times per week", [ 7.2, 7, 7.8 ] )
                            , ( "five times per week", [ 4.2, 4.5, 4.9 ] )
                            ]
                    in
                    Expect.equal (dataBandToDataStacked data defaultConfig) expected
            ]
        ]

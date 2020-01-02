module Chart.Internal.BarTest exposing (suite)

import Chart.Internal.Bar exposing (getStackedValuesAndGroupes)
import Chart.Internal.Type exposing (..)
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "The Bar module"
        [ describe "getStackedValuesAndGroupes"
            [ test "Values are ordered in accordance with groupes" <|
                \_ ->
                    let
                        data : Data
                        data =
                            DataBand
                                [ { groupLabel = Just "16-24"
                                  , points =
                                        [ ( "once per month", 21.1 )
                                        , ( "once per week", 15.0 )
                                        , ( "three times per week", 7.8 )
                                        , ( "five times per week", 4.9 )
                                        ]
                                  }
                                , { groupLabel = Just "25-34"
                                  , points =
                                        [ ( "once per month", 19.0 )
                                        , ( "once per week", 13.1 )
                                        , ( "three times per week", 7.0 )
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

                        values =
                            [ [ ( 0, 4.2 ), ( 0, 4.5 ), ( 0, 4.9 ) ]
                            , [ ( 4.2, 26.099999999999998 ), ( 4.5, 23.5 ), ( 4.9, 26 ) ]
                            , [ ( 26.099999999999998, 41.199999999999996 ), ( 23.5, 36.6 ), ( 26, 41 ) ]
                            , [ ( 41.199999999999996, 48.4 ), ( 36.6, 43.6 ), ( 41, 48.8 ) ]
                            ]

                        expected : ( List (List ( Float, Float )), List String )
                        expected =
                            ( [ [ ( 0, 4.9 ), ( 4.9, 26 ), ( 26, 41 ), ( 41, 48.8 ) ]
                              , [ ( 0, 4.5 ), ( 4.5, 23.5 ), ( 23.5, 36.6 ), ( 36.6, 43.6 ) ]
                              , [ ( 0, 4.2 )
                                , ( 4.2, 26.099999999999998 )
                                , ( 26.099999999999998, 41.199999999999996 )
                                , ( 41.199999999999996, 48.4 )
                                ]
                              ]
                            , [ "16-24", "25-34", "35-44" ]
                            )
                    in
                    Expect.equal (getStackedValuesAndGroupes values data) expected
            ]
        ]

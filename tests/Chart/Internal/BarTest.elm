module Chart.Internal.BarTest exposing (suite)

import Chart.Internal.Bar exposing (getStackedValuesAndGroupes)
import Chart.Internal.Type as Type
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "The Bar module"
        [ describe "getStackedValuesAndGroupes"
            [ test "Values are ordered in accordance with groupes" <|
                \_ ->
                    let
                        data : Type.Data
                        data =
                            Type.DataBand
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

                        values : List (List ( Float, Float ))
                        values =
                            [ [ ( 0, 4.2 ), ( 0, 4.5 ), ( 0, 4.9 ) ]
                            , [ ( 4.2, 26.099999999999998 ), ( 4.5, 23.5 ), ( 4.9, 26 ) ]
                            , [ ( 26.099999999999998, 41.199999999999996 ), ( 23.5, 36.6 ), ( 26, 41 ) ]
                            , [ ( 41.199999999999996, 48.4 ), ( 36.6, 43.6 ), ( 41, 48.8 ) ]
                            ]

                        expected : Type.StackedValuesAndGroupes
                        expected =
                            ( [ [ { rawValue = 21.1, stackedValue = ( 0, 4.9 ) }
                                , { rawValue = 15.0, stackedValue = ( 4.9, 26 ) }
                                , { rawValue = 7.8, stackedValue = ( 26, 41 ) }
                                , { rawValue = 4.9, stackedValue = ( 41, 48.8 ) }
                                ]
                              , [ { rawValue = 19.0, stackedValue = ( 0, 4.5 ) }
                                , { rawValue = 13.1, stackedValue = ( 4.5, 23.5 ) }
                                , { rawValue = 7.0, stackedValue = ( 23.5, 36.6 ) }
                                , { rawValue = 4.5, stackedValue = ( 36.6, 43.6 ) }
                                ]
                              , [ { rawValue = 21.9, stackedValue = ( 0, 4.2 ) }
                                , { rawValue = 15.1, stackedValue = ( 4.2, 26.099999999999998 ) }
                                , { rawValue = 7.2, stackedValue = ( 26.099999999999998, 41.199999999999996 ) }
                                , { rawValue = 4.2, stackedValue = ( 41.199999999999996, 48.4 ) }
                                ]
                              ]
                            , [ "16-24", "25-34", "35-44" ]
                            )
                    in
                    Expect.equal (getStackedValuesAndGroupes values data) expected
            ]
        ]

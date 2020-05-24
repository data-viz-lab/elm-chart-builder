module Chart.Internal.TypeTest exposing (suite)

import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type exposing (..)
import Expect exposing (Expectation)
import Test exposing (..)
import Time exposing (Posix)


type alias Data =
    { x : Posix, y : Float, groupLabel : String }


suite : Test
suite =
    describe "The Type module"
        [ describe "getDomainBandFromData"
            [ test "with DomainBand" <|
                \_ ->
                    let
                        data : DataBand
                        data =
                            toDataBand
                                [ { groupLabel = Just "CA", points = [ ( "a", 10 ), ( "b", 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( "a", 11 ), ( "b", 21 ) ] }
                                ]

                        expected : DomainBandStruct
                        expected =
                            { bandGroup = Just [ "CA", "TX" ]
                            , bandSingle = Just [ "a", "b" ]
                            , linear = Just ( 0, 21 )
                            }
                    in
                    Expect.equal (getDomainBandFromData data defaultConfig) expected
            , test "with DomainBand complex example" <|
                \_ ->
                    let
                        data : DataBand
                        data =
                            toDataBand
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

                        expected : DomainBandStruct
                        expected =
                            { bandGroup = Just [ "16-24", "25-34", "35-44" ]
                            , bandSingle =
                                Just
                                    [ "once per month"
                                    , "once per week"
                                    , "three times per week"
                                    , "five times per week"
                                    ]
                            , linear = Just ( 0, 21.9 )
                            }
                    in
                    Expect.equal (getDomainBandFromData data defaultConfig) expected
            ]
        , describe "getDomainLinearFromData"
            [ test "with default domain" <|
                \_ ->
                    let
                        data : List DataGroupLinear
                        data =
                            [ { groupLabel = Just "CA", points = [ ( 5, 10 ), ( 6, 20 ) ] }
                            , { groupLabel = Just "TX", points = [ ( 5, 11 ), ( 6, 21 ) ] }
                            ]

                        expected : DomainLinearStruct
                        expected =
                            { x = Just ( 5, 6 ), y = Just ( 0, 21 ) }
                    in
                    Expect.equal (getDomainLinearFromData defaultConfig data) expected
            , test "with Y domain manually set" <|
                \_ ->
                    let
                        linearDomain : LinearDomain
                        linearDomain =
                            ( 0, 30 )

                        config : Config
                        config =
                            defaultConfig
                                |> setDomainLinearAndTimeY linearDomain

                        data : List DataGroupLinear
                        data =
                            [ { groupLabel = Just "CA"
                              , points =
                                    [ ( 1, 10 )
                                    , ( 2, 20 )
                                    ]
                              }
                            , { groupLabel = Just "TX"
                              , points =
                                    [ ( 1, 11 )
                                    , ( 2, 21 )
                                    ]
                              }
                            ]

                        expected : DomainLinearStruct
                        expected =
                            { x = Just ( 1, 2 )
                            , y = Just ( 0, 30 )
                            }
                    in
                    Expect.equal (getDomainLinearFromData config data) expected
            ]
        , describe "getDomainTimeFromData"
            [ test "with default domain" <|
                \_ ->
                    let
                        data : List DataGroupTime
                        data =
                            [ { groupLabel = Just "CA"
                              , points =
                                    [ ( Time.millisToPosix 1579275175634, 10 )
                                    , ( Time.millisToPosix 1579285175634, 20 )
                                    ]
                              }
                            , { groupLabel = Just "TX"
                              , points =
                                    [ ( Time.millisToPosix 1579275175634, 11 )
                                    , ( Time.millisToPosix 1579285175634, 21 )
                                    ]
                              }
                            ]

                        expected : DomainTimeStruct
                        expected =
                            { x = Just ( Time.millisToPosix 1579275175634, Time.millisToPosix 1579285175634 )
                            , y = Just ( 0, 21 )
                            }
                    in
                    Expect.equal (getDomainTimeFromData defaultConfig data) expected
            , test "with Y domain manually set" <|
                \_ ->
                    let
                        linearDomain : LinearDomain
                        linearDomain =
                            ( 0, 30 )

                        config : Config
                        config =
                            defaultConfig
                                |> setDomainLinearAndTimeY linearDomain

                        data : List DataGroupTime
                        data =
                            [ { groupLabel = Just "CA"
                              , points =
                                    [ ( Time.millisToPosix 1579275175634, 10 )
                                    , ( Time.millisToPosix 1579285175634, 20 )
                                    ]
                              }
                            , { groupLabel = Just "TX"
                              , points =
                                    [ ( Time.millisToPosix 1579275175634, 11 )
                                    , ( Time.millisToPosix 1579285175634, 21 )
                                    ]
                              }
                            ]

                        expected : DomainTimeStruct
                        expected =
                            { x = Just ( Time.millisToPosix 1579275175634, Time.millisToPosix 1579285175634 )
                            , y = Just ( 0, 30 )
                            }
                    in
                    Expect.equal (getDomainTimeFromData config data) expected
            ]
        , describe "groupedLayoutConfig"
            [ test "showIcons is False" <|
                \_ ->
                    Expect.equal (showIcons defaultGroupedConfig) False
            , test "showIcons is True" <|
                \_ ->
                    Expect.equal (showIcons (defaultGroupedConfig |> setIcons [ Triangle "id" ])) True
            ]
        , describe "symbolCustomSpace"
            [ test "x, icon ratio < 1" <|
                \_ ->
                    let
                        orientation : Orientation
                        orientation =
                            Horizontal

                        localDimension : Float
                        localDimension =
                            5.0

                        customSymbolConf : Chart.Internal.Symbol.CustomSymbolConf
                        customSymbolConf =
                            { identifier = "x"
                            , width = 110
                            , height = 100
                            , paths = []
                            , useGap = False
                            }

                        expected : Float
                        expected =
                            5.5
                    in
                    Expect.within (Expect.Absolute 0.001)
                        (symbolCustomSpace orientation localDimension customSymbolConf)
                        expected
            , test "x, icon ratio >= 1" <|
                \_ ->
                    let
                        orientation : Orientation
                        orientation =
                            Horizontal

                        localDimension : Float
                        localDimension =
                            5.0

                        customSymbolConf : Chart.Internal.Symbol.CustomSymbolConf
                        customSymbolConf =
                            { identifier = "x"
                            , width = 100
                            , height = 110
                            , paths = []
                            , useGap = False
                            }

                        expected : Float
                        expected =
                            4.5454
                    in
                    Expect.within (Expect.Absolute 0.001)
                        (symbolCustomSpace orientation localDimension customSymbolConf)
                        expected
            , test "y" <|
                \_ ->
                    let
                        orientation : Orientation
                        orientation =
                            Vertical

                        localDimension : Float
                        localDimension =
                            5.0

                        customSymbolConf : Chart.Internal.Symbol.CustomSymbolConf
                        customSymbolConf =
                            { identifier = "x"
                            , width = 110
                            , height = 100
                            , paths = []
                            , useGap = False
                            }

                        expected : Float
                        expected =
                            4.5454
                    in
                    Expect.within (Expect.Absolute 0.001)
                        (symbolCustomSpace orientation localDimension customSymbolConf)
                        expected
            , test "y 2" <|
                \_ ->
                    let
                        orientation : Orientation
                        orientation =
                            Vertical

                        localDimension : Float
                        localDimension =
                            5.0

                        customSymbolConf : Chart.Internal.Symbol.CustomSymbolConf
                        customSymbolConf =
                            { identifier = "x"
                            , width = 100
                            , height = 110
                            , paths = []
                            , useGap = False
                            }

                        expected : Float
                        expected =
                            5.5
                    in
                    Expect.within (Expect.Absolute 0.001)
                        (symbolCustomSpace orientation localDimension customSymbolConf)
                        expected
            ]
        , describe "externalToDataLinearGroup"
            [ test "with time data" <|
                \_ ->
                    let
                        t1 =
                            Time.millisToPosix 1579275175634

                        t2 =
                            Time.millisToPosix 1579285175634

                        data : ExternalData Data
                        data =
                            [ { groupLabel = "A"
                              , x = t1
                              , y = 10
                              }
                            , { groupLabel = "B"
                              , x = t1
                              , y = 13
                              }
                            , { groupLabel = "A"
                              , x = t2
                              , y = 16
                              }
                            , { groupLabel = "B"
                              , x = t2
                              , y = 23
                              }
                            ]
                                |> toExternalData

                        accessor : AccessorLinearGroup Data
                        accessor =
                            AccessorTime (AccessorTimeStruct .groupLabel .x .y)

                        expected : DataLinearGroup
                        expected =
                            DataTime
                                [ { groupLabel = Just "A"
                                  , points = [ ( t1, 10 ), ( t2, 16 ) ]
                                  }
                                , { groupLabel = Just "B"
                                  , points = [ ( t1, 13 ), ( t2, 23 ) ]
                                  }
                                ]

                        result : DataLinearGroup
                        result =
                            externalToDataLinearGroup data accessor
                    in
                    Expect.equal result expected
            ]
        , describe "getStackedValuesAndGroupes"
            [ test "Values are ordered in accordance with groupes" <|
                \_ ->
                    let
                        data : DataBand
                        data =
                            toDataBand
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
        , describe "dataBandToDataStacked"
            [ test "simple" <|
                \_ ->
                    let
                        data : DataBand
                        data =
                            toDataBand
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
                        data : DataBand
                        data =
                            toDataBand
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
        , describe "histogram tests"
            [ test "generate histogram from external data" <|
                \_ ->
                    let
                        data =
                            toExternalData
                                [ 0.01
                                , 0.02
                                , 0.09
                                , 0.1
                                , 0.12
                                , 0.15
                                ]

                        config =
                            defaultConfig
                                |> setHistogramDomain ( 0, 1 )

                        histogramConfig =
                            defaultHistogramConfig
                                |> setHistogramSteps [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 ]

                        accessor =
                            AccessorHistogram histogramConfig identity

                        expected =
                            [ { length = 4, values = [ 0.1, 0.09, 0.02, 0.01 ], x0 = 0, x1 = 0.1 }
                            , { length = 2, values = [ 0.15, 0.12 ], x0 = 0.1, x1 = 0.2 }
                            , { length = 0, values = [], x0 = 0.2, x1 = 0.3 }
                            , { length = 0, values = [], x0 = 0.3, x1 = 0.4 }
                            , { length = 0, values = [], x0 = 0.4, x1 = 0.5 }
                            , { length = 0, values = [], x0 = 0.5, x1 = 0.6 }
                            , { length = 0, values = [], x0 = 0.6, x1 = 0.7 }
                            , { length = 0, values = [], x0 = 0.7, x1 = 0.8 }
                            , { length = 0, values = [], x0 = 0.8, x1 = 0.9 }
                            , { length = 0, values = [], x0 = 0.9, x1 = 1 }
                            ]
                    in
                    Expect.equal (externalToDataHistogram config data accessor) expected
            , test "generate histogram with pre calculated data" <|
                \_ ->
                    let
                        data =
                            toExternalData
                                [ { length = 4, values = [ 0.1, 0.09, 0.02, 0.01 ], x0 = 0, x1 = 0.1 }
                                , { length = 2, values = [ 0.15, 0.12 ], x0 = 0.1, x1 = 0.2 }
                                , { length = 0, values = [], x0 = 0.2, x1 = 0.3 }
                                , { length = 0, values = [], x0 = 0.3, x1 = 0.4 }
                                , { length = 0, values = [], x0 = 0.4, x1 = 0.5 }
                                , { length = 0, values = [], x0 = 0.5, x1 = 0.6 }
                                , { length = 0, values = [], x0 = 0.6, x1 = 0.7 }
                                , { length = 0, values = [], x0 = 0.7, x1 = 0.8 }
                                , { length = 0, values = [], x0 = 0.8, x1 = 0.9 }
                                , { length = 0, values = [], x0 = 0.9, x1 = 1 }
                                ]

                        config =
                            defaultConfig
                                |> setHistogramDomain ( 0, 1 )

                        accessor =
                            AccessorHistogramPreProcessed identity

                        expected =
                            [ { length = 4, values = [ 0.1, 0.09, 0.02, 0.01 ], x0 = 0, x1 = 0.1 }
                            , { length = 2, values = [ 0.15, 0.12 ], x0 = 0.1, x1 = 0.2 }
                            , { length = 0, values = [], x0 = 0.2, x1 = 0.3 }
                            , { length = 0, values = [], x0 = 0.3, x1 = 0.4 }
                            , { length = 0, values = [], x0 = 0.4, x1 = 0.5 }
                            , { length = 0, values = [], x0 = 0.5, x1 = 0.6 }
                            , { length = 0, values = [], x0 = 0.6, x1 = 0.7 }
                            , { length = 0, values = [], x0 = 0.7, x1 = 0.8 }
                            , { length = 0, values = [], x0 = 0.8, x1 = 0.9 }
                            , { length = 0, values = [], x0 = 0.9, x1 = 1 }
                            ]
                    in
                    Expect.equal (externalToDataHistogram config data accessor) expected
            , test "calculate histogram domain" <|
                \_ ->
                    let
                        data =
                            [ { length = 4, values = [ 0.1, 0.09, 0.02, 0.01 ], x0 = 0, x1 = 0.1 }
                            , { length = 2, values = [ 0.15, 0.12 ], x0 = 0.1, x1 = 0.2 }
                            , { length = 0, values = [], x0 = 0.2, x1 = 0.3 }
                            , { length = 0, values = [], x0 = 0.3, x1 = 0.4 }
                            , { length = 0, values = [], x0 = 0.4, x1 = 0.5 }
                            , { length = 0, values = [], x0 = 0.5, x1 = 0.6 }
                            , { length = 0, values = [], x0 = 0.6, x1 = 0.7 }
                            , { length = 0, values = [], x0 = 0.7, x1 = 0.8 }
                            , { length = 0, values = [], x0 = 0.8, x1 = 0.9 }
                            , { length = 0, values = [], x0 = 0.9, x1 = 1 }
                            ]

                        expected =
                            ( 0, 1 )
                    in
                    Expect.equal expected (calculateHistogramDomain data)
            ]
        ]

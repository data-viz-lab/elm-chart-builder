module Chart.Internal.TypeTest exposing (suite)

import Chart.Internal.Symbol as Symbol exposing (Symbol(..))
import Chart.Internal.Type exposing (..)
import Dict exposing (Dict)
import Expect exposing (Expectation)
import Test exposing (..)
import Time exposing (Posix)


type alias Data =
    { x : Posix, y : Float, groupLabel : String }


suite : Test
suite =
    Test.describe "The Type module"
        [ getDomainBandFromDataTest
        , getDomainContinuousFromDataTest
        , getDomainTimeFromDataTest
        , groupedLayoutConfigTest
        , symbolCustomSpaceTest
        , externalToDataContinuousGroupTest
        , getStackedValuesAndGroupesTest
        , dataBandToDataStackedTest
        , histogramTest
        , externalToDataBandTest
        , fillGapsForStackTest
        ]


getDomainBandFromDataTest : Test
getDomainBandFromDataTest =
    describe "getDomainBandFromData"
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
                        , continuous = Just ( 0, 21 )
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
                        , continuous = Just ( 0, 21.9 )
                        }
                in
                Expect.equal (getDomainBandFromData data defaultConfig) expected
        ]


getDomainContinuousFromDataTest : Test
getDomainContinuousFromDataTest =
    describe "getDomainContinuousFromData"
        [ test "with default domain" <|
            \_ ->
                let
                    data : List DataGroupContinuous
                    data =
                        [ { groupLabel = Just "CA", points = [ ( 5, 10 ), ( 6, 20 ) ] }
                        , { groupLabel = Just "TX", points = [ ( 5, 11 ), ( 6, 21 ) ] }
                        ]

                    expected : DomainContinuousStruct
                    expected =
                        { x = Just ( 5, 6 ), y = Just ( 0, 21 ) }

                    domain : DomainContinuousStruct
                    domain =
                        defaultConfig
                            |> getDomainContinuous
                in
                Expect.equal (getDomainContinuousFromData Nothing domain data) expected
        , test "with Y domain manually set" <|
            \_ ->
                let
                    continuousDomain : ContinuousDomain
                    continuousDomain =
                        ( 0, 30 )

                    domain : DomainContinuousStruct
                    domain =
                        defaultConfig
                            |> setDomainContinuousAndTimeY continuousDomain
                            |> getDomainContinuous

                    data : List DataGroupContinuous
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

                    expected : DomainContinuousStruct
                    expected =
                        { x = Just ( 1, 2 )
                        , y = Just ( 0, 30 )
                        }
                in
                Expect.equal (getDomainContinuousFromData Nothing domain data) expected
        ]


getDomainTimeFromDataTest : Test
getDomainTimeFromDataTest =
    describe "getDomainTimeFromData"
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

                    domain : DomainTimeStruct
                    domain =
                        defaultConfig
                            |> getDomainTime

                    expected : DomainTimeStruct
                    expected =
                        { x = Just ( Time.millisToPosix 1579275175634, Time.millisToPosix 1579285175634 )
                        , y = Just ( 0, 21 )
                        }
                in
                Expect.equal (getDomainTimeFromData Nothing domain data) expected
        , test "with Y domain manually set" <|
            \_ ->
                let
                    continuousDomain : ContinuousDomain
                    continuousDomain =
                        ( 0, 30 )

                    domain : DomainTimeStruct
                    domain =
                        defaultConfig
                            |> setDomainContinuousAndTimeY continuousDomain
                            |> getDomainTime

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
                Expect.equal (getDomainTimeFromData Nothing domain data) expected
        , test "with Y domain manually set and extent" <|
            \_ ->
                let
                    continuousDomain : ContinuousDomain
                    continuousDomain =
                        ( 0, 30 )

                    domain : DomainTimeStruct
                    domain =
                        defaultConfig
                            |> setDomainContinuousAndTimeY continuousDomain
                            |> getDomainTime

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
                Expect.equal (getDomainTimeFromData (Just ( 0, 100 )) domain data) expected
        , test "with extent" <|
            \_ ->
                let
                    continuousDomain : ContinuousDomain
                    continuousDomain =
                        ( 0, 30 )

                    domain : DomainTimeStruct
                    domain =
                        defaultConfig
                            |> getDomainTime

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
                        , y = Just ( 0, 100 )
                        }
                in
                Expect.equal (getDomainTimeFromData (Just ( 0, 100 )) domain data) expected
        ]


groupedLayoutConfigTest : Test
groupedLayoutConfigTest =
    describe "groupedLayoutConfig"
        [ test "showIcons is False" <|
            \_ ->
                Expect.equal (showIcons defaultConfig) False
        , test "showIcons is True" <|
            \_ ->
                Expect.equal
                    (showIcons
                        (defaultConfig
                            |> setIcons [ Triangle Symbol.initialConf ]
                        )
                    )
                    True
        ]


symbolCustomSpaceTest : Test
symbolCustomSpaceTest =
    describe "symbolCustomSpace"
        [ test "x, icon ratio < 1" <|
            \_ ->
                let
                    orientation : Orientation
                    orientation =
                        Horizontal

                    localDimension : Float
                    localDimension =
                        5.0

                    customSymbolConf : Symbol.CustomSymbolConf
                    customSymbolConf =
                        { identifier = "x"
                        , viewBoxWidth = 110
                        , viewBoxHeight = 100
                        , paths = []
                        , useGap = False
                        , styles = []
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

                    customSymbolConf : Symbol.CustomSymbolConf
                    customSymbolConf =
                        { identifier = "x"
                        , viewBoxWidth = 100
                        , viewBoxHeight = 110
                        , paths = []
                        , useGap = False
                        , styles = []
                        }

                    localDimension : Float
                    localDimension =
                        5.0

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

                    customSymbolConf : Symbol.CustomSymbolConf
                    customSymbolConf =
                        { identifier = "y"
                        , viewBoxWidth = 110
                        , viewBoxHeight = 100
                        , paths = []
                        , useGap = False
                        , styles = []
                        }

                    localDimension : Float
                    localDimension =
                        5.0

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

                    customSymbolConf : Symbol.CustomSymbolConf
                    customSymbolConf =
                        { identifier = "y"
                        , viewBoxWidth = 100
                        , viewBoxHeight = 110
                        , paths = []
                        , useGap = False
                        , styles = []
                        }

                    localDimension : Float
                    localDimension =
                        5.0

                    expected : Float
                    expected =
                        5.5
                in
                Expect.within (Expect.Absolute 0.001)
                    (symbolCustomSpace orientation localDimension customSymbolConf)
                    expected
        ]


externalToDataContinuousGroupTest : Test
externalToDataContinuousGroupTest =
    describe "externalToDataContinuousGroup"
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

                    accessor : AccessorContinuousOrTime Data
                    accessor =
                        AccessorTime (AccessorTimeStruct (.groupLabel >> Just) .x .y)

                    expected : DataContinuousGroup
                    expected =
                        DataTime
                            [ { groupLabel = Just "A"
                              , points = [ ( t1, 10 ), ( t2, 16 ) ]
                              }
                            , { groupLabel = Just "B"
                              , points = [ ( t1, 13 ), ( t2, 23 ) ]
                              }
                            ]

                    result : DataContinuousGroup
                    result =
                        externalToDataContinuousGroup data accessor
                in
                Expect.equal result expected
        ]


fillGapsForStackTest : Test
fillGapsForStackTest =
    describe "fillGapsForStack"
        [ test "With missing values" <|
            \_ ->
                let
                    data : DataBand
                    data =
                        toDataBand
                            [ { groupLabel = Just "A"
                              , points = [ ( "a", -10 ) ]
                              }
                            , { groupLabel = Just "B"
                              , points = [ ( "b", 23 ) ]
                              }
                            ]

                    expected =
                        toDataBand
                            [ { groupLabel = Just "A", points = [ ( "a", -10 ), ( "b", 0 ) ] }
                            , { groupLabel = Just "B", points = [ ( "a", 0 ), ( "b", 23 ) ] }
                            ]
                in
                Expect.equal expected (fillGapsForStack data)
        ]


getStackedValuesAndGroupesTest : Test
getStackedValuesAndGroupesTest =
    describe "getStackedValuesAndGroupes"
        [ test "With missing values" <|
            \_ ->
                let
                    data : DataBand
                    data =
                        toDataBand
                            [ { groupLabel = Just "A"
                              , points = [ ( "a", -10 ) ]
                              }
                            , { groupLabel = Just "B"
                              , points = [ ( "b", 23 ) ]
                              }
                            ]
                            |> fillGapsForStack

                    values : List (List ( Float, Float ))
                    values =
                        [ [ ( 0, 0 ), ( -10, 0 ) ], [ ( 0, 23 ), ( 0, 0 ) ] ]

                    expected =
                        ( [ [ { rawValue = -10, stackedValue = ( -10, 0 ) }
                            , { rawValue = 0, stackedValue = ( 0, 0 ) }
                            ]
                          , [ { rawValue = 0, stackedValue = ( 0, 0 ) }
                            , { rawValue = 23, stackedValue = ( 0, 23 ) }
                            ]
                          ]
                        , [ "A", "B" ]
                        )
                in
                Expect.equal expected (getStackedValuesAndGroupes values data)
        , test "Values are ordered in accordance with groupes" <|
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


dataBandToDataStackedTest : Test
dataBandToDataStackedTest =
    describe "dataBandToDataStacked"
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
                Expect.equal (dataBandToDataStacked defaultConfig data) expected
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
                Expect.equal (dataBandToDataStacked defaultConfig data) expected
        ]


histogramTest : Test
histogramTest =
    describe "histogram tests"
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

                    bins =
                        [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 ]

                    accessor =
                        AccessorHistogram bins identity

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


externalToDataBandTest : Test
externalToDataBandTest =
    describe "externalToDataBand"
        [ test "generate bandDatta from external data" <|
            \_ ->
                let
                    data =
                        toExternalData
                            [ { countryId = "XM", countryIso3code = "", countryName = "Low income", indicator = "Population in urban agglomerations of more than 1 million (% of total population)", value = 12.3796416662598, year = "2019" }, { countryId = "XO", countryIso3code = "LMY", countryName = "Low & middle income", indicator = "Population in urban agglomerations of more than 1 million (% of total population)", value = 21.5619375454364, year = "2019" }, { countryId = "XO", countryIso3code = "LMY", countryName = "Low & middle income", indicator = "Prevalence of underweight, weight for age (% of children under 5)", value = 14.5, year = "2019" }, { countryId = "XM", countryIso3code = "", countryName = "Low income", indicator = "Prevalence of underweight, weight for age (% of children under 5)", value = 18.1, year = "2019" } ]

                    accessor =
                        AccessorBand (.countryName >> Just) .indicator .value

                    expected =
                        toDataBand [ { groupLabel = Just "Low & middle income", points = [ ( "Population in urban agglomerations of more than 1 million (% of total population)", 21.5619375454364 ), ( "Prevalence of underweight, weight for age (% of children under 5)", 14.5 ) ] }, { groupLabel = Just "Low income", points = [ ( "Population in urban agglomerations of more than 1 million (% of total population)", 12.3796416662598 ), ( "Prevalence of underweight, weight for age (% of children under 5)", 18.1 ) ] } ]
                in
                Expect.equal (externalToDataBand data accessor) expected
        ]

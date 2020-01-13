module Chart.Internal.TypeTest exposing (suite)

import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type exposing (..)
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "The Type module"
        [ describe "getDomainBandFromData"
            [ test "with DomainBand" <|
                \_ ->
                    let
                        data : Data
                        data =
                            DataBand
                                [ { groupLabel = Just "CA", points = [ ( "a", 10 ), ( "b", 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( "a", 11 ), ( "b", 21 ) ] }
                                ]

                        expected : DomainBandStruct
                        expected =
                            { bandGroup = Just [ "CA", "TX" ], bandSingle = Just [ "a", "b" ], linear = Just ( 0, 21 ) }
                    in
                    Expect.equal (getDomainBandFromData data defaultConfig) expected
            , test "with DomainBand complex example" <|
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
            , test "with DomainLinear" <|
                \_ ->
                    let
                        data : Data
                        data =
                            DataLinear
                                [ { groupLabel = Just "CA", points = [ ( 5, 10 ), ( 6, 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( 5, 11 ), ( 6, 21 ) ] }
                                ]

                        expected : DomainLinearStruct
                        expected =
                            { horizontal = Just ( 0, 6 ), vertical = Just ( 0, 21 ) }
                    in
                    Expect.equal (getDomainLinearFromData data defaultConfig) expected
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
            [ test "horizontal, icon ratio < 1" <|
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
            , test "horizontal, icon ratio >= 1" <|
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
            , test "vertical" <|
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
            , test "vertical 2" <|
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
        ]

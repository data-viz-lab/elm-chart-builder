module Chart.TypeTest exposing (suite)

import Chart.Symbol exposing (Symbol(..))
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
        , describe "groupedLayoutConfig"
            [ test "showIcons is False" <|
                \_ ->
                    Expect.equal (showIcons defaultGroupedConfig) False
            , only <|
                test "showIcons is True" <|
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

                        customSymbolConf : Chart.Symbol.CustomSymbolConf
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

                        customSymbolConf : Chart.Symbol.CustomSymbolConf
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

                        customSymbolConf : Chart.Symbol.CustomSymbolConf
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

                        customSymbolConf : Chart.Symbol.CustomSymbolConf
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

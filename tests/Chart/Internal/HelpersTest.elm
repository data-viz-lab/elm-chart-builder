module Chart.Internal.HelpersTest exposing (suite)

import Chart.Internal.Helpers exposing (..)
import Chart.Internal.Type exposing (..)
import Color
import Expect exposing (Expectation)
import Fuzz
import Scale.Color
import Set
import Test exposing (..)
import Time exposing (Posix)


suite : Test
suite =
    Test.describe "The helpers module"
        [ colorPaletteToColorTest
        , mergeStylesTest
        , sortStringsTest
        , stackDataGroupLinearTest
        ]


stackDataGroupLinearTest : Test
stackDataGroupLinearTest =
    describe "combineStakedValuesWithXValuesTest"
        [ test "It should combine the stacked values into dataGroupLinear" <|
            \_ ->
                let
                    values =
                        [ [ ( 0, 10 ), ( 0, 16 ), ( 0, 26 ) ], [ ( 10, 23 ), ( 16, 39 ), ( 26, 42 ) ] ]

                    dataGroupLinear =
                        [ { groupLabel = Just "A"
                          , points = [ ( 1991, 10 ), ( 1992, 16 ), ( 1993, 26 ) ]
                          }
                        , { groupLabel = Just "B"
                          , points = [ ( 1991, 13 ), ( 1992, 23 ), ( 1993, 16 ) ]
                          }
                        ]

                    expected =
                        [ { groupLabel = Just "A"
                          , points = [ ( 1991, 10 ), ( 1992, 16 ), ( 1993, 26 ) ]
                          }
                        , { groupLabel = Just "B"
                          , points = [ ( 1991, 23 ), ( 1992, 39 ), ( 1993, 42 ) ]
                          }
                        ]
                in
                Expect.equal (stackDataGroupContinuous values dataGroupLinear) expected
        ]


colorPaletteToColorTest : Test
colorPaletteToColorTest =
    describe "colorPaletteToColor"
        [ fuzz (Fuzz.intRange 1 20) "simple" <|
            \randomIndx ->
                let
                    palette =
                        Scale.Color.tableau10

                    paletteSet =
                        palette
                            |> List.map Color.toCssString
                            |> Set.fromList

                    result =
                        colorPaletteToColor palette randomIndx
                in
                if Set.member result paletteSet then
                    Expect.pass

                else
                    Expect.fail "The color generated is not in the input palette"
        ]


sortStringsTest : Test
sortStringsTest =
    describe "sortString"
        [ test "It should sort a list of number strings in number order" <|
            \_ ->
                let
                    input =
                        [ "2", "3", "1", "60" ]

                    expected =
                        [ "1", "2", "3", "60" ]
                in
                Expect.equal (sortStrings identity input) expected
        , test "It should sort a list of records with number strings in number order" <|
            \_ ->
                let
                    input =
                        [ { age = "5", gender = "Male", people = -1411067 }
                        , { age = "5", gender = "Female", people = 1359668 }
                        , { age = "45", gender = "Male", people = -384211 }
                        , { age = "45", gender = "Female", people = 341254 }
                        , { age = "50", gender = "Male", people = -321343 }
                        , { age = "50", gender = "Female", people = 286580 }
                        , { age = "55", gender = "Male", people = -194080 }
                        , { age = "55", gender = "Female", people = 187208 }
                        ]

                    expected =
                        [ { age = "5", gender = "Male", people = -1411067 }
                        , { age = "5", gender = "Female", people = 1359668 }
                        , { age = "45", gender = "Male", people = -384211 }
                        , { age = "45", gender = "Female", people = 341254 }
                        , { age = "50", gender = "Male", people = -321343 }
                        , { age = "50", gender = "Female", people = 286580 }
                        , { age = "55", gender = "Male", people = -194080 }
                        , { age = "55", gender = "Female", people = 187208 }
                        ]
                in
                Expect.equal (sortStrings .age input) expected
        ]


mergeStylesTest : Test
mergeStylesTest =
    describe "mergeStyles"
        [ test "It should add a new style" <|
            \_ ->
                let
                    existing =
                        "fill:red"

                    new =
                        [ ( "stroke", "green" ) ]

                    expected =
                        mergeStyles new existing
                in
                Expect.equal "stroke:green;fill:red" expected
        , test "It should override with a new style" <|
            \_ ->
                let
                    existing =
                        "fill:red;stroke:2px"

                    new =
                        [ ( "fill", "green" ) ]

                    expected =
                        mergeStyles new existing
                in
                Expect.equal "fill:green;stroke:2px" expected
        , test "It should override with a new style 2" <|
            \_ ->
                let
                    existing =
                        "fill: rgba(88.24%,34.12%,34.9%,1)"

                    new =
                        [ ( "fill", "none" ) ]

                    expected =
                        mergeStyles new existing
                in
                Expect.equal "fill:none" expected
        ]

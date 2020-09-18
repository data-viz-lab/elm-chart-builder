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
                Expect.equal (stackDataGroupLinear values dataGroupLinear) expected
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

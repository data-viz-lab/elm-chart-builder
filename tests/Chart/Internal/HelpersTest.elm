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
    describe "The Helpers module"
        [ describe "colorPaletteToColor"
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
        ]

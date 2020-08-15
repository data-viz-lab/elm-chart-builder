module Chart.LineTest exposing (suite)

import Chart.Internal.Type as Type
import Chart.Line as Line
import Expect exposing (Expectation)
import Test exposing (..)


requiredConfig =
    { margin = { top = 0, right = 0, bottom = 0, left = 0 }
    , width = 10
    , height = 10
    }


suite : Test
suite =
    describe "The Public Line module"
        [ describe "withYDomainTime"
            [ test "it should set the X LinearDomain value in the domain" <|
                \_ ->
                    let
                        linearDomain : Type.LinearDomain
                        linearDomain =
                            ( 0, 10 )

                        config : Type.Config
                        config =
                            Line.init requiredConfig
                                |> Line.withYDomain linearDomain

                        newDomain =
                            config
                                |> Type.getDomainTime
                                |> .y
                    in
                    Expect.equal (Just linearDomain) newDomain
            ]
        ]

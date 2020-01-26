module Chart.LineTest exposing (suite)

import Chart.Internal.Type as Type
import Chart.Line as Line
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "The Public Line module"
        [ describe "setDomainTimeVertical"
            [ test "it should set the X LinearDomain value in the domain" <|
                \_ ->
                    let
                        linearDomain : Type.LinearDomain
                        linearDomain =
                            ( 0, 10 )

                        config : Type.Config
                        config =
                            Line.init
                                |> Line.setDomainVertical linearDomain

                        newDomain =
                            config
                                |> Type.getDomainTime
                                |> .vertical
                    in
                    Expect.equal (Just linearDomain) newDomain
            ]
        ]

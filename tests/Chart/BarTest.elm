module Chart.BarTest exposing (suite)

import Chart.Bar as Bar
import Chart.Internal.Type as Type
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "The Public Bar module"
        [ describe "setDomainBandGroup"
            [ test "it should set the bandGroup value in the domain" <|
                \_ ->
                    let
                        bandGroup : List String
                        bandGroup =
                            [ "CA", "TX", "NY" ]

                        config : Type.Config
                        config =
                            Bar.init
                                |> Bar.setDomainBandGroup bandGroup

                        newBandGroup =
                            config
                                |> Type.getDomainBand
                                |> .bandGroup
                    in
                    Expect.equal (Just bandGroup) newBandGroup
            ]
        , describe "setDomainBandSingle"
            [ test "it should set the bandSingle value in the domain" <|
                \_ ->
                    let
                        bandSingle : List String
                        bandSingle =
                            [ "a", "b", "c" ]

                        config : Type.Config
                        config =
                            Bar.init
                                |> Bar.setDomainBandSingle bandSingle

                        newBandSingle =
                            config
                                |> Type.getDomainBand
                                |> .bandSingle
                    in
                    Expect.equal (Just bandSingle) newBandSingle
            ]
        , describe "setDomainLinear"
            [ test "it should set the linear value in the domain" <|
                \_ ->
                    let
                        linearDomain =
                            ( 0, 30 )

                        config : Type.Config
                        config =
                            Bar.init
                                |> Bar.setDomainLinear linearDomain

                        newLinearDomain =
                            config
                                |> Type.getDomainBand
                                |> .linear
                    in
                    Expect.equal (Just linearDomain) newLinearDomain
            ]
        ]

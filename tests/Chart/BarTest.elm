module Chart.BarTest exposing (suite)

import Chart.Bar as Bar
import Chart.Internal.Type as Type
import Expect exposing (Expectation)
import Test exposing (..)


requiredConfig =
    { margin = { top = 0, right = 0, bottom = 0, left = 0 }
    , width = 10
    , height = 10
    }


suite : Test
suite =
    describe "The Public Bar module"
        [ describe "withBandGroupDomain"
            [ test "it should set the bandGroup value in the domain" <|
                \_ ->
                    let
                        bandGroup : List String
                        bandGroup =
                            [ "CA", "TX", "NY" ]

                        config : Type.Config
                        config =
                            Bar.init requiredConfig
                                |> Bar.withXGroupDomain bandGroup

                        newBandGroup =
                            config
                                |> Type.getDomainBand
                                |> .bandGroup
                    in
                    Expect.equal (Just bandGroup) newBandGroup
            ]
        , describe "withBandSingleDomain"
            [ test "it should set the bandSingle value in the domain" <|
                \_ ->
                    let
                        bandSingle : List String
                        bandSingle =
                            [ "a", "b", "c" ]

                        config : Type.Config
                        config =
                            Bar.init requiredConfig
                                |> Bar.withXDomain bandSingle

                        newBandSingle =
                            config
                                |> Type.getDomainBand
                                |> .bandSingle
                    in
                    Expect.equal (Just bandSingle) newBandSingle
            ]
        , describe "withLinearDomain"
            [ test "it should set the linear value in the domain" <|
                \_ ->
                    let
                        linearDomain =
                            ( 0, 30 )

                        config : Type.Config
                        config =
                            Bar.init requiredConfig
                                |> Bar.withYLinearDomain linearDomain

                        newLinearDomain =
                            config
                                |> Type.getDomainBand
                                |> .linear
                    in
                    Expect.equal (Just linearDomain) newLinearDomain
            ]
        ]

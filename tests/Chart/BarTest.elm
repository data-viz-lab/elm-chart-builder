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
                        data : Type.Data
                        data =
                            Type.DataBand
                                [ { groupLabel = Just "CA", points = [ ( "a", 10 ), ( "b", 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( "a", 11 ), ( "b", 21 ) ] }
                                ]

                        bandGroup : List String
                        bandGroup =
                            [ "CA", "TX", "NY" ]

                        bar : ( Type.Data, Type.Config )
                        bar =
                            Bar.init data
                                |> Bar.setDomainBandGroup bandGroup

                        ( _, config_ ) =
                            bar

                        config =
                            Type.fromConfig config_

                        newBandGroup =
                            config.domain
                                |> Maybe.map Type.fromDomainBand
                                |> Maybe.map .bandGroup
                                |> Maybe.withDefault []
                    in
                    Expect.equal bandGroup newBandGroup
            , test "when setting the bandGroup value in the domain, the linear value should calculate from the data" <|
                \_ ->
                    let
                        data : Type.Data
                        data =
                            Type.DataBand
                                [ { groupLabel = Just "CA", points = [ ( "a", 10 ), ( "b", 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( "a", 11 ), ( "b", 21 ) ] }
                                ]

                        bandGroup : List String
                        bandGroup =
                            [ "CA", "TX", "NY" ]

                        bar : ( Type.Data, Type.Config )
                        bar =
                            Bar.init data
                                |> Bar.setDomainBandGroup bandGroup

                        ( _, config_ ) =
                            bar

                        config =
                            Type.fromConfig config_

                        linear =
                            config.domain
                                |> Maybe.map Type.fromDomainBand
                                |> Maybe.map .linear
                                |> Maybe.withDefault ( 0, 0 )
                    in
                    Expect.equal linear ( 0, 21 )
            ]
        , describe "setDomainBandSingle"
            [ test "it should set the bandSingle value in the domain" <|
                \_ ->
                    let
                        data : Type.Data
                        data =
                            Type.DataBand
                                [ { groupLabel = Just "CA", points = [ ( "a", 10 ), ( "b", 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( "a", 11 ), ( "b", 21 ) ] }
                                ]

                        bandSingle : List String
                        bandSingle =
                            [ "a", "b", "c" ]

                        bar : ( Type.Data, Type.Config )
                        bar =
                            Bar.init data
                                |> Bar.setDomainBandSingle bandSingle

                        ( _, config_ ) =
                            bar

                        config =
                            Type.fromConfig config_

                        newBandSingle =
                            config.domain
                                |> Maybe.map Type.fromDomainBand
                                |> Maybe.map .bandSingle
                                |> Maybe.withDefault []
                    in
                    Expect.equal bandSingle newBandSingle
            , test "when setting the bandSingle value in the domain, the linear value should calculate from the data" <|
                \_ ->
                    let
                        data : Type.Data
                        data =
                            Type.DataBand
                                [ { groupLabel = Just "CA", points = [ ( "a", 10 ), ( "b", 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( "a", 11 ), ( "b", 21 ) ] }
                                ]

                        bandSingle : List String
                        bandSingle =
                            [ "a", "b", "c" ]

                        bar : ( Type.Data, Type.Config )
                        bar =
                            Bar.init data
                                |> Bar.setDomainBandSingle bandSingle

                        ( _, config_ ) =
                            bar

                        config =
                            Type.fromConfig config_

                        linear =
                            config.domain
                                |> Maybe.map Type.fromDomainBand
                                |> Maybe.map .linear
                                |> Maybe.withDefault ( 0, 0 )
                    in
                    Expect.equal linear ( 0, 21 )
            ]
        , describe "setDomainLinear"
            [ test "it should set the linear value in the domain" <|
                \_ ->
                    let
                        data : Type.Data
                        data =
                            Type.DataBand
                                [ { groupLabel = Just "CA", points = [ ( "a", 10 ), ( "b", 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( "a", 11 ), ( "b", 21 ) ] }
                                ]

                        linearDomain =
                            ( 0, 30 )

                        bar : ( Type.Data, Type.Config )
                        bar =
                            Bar.init data
                                |> Bar.setDomainLinear linearDomain

                        ( _, config_ ) =
                            bar

                        config =
                            Type.fromConfig config_

                        newLinearDomain =
                            config.domain
                                |> Maybe.map Type.fromDomainBand
                                |> Maybe.map .linear
                                |> Maybe.withDefault ( 0, 0 )
                    in
                    Expect.equal newLinearDomain linearDomain
            , test "when setting the linear value in the domain, the bandGroup value should be set from the data" <|
                \_ ->
                    let
                        data : Type.Data
                        data =
                            Type.DataBand
                                [ { groupLabel = Just "CA", points = [ ( "a", 10 ), ( "b", 20 ) ] }
                                , { groupLabel = Just "TX", points = [ ( "a", 11 ), ( "b", 21 ) ] }
                                ]

                        bar : ( Type.Data, Type.Config )
                        bar =
                            Bar.init data
                                |> Bar.setDomainLinear ( 0, 30 )

                        ( _, config_ ) =
                            bar

                        config =
                            Type.fromConfig config_

                        bandGroup =
                            config.domain
                                |> Maybe.map Type.fromDomainBand
                                |> Maybe.map .bandGroup
                                |> Maybe.withDefault []
                    in
                    Expect.equal bandGroup [ "CA", "TX" ]
            ]
        ]

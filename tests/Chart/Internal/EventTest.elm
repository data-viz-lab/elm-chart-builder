module Chart.Internal.EventTest exposing (suite)

import Chart.Internal.Event exposing (..)
import Expect exposing (Expectation)
import Json.Decode as Decode
import Scale
import Test exposing (..)


suite : Test
suite =
    Test.describe "The event module"
        [ getWithinTest ]


getWithinTest : Test
getWithinTest =
    describe "getWithinTest"
        [ only <|
            test "TODO: it returns a value" <|
                \_ ->
                    let
                        config =
                            { margin = { top = 0, right = 0, bottom = 0, left = 0 }
                            , width = 200
                            , height = 200
                            }

                        data =
                            [ { x = 1
                              , y = 10
                              }
                            , { x = 2
                              , y = 12
                              }
                            , { x = 3
                              , y = 8
                              }
                            , { x = 4
                              , y = 20
                              }
                            ]

                        xScale =
                            -- range domain
                            Scale.linear ( 0, config.width ) ( 1, 4 )

                        yScale =
                            Scale.linear ( 0, config.height ) ( 0, 20 )

                        domRectangle =
                            { top = 0
                            , left = 0
                            , width = 0
                            , height = 0
                            }

                        mouseEventData =
                            { pageX = 0
                            , pageY = 0
                            , boundingClientRect = domRectangle
                            }

                        result =
                            getWithin config data ( xScale, yScale ) 30 mouseEventData
                    in
                    Expect.equal result (Just ( 0, 0 ))
        ]

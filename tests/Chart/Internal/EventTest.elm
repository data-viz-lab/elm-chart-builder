module Chart.Internal.EventTest exposing (suite)

import Chart.Internal.Event exposing (..)
import Dict
import Expect exposing (..)
import Scale
import Test exposing (..)


suite : Test
suite =
    Test.describe "The event module"
        [ getWithinTest
        , transposeDataGroupTest
        , flatDataGroupTest
        , nearestTest
        ]


getWithinTest : Test
getWithinTest =
    describe "getWithinTest"
        [ test "Get within HoverOne" <|
            \_ ->
                let
                    width =
                        200

                    height =
                        200

                    config =
                        { margin = { top = 0, right = 0, bottom = 0, left = 0 }
                        , width = width
                        , height = height
                        }

                    boundingClientRect =
                        { height = height, left = 0, top = 0, width = width }

                    mouseEventData =
                        { pageX = 90

                        -- TODO: is this correct? or would it be inverted in reality (160)?
                        , pageY = 40
                        , boundingClientRect = boundingClientRect
                        }

                    data =
                        [ { groupLabel = Just "A", points = [ ( 1, 1 ), ( 2, 2 ) ] }
                        , { groupLabel = Just "B", points = [ ( 1, 2 ), ( 2, 4 ) ] }
                        ]

                    xScale =
                        -- range domain
                        Scale.linear ( 0, config.width ) ( 0, 2 )

                    yScale =
                        Scale.linear ( 0, config.height ) ( 0, 4 )

                    searchCriteria =
                        HoverOneCriteria 30

                    result =
                        getWithin config data ( xScale, yScale ) searchCriteria mouseEventData

                    expected =
                        Just
                            { boundingClientRect = boundingClientRect
                            , selection =
                                { x = 1
                                , y =
                                    [ { groupLabel = Just "A"
                                      , value = 1
                                      }
                                    ]
                                }
                            , xPosition = 100
                            , yPosition = 50
                            }
                in
                Expect.equal expected result
        , test "Get within HoverAll" <|
            \_ ->
                let
                    width =
                        200

                    height =
                        200

                    config =
                        { margin = { top = 0, right = 0, bottom = 0, left = 0 }
                        , width = width
                        , height = height
                        }

                    boundingClientRect =
                        { height = height, left = 0, top = 0, width = width }

                    mouseEventData =
                        { pageX = 90

                        -- TODO: is this correct? or would it be inverted in reality (160)?
                        , pageY = 40
                        , boundingClientRect = boundingClientRect
                        }

                    data =
                        [ { groupLabel = Just "A", points = [ ( 1, 1 ), ( 2, 2 ) ] }
                        , { groupLabel = Just "B", points = [ ( 1, 2 ), ( 2, 4 ) ] }
                        ]

                    xScale =
                        -- range domain
                        Scale.linear ( 0, config.width ) ( 0, 2 )

                    yScale =
                        Scale.linear ( 0, config.height ) ( 0, 4 )

                    searchCriteria =
                        HoverAllCriteria 30

                    result =
                        getWithin config data ( xScale, yScale ) searchCriteria mouseEventData

                    expected =
                        Just
                            { boundingClientRect = boundingClientRect
                            , selection =
                                { x = 1
                                , y =
                                    [ { groupLabel = Just "A"
                                      , value = 1
                                      }
                                    , { groupLabel = Just "B"
                                      , value = 2
                                      }
                                    ]
                                }
                            , xPosition = 100
                            , yPosition = 100
                            }
                in
                Expect.equal expected result
        ]


flatDataGroupTest : Test
flatDataGroupTest =
    describe "flatDataGroup tests"
        [ test "simple case" <|
            \_ ->
                let
                    data : List (DataGroup Float)
                    data =
                        [ { groupLabel = Just "CA", points = [ ( 5, 10 ), ( 6, 20 ) ] }
                        , { groupLabel = Just "TX", points = [ ( 5, 11 ), ( 6, 21 ) ] }
                        ]

                    expected : List { groupLabel : Maybe String, point : PointContinuous }
                    expected =
                        [ { groupLabel = Just "CA", point = ( 5, 10 ) }
                        , { groupLabel = Just "CA", point = ( 6, 20 ) }
                        , { groupLabel = Just "TX", point = ( 5, 11 ) }
                        , { groupLabel = Just "TX", point = ( 6, 21 ) }
                        ]
                in
                Expect.equal expected (flatDataGroup data)
        ]


transposeDataGroupTest : Test
transposeDataGroupTest =
    describe "transposeDataGroup tests"
        [ test "simple case" <|
            \_ ->
                let
                    data : List (DataGroup Float)
                    data =
                        [ { groupLabel = Just "CA", points = [ ( 5, 10 ), ( 6, 20 ) ] }
                        , { groupLabel = Just "TX", points = [ ( 5, 11 ), ( 6, 21 ) ] }
                        ]

                    expected : DataGroupTransposed
                    expected =
                        Dict.fromList
                            [ ( "5"
                              , [ { groupLabel = Just "CA", point = ( 5, 10 ) }
                                , { groupLabel = Just "TX", point = ( 5, 11 ) }
                                ]
                              )
                            , ( "6"
                              , [ { groupLabel = Just "CA", point = ( 6, 20 ) }
                                , { groupLabel = Just "TX", point = ( 6, 21 ) }
                                ]
                              )
                            ]
                in
                Expect.equal expected (transposeDataGroup data)
        ]


nearestTest : Test
nearestTest =
    describe "nearest tests"
        [ test "simple case" <|
            \_ ->
                let
                    data : List Float
                    data =
                        [ 1990, 1991, 1992 ]
                in
                Expect.within (Absolute 0.000000001) 1992 (nearest data 1991.6)
        ]

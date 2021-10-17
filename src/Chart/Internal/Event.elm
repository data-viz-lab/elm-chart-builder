module Chart.Internal.Event exposing
    ( DataGroup
    , DataGroupTransposed
    , Event(..)
    , Hint
    , HintRect
    , PointContinuous
    , SearchCriteria(..)
    , WithinRectArgs
    , flatDataGroup
    , getWithin
    , getWithinRect
    , hoverAll
    , hoverAllRect
    , hoverOne
    , nearest
    , transposeDataGroup
    )

--import Chart.Internal.GeometryHelpers as Helpers

import Chart.Internal.GeometryHelpers as Helpers
import DOM
import Dict exposing (Dict)
import Html exposing (Attribute)
import Html.Events exposing (on)
import Json.Decode as Decode
import List.Extra
import Scale exposing (ContinuousScale)



-- EVENT


type Event msg
    = HoverOne (Maybe Hint -> msg)
    | HoverAll (Maybe Hint -> msg)
    | HoverAllRect (Maybe HintRect -> msg)


type alias Tolerance =
    Float


type SearchCriteria
    = HoverOneCriteria Tolerance
    | HoverAllCriteria Tolerance


type alias PointComparable comparable =
    ( comparable, Float )


type alias PointContinuous =
    PointComparable Float


type alias DataGroup x =
    { groupLabel : Maybe String
    , points : List ( x, Float )
    }


type alias DataGroupTransposed =
    Dict
        String
        (List
            { groupLabel : Maybe String
            , point : ( Float, Float )
            }
        )


type alias DataGroupContinuous =
    DataGroup Float


type alias DataGroupBand =
    DataGroup String


type alias SelectionDataY =
    { groupLabel : Maybe String
    , value : Float
    }


type alias CrossGroupData =
    { x : Float
    , y : List SelectionDataY
    }


type alias Hint =
    { boundingClientRect : DOM.Rectangle
    , selection : CrossGroupData
    , xPosition : Float

    --, yPosition : List Float
    -- see Line.symbolGroup for why this should not be a list
    , yPosition : Float
    }


type alias HintRect =
    { boundingClientRect : DOM.Rectangle
    , selection : DataGroup String
    , xPosition : Float

    --, yPosition : List Float
    -- see Line.symbolGroup for why this should not be a list
    , yPosition : Float
    }


type alias EventData =
    { pageX : Float
    , pageY : Float
    , boundingClientRect : DOM.Rectangle
    }


type alias Config c =
    { c
        | margin : { top : Float, right : Float, bottom : Float, left : Float }
        , width : Float
        , height : Float
    }


type alias Scales =
    ( ContinuousScale Float, ContinuousScale Float )


{-| -}
hoverOne :
    Config c
    -> List DataGroupContinuous
    -> Scales
    -> (Maybe Hint -> msg)
    -> List (Attribute msg)
hoverOne config data scales msg =
    [ onEvent "mousemove" (HoverOneCriteria 30) config data scales msg
    , onEvent "touchstart" (HoverOneCriteria 100) config data scales msg
    , onEvent "touchmove" (HoverOneCriteria 100) config data scales msg
    , onMouseLeave msg
    ]


{-| -}
hoverAll :
    Config c
    -> List DataGroupContinuous
    -> Scales
    -> (Maybe Hint -> msg)
    -> List (Attribute msg)
hoverAll config data scales msg =
    [ onEvent "mousemove" (HoverAllCriteria 30) config data scales msg
    , onEvent "touchstart" (HoverAllCriteria 100) config data scales msg
    , onEvent "touchmove" (HoverAllCriteria 100) config data scales msg
    , onMouseLeave msg
    ]


{-| -}
hoverAllRect : WithinRectArgs -> (Maybe HintRect -> msg) -> List (Attribute msg)
hoverAllRect args msg =
    [ onEventRect "mousemove" args (HoverAllCriteria 0) msg
    , onEventRect "touchstart" args (HoverAllCriteria 10) msg
    , onEventRect "touchmove" args (HoverAllCriteria 10) msg
    , onMouseLeaveRect msg
    ]


onEventRect :
    String
    -> WithinRectArgs
    -> SearchCriteria
    -> (Maybe HintRect -> msg)
    -> Attribute msg
onEventRect stringEvent args searchCriteria message =
    on stringEvent
        (mouseEventDecoder
            |> Decode.andThen
                (\e ->
                    getWithinRect args searchCriteria e
                        |> Maybe.map
                            (\d ->
                                { boundingClientRect = e.boundingClientRect
                                , selection = d
                                , xPosition = e.pageX
                                , yPosition = e.pageY
                                }
                            )
                        |> Decode.succeed
                )
            |> Decode.map message
        )


onEvent :
    String
    -> SearchCriteria
    -> Config c
    -> List DataGroupContinuous
    -> Scales
    -> (Maybe Hint -> msg)
    -> Attribute msg
onEvent stringEvent searchCriteria config data scales message =
    on stringEvent
        (mouseEventDecoder
            |> Decode.andThen
                (\e ->
                    getWithin config data scales searchCriteria e
                        |> Decode.succeed
                )
            |> Decode.map message
        )


{-| -}
onMouseLeave : (Maybe Hint -> msg) -> Attribute msg
onMouseLeave message =
    on "mouseleave" (Decode.succeed (message Nothing))


{-| -}
onMouseLeaveRect : (Maybe HintRect -> msg) -> Attribute msg
onMouseLeaveRect message =
    on "mouseleave" (Decode.succeed (message Nothing))


getWithin :
    Config c
    -> List DataGroupContinuous
    -> Scales
    -> SearchCriteria
    -> EventData
    -> Maybe Hint
getWithin { margin, width, height } data ( xScale, yScale ) criteria eventData =
    let
        xPosition =
            eventData.pageX
                - eventData.boundingClientRect.left
                - margin.left

        yPosition =
            eventData.pageY
                - eventData.boundingClientRect.top
                - margin.top

        ( xValue, yValue ) =
            ( Scale.invert xScale xPosition, Scale.invert yScale yPosition )

        dataTransposed =
            transposeDataGroup data

        keys =
            dataTransposed
                |> Dict.keys

        nearestKey =
            nearest
                (keys
                    |> List.map String.toFloat
                    |> List.filterMap identity
                )
                xValue
                |> String.fromFloat

        nearestGroup :
            List
                { groupLabel : Maybe String
                , point : ( Float, Float )
                }
        nearestGroup =
            dataTransposed
                |> Dict.get nearestKey
                |> Maybe.withDefault []

        vectorDistances : List ( Float, ( Float, Float ) )
        vectorDistances =
            nearestGroup
                |> List.map
                    (.point
                        >> (\( x, y ) ->
                                ( vectorLength
                                    { eventX = xPosition
                                    , eventY = yPosition
                                    , dataX = Scale.convert xScale x
                                    , dataY = Scale.convert yScale y
                                    }
                                , ( x, y )
                                )
                           )
                    )

        nearestPointInGroup : Maybe ( Float, ( Float, Float ) )
        nearestPointInGroup =
            vectorDistances
                |> List.sortBy (\( distance, _ ) -> distance)
                |> List.head
    in
    case criteria of
        HoverOneCriteria tolerance ->
            nearestGroup
                |> List.Extra.find
                    (\{ point } ->
                        case nearestPointInGroup of
                            Just ( d, p ) ->
                                p == point && d < tolerance

                            Nothing ->
                                False
                    )
                |> Maybe.map
                    (\{ groupLabel, point } ->
                        { boundingClientRect = eventData.boundingClientRect
                        , selection =
                            { x = Tuple.first point
                            , y =
                                [ { groupLabel = groupLabel
                                  , value = Tuple.second point
                                  }
                                ]
                            }
                        , xPosition = Tuple.first point |> Scale.convert xScale
                        , yPosition = Tuple.second point |> Scale.convert yScale
                        }
                    )

        HoverAllCriteria _ ->
            nearestGroup
                |> List.foldr
                    (\{ groupLabel, point } acc ->
                        case acc of
                            Nothing ->
                                Just
                                    { boundingClientRect = eventData.boundingClientRect
                                    , selection =
                                        { x = Tuple.first point
                                        , y =
                                            [ { groupLabel = groupLabel
                                              , value = Tuple.second point
                                              }
                                            ]
                                        }
                                    , xPosition = Tuple.first point |> Scale.convert xScale
                                    , yPosition = Tuple.second point |> Scale.convert yScale
                                    }

                            Just acc_ ->
                                let
                                    newY =
                                        { groupLabel = groupLabel
                                        , value = Tuple.second point
                                        }
                                            :: acc_.selection.y
                                in
                                Just
                                    { acc_
                                        | selection =
                                            { x = Tuple.first point
                                            , y = newY
                                            }
                                    }
                    )
                    Nothing


mouseEventDecoder : Decode.Decoder EventData
mouseEventDecoder =
    Decode.map3
        EventData
        (Decode.field "pageX" Decode.float)
        (Decode.field "pageY" Decode.float)
        (DOM.target position)


position : Decode.Decoder DOM.Rectangle
position =
    Decode.oneOf
        [ DOM.boundingClientRect
        , Decode.lazy (\_ -> DOM.parentElement position)
        ]



-- SEARCHES


type alias VectorInputs =
    { eventX : Float
    , eventY : Float
    , dataX : Float
    , dataY : Float
    }


vectorLength : VectorInputs -> Float
vectorLength { eventX, eventY, dataX, dataY } =
    sqrt ((eventX - dataX) ^ 2 + (eventY - dataY) ^ 2)



-- HELPERS


flatDataGroup :
    List (DataGroup comparable)
    -> List { groupLabel : Maybe String, point : PointComparable comparable }
flatDataGroup dataGroup =
    dataGroup
        |> List.map
            (\d ->
                d.points
                    |> List.map
                        (\p ->
                            { groupLabel = d.groupLabel, point = p }
                        )
            )
        |> List.concat


transposeDataGroup : List (DataGroup Float) -> DataGroupTransposed
transposeDataGroup dataGroup =
    -- TODO: this feels all very inefficient,
    -- especially with a stateless componet
    -- where on every event this needs recalculating
    dataGroup
        |> flatDataGroup
        |> List.foldr
            (\{ groupLabel, point } acc ->
                let
                    k =
                        Tuple.first point
                            |> String.fromFloat
                in
                if Dict.member k acc then
                    Dict.update k
                        (\values ->
                            values
                                |> Maybe.map
                                    (\v ->
                                        { groupLabel = groupLabel, point = point } :: v
                                    )
                        )
                        acc

                else
                    Dict.insert k [ { groupLabel = groupLabel, point = point } ] acc
            )
            Dict.empty


nearest : List Float -> Float -> Float
nearest numbers number =
    --naive implementation
    numbers
        |> List.foldr
            (\n ( delta_, value ) ->
                let
                    delta =
                        abs (n - number)
                in
                if delta < delta_ then
                    ( delta, n )

                else
                    ( delta_, value )
            )
            ( 1 / 0, 0 )
        |> Tuple.second


type alias WithinRectArgs =
    { height : Float
    , symbolOffset : Maybe Float
    , data : List DataGroupBand
    , bandSingleScale : Scale.BandScale String
    , continuousScale : Scale.ContinuousScale Float

    --, eventData : EventData
    }


getWithinRect : WithinRectArgs -> SearchCriteria -> EventData -> Maybe DataGroupBand
getWithinRect { height, symbolOffset, data, bandSingleScale, continuousScale } criteria eventData =
    let
        rect : ( String, Float ) -> { x_ : Float, y_ : Float, w : Float, h : Float }
        rect d =
            Helpers.verticalRect height symbolOffset bandSingleScale continuousScale d

        within d =
            d
                |> List.map
                    (\p ->
                        let
                            r =
                                rect p

                            a =
                                eventData.pageX
                                    > r.x_
                                    && (eventData.pageX < r.x_ + r.w)

                            b =
                                --FIXME
                                eventData.pageY
                                    > r.y_
                        in
                        a && b
                    )
                |> List.filter (\x -> x)
                |> Debug.log "fffff"
                |> List.head
                |> Maybe.withDefault False

        pick : DataGroupBand -> Maybe DataGroupBand
        pick d =
            if within d.points then
                Just d

            else
                Nothing
    in
    data
        |> List.map pick
        |> List.filterMap identity
        |> List.head

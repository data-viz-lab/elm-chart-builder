module Chart.Internal.Event exposing
    ( Event(..)
    , decodePoint
    , getWithin
    , hoverOne
    )

import DOM
import Html exposing (Attribute)
import Html.Events exposing (on)
import Json.Decode as Decode
import Scale exposing (BandScale, ContinuousScale)
import Time exposing (Posix)
import TypedSvg.Attributes
import TypedSvg.Core
import TypedSvg.Events



-- EVENT


type Event msg
    = HoverOne (Maybe ( Float, Float ) -> msg)


type alias PointContinuous =
    ( Float, Float )


type alias DataGroupContinuous =
    { groupLabel : Maybe String
    , points : List PointContinuous
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
    -> (Maybe ( Float, Float ) -> msg)
    -> List (Attribute msg)
hoverOne config data scales msg =
    [ onEvent "mousemove" 30 config data scales msg
    , onEvent "touchstart" 100 config data scales msg
    , onEvent "touchmove" 100 config data scales msg
    , onMouseLeave msg
    ]


onEvent :
    String
    -> Float
    -> Config c
    -> List DataGroupContinuous
    -> Scales
    -> (Maybe ( Float, Float ) -> msg)
    -> Attribute msg
onEvent stringEvent radius config data scales message =
    on stringEvent
        (mouseEventDecoder
            |> Decode.andThen
                (\e -> getWithin config data scales radius e |> Decode.succeed)
            |> Decode.map message
        )


{-| -}
onMouseLeave : (Maybe ( Float, Float ) -> msg) -> Attribute msg
onMouseLeave message =
    on "mouseleave" (Decode.succeed (message Nothing))


decodePoint : Decode.Decoder PointContinuous
decodePoint =
    Decode.map2 Tuple.pair (Decode.index 0 Decode.float) (Decode.index 1 Decode.float)


getWithin :
    Config c
    -> List DataGroupContinuous
    -> Scales
    -> Float
    -> EventData
    -> Maybe PointContinuous
getWithin { margin, width, height } data ( xScale, yScale ) radius eventData =
    let
        xCoord =
            eventData.pageX
                - eventData.boundingClientRect.left
                - margin.left

        yCoord =
            eventData.pageY
                - eventData.boundingClientRect.top
                - margin.top

        ( valueX, valueY ) =
            ( Scale.invert xScale xCoord, Scale.invert yScale yCoord )
    in
    data
        |> List.map .points
        |> List.concat
        |> List.map
            (\( x, y ) ->
                ( ( x, y )
                , vectorLength
                    { eventX = xCoord
                    , eventY = yCoord
                    , dataX = Scale.convert xScale x
                    , dataY = Scale.convert yScale y
                    }
                )
            )
        |> List.filter (\( point, distance ) -> distance < radius)
        |> List.sortBy Tuple.second
        |> List.head
        |> Maybe.map Tuple.first


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



-------------
--{-| -}
--hoverOne : (Maybe Type.PointTime -> msg) -> Config msg
--hoverOne msg =
--    custom
--        [ on "mousemove" msg (getWithin 30)
--        , on "touchstart" msg (getWithin 100)
--        , on "touchmove" msg (getWithin 100)
--        , onMouseLeave (msg Nothing)
--        ]
--{-| -}
--onMouseLeave : msg -> Event msg
--onMouseLeave msg =
--    Event False <|
--        \_ _ ->
--            Svg.Events.on "mouseleave" (Json.succeed msg)
-- SEARCHERS
--{-| -}
--type Decoder data msg
--    = Decoder (List (Data.Data data) -> System -> Point -> msg)

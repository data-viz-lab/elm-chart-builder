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


type alias MouseEventData =
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
    [ onMouseMove config data scales msg
    ]


onMouseMove : Config c -> List DataGroupContinuous -> Scales -> (Maybe ( Float, Float ) -> msg) -> Attribute msg
onMouseMove config data scales message =
    on "mousemove"
        (mouseEventDecoder
            |> Decode.andThen
                (\e -> getWithin config data scales 30 e |> Decode.succeed)
            |> Decode.map message
        )


decodePoint : Decode.Decoder PointContinuous
decodePoint =
    Decode.map2 Tuple.pair (Decode.index 0 Decode.float) (Decode.index 1 Decode.float)


getWithin :
    Config c
    -> List DataGroupContinuous
    -> Scales
    -> Float
    -> MouseEventData
    -> Maybe PointContinuous
getWithin { margin, width, height } data ( xScale, yScale ) radius mouseEventData =
    let
        _ =
            Debug.log "mouseEventData" mouseEventData

        xCoord =
            mouseEventData.pageX
                - mouseEventData.boundingClientRect.left
                - margin.left

        yCoord =
            mouseEventData.pageY
                - mouseEventData.boundingClientRect.top
                - margin.top

        ( valueX, valueY ) =
            ( Scale.invert xScale xCoord, Scale.invert yScale yCoord )

        vectorLengths =
            data
                |> List.map .points
                |> List.concat
                |> List.map
                    (\( x, y ) ->
                        vectorLength
                            { eventX = xCoord
                            , eventY = yCoord
                            , dataX = Scale.convert xScale x
                            , dataY = Scale.convert yScale y
                            }
                    )
    in
    Just ( 0, 0 )


mouseEventDecoder : Decode.Decoder MouseEventData
mouseEventDecoder =
    Decode.map3
        MouseEventData
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

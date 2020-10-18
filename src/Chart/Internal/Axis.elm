module Chart.Internal.Axis exposing
    ( XAxis(..)
    , YAxis(..)
    , xAxisAttributes
    , yAxisAttributes
    )

import Axis as VAxis


type YAxis value
    = Left (List (VAxis.Attribute value))
    | Right (List (VAxis.Attribute value))


type XAxis value
    = Bottom (List (VAxis.Attribute value))


yAxisAttributes : YAxis value -> List (VAxis.Attribute value)
yAxisAttributes axis =
    case axis of
        Left a ->
            a

        Right a ->
            a


xAxisAttributes : XAxis value -> List (VAxis.Attribute value)
xAxisAttributes axis =
    case axis of
        Bottom a ->
            a

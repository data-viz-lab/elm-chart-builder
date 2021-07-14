module Chart.Internal.Axis exposing
    ( XAxis(..)
    , YAxis(..)
    , xAxisAttributes
    )

import Axis as VAxis


type YAxis value
    = Left (List (VAxis.Attribute value))
    | Right (List (VAxis.Attribute value))
    | Grid (List (VAxis.Attribute value))


type XAxis value
    = Bottom (List (VAxis.Attribute value))
    | Top (List (VAxis.Attribute value))


xAxisAttributes : XAxis value -> List (VAxis.Attribute value)
xAxisAttributes axis =
    case axis of
        Bottom a ->
            a

        Top a ->
            a

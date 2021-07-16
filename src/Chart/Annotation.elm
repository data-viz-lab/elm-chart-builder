module Chart.Annotation exposing (Hint)

{-| The annotation module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

It defines the data formats that need to be passed to a chart in order to draw extra annotations on top of it.


# Data Formats

@docs Hint

-}

import Chart.Internal.Event as Event


{-| A Hint
Use it for example in conjuction with some event data to draw the dots on chart hover.

It'a a tuple made of a Event.Hint with list of style definitions.

-}
type alias Hint =
    ( Event.Hint, List ( String, String ) )

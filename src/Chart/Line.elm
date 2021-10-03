module Chart.Line exposing
    ( Accessor, AccessorCont, AccessorContinuous, AccessorTime, continuous, cont, time
    , init
    , render
    , Config, RequiredConfig
    , asArea, withBottomPadding, withColorPalette, withCurve, withDesc, withEvent, withGroupedLayout, withLabels, withLeftPadding, withLineStyle, withLogYScale, withPointAnnotation, withStackedLayout, withSymbols, withTableFloatFormat, withTablePosixFormat, withTitle, withVLineAnnotation, withXContDomain, withXContinuousDomain, withXTimeDomain, withYDomain, withoutTable
    , axisBottom, axisGrid, axisLeft, axisRight, drawLine, xGroupLabel
    , XAxis, YAxis, hideAxis, hideXAxis, hideYAxis, withXAxisCont, withXAxisContinuous, withXAxisTime, withYAxis
    , Hint, hoverAll, hoverOne
    )

{-| This is the line chart module from [elm-chart-builder](https://github.com/data-viz-lab/elm-chart-builder).

It expects the X axis to plot time or continuous data and the Y axis to plot continuous data.


# Chart Data Format

@docs Accessor, AccessorCont, AccessorContinuous, AccessorTime, continuous, cont, time


# Chart Initialization

@docs init


# Chart Rendering

@docs render


# Configuration

@docs Config, RequiredConfig


# Optional Configuration setters

@docs asArea, withBottomPadding, withColorPalette, withCurve, withDesc, withEvent, withGroupedLayout, withLabels, withLeftPadding, withLineStyle, withLogYScale, withPointAnnotation, withStackedLayout, withSymbols, withTableFloatFormat, withTablePosixFormat, withTitle, withVLineAnnotation, withXContDomain, withXContinuousDomain, withXTimeDomain, withYDomain, withoutTable


# Configuration arguments

@docs axisBottom, axisGrid, axisLeft, axisRight, drawLine, xGroupLabel


# Axis

@docs XAxis, YAxis, hideAxis, hideXAxis, hideYAxis, withXAxisCont, withXAxisContinuous, withXAxisTime, withYAxis


# Events

@docs Hint, hoverAll, hoverOne

-}

import Axis
import Chart.Annotation as Annotation
import Chart.Internal.Axis as ChartAxis
import Chart.Internal.Event as Event exposing (Event(..))
import Chart.Internal.Line
    exposing
        ( renderLineGrouped
        , renderLineStacked
        )
import Chart.Internal.Symbol exposing (Symbol)
import Chart.Internal.Type as Type
import Color exposing (Color)
import Html exposing (Html)
import SubPath exposing (SubPath)
import Time exposing (Posix)


{-| The Config opaque type
-}
type alias Config msg validation =
    Type.Config msg validation


{-| The required config, passed as an argument to the `init` function

    { margin =
        { top = Float
        , right = Float
        , bottom = Float
        , left = Float
        }
    , width = Float
    , height = Float
    }

-}
type alias RequiredConfig =
    Type.RequiredConfig


{-| The data accessors

A line chart can have the X axis as continuous or time data.

    type Accessor data
        = AccessorContinuous (accessorContinuous data)
        | AccessorTime (accessorTime data)

-}
type alias Accessor data =
    Type.AccessorContinuousOrTime data


{-| The accessor structure for x time lines.
-}
type alias AccessorTime data =
    { xGroup : data -> Maybe String
    , xValue : data -> Posix
    , yValue : data -> Float
    }


{-| The accessor constructor for x time lines.

    Line.time (Line.AccessorTime .groupLabel .x .y)

-}
time : Type.AccessorTimeStruct data -> Accessor data
time acc =
    Type.AccessorTime acc


{-| The accessor structure for x continuous lines.
-}
type alias AccessorContinuous data =
    { xGroup : data -> Maybe String
    , xValue : data -> Float
    , yValue : data -> Float
    }


{-| An alias for AccessorContinuous
-}
type alias AccessorCont data =
    { xGroup : data -> Maybe String
    , xValue : data -> Float
    , yValue : data -> Float
    }


{-| The accessor constructor for x continuous lines.

    Line.continuous (Line.AccessorContinuous .groupLabel .x .y)

-}
continuous : Type.AccessorContinuousStruct data -> Accessor data
continuous acc =
    Type.AccessorContinuous acc


{-| An alias for Line.continuous

    Line.cont (Line.AccessorCont .groupLabel .x .y)

-}
cont : Type.AccessorContinuousStruct data -> Accessor data
cont acc =
    Type.AccessorContinuous acc


{-| Initializes the line chart with a default config

    data : List Data
    data =
        [ { groupLabel = "A"
          , x = Time.millisToPosix 1579275175634
          , y = 10
          }
        , { groupLabel = "A"
          , x = Time.millisToPosix 1579285175634
          , y = 16
          }
        , { groupLabel = "B"
          , x = Time.millisToPosix 1579275175634
          , y = 13
          }
        , { groupLabel = "B"
          , x = Time.millisToPosix 1579285175634
          , y = 23
          }
        ]

    accessor : Line.Accessor data
    accessor =
        Line.time (Line.accessorTime .groupLabel .x .y)

    Line.init
        { margin =
            { top = 10
            , right = 10
            , bottom = 30
            , left = 30
            }
        , width = 500
        , height = 200
        }
        |> Line.render (data, accessor)

-}
init : RequiredConfig -> Config msg validation
init c =
    Type.defaultConfig
        |> withGroupedLayout
        |> Type.setDimensions { margin = c.margin, width = c.width, height = c.height }


{-| Renders the line chart, after initialisation and optional customisations.

    Line.init requiredConfig
        |> Line.render ( data, accessor )

-}
render : ( List data, Accessor data ) -> Config msg validation -> Html msg
render ( externalData, accessor ) config =
    let
        c =
            Type.fromConfig config

        data =
            Type.externalToDataContinuousGroup (Type.toExternalData externalData) accessor
    in
    case c.layout of
        Type.GroupedLine ->
            renderLineGrouped ( data, config )

        Type.StackedLine offset ->
            renderLineStacked offset ( data, config )

        _ ->
            -- TODO
            Html.text ""


{-| Draw the line chart as an area

    Line.init requiredConfig
        |> Line.asArea
        |> Line.render ( data, accessor )

-}
asArea : Config msg validation -> Config msg validation
asArea =
    Type.setLineDraw Type.Area


{-| Sets the line curve shape

Defaults to `Shape.continuousCurve`

See [elm-visualization/latest/Shape](https://package.elm-lang.org/packages/gampleman/elm-visualization/latest/Shape)
Curves section for more info.

    Line.init requiredConfig
        |> Line.withCurve Shape.monotoneInXCurve
        |> Line.render ( data, accessor )

-}
withCurve : (List ( Float, Float ) -> SubPath) -> Config msg validation -> Config msg validation
withCurve curve config =
    Type.setCurve curve config


{-| Sets the Y domain of a time line chart

If not set, the domain is calculated from the data.
If set on a continuous line chart this setting will have no effect.

    Line.init requiredConfig
        |> Line.withXTimeDomain ( Time.millisToPosix 1579275175634, 10 )
        |> Line.render ( data, accessor )

-}
withXTimeDomain : ( Posix, Posix ) -> Config msg validation -> Config msg validation
withXTimeDomain value config =
    Type.setDomainTimeX value config


{-| Sets the Y domain of a line chart

This is always a continuous domain, not a time domain.
If not set, the domain is calculated from the data.
If set on a continuous line chart this setting will have no effect.

    Line.init required
        |> Line.withYDomain ( Time.millisToPosix 1579275175634, Time.millisToPosix 1579375175634 )
        |> Line.render ( data, accessor )

-}
withYDomain : ( Float, Float ) -> Config msg validation -> Config msg validation
withYDomain value config =
    Type.setDomainContinuousAndTimeY value config


{-| Sets the Y domain of a continuous line chart

If not set, the domain is calculated from the data.
If set on a continuous line chart this setting will have no effect.

    Line.init requiredConfig
        |> Line.withXContinuousDomain ( 0, 10 )
        |> Line.render ( data, accessor )

-}
withXContinuousDomain : ( Float, Float ) -> Config msg validation -> Config msg validation
withXContinuousDomain value config =
    Type.setDomainContinuousX value config


{-| An alias for withXContinuousDomain

If not set, the domain is calculated from the data.
If set on a continuous line chart this setting will have no effect.

    Line.init requiredConfig
        |> Line.withXContDomain ( 0, 10 )
        |> Line.render ( data, accessor )

-}
withXContDomain : ( Float, Float ) -> Config msg validation -> Config msg validation
withXContDomain value config =
    Type.setDomainContinuousX value config


{-| Sets the left padding for the chart component.
The higher the padding, the bigger the gap between the chart and the axis.

    Line.init requiredConfig
        |> Line.withLeftPadding 4
        |> Line.render ( data, accessor )

-}
withLeftPadding : Float -> Config msg validation -> Config msg validation
withLeftPadding value config =
    Type.setLeftPadding value config


{-| Sets the bottom padding for the chart component.
The higher the padding, the bigger the gap between the chart and the axis.

    Line.init requiredConfig
        |> Line.withBottomPadding 4
        |> Line.render ( data, accessor )

-}
withBottomPadding : Float -> Config msg validation -> Config msg validation
withBottomPadding value config =
    Type.setBottomPadding value config


{-| Do **not** build an alternative table content for accessibility

&#9888; By default an alternative table is always being rendered.
Use this option to not build the table.

    Line.init requiredConfig
        |> Line.withoutTable
        |> Line.render ( data, accessor )

-}
withoutTable : Config msg validation -> Config msg validation
withoutTable =
    Type.setAccessibilityContent Type.AccessibilityNone


{-| An optional formatter for all float values in the alternative table content for accessibility.

Defaults to `String.fromFloat`

    Line.init requiredConfig
        |> Line.withTableFloatFormat String.fromFloat
        |> Line.render ( data, accessor )

-}
withTableFloatFormat : (Float -> String) -> Config msg validation -> Config msg validation
withTableFloatFormat f =
    Type.setTableFloatFormat f


{-| An optional formatter for all posix values in the alternative table content for accessibility.

Defaults to `Time.posixToMillis >> String.fromInt`

    Line.init requiredConfig
        |> Line.withTablePosixFormat (Time.posixToMillis >> String.fromInt)
        |> Line.render ( data, accessor )

-}
withTablePosixFormat : (Posix -> String) -> Config msg validation -> Config msg validation
withTablePosixFormat f =
    Type.setTablePosixFormat f


{-| Sets an accessible, long-text description for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Line.init requiredConfig
        |> Line.withDesc "This is an accessible chart"
        |> Line.render ( data, accessor )

-}
withDesc : String -> Config msg validation -> Config msg validation
withDesc value config =
    Type.setSvgDesc value config


{-| Sets an accessible title for the svg chart.

It defaults to an empty string.
This shuld be set if no title nor description exists for the chart, for example in a sparkline.

    Line.init required
        |> Line.withTitle "Line chart"
        |> Line.render ( data, accessor )

-}
withTitle : String -> Config msg validation -> Config msg validation
withTitle value config =
    Type.setSvgTitle value config


{-| Sets the color palette for the chart.

    palette =
        -- From elm-visualization
        Scale.Color.tableau10

    Line.init requiredConfig
        |> Line.withColorPalette palette
        |> Line.render (data, accessor)

-}
withColorPalette : List Color -> Config msg validation -> Config msg validation
withColorPalette palette config =
    Type.setColorResource (Type.ColorPalette palette) config


{-| Creates a stacked line chart.

It takes an option to draw stacked lines or stacked areas

    Line.init requiredConfig
        |> Line.withStackedLayout Line.drawLine
        |> Line.render ( data, accessor )

-}
withStackedLayout : Type.StackOffset -> Config msg validation -> Config msg validation
withStackedLayout offset config =
    Type.setLayout (Type.StackedLine offset) config


{-| Creates a grouped line chart. This option is already set by default.

    Line.init requiredConfig
        |> Line.withGroupedLayout
        |> Line.render ( data, accessor )

-}
withGroupedLayout : Config msg validation -> Config msg validation
withGroupedLayout config =
    Type.setLayout Type.GroupedLine config


{-| Show a label at the end of the lines.

Currently only takes an [xGroupLabel](#xGroupLabel)

&#9888; Use with caution, there is no knowledge of text wrapping!

    defaultLayoutConfig
        |> Line.withLabels Line.xGroupLabel

-}
withLabels : Type.Label -> Config msg validation -> Config msg validation
withLabels label =
    case label of
        Type.XGroupLabel ->
            Type.showXGroupLabel

        _ ->
            identity


{-| Sets the style for the lines
The styles set here have precedence over [withColorPalette](#withColorPalette) and css rules.

    Line.init requiredConfig
        |> Line.withLineStyle [ ( "stroke-width", "2" ) ]
        |> Line.render ( data, accessor )

-}
withLineStyle : List ( String, String ) -> Config msg validation -> Config msg validation
withLineStyle styles config =
    Type.setCoreStyles styles config


{-| Set the Y scale to logaritmic, passing a base

    Line.init requiredConfig
        |> Line.withLogYScale 10
        |> Line.render ( data, accessor )

-}
withLogYScale : Float -> Config msg validation -> Config msg validation
withLogYScale base =
    Type.setYScale (Type.LogScale base)



-- AXIS


{-| The XAxis type
-}
type alias XAxis value =
    ChartAxis.XAxis value


{-| The YAxis type
-}
type alias YAxis value =
    ChartAxis.YAxis value


{-| It returns an YAxis Left type

    Line.axisLeft [ Axis.tickCount 5 ]

-}
axisLeft : List (Axis.Attribute value) -> ChartAxis.YAxis value
axisLeft =
    ChartAxis.Left


{-| It returns an YAxis Grid type

    Line.axisGrid [ Axis.tickCount 5 ]

-}
axisGrid : List (Axis.Attribute value) -> ChartAxis.YAxis value
axisGrid =
    ChartAxis.Grid


{-| It returns an YAxis right type

    Line.axisRight [ Axis.tickCount 5 ]

-}
axisRight : List (Axis.Attribute value) -> ChartAxis.YAxis value
axisRight =
    ChartAxis.Right


{-| It returns an XAxis bottom type

    Line.axisBottom [ Axis.tickCount 5 ]

-}
axisBottom : List (Axis.Attribute value) -> ChartAxis.XAxis value
axisBottom =
    ChartAxis.Bottom


{-| Hide the Y aixs

The Y axis depends from the layout:

  - With a vertical layout the Y axis is the vertical axis.

  - With a horizontal layout the Y axis is the horizontal axis.

```
Line.init requiredConfig
    |> Line.hideYAxis
    |> Line.render ( data, accessor )
```

-}
hideYAxis : Config msg validation -> Config msg validation
hideYAxis config =
    Type.setYAxis False config


{-| Hide the X axis

The X axis depends from the layout:

  - With a vertical layout the X axis is the horizontal axis.
  - With a horizontal layout the X axis is the vertical axis.

```
Line.init requiredConfig
    |> Line.hideXAxis
    |> Line.render ( data, accessor )
```

-}
hideXAxis : Config msg validation -> Config msg validation
hideXAxis config =
    Type.setXAxis False config


{-| Hide all axis. Useful, for example, when drawing a sparkline.

    Line.init requiredConfig
        |> Line.hideAxis
        |> Line.render ( data, accessor )

-}
hideAxis : Config msg validation -> Config msg validation
hideAxis config =
    Type.setXAxis False config
        |> Type.setYAxis False


{-| Customise the time xAxis

    Line.init requiredConfig
        |> Line.withXAxisTime (Line.axisBottom [ Axis.tickCount 5 ])
        |> Line.render ( data, accessor )

-}
withXAxisTime : ChartAxis.XAxis Posix -> Config msg validation -> Config msg validation
withXAxisTime =
    Type.setXAxisTime


{-| Customise the continuous xAxis

    Line.init requiredConfig
        |> Line.withXAxisContinuous (Line.axisBottom [ Axis.tickCount 5 ])
        |> Line.render ( data, accessor )

-}
withXAxisContinuous : ChartAxis.XAxis Float -> Config msg validation -> Config msg validation
withXAxisContinuous =
    Type.setXAxisContinuous


{-| An alias for withXAxisContinuous

    Line.init requiredConfig
        |> Line.withXAxisCont (Line.axisBottom [ Axis.tickCount 5 ])
        |> Line.render ( data, accessor )

-}
withXAxisCont : ChartAxis.XAxis Float -> Config msg validation -> Config msg validation
withXAxisCont =
    Type.setXAxisContinuous


{-| Customise the yAxis

    Line.init requiredConfig
        |> Line.withYAxis (Line.axisRight [ Axis.tickCount 5 ])
        |> Line.render ( data, accessor )

-}
withYAxis : ChartAxis.YAxis Float -> Config msg validation -> Config msg validation
withYAxis =
    Type.setYAxisContinuous



-- EVENTS


{-| The data format returned by an event.
Internaly defined as:

    type alias Hint =
        { groupLabel : Maybe String
        , xChart : Float
        , yChart : List Float
        , xData : Float
        , yData : List Float
        }

  - xChart is the cursor's x coordinate in the chart's svg space.
  - yChart is the cursor's y coordinate in the chart's svg space.
  - xData is the list of all x line values within the tolerance of the xChart cursor's position.
  - yData is the list of all y line values within the tolerance of the yChart cursor's position. For a [hoverOne](#hoverOne) event, the yChart will always only have one value.

-}
type alias Hint =
    Event.Hint


{-| An event listener for a single element at a time.

    Line.init requiredConfig
        |> Line.withEvent (Line.hoverOne OnHover)
        |> Line.render ( data, accessor )

-}
hoverOne : (Maybe Event.Hint -> msg) -> Event.Event msg
hoverOne msg =
    Event.HoverOne msg


{-| An event listener for all elements along the same x-value.

    Line.init requiredConfig
        |> Line.withEvent (Line.hoverAll OnHover)
        |> Line.render ( data, accessor )

-}
hoverAll : (Maybe Event.Hint -> msg) -> Event.Event msg
hoverAll msg =
    Event.HoverAll msg


{-| Add an event with a msg to handle the returned Hint data.
One of:

  - [hoverOne](#hoverOne)

  - [hoverAll](#hoverAll)

```
Line.init requiredConfig
    |> Line.withEvent (Line.hoverOne OnHover)
    |> Line.render ( data, accessor )
```

-}
withEvent : Event msg -> Config msg validation -> Config msg validation
withEvent event =
    case event of
        HoverOne msg ->
            Type.addEvent (Event.HoverOne msg)

        HoverAll msg ->
            Type.addEvent (Event.HoverAll msg)


{-| A predefined point annotation, in the format of `Chart.Annotation.Point`
Typically used to draw points on hover.

    Line.init requiredConfig
        |> Line.withEvent (Line.hoverOne OnHover)
        |> Line.withPointAnnotation annotations
        |> Line.render ( data, accessor )

-}
withPointAnnotation : Maybe Annotation.Hint -> Config msg validation -> Config msg validation
withPointAnnotation annotation config =
    case annotation of
        Just a ->
            Type.setAnnotiation (Type.AnnotationPointHint a) config

        Nothing ->
            config


{-| A predefined x-bar annotation, in the format of `Chart.Annotation.Point`
Typically used to draw a vertical bar on hover.

    Line.init requiredConfig
        |> Line.withEvent (Line.hoverOne OnHover)
        |> Line.VerticalLine annotations
        |> Line.render ( data, accessor )

-}
withVLineAnnotation : Maybe Annotation.Hint -> Config msg validation -> Config msg validation
withVLineAnnotation annotation config =
    case annotation of
        Just a ->
            Type.setAnnotiation (Type.AnnotationXBarHint a) config

        Nothing ->
            config


{-| A stacked chart with lines option.

    Line.init requiredConfig
        |> Line.withStackedLayout Line.drawLine
        |> Line.render ( data, accessor )

-}
drawLine : Type.LineDraw
drawLine =
    Type.lineDrawLine



--SYMBOLS


{-| Pass a list of symbols to the line chart, one per data group.
If the list is empty, no symbols are rendered. It defaults to empty List.

    defaultLayoutConfig
        |> withSymbols [ Circle, Corner, Triangle ]

-}
withSymbols : List Symbol -> Config msg validation -> Config msg validation
withSymbols =
    Type.setIcons



--


{-| The xGroup label type.
-}
xGroupLabel : Type.Label
xGroupLabel =
    Type.XGroupLabel

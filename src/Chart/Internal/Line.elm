module Chart.Internal.Line exposing
    ( renderLineGrouped
    , wrongDataTypeErrorView
    )

import Axis
import Chart.Internal.Helpers as Helpers
import Chart.Internal.Symbol exposing (Symbol(..))
import Chart.Internal.Type
    exposing
        ( AxisContinousDataTickCount(..)
        , AxisContinousDataTickFormat(..)
        , AxisContinousDataTicks(..)
        , AxisOrientation(..)
        , Config
        , ConfigStruct
        , Data(..)
        , DataGroupLinear
        , Domain(..)
        , Layout(..)
        , PointLinear
        , RenderContext(..)
        , ariaLabelledby
        , bottomGap
        , fromConfig
        , fromDataLinear
        , fromDomainLinear
        , getDomain
        , getHeight
        , getMargin
        , getWidth
        , leftGap
        , role
        )
import Html exposing (Html)
import Path exposing (Path)
import Scale exposing (ContinuousScale)
import Shape
import TypedSvg exposing (g, svg)
import TypedSvg.Attributes
    exposing
        ( class
        , transform
        , viewBox
        )
import TypedSvg.Attributes.InPx exposing (height, width)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))



-- LOCAL TYPES


type AxisType
    = Vertical
    | Horizontal



-- INTERNALS
--


descAndTitle : ConfigStruct -> List (Svg msg)
descAndTitle c =
    -- https://developer.paciellogroup.com/blog/2013/12/using-aria-enhance-svg-accessibility/
    [ TypedSvg.title [] [ text c.title ]
    , TypedSvg.desc [] [ text c.desc ]
    ]


renderLineGrouped : ( Data, Config ) -> Html msg
renderLineGrouped ( data, config ) =
    let
        c =
            fromConfig config

        m =
            getMargin config

        w =
            getWidth config

        h =
            getHeight config

        outerW =
            w + m.left + m.right

        outerH =
            h + m.top + m.bottom

        domain =
            getDomain config
                |> fromDomainLinear

        horizontalRange =
            ( 0, w )

        verticalRange =
            ( h, 0 )

        sortedData =
            data
                |> fromDataLinear
                --FIXME
                |> List.sortBy (.points >> List.map Tuple.first)

        horizontalScale : ContinuousScale Float
        horizontalScale =
            Scale.linear horizontalRange domain.horizontal

        verticalScale : ContinuousScale Float
        verticalScale =
            Scale.linear verticalRange domain.vertical

        lineGenerator : PointLinear -> Maybe PointLinear
        lineGenerator ( x, y ) =
            Just ( Scale.convert horizontalScale x, Scale.convert verticalScale y )

        line : DataGroupLinear -> Path
        line dataGroup =
            dataGroup.points
                |> List.map lineGenerator
                |> Shape.line Shape.monotoneInXCurve
    in
    svg
        [ viewBox 0 0 outerW outerH
        , width outerW
        , height outerH
        , role "img"
        , ariaLabelledby "title desc"
        ]
    <|
        descAndTitle c
            ++ axisGenerator c Vertical verticalScale
            ++ axisGenerator c Horizontal horizontalScale
            ++ [ g
                    [ transform [ Translate m.left m.top ]
                    , class [ "series" ]
                    ]
                 <|
                    List.indexedMap
                        (\idx d ->
                            Path.element (line d)
                                [ class [ "line", "line-" ++ String.fromInt idx ]
                                ]
                        )
                        sortedData
               ]


axisGenerator : ConfigStruct -> AxisType -> ContinuousScale Float -> List (Svg msg)
axisGenerator c axisType scale =
    if c.showContinousAxis == True then
        case axisType of
            Vertical ->
                let
                    ticks =
                        case c.axisVerticalTicks of
                            DefaultTicks ->
                                Nothing

                            CustomTicks t ->
                                Just (Axis.ticks t)

                    tickCount =
                        case c.axisVerticalTickCount of
                            DefaultTickCount ->
                                Nothing

                            CustomTickCount count ->
                                Just (Axis.tickCount count)

                    tickFormat =
                        case c.axisVerticalTickFormat of
                            DefaultTickFormat ->
                                Nothing

                            CustomTickFormat formatter ->
                                Just (Axis.tickFormat formatter)

                    attributes =
                        [ ticks, tickFormat, tickCount ]
                            |> List.filterMap identity

                    axis =
                        Axis.left attributes scale
                in
                [ g
                    [ transform [ Translate (c.margin.left - leftGap |> Helpers.floorFloat) c.margin.top ]
                    , class [ "axis", "axis--vertical" ]
                    ]
                    [ axis ]
                ]

            Horizontal ->
                let
                    ticks =
                        case c.axisHorizontalTicks of
                            DefaultTicks ->
                                Nothing

                            CustomTicks t ->
                                Just (Axis.ticks t)

                    tickCount =
                        case c.axisHorizontalTickCount of
                            DefaultTickCount ->
                                Nothing

                            CustomTickCount count ->
                                Just (Axis.tickCount count)

                    tickFormat =
                        case c.axisHorizontalTickFormat of
                            DefaultTickFormat ->
                                Nothing

                            CustomTickFormat formatter ->
                                Just (Axis.tickFormat formatter)

                    attributes =
                        [ ticks, tickFormat, tickCount ]
                            |> List.filterMap identity

                    axis =
                        Axis.bottom attributes scale
                in
                [ g
                    [ transform [ Translate c.margin.left (c.height + bottomGap + c.margin.top) ]
                    , class [ "axis", "axis--horizontal" ]
                    ]
                    [ axis ]
                ]

    else
        []



-- ERROR VIEWS


wrongDataTypeErrorView : Html msg
wrongDataTypeErrorView =
    Html.div [] [ Html.text "Data type not supported in line charts" ]

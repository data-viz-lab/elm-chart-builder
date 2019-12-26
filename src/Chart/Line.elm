module Chart.Line exposing
    ( init
    , render
    , setDesc
    , setDimensions
    , setDomain
    , setHeight
    , setTitle
    , setWidth
    )

import Axis
import Chart.Helpers as Helpers exposing (dataBandToDataStacked)
import Chart.Symbol
    exposing
        ( Symbol(..)
        , circle_
        , corner
        , custom
        , getSymbolByIndex
        , symbolGap
        , symbolToId
        , triangle
        )
import Chart.Type
    exposing
        ( AxisOrientation(..)
        , Config
        , ConfigStruct
        , ContinousDataTickCount(..)
        , ContinousDataTickFormat(..)
        , ContinousDataTicks(..)
        , Data(..)
        , DataGroupLinear
        , Domain(..)
        , GroupedConfig
        , Layout(..)
        , Margin
        , Orientation(..)
        , PointLinear
        , RenderContext(..)
        , adjustLinearRange
        , ariaLabelledby
        , defaultConfig
        , fromConfig
        , fromDataLinear
        , fromDomainLinear
        , getBandGroupRange
        , getBandSingleRange
        , getDataDepth
        , getDomain
        , getDomainFromData
        , getHeight
        , getIcons
        , getIconsFromLayout
        , getLinearRange
        , getMargin
        , getOffset
        , getWidth
        , role
        , setContinousDataTickCount
        , setDimensions
        , setDomain
        , setShowContinousAxis
        , setShowOrdinalAxis
        , setTitle
        , showIcons
        , showIconsFromLayout
        , symbolCustomSpace
        , symbolSpace
        , toConfig
        )
import Html exposing (Html)
import Html.Attributes
import List.Extra
import Path exposing (Path)
import Scale exposing (BandScale, ContinuousScale, defaultBandConfig)
import Shape exposing (StackConfig)
import TypedSvg exposing (g, rect, svg, text_)
import TypedSvg.Attributes
    exposing
        ( alignmentBaseline
        , class
        , shapeRendering
        , textAnchor
        , transform
        , viewBox
        , xlinkHref
        )
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AlignmentBaseline(..), AnchorAlignment(..), ShapeRendering(..), Transform(..))



-- API METHODS


{-| Initializes the line chart

    Line.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])

-}
init : Data -> ( Data, Config )
init data =
    ( data, defaultConfig )
        |> setDomain (getDomainFromData data)


{-| Renders the line chart, after initialisation and customisation

    Line.init (DataBand [ { groupLabel = Nothing, points = [ ( "a", 10 ) ] } ])
        |> Line.render

-}
render : ( Data, Config ) -> Html msg
render ( data, config ) =
    let
        c =
            fromConfig config
    in
    case data of
        DataLinear _ ->
            case c.layout of
                Grouped _ ->
                    renderLineGrouped ( data, config )

                Stacked _ ->
                    Html.text "TODO"

        _ ->
            wrongDataTypeErrorView


setHeight : Float -> ( Data, Config ) -> ( Data, Config )
setHeight =
    Chart.Type.setHeight


setWidth : Float -> ( Data, Config ) -> ( Data, Config )
setWidth =
    Chart.Type.setWidth


setDimensions : { margin : Margin, width : Float, height : Float } -> ( Data, Config ) -> ( Data, Config )
setDimensions =
    Chart.Type.setDimensions


{-| Sets the domain value in the config
If not set, the domain is calculated from the data

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setDomain (DomainLinear { horizontal = ( 1, 1 ), vertical = ( 0, 20 ) })
        |> Line.render

-}
setDomain : Domain -> ( Data, Config ) -> ( Data, Config )
setDomain =
    Chart.Type.setDomain


{-| Sets an accessible, long-text description for the svg chart.
Default value: ""

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setDesc "This is an accessible chart, with a desc element"
        |> Line.render

-}
setDesc : String -> ( Data, Config ) -> ( Data, Config )
setDesc =
    Chart.Type.setDesc


{-| Sets an accessible title for the svg chart.
Default value: ""

    Line.init (DataLinear [ { groupLabel = Nothing, points = [ ( 0, 10 ), ( 1, 20 ) ] } ])
        |> Line.setTitle "This is a chart"
        |> Line.render

-}
setTitle : String -> ( Data, Config ) -> ( Data, Config )
setTitle =
    Chart.Type.setTitle



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
            ++ [ g
                    [ transform [ Translate m.left m.top ]
                    , class [ "series" ]
                    ]
                 <|
                    List.map (\d -> Path.element (line d) []) sortedData
               ]



-- ERROR VIEWS


wrongDataTypeErrorView : Html msg
wrongDataTypeErrorView =
    Html.div [] [ Html.text "Data type not supported in line charts" ]

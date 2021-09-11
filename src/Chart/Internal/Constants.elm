module Chart.Internal.Constants exposing
    ( annotationClassName
    , areaShapeClassName
    , axisClassName
    , axisXClassName
    , axisYClassName
    , axisYLeftClassName
    , axisYRightClassName
    , barClassName
    , columnClassName
    , componentClassName
    , dataGroupClassName
    , histogramClassName
    , labelClassName
    , lineClassName
    , lineShapeClassName
    , rootClassName
    , symbolClassName
    , vLineAnnotationClassName
    )


rootClassName : String
rootClassName =
    -- short for elm-chart-builder
    "ecb"


barClassName : String
barClassName =
    "ecb-bar"


lineClassName : String
lineClassName =
    "ecb-line"


histogramClassName : String
histogramClassName =
    "ecb-histogram"


componentClassName : String
componentClassName =
    "ecb-component"


labelClassName : String
labelClassName =
    "ecb-label"


symbolClassName : String
symbolClassName =
    "ecb-symbol"


annotationClassName : String
annotationClassName =
    "ecb-annotation"


vLineAnnotationClassName : String
vLineAnnotationClassName =
    "ecb-annotation-v-line"


columnClassName : String
columnClassName =
    "ecb-column"


dataGroupClassName : String
dataGroupClassName =
    "ecb-data-group"


axisClassName : String
axisClassName =
    "ecb-axis"


axisYRightClassName : String
axisYRightClassName =
    "ecb-axis-y-right"


axisYLeftClassName : String
axisYLeftClassName =
    "ecb-axis-y-left"


axisYClassName : String
axisYClassName =
    "ecb-axis-y"


axisXClassName : String
axisXClassName =
    "ecb-axis-x"


areaShapeClassName : String
areaShapeClassName =
    "ecb-area"


lineShapeClassName : String
lineShapeClassName =
    "ecb-line"

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
    "chart-builder"


barClassName : String
barClassName =
    "chart-builder--bar"


lineClassName : String
lineClassName =
    "chart-builder--line"


histogramClassName : String
histogramClassName =
    "chart-builder--histogram"


componentClassName : String
componentClassName =
    "chart-builder__component"


labelClassName : String
labelClassName =
    "chart-builder__label"


symbolClassName : String
symbolClassName =
    "chart-builder__symbol"


annotationClassName : String
annotationClassName =
    "chart-builder__annotation"


vLineAnnotationClassName : String
vLineAnnotationClassName =
    "chart-builder__annotation--v-line"


columnClassName : String
columnClassName =
    "chart-builder__column"


dataGroupClassName : String
dataGroupClassName =
    "chart-builder__data-group"


axisClassName : String
axisClassName =
    "chart-builder__axis"


axisYRightClassName : String
axisYRightClassName =
    "chart-builder__axis--y-right"


axisYLeftClassName : String
axisYLeftClassName =
    "chart-builder__axis--y-left"


axisYClassName : String
axisYClassName =
    "chart-builder__axis--y"


axisXClassName : String
axisXClassName =
    "chart-builder__axis--x"


areaShapeClassName : String
areaShapeClassName =
    "chart-builder__area"


lineShapeClassName : String
lineShapeClassName =
    "chart-builder__line"

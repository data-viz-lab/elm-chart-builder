![elm-chart-builder](https://raw.githubusercontent.com/data-viz-lab/elm-chart-builder/master/elm-chart-builder-example-small.png "elm-chart-builder-example")

# elm-chart-builder
An opinionated and accessible charting library for Elm based on [gampleman/elm-visualization](https://github.com/gampleman/elm-visualization).

The aim of this package is to make it easy to create some basic chart types. 
It is an opinionated library because every charting module represents a very specific charting choice, that also requires a specific data structure.
For example, the `Line` module can be a time-line chart, that expects time values on the X axis and float values on the Y axis.

If your aim is to build some personalized charts not covered here, then you should use `elm-visualization` directly.

All chart modules will be as much accessible as possible, but for now this is still a work in progress.

The `Chart.Bar` module is almost feature complete.

The `Chart.Line` module is still a work in progress and has limited functionality.

## Examples:
`cd examples && elm reactor`

Then navigate the examples in the browser.

## Tests:
`elm-test`

## Roadmap:
* Add areas to lines-charts (stacked and none)
* Solve tooltips
* Solve zooming
* Add sampling
* Add line-chart animation example
* Revisit API
* Add labelling
* Add table representation


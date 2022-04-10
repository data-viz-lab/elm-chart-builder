![elm-chart-builder](https://raw.githubusercontent.com/data-viz-lab/elm-chart-builder/master/images/elm-chart-builder.png "elm-chart-builder-example")

# [elm-chart-builder](https://data-viz-lab.github.io/elm-chart-builder-presentation/)
**Note:** the library is in active development and some parts of the API will change in the upcoming release.

An opinionated and accessible charting library for elm based on [gam    pleman/elm-visualization](https://github.com/gampleman/elm-visualization) and [elm-community/typed-svg](https://package.elm-lang.org/packages/elm-community/typed-svg/latest/).
                                                                        
The aim of this package is to expose an easy and intuitive api for building a variety of accessible chart types. 
It is an opinionated library, because every charting module represents a very specific charting choice. If your aim is to build some personalized charts not covered here, then you should probably try a more low level library such as `gampleman/elm-visualization`.

All chart modules are being developed with full accessibility in mind (work in progress).

## Core concepts

To build a chart you need:
- Your data
- An accessor function that tells elm-chart-builder how to get x and y values from the data, and how to group them.
- A configuration (data structure) that tells elm-chart-builder how the chart should look

Build your configuration in a pipeline: 
- Start with ['init'](https://package.elm-lang.org/packages/data-viz-lab/elm-chart-builder/latest/Chart-Bar#init), which takes all the mandatory parameters,
- pipe through functions that set options,
- and end with ['render'](https://package.elm-lang.org/packages/data-viz-lab/elm-chart-builder/latest/Chart-Bar#render) which takes your data and accessor and returns your chart as `Html msg`.

```elm
Bar.init
    { margin =
        { top = 10
        , right = 10
        , bottom = 30
        , left = 30
        }
    , width = 500
    , height = 200
    }
    |> Bar.withStackedLayout Bar.noDirection
    |> Bar.render
        ( [ ("a", 10 ), ("b", 20 )]
        , Bar.Accessor (always Nothing)
            Tuple.first
            Tuple.second
        )
```

## Built-in CSS classes 
elm-chart-builder adds a number of css classes to the generated elements. These can be used to customize the charts with css.

## Documentation

Find the documentation on [Elm's package website](https://package.elm-lang.org/packages/data-viz-lab/elm-chart-builder/latest/).

## Online presentation page

* [elm-chart-builder-presentation](https://data-viz-lab.github.io/elm-chart-builder-presentation/)

## Development

### Examples

You can test code changes with the existing examples.
It expects elm to already be installed and accessible.

```shell
$ cd examples
$ elm reactor
```

and then open [examples](https://localhost:8000).

### Unit tests:

```shell
$ npm install
$ elm-test
```

### elm-anlyse:

```shell
$ npm install
$ elm-analyse > elm-analyse.log
```

### Screenshot tests:

It expects the `elm reactor` server to be already running on port 8000.

```shell
$ npm install
$ cd screenshot-tests

# Check if a page in the examples folder has changed unexpectedly after a code change:
$ node tests.js

# Then if any example page has changed: 
# you can check the diff images in the diffs folder,
# and you can also check the current and prev images in the images folder.

# If the change was intentional, you can reset all images by running:
$ node tests.js --reset
```



![elm-chart-builder](https://raw.githubusercontent.com/data-viz-lab/elm-chart-builder/master/images/elm-chart-builder.png "elm-chart-builder-example")

# elm-chart-builder
An opinionated and accessible charting library for elm based on [gampleman/elm-visualization](https://github.com/gampleman/elm-visualization) and [elm-community/typed-svg](https://package.elm-lang.org/packages/elm-community/typed-svg/latest/).

The aim of this package is to expose an easy and intuitive api for building a variety of accessible chart types. 
It is an opinionated library, because every charting module represents a very specific charting choice. If your aim is to build some personalized charts not covered here, then you should probably try a more low level library such as `gampleman/elm-visualization`.

All chart modules are being developed with full accessibility in mind (work in progress).

## Core concepts

* For all charts the building process starts by passing a required config to the init function.
* The required config includes the width, height and margin of the chart.
* After initialisation, an extensive list of optional configuration functions can be passed in a pipeline.
* The pipeline is closed with a render function, that takes the configuration from the pipeline together with the data and a data accessor.
* The data is a flat list of generic items that must at least contain an xValue and a yValue value and an optional xGroup value.
* The accessor is a function that tells the library how to access the xValue, yValue and xGroup fields.

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


## Documentation

Find the documentation on [Elm's package website](https://package.elm-lang.org/packages/data-viz-lab/elm-chart-builder/latest/).

## Examples

It expects elm to already be installed and accessible.

```shell
$ cd examples
$ elm reactor
```

and open [examples](https://localhost:8000).

## Tests:

It expects elm-test to already be installed and accessible.

```shell
$ elm-test
```


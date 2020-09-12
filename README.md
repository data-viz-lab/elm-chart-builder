![elm-chart-builder](https://raw.githubusercontent.com/data-viz-lab/elm-chart-builder/master/images/elm-chart-builder.png "elm-chart-builder-example")

# elm-chart-builder
An opinionated and accessible charting library for elm based on [gampleman/elm-visualization](https://github.com/gampleman/elm-visualization) and [elm-community/typed-svg](https://package.elm-lang.org/packages/elm-community/typed-svg/latest/).

The aim of this package is to expose an easy and intuitive api for building a variety of accessible chart types. 
It is an opinionated library, because every charting module represents a very specific charting choice. If your aim is to build some personalized charts not covered here, then you should probably try a more low level library such as `gampleman/elm-visualization`.

All chart modules are being developed with full accessibility in mind (work in progress).

## Core concepts

To build a chart you need:
- Your data
- An accessor function that tells elm-chart-builder how to get x and y values from the data, and how to group them.
- A configuration (data structure) that tells elm-chart-builder how the chart should look

Build your configuration in a pipeline: 
- Start with ['init'](link to the function if you can), which takes all the mandatory parameters,
- pipe through functions that set options,
- and end with ['render']() which which takes your data and accessor and returns your chart as  `Html msg`.

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


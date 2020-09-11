![elm-chart-builder](https://raw.githubusercontent.com/data-viz-lab/elm-chart-builder/master/images/world-bank-example.png "elm-chart-builder-example")

# elm-chart-builder
An opinionated and accessible charting library for Elm based on [gampleman/elm-visualization](https://github.com/gampleman/elm-visualization) and [elm-community/typed-svg](https://package.elm-lang.org/packages/elm-community/typed-svg/latest/).

The aim of this package is to expose an easy and intuitive api for building a variety of accessible chart types. 
It is an opinionated library, because every charting module represents a very specific charting choice. If your aim is to build some personalized charts not covered here, then you should probably try a more low level library such as `gampleman/elm-visualization`.

All chart modules are being developed with full accessibility in mind, but this is still work in progress.

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


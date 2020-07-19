## API notes around conflicting config

### Summary
My current approach for the API is:

* Avoid conflicting configurations. For example, one should not be able to set symbols on a stacked bar chart.
* Prefer simplicity over consistency. For example, because stacked line charts should accept symbols, simplify the API and do not make it consistent with the bar chart module.

### Problem

Layouts can be Stacked or Grouped. For Bar charts I only want to allow Symbols for grouped layouts. For Line charts instead, for both grouped and stacked layouts (not yet implemented).

In the current Bar chart implementation, symbols are defined as part of the layout (in order to avoid conflicting configurations):

```elm
    -- A groupded layout accepts a config with icons:
    Bar.init
        |> Bar.setLayout (Bar.groupedLayout (Bar.defaultGroupedConfig |> Bar.setIcons icon))

    -- A stacked layout only accepts a direction:
    Bar.init
        |> Bar.setLayout (Bar.stackedLayout Bar.divergingDirection)

```

This approach avoids combinations that make no sense, but at the same time it might not be as intuitive. How much are the symbols and the layout of a bar chart related? One could argue not much.

Another possible approach is to ignore these conflicting combinations (and maybe log a warning at runtime):

```elm
    -- More readable
    Bar.init
        |> Bar.setLayout Bar.groupedLayout
        |> Bar.setIcons icon

    -- Impossible combination, setIcons will be ignored and no icons will be rendered at runtime
    Bar.init
        |> Bar.setLayout (Bar.stackedLayout Bar.divergingDirection)
        |> Bar.setIcons icon
```

Adding symbols to Line charts (not implemented) complicates things further. Symbols in line charts are fine in both grouped and stacked layouts, so this could easily be done by:

```elm
    Line.init
        |> Line.setLayout Line.groupedLayout
        |> Line.setIcons icon

    Bar.init
        |> Line.setLayout Line.stackedLayout
        |> Line.setIcons icon
```

But for consistency with the Bar chart API, one might prefer:

```elm
    Line.init
        |> Line.setLayout (Line.groupedLayout (Line.defaultGroupedConfig |> Line.setIcons icon))
        |> Line.setIcons icon

    Bar.init
        |> Line.setLayout (Line.stackedLayout (Line.defaultStackedConfig |> Line.setIcons icon))
        |> Line.setIcons icon
```

But this is not very nice, and brings me back to the question if both line and bar charts should have a nicer API, that in some cases can generate conflicting configurations that would be ignored.


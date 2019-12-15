---
id: scale_link_color
title: Scale Link Color
sidebar_label: Scale Link Color
---

## Description

Scale links color, note that links colors are split in two.


## Usage

```r
scale_link_source_color(g, variable, palette = graph_palette())
scale_link_target_color(g, variable, palette = graph_palette())
scale_link_color(g, variable, palette = graph_palette())
scale_link_color_coords(g, red = c(0.01, 0.99), green = red, blue = red)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`variable`     |     Bare column name of variable to scale against.
`palette`     |     Color palette.
`red`     |     The possible range of values (light) that the red, green, and blue channels can take, must be vectors ranging from `0` to `1` .
`green`     |     The possible range of values (light) that the red, green, and blue channels can take, must be vectors ranging from `0` to `1` .
`blue`     |     The possible range of values (light) that the red, green, and blue channels can take, must be vectors ranging from `0` to `1` .


## Examples

```r
g <- make_data(1000)

# color by cluster
graph(g) %>%
graph_cluster() %>%
scale_link_color(cluster)

# color by coordinates
graph(g) %>%
graph_layout_offline() %>%
scale_link_color_coords()
```



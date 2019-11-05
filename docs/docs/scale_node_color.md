---
id: scale_node_color
title: scale node color
sidebar_label: scale node color
---

# `scale_node_color`

Scale Node Color


## Description

Scale nodes color.


## Usage

```r
scale_node_color(g, variable, palette = graph_palette())
scale_node_color_coords(g, red = c(0.01, 0.99), green = red, blue = red)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`variable`     |     Bare column name of variable to scale against.
`palette`     |     Color palette.
`red, green, blue`     |     The possible range of values (light) that the red, green, and blue channels can take, must be vectors ranging from `0` to `1` .


## Examples

```r
graph_data <- make_data(100)
graph_data$nodes$var <- runif(100, 1, 10)

# scale by variable
graph() %>%
graph_nodes(graph_data$nodes, id, var) %>%
graph_links(graph_data$links, source, target) %>%
scale_node_color(var)

# scale by coordinate position
graph(graph_data) %>%
graph_static_layout() %>%
scale_node_color_coords()
```



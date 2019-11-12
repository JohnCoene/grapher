---
id: graph_static_layout
title: Graph Static Layout
sidebar_label: Graph Static Layout
---

## Description

Layout the graph given using an igraph algorithm rather
 than the built-in force layout.


## Usage

```r
graph_static_layout(
  g,
  method = igraph::layout_nicely,
  dim = 3,
  scaling = c(-200, 200),
  weights = NULL,
  ...
)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`method`     |     The igraph function to compute node positions.
`dim`     |     Number of dimensions to use, passed to `method` .
`scaling`     |     A vector or 2 values defining the output range to rescale the coordinates, set `NULL` to not use any scaling.
`weights`     |     Bare column name of links weight if `NULL`  no weight is taken into account.
`...`     |     Any other argument to pass to `method` .


## See Also

[`graph_offline_layout`](#graphofflinelayout) to compute the same layout as
 [`graph_live_layout`](#graphlivelayout) but in R rather than in the browser.


## Note

This function will overwrite `x` , `y` , `z` variables
 previously passed to [`graph_nodes`](#graphnodes) .


## Examples

```r
graph_data <- make_data(200)

g <- graph(graph_data)

# layout without scaling
graph_static_layout(g, scaling = NULL)

# layout with scaling
graph_static_layout(g)

# layout with weight
graph_static_layout(g, method = igraph::layout_with_fr, weight = weight)
```



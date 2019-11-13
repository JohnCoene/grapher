---
id: rescale_layout
title: Rescale Layout
sidebar_label: Rescale Layout
---

## Description

Rescale the coordinates of the layout.


## Usage

```r
rescale_layout(g, scale = c(-1000, 1000))
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`scale`     |     A vector or 2 values defining the output range to rescale the coordinates.


## Examples

```r
g <- make_data()

graph(g) %>%
graph_static_layout(scaling = NULL) %>%
rescale_layout()
```



---
id: graph_draw
title: graph draw
sidebar_label: graph draw
---

# `graph_draw`

Draw or Redraw a Graph


## Description

Draw or re-draw a graph.


## Usage

```r
graph_draw(g)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.


## Details

If used on a [`graph_proxy`](#graphproxy) then
 the graph is re-draw, if used on a static visualisation
 ( [`graph`](#graph) ) then the graph is simply drawn. The
 latter is only useful if `draw` was set to `FALSE` 
 in the initialisation function ( [`graph`](#graph) ).


## Examples

```r
make_data() %>%
graph(draw = FALSE) %>%
graph_draw()
```



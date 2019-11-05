---
id: scale_node_size
title: Scale Node Size
sidebar_label: Scale Node Size
---

## Description

Scale nodes size.


## Usage

```r
scale_node_size(g, variable, range = c(20, 70))
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`variable`     |     Bare column name of variable to scale against.
`range`     |     Output range.


## Examples

```r
graph_data <- make_data()

graph_data %>%
graph() %>%
scale_node_size(size, c(10, 100))
```



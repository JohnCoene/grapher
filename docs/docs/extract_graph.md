---
id: extract_graph
title: Extract Graph
sidebar_label: Extract Graph
---

## Description

Extract the graph as list, useful if one wants to
 further process it or generate the offline layout
 using nodejs as it can be imported with
 [https://github.com/anvaka/ngraph.fromjson](ngraph.fromjson) .


## Usage

```r
extract_graph(g, json = FALSE)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`json`     |     Whether to return JSON, if `FALSE` returns a list.


## Value

A `list` of nodes and edges.


## Examples

```r
data <- make_data(10)

g <- graph(data)

lst <- extract_graph(g)

# json read to import oin ngraph
json <- extract_graph(g, json = TRUE)
```



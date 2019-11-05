---
id: cran_deps_graph
title: cran deps graph
sidebar_label: cran deps graph
---

# `cran_deps_graph`

CRAN Dependency Graph


## Description

Builds the CRAN dependency graph.


## Usage

```r
cran_deps_graph(
  max = 10,
  include_base_r = TRUE,
  deps = c("Depends", "Imports", "LinkingTo"),
  format = c("list", "igraph")
)
```


## Arguments

Argument      |Description
------------- |----------------
`max`     |     Maximum number of reverse dependencies for a package may have. Set to `Inf` to return the entire graph.
`include_base_r`     |     Set to `FALSE` to exclude base R packages.
`deps`     |     Forms of dependencies to take into account.
`format`     |     The format in which to return the graph, either a `list` or nodes and edges or an object of class `igraph` .


## Value

A list of nodes and links.


## Examples

```r
g <- cran_deps_graph(500, format = "igraph")
min_g <- igraph::mst(g)

min_g %>%
graph() %>%
graph_cluster() %>%
scale_link_color(cluster) %>%
scale_node_size(degree, c(20, 100))
```



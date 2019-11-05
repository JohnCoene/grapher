---
id: graph_cluster
title: Graph Cluster
sidebar_label: Graph Cluster
---

## Description

Cluster nodes on the graph. This ultimately adds a `cluster` 
 column to the internal node data.frame. The latter can be used in
 e.g.: [`scale_node_color`](#scalenodecolor) .


## Usage

```r
graph_cluster(
  g,
  method = igraph::cluster_walktrap,
  quiet = !interactive(),
  ...
)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`method`     |     The igraph function to create the cluster.
`quiet`     |     Set to `TRUE` to not print number of clusters in the console.
`...`     |     Any other bare named column containing meta data to attach to the nodes.


## Examples

```r
graph_data <- make_data(200)

graph(graph_data) %>%
graph_cluster()
```



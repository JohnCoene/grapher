---
id: graph_bin_layout
title: Graph Bin Layout
sidebar_label: Graph Bin Layout
---

## Description

Add layout computed offline via nodejs.
 Note that [`graph_offline_layout`](#graphofflinelayout) uses the same algorithm.


## Usage

```r
graph_bin_layout(g, positions)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`positions`     |     Path to binary positions file as computed by [https://github.com/anvaka/ngraph.offline.layout](ngraph.offline.layout) , generally `positions.bin` .


## See Also

[`graph_offline_layout`](#graphofflinelayout) to run the same algorithm without
 having to export the graph and use nodejs.



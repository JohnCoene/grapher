---
id: graph_layout_bin
title: Graph Layout Bin
sidebar_label: Graph Layout Bin
---

## Description

Add layout computed offline via nodejs.
 Note that [`graph_layout_offline`](#graphlayoutoffline) uses the same algorithm.


## Usage

```r
graph_bin_layout(g, positions)
graph_layout_bin(g, positions)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`positions`     |     Path to binary positions file as computed by [https://github.com/anvaka/ngraph.offline.layout](ngraph.offline.layout) , generally `positions.bin` .


## See Also

[`graph_layout_offline`](#graphlayoutoffline) to run the same algorithm without
 having to export the graph and use nodejs.



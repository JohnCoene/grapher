---
id: link_distance
title: link distance
sidebar_label: link distance
---

# `link_distance`

Hide Links


## Description

Hide links over a certain length, based on computations by `graph_static_layout` .
 Nodes will actually be hidden in resulting visualisation but not removed.


## Usage

```r
hide_long_links(g, length = 1)
compute_links_length(g)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`length`     |     Length above which links should be hidden.


## Details

This is the technique used by [https://github.com/anvaka](Andrei Kashcha) ,
 in his [https://anvaka.github.io/pm](package managers visualisation project) , though
 the latter does not use ngraph.pixel (which grapher uses) and hides links based on the
 length in pixels. Hiding distant edges allows to undo the hairball while still being
 able to discern smaller communities.


## Examples

```r
gdata <- make_data(500)

g <- graph(gdata) %>%
graph_static_layout(scaling = c(-1000, 1000)) %>%
graph_cluster() %>%
scale_link_color(cluster)

# hide links longer than 100
hide_long_links(g, 100)

# or get computed lengths
lengths <- compute_links_length(g)

# define threshold
threshold <- quantile(lengths$length, .2)

hide_long_links(g, threshold)
```



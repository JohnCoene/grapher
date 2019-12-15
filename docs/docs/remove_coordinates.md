---
id: remove_coordinates
title: Remove Coordinates
sidebar_label: Remove Coordinates
---

## Description

Removes coordinates ( `x` , `y` , and `z` ) from the
 graph. This is useful if you have used the `graph_layout_static` 
 to then `hide_long_links` but nonetheless want to use the default
 force layout ( `graph_layout_live` ).


## Usage

```r
remove_coordinates(g)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.


## Examples

```r
gdata <- make_data(500)

graph(gdata) %>%
graph_layout_static() %>%
hide_long_links(20) %>% # hide links
remove_coordinates()
```



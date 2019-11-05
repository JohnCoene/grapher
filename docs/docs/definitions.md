---
id: definitions
title: definitions
sidebar_label: definitions
---

# `definitions`

Definitions


## Description

Define variables to use for color, size, and hidden links.


## Usage

```r
define_node_color(g, var)
define_node_size(g, var)
define_link_source_color(g, var)
define_link_target_color(g, var)
define_link_hidden(g, var)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`var`     |     Bare name of variable to define.


## Examples

```r
# generate data
# add custom color
data <- make_data()
data$nodes$myColor <- "#0000ff"

graph(data) %>%
define_node_color(myColor)
```



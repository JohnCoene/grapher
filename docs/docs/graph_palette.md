---
id: graph_palette
title: Graph Palette
sidebar_label: Graph Palette
---

## Description

Bright and light color palettes for examples and defaults.


## Usage

```r
graph_palette()
graph_palette_light()
```


## Value

A vector of hex colors.


## Examples

```r
graph_data <- make_data(200)

graph_data %>%
graph() %>%
graph_cluster() %>%
scale_link_color(cluster, palette = graph_palette_light())
```



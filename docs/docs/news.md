---
id: news
title: Changelog
sidebar_label: Changelog
---

# 0.1.1.9000

- `graph` now accepts object of class `graphframes` as returned by [graphframes](https://github.com/rstudio/graphframes).
- `graph_cluster` and `graph_static_layout` now accept a `weights` argument.

## Shiny

A new family of `update_*` functions to easily update graph aspects on the fly.

- `update_node_size` and `update_node_color` to update a single node.
- `update_nodes_size` and `update_nodes_color` to update multiple nodes from a data.frame.
- `update_link_source_color` and `update_link_target_color` to update a link source and target color.
- `update_links_source_color` and `update_links_target_color` to update multiple links from a data.frame.

# 0.1.0

Initial Version.

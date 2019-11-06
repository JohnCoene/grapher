---
id: cluster
title: Cluster
sidebar_label: Cluster
---

You can compute clusters, also known as communities, using grapher. Note that internally, as for static layouts, grapher uses [igraph](https://igraph.org/r/). You are by no means forced to use grapher's clustering methods, you can always compute these yourself before initialising the graph.

Assigning nodes to communities, using grapher's `graph_cluster` function or any other prior to initialisation, has not direct effect on the visualisation. In fact it does not directly pertains to graph visualisation. It is included as it is so often used to define visual aspects of a graph, most commonly, node color.

---
id: cluster
title: Cluster
sidebar_label: Cluster
---

Grapher also lets you compute clusters, also known as communities. Note that internally, as for static layouts, grapher uses [igraph](https://igraph.org/r/). You are by no means forced to use grapher's clustering methods, you can always compute these yourself before initialising the graph.

Community detection is included in the package as it is often used to define visual aspects of a graph (e.g.: node color), but in fact does not directly pertain to graph visualisation. Therefore assigning nodes to communities using `graph_cluster` has no direct effect on the visualisation.

The `graph_cluster` function defaults to using `igraph::cluster_walktrap` but you can use another clustering igraph function.

```r
g <- make_data()

graph(g) %>% 
  graph_cluster()
```

If you ran the above you probably observed that the output graph was no different had you ran the snippet without `graph_cluster`. This is, as mentioned above because is simply computes the cluster to which each node belongs but does not apply that to any aspect of the graph. We can do so with `scale_*` functions (covered later).

```r
g <- make_data()

graph(g) %>% 
  graph_cluster() %>% 
  scale_node_color(cluster)
```

Just to reiterate, you can compute those outside of the grapher pipe, using [tidygraph](https://github.com/thomasp85/tidygraph).

```r
library(tidygraph)

play_smallworld(1, 100, 3, 0.05) %>% 
  activate(nodes) %>% 
  mutate(
    id = 1:n(), # add id
    group = group_walktrap()
  ) %>% 
  graph() %>% 
  scale_node_color(group)
```

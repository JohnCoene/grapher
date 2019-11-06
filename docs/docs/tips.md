---
id: tips
title: Tips & Tricks
sidebar_label: Tips
---

This document gives away a few tips to make visualisations look nicer and render faster. 

Some issues arise when visualising large graphs: 1) hairballs, large graphs tend to have a large number of edges making for undecipherable graphs, 2) clustering is often need as it helps make sense of the graph but quickly becomes a bottleneck with large graphs. 3) Another computationally expensive operation is the layout which you are almost certainly going to to do before rendering.

## Cluster

So the clustering is, if not a bottleneck, certainly adds computation time to creating the visualisation. You could, maybe contemplate skipping this step so to speak. If you need to know the actual cluster nodes belong for any statistical analysis, by all means compute it but if your aim is to merely bring to view nodes that are close to one another (e.g.: a community) there is, in grapher, a much more efficient way of doing so. 

Since we've already established that you are rendering a large graph one thing you will have to do is to compute the layout the graph offline. Moreover, nodes within the same community are layed out closed to one another. So why not simply use the layout, the `x`, `y`, `z` coordinates of each node to simply define the color.

This is the reason behind `scale_node_color_coords`, `scale_link_color_coords`.

```r
g <- make_data(2000)

graph(g) %>% 
  graph_offline_layout() %>% 
  scale_link_color_coords()
```

## Hiding links

Plainly hiding links seems blunt but works surprisingly well. Again grapher is only worried about the visualisation so if a graph tends towards a hairball it makes sense to hide links. The benefits of hiding links are numerous. 1) The alternative is often to remove links (e.g.: with minimum spanning tree) this method actually keeps all links making the resulting layout more sensible: the link between X and Y might be hidden but they are nonetheless close to one another.

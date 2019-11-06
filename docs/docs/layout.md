---
id: layout
title: Layout
sidebar_label: Layout
---

There are multiple ways to layout your graph with grapher, though those can be broken down into two broad categories: static and dynamic. The former pre-computes the positions of the nodes before rendering the visualisation to produce a _static_ graph. The latter does the layout _live_ in the browser.

Computing the layout is computationally expensive and though the live layout looks fancy it quickly becomes unmanageable for the browser as the graph grows in size. You will therefore often pre-compute those in R or node js.

By default the graph will use the live layout: it will layout the graph in the browser, unless the object you used to initialise the graph contained nodes coordinates as `x`, `y`, and `z`. Note that if you have pre-computed the coordinates but do not wish to use them in grapher you can remove them with `remove_coordinates`.

When it comes to pre-computing the layout you have two main choices, 1) use R and compute the coordinates using an [igraph](https://igraph.org/r/doc/layout_.html) layout function. Or, if you have the full installation of grapher which includes V8, you can also use the same algorithm as used in the browser but _offline_.

## Live

You can customise the default live layout with `graph_live_layout`.

```r
# generate mock data
g <- make_data(200)

# grapher defaults to live layout
graph(g)

# customise the live layout parameters
graph(g) %>% 
  graph_live_layout(gravity = -3)
```

Since the above is draining on the browser you can stabilise the network after some time by using `graph_stable_layout` and specifying the number of milliseconds to let the layout algorithm run before stabilising it.

```r
graph(g) %>% 
  graph_live_layout() %>% 
  graph_stable_layout(ms = 4000) # stabilise after 4 seconds
```

## Static

By default grapher will use the `igraph::layout_nicely` function to compute the position of nodes but you can specify any other as `method` argument.

```r
graph(g) %>% 
  graph_static_layout(method = igraph::layout_with_kk) 
```

## Offline

Finally once can also use the same algorithm as used in the browser but offline, precomputing the nodes positons.

```r
graph(g) %>% 
  graph_offline_layout() 
```

If you have used the node js [ngraph.offline.layout](https://github.com/anvaka/ngraph.offline.layout) library to compute the layout, you can read the `positions.bin` file with `graph_bin_layout`.
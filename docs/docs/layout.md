---
id: layout
title: Layout
sidebar_label: Layout
---

There are multiple ways to layout your graph with grapher, though those can be broken down into two broad categories: static and live. The former pre-computes the positions of the nodes before rendering the visualisation to produce a _static_ graph. The latter does the layout _live_ in the browser.

Computing the layout is computationally expensive and though the live layout looks fancy it quickly becomes unmanageable for the browser as graphs become larger. You will therefore often pre-compute those in R or node js.

By default the graph will use the live layout: it will layout the graph in the browser, unless the object you used to initialise the graph contained nodes coordinates as `x`, `y`, and `z` in which case it will use those to position the nodes on the canvas. If you have those coordinates but do not wish to use them to position the nodes you can remove them with `remove_coordinates`.

When it comes to pre-computing the layout you have two main choices, 1) use R and compute the coordinates using an [igraph](https://igraph.org/r/doc/layout_.html) layout function, or, if you have the full installation of grapher which includes V8, you can also use the same algorithm as used in the browser but _offline_. Though there is a suboptimal third option: if you have used the node js [ngraph.offline.layout](https://github.com/anvaka/ngraph.offline.layout) library to compute the layout, you can read the `positions.bin` file with `graph_bin_layout`.

## Live

You can customise the default live layout with `graph_live_layout`.

```r
# generate mock data
g <- make_data(200)

# grapher defaults to live layout
graph(g)

# customise the live layout parameters
graph(g) %>% 
  graph_layout_live(gravity = -3)
```

Since the above is draining on the browser you can stabilise the network after some time by using `graph_stable_layout` and specifying the number of milliseconds before the layout algorithm is stopped. 

```r
graph(g) %>% 
  graph_layout_live() %>% 
  graph_layout_stable(ms = 4000) # stabilise after 4 seconds
```

## Static

By default grapher will use the `igraph::layout_nicely` function to compute the position of nodes but you can specify any other as `method` argument. The function also optionally takes a `weights` argument to specify links weights to take into account.

```r
graph(g) %>% 
  graph_layout_static(method = igraph::layout_with_kk) 
```

## Offline

Finally if you have the [full installation](install.md) you can also use the same algorithm as used in the browser but offline, precomputing the nodes positons with `graph_offline_layout`.

```r
graph(g) %>% 
  graph_layout_offline() 
```

Then again, these do not have to be computed with grapher, you can compute them yourself prior to initialising the graph.

```r
# random coordinates
g$nodes$x <- runif(200, 1, 1000)
g$nodes$y <- runif(200, 1, 1000)
g$nodes$z <- runif(200, 1, 1000)

graph(g)
```
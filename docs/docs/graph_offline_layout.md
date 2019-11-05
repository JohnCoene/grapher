---
id: graph_offline_layout
title: Graph Offline Layout
sidebar_label: Graph Offline Layout
---

## Description

Compute the force layout (same as [`graph_live_layout`](#graphlivelayout) )
 but before rendering in the browser.


## Usage

```r
graph_offline_layout(
  g,
  steps = 500,
  spring_length = 30L,
  sping_coeff = 8e-04,
  gravity = -1.2,
  theta = 0.8,
  drag_coeff = 0.02,
  time_step = 20L,
  is_3d = TRUE,
  verlet_integration = FALSE,
  quiet = !interactive()
)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`steps`     |     Number of steps to run the layout algorithm.
`spring_length`     |     Used to compute Hook's law, default of `30` is generally ideal.
`sping_coeff`     |     Hook's law coefficient, where `1` is a solid spring.
`gravity`     |     Coulomb's law coefficient. It's used to repel nodes thus should be negative if positive nodes attract each other.
`theta`     |     Theta coefficient from Barnes Hut simulation, between `0` and `1` . The closer it's to `1` the more nodes the algorithm will have to go through. Setting it to one makes Barnes Hut simulation no different from brute-force forces calculation (each node is considered).
`drag_coeff`     |     Drag force coefficient. Used to slow down system, thus should be less than `1` . The closer it is to 0 the less tight system will be.
`time_step`     |     Default time step $dt$ for forces integration.
`is_3d`     |     Whether to plot in 3 dimensions or 2 dimensions.
`verlet_integration`     |     If you find that standard the default Euler integration produces too many errors and jitter, consider using verlet integration by settings this to `TRUE` .
`quiet`     |     Set to `FALSE` to print helpful messages and progress bar to track computation steps, defaults to [interactive](#interactive) .


## Details

This method is not necessarily faster than rendering
 in the browser as the graph has to be serialised to JSON once
 more to be processed by the [https://github.com/anvaka/ngraph.forcelayout3d](ngraph.forcelayout3d) 
 algorithm then reimported in grapher.


## Seealso

[`graph_static_layout`](#graphstaticlayout) for other "offline" layout methods.


## Examples

```r
gdata <- make_data(500)

gdata %>%
graph() %>%
graph_offline_layout(steps = 100)
```



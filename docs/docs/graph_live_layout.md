---
id: graph_live_layout
title: Graph Live Layout
sidebar_label: Graph Live Layout
---

## Description

Layout the graph live on the canvas using a physics simulator.


## Usage

```r
graph_live_layout(
  g,
  spring_length = 30L,
  sping_coeff = 8e-04,
  gravity = -1.2,
  theta = 0.8,
  drag_coeff = 0.02,
  time_step = 20L,
  is_3d = TRUE
)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`spring_length`     |     Used to compute Hook's law, default of `30` is generally ideal.
`sping_coeff`     |     Hook's law coefficient, where `1` is a solid spring.
`gravity`     |     Coulomb's law coefficient. It's used to repel nodes thus should be negative if positive nodes attract each other.
`theta`     |     Theta coefficient from Barnes Hut simulation, between `0` and `1` . The closer it's to `1` the more nodes the algorithm will have to go through. Setting it to one makes Barnes Hut simulation no different from brute-force forces calculation (each node is considered).
`drag_coeff`     |     Drag force coefficient. Used to slow down system, thus should be less than `1` . The closer it is to 0 the less tight system will be.
`time_step`     |     Default time step $dt$ for forces integration.
`is_3d`     |     Whether to plot in 3 dimensions or 2 dimensions.


## Details

Calculates forces acting on each body and then deduces
 their position via Newton's law. There are three major forces in the system:
 
   

*  list("Spring force keeps connected nodes together via ", list(list("https://en.wikipedia.org/wiki/Hooke's_law"), list("Hooke's law")), ".")   

*  list("Each body repels each other via ", list(list("https://en.wikipedia.org/wiki/Coulomb's_law"), list("Coulomb's law")), ".")   

*  list("To guarantee we get to \"stable\" state the system has a drag force which slows entire simulation down.")  
 
 Body forces are calculated in $n*lg(n)$ time with help of Barnes-Hut algorithm.
 [Euler](https://en.wikipedia.org/wiki/Euler_method) method is then used to
 solve ordinary differential equation of Newton's law and get position of bodies.


## Examples

```r
data <- make_data(20)

graph(data) %>%
graph_live_layout(time_step = 5L)
```



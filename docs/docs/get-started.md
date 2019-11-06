---
id: get-started
title: Get Started
sidebar_label: Get Started
---

This is at its core an integration of the many works of [Andrei Kashcha](credits.md) that form [ngraph](https://github.com/anvaka/ngraph). This package is intended to make large visualisations where the latter is the core, such as [this one](http://shiny.john-coene.com/cran). Therefore, we show the example code but do not render the visualisation as in this form they can only be underwhelming.

grapher attempts to combine ease of use and customisation. One can initialise a graph from almost type of graph object with a single line of code but nonetheless greatly customise all visual aspects of the graph later on. 

There are many ways to refer to the components of a graph, grapher refers to them as nodes and links.

- nodes: vertices, points, etc.
- links: edges, lines, etc.

To initialise a graph one needs at least nodes or links, the graph cannot be initialised empty. 

Many of the examples in the manual pages and this documentation make use of a convenience function to generate graph data, called `make_data` which returns a list of links and nodes. It takes a parameter `n` to define the size of the graph wanted, by default `100`.

```r
g <- make_data() # mock data

head(g)
#> $nodes
#> # A tibble: 100 x 4
#>    id    label  size color  
#>    <chr> <chr> <dbl> <chr>  
#>  1 1     U47      15 #ffaa0e
#>  2 2     Y77      39 #2ca030
#>  3 3     C3       35 #ba43b4
#>  4 4     K37      17 #78a641
#>  5 5     N14      33 #78a641
#>  6 6     A27      12 #8a60b0
#>  7 7     K37      15 #6f63bb
#>  8 8     R44      45 #6f63bb
#>  9 9     O41      24 #ffaa0e
#> 10 10    L64      39 #78a641
#> # … with 90 more rows
#> 
#> $links
#> # A tibble: 100 x 3
#>    source target hidden
#>    <chr>  <chr>  <lgl> 
#>  1 1      41     FALSE 
#>  2 2      63     FALSE 
#>  3 3      55     FALSE 
#>  4 4      15     FALSE 
#>  5 5      8      FALSE 
#>  6 6      95     FALSE 
#>  7 7      33     FALSE 
#>  8 8      33     FALSE 
#>  9 9      27     FALSE 
#> 10 10     18     FALSE 
#> # … with 90 more rows
```

With data generated and the package loaded you can start using grapher.

## List

From a named list of `nodes` and `links`, it only assumes that the latter are data.frames where the first column of the nodes data.frame contains their unique `id` and that the first two columns of the links indicate the `source` and `target` of the links. Other columns are treated as meta data to subsequently define aspects such as size and color.

```r
graph(g)
```

## igraph

```r
# create an igraph ring
ig <- igraph::make_ring(10)
graph(ig)
```

## Tidygraph

```r
tbl_graph <- tidygraph::create_ring(20)
graph(tbl_graph)
```

## Gexf

If you pass a character string to `character` string as first argument this is assumed to be the path to either a `.gexf` or a `.gv` file. It could in fact also be a `json` file, but that is demonstrated later as it only applies to the [Shiny](https://shiny.rstudio.com/) framework.

These are particularly useful if you are importing graph data from another software such as [Gephi](https://gephi.org/) or [GraphViz](https://www.graphviz.org/).

```r
graph("http://gephi.org/datasets/LesMiserables.gexf")
```

## Dot

```r
fl <- system.file("example/dotfile.gv", package = "grapher")
graph(fl)
```

## Data.frame

From a single data.frame, it assumes those are links.

```r
# assumes data.frame contains are links
graph(g$links)
```

Or pass the data.frame of nodes and links separately.

```r
# pass only links
graph() %>% 
  graph_links(g$links, source, target)

# pass nodes and links
graph() %>% 
  graph_nodes(g$nodes, id) %>% 
  graph_links(g$links, source, target)
```
---
id: get-started
title: Get Started
sidebar_label: Get Started
---

This package is at its core an integration of many of the works of [Andrei Kashcha](credits.md) that form [ngraph](https://github.com/anvaka/ngraph). It is intended to make large visualisations of simple monopartite graphs, such as this visualisation of [CRAN dependencies](http://shiny.john-coene.com/cran), where the user uses the keyboard and mouse to explore the galaxy-looking graph (<kbd>w</kbd>, <kbd>a</kbd>, <kbd>s</kbd>, <kbd>d</kbd>, and the arrow keys). At its core grapher is an htmlwidget like any other (e.g.: plotly, and highcharter) and will work with [R Markdown](https://rmarkdown.rstudio.com/) and [Shiny](https://shiny.rstudio.com/).

In this guide, we show example code but do not render the visualisation since embedded in a document such as this one they can only be underwhelming: you are encouraged to run the examples in your R/RStudio session.

![grapher in RStudio](/img/rstudio.png)

grapher attempts to combine ease of use and customisation. One can initialise a graph from almost type of graph object with a single line of code but nonetheless greatly customise all visual aspects of the graph later on. 

There are many ways to refer to the components of a graph, grapher refers to them as nodes and links.

- nodes: vertices, points, etc.
- links: edges, lines, etc.

To initialise a graph one needs at least nodes or links, the graph cannot be initialised empty. 

Many of the examples in the manual pages and this documentation make use of a convenience function to generate graph data, called `make_data` which returns a list of two data.frames: links and nodes. It takes a parameter `n` to define the size of the graph wanted, which defaults to `100`.

```r
g <- make_data() # mock data

head(g)
#> $nodes
#> # A tibble: 100 x 4
#>    id    label  size color  
#>    <chr> <chr> <dbl> <chr>  
#>  1 1     A79      13 #12a2a8
#>  2 2     S19      23 #ffbf50
#>  3 3     A79      39 #8a60b0
#>  4 4     I61      28 #6f63bb
#>  5 5     D30      17 #2ca030
#>  6 6     D82      13 #ff7f0e
#>  7 7     W75      15 #c7519c
#>  8 8     K63      22 #2ca030
#>  9 9     W75      40 #bcbd22
#> 10 10    I61      15 #c7519c
#> # … with 90 more rows
#> 
#> $links
#> # A tibble: 100 x 4
#>    source target weight hidden
#>    <chr>  <chr>   <dbl> <lgl> 
#>  1 1      85       6.68 FALSE 
#>  2 2      69       6.48 FALSE 
#>  3 3      22       4.03 FALSE 
#>  4 4      93       2.55 FALSE 
#>  5 5      89       6.42 FALSE 
#>  6 6      51       4.51 FALSE 
#>  7 7      54       6.68 FALSE 
#>  8 8      93       3.60 FALSE 
#>  9 9      54       4.98 FALSE 
#> 10 10     42       8.22 FALSE 
#> # … with 90 more rows
```

With data generated and the package loaded we can start visualising graphs.

## List

You can initialise the graph from a named list of `nodes` and `links`, grapher assumes that the latter are data.frames where the first column of the nodes data.frame contains the unique node `id` and that the first two columns of the links indicate the `source` and `target` of the links. Other columns are treated as meta data to subsequently define aspects such as size and color of the nodes and links.

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

If you pass a `character` string as first argument it is assumed to be the path to either a `.gexf` or a `.gv` file. It could in fact also be a `json` file, but that is demonstrated later as it only applies to the [Shiny](https://shiny.rstudio.com/) framework.

These are particularly useful if you are importing graph data from another software such as [Gephi](https://gephi.org/) or [GraphViz](https://www.graphviz.org/).

It must be noted however, that some features of the package will not be available using this method. The files are read in R and passed to the JavaScript front end, they are not interpreted by grapher, therefore things such as [scaling](scale_node_color.md) functions will not work. These visual aspects should be computed beforehand in whatever software you used to generate said files.

```r
graph("http://gephi.org/datasets/LesMiserables.gexf")
```

## Dot

```r
fl <- system.file("example/dotfile.gv", package = "grapher")
graph(fl)
```

## Graphframe

You can also initialise a graph from an object of class `graphframe` as returned by the [graphframes](https://spark.rstudio.com/graphframes/) package.

```r
library(sparklyr)
library(graphframes)

# create graphframe
sc <- spark_connect(master = "local", version = "2.3.0")

spark_links <- copy_to(sc, g$links, "links")
spark_nodes <- copy_to(sc, g$nodes, "nodes")

g <- gf_graphframe(spark_nodes, spark_links)

graph(g)
```

## Data.frame

From a single data.frame, it assumes those are links.

```r
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
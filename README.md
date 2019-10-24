<!-- badges: start -->
<!-- badges: end -->

# grapher

Create 3D and 2D interactive graphs (networks): an R integration of many of the amazing works of [Andrei Kashcha](https://github.com/anvaka).

## Usage

{grapher} works hand-in-hand with most graph formats.

```r
library(grapher)

g <- make_data(50) # mock data

# from a list
graph(g)

# from igraph
ig <- igraph::make_ring(10)
graph(ig)

# from tidygraph
tbl_graph <- tidygraph::create_ring(20)
graph(tbl_graph)

# from gexf
graph("http://gephi.org/datasets/LesMiserables.gexf")

# from dot file
fl <- system.file("example/dotfile.gv", package = "grapher")
graph(fl)

# from data.frames
# pass only links
graph() %>% 
  graph_links(g$links, source, target)

# pass nodes and links
graph() %>% 
  graph_nodes(g$nodes, id) %>% 
  graph_links(g$links, source, target)
```

## Installation

Simply use `remote` or `devtools`

``` r
# install.packages(remotes)
remotes::install_github("JohnCoene/grapher")
```


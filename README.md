<div align="center">

[![](/man/figures/cran.png)](https://shiny.john-coene.com/cran/)

# grapher

Create 3D interactive graphs.

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/JohnCoene/grapher.svg?branch=master)](https://travis-ci.org/JohnCoene/grapher)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/JohnCoene/grapher?branch=master&svg=true)](https://ci.appveyor.com/project/JohnCoene/grapher)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://graph.network)
<!-- badges: end -->

[Website](https://grapher.network) | [Install](https://grapher.network/docs/install) | [Get Started](https://grapher.network/docs/get-started) | [Blog](https://grapher.network/blog/)

</div>

## Usage

{grapher} works hand-in-hand with most graph objects.

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

# from single data.frame
# assumes they are links
graph(g$links)

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

Simply use the `remote` or `devtools`.

``` r
# install.packages(remotes)
remotes::install_github("JohnCoene/grapher")
```


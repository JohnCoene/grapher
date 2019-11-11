---
id: graph
title: Graph
sidebar_label: Graph
---

## Description

Initialise a grapher graph.


## Usage

```r
graph(
  data = NULL,
  directed = TRUE,
  draw = TRUE,
  width = "100%",
  height = NULL,
  elementId = NULL
)
```


## Arguments

Argument      |Description
------------- |----------------
`data`     |     A named `list` containing `nodes` and `links`  where the former's first column are the node ids and the latter's first and second columns are source and target, every other column is added as respective meta-data. Can also be an object of class `igraph` from the [igraph](#igraph) package or an object of class `tbl_graph` from the [tidygraph](#tidygraph) package. If a character string is passed the string is assumed to be the path to either a `.gexf` file or a `.gv`  [dot file](https://en.wikipedia.org/wiki/DOT_(graph_description_language)) . The thrid file type acceted is JSON, it must be the output of [`save_graph_json`](#savegraphjson) . If a `data.frame` is passed it is assumed to be links where the first column indicates the source, and the second the target of the links. This argument can also be of class `graphframe` from the [https://spark.rstudio.com/graphframes/](graphframes) package. If `NULL` data must be later supplied with [`graph_nodes`](#graphnodes)  and [`graph_links`](#graphlinks) .
`directed`     |     Whether the graph is directed, if passing an object of class `igraph` to `data` then this is inferred from the object.
`draw`     |     If `FALSE` the graph is not rendered.
`width, height`     |     Must be a valid CSS unit (like `'100%'` , `'400px'` , `'auto'` ) or a number, which will be coerced to a string and have `'px'` appended.
`elementId`     |     Id of element.


## Details

if the variables `x` , `y` , and `z` 
 are included in the `nodes` the rendered visualisation
 is stable 2/3 dimensional and the force layout algorithm is not run.


## See Also

[`graph_nodes`](#graphnodes) and [`graph_links`](#graphlinks) to add nodes and links.


## Examples

```r
g <- make_data() # mock data

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
# assumes edges
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



---
id: graph_nodes
title: Graph Nodes
sidebar_label: Graph Nodes
---

## Description

Add nodes to the graph.


## Usage

```r
graph_nodes(g, data, id, ...)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`data`     |     A data.frame containing nodes data.
`id`     |     The bare column names containing the nodes ids.
`...`     |     Any other bare named column containing meta data to attach to the nodes.


## Details

if the variables `x` , `y` , and `z` 
 are passed the rendered visualisation is stable 2/3D and
 the force layout algorithm is not run.


## See Also

[`graph_links`](#graphlinks) to add links.


## Examples

```r
graph_data <- make_data()

graph() %>%
graph_nodes(graph_data$nodes, id)

# using a shiny proxy
library(shiny)

data1 <- make_data(150)
data2 <- make_data(50)

# nodes that do not overalp
# 120 = 30 new nodes added
noverlap <- 120

data2$nodes$id <- as.integer(data2$nodes$id) + noverlap
data2$links$source <- as.integer(data2$links$source) + noverlap
data2$links$target <- as.integer(data2$links$target) + noverlap

ui <- fluidPage(
actionButton("add", "add"),
graphOutput("g", height = "90vh")
)

server <- function(input, output) {
output$g <- render_graph({
graph(data1)
})

observeEvent(input$add, {
graph_proxy("g") %>%
graph_nodes(data2$nodes, id) %>%
graph_links(data2$links, source, target)
})
}

shinyApp(ui, server)
```



---
id: graph_links
title: Graph Links
sidebar_label: Graph Links
---

## Description

Add links to a graph.


## Usage

```r
graph_links(g, data, source, target, ...)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`data`     |     A data.frame containing links data.
`source, target`     |     The bare column names containing the links source and target.
`...`     |     Any other bare named column containing meta data to attach to the links.


## Seealso

[`graph_nodes`](#graphnodes) to add nodes.


## Examples

```r
graph_data <- make_data()

graph() %>%
graph_nodes(graph_data$nodes, id) %>%
graph_links(graph_data$links, source, target)

# using the shiny proxy
library(shiny)

data1 <- make_data(150)
data2 <- make_data(50)

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
graph_links(data2$links, source, target)
})
}

shinyApp(ui, server)
```



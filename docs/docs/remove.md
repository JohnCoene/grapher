---
id: remove
title: Remove
sidebar_label: Remove
---

## Description

Remove nodes and edges from the graph.


## Usage

```r
graph_drop_nodes(g, data, id)
graph_drop_node(g, id)
graph_drop_links(g, data, source, target)
graph_drop_link(g, source, target)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`data`     |     A data.frame holding nodes id or links source and target.
`id`     |     Id or bare column name holding node ids to remove.
`source, target`     |     Bare column names or vectors of length one holding source and target defining links to remove.


## Examples

```r
library(shiny)

N <- 250

data <- make_data(N)

ui <- fluidPage(
actionButton("rm", "remove random nodes"),
graphOutput("g", height = "90vh")
)

server <- function(input, output) {
output$g <- render_graph({
graph(data)
})

observeEvent(input$rm, {
graph_proxy("g") %>%
graph_drop_nodes(
dplyr::slice(data$nodes, sample(1:N, 2)),
id
)
})
}

shinyApp(ui, server)
```



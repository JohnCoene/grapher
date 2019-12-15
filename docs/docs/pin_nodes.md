---
id: pin_nodes
title: Pin Nodes
sidebar_label: Pin Nodes
---

## Description

Pin nodes in place.


## Usage

```r
pin_nodes(g, data, id)
pin_node(g, id)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`data`     |     A data.frame holding nodes to pin.
`id`     |     Either the bare name of the column containing node ids to pin or an integer (vector of length one) of node id to pin.


## Examples

```r
library(shiny)

N <- 500
graph_data <- make_data(N)

ui <- fluidPage(
actionButton("pin", "pin node"),
numericInput("node", "node to pin", 1, min = 1, max = N, step = 1),
actionButton("pinall", "pin ALL node"),
graphOutput("graph")
)

server <- function(input, output) {

output$graph <- renderGraph({
graph_data %>%
graph() %>%
graph_layout_live(time_step = 5)
})

observeEvent(input$pin, {
graph_proxy("graph") %>%
pin_node(input$node)
})

observeEvent(input$pinall, {
graph_proxy("graph") %>%
pin_nodes(graph_data$nodes, id)
})

}

shinyApp(ui, server)
```



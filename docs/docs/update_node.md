---
id: update_node
title: Update Node
sidebar_label: Update Node
---

## Description

Update a node's color or size, works with /code list("graph_proxy") .


## Usage

```r
update_node_size(g, id, val, var = "size")
update_node_color(g, id, val, var = "color")
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`id`     |     Id of node to update.
`val`     |     New value to assign to `var` .
`var`     |     Variable name to update.


## See Also

[`update_nodes`](#updatenodes) to update multiple nodes at once.


## Examples

```r
library(shiny)

N <- 200
g <- make_data(N)

ui <- fluidPage(
numericInput("node", "Node ID", 5, min = 1, max = N, step = 1L),
selectInput("color", "New Color", c("red", "green", "blue")),
graphOutput("g", height = "80vh")
)

server <- function(input, output) {
output$g <- render_graph({
graph(g)
})

observeEvent(c(input$color, input$node), {
graph_proxy("g") %>%
update_node_color(input$node, input$color, "color")
})
}

if(interactive()) shinyApp(ui, server)
```



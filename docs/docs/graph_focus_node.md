---
id: graph_focus_node
title: Graph Focus Node
sidebar_label: Graph Focus Node
---

## Description

Focus on a specific node.


## Usage

```r
graph_focus_node(g, id, dist = 0.1)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`id`     |     The id of the node to focus on.
`dist`     |     The distance from the node the camera should move to.


## Examples

```r
library(shiny)

gdata <- make_data(100)

ui <- fluidPage(
sliderInput("node", "node to focus on", 1, max = 100, value = 5),
graphOutput("g", height = "80vh")
)

server <- function(input, output) {
output$g <- render_graph({
graph(gdata) %>%
graph_stable_layout(ms = 1500)
})

observeEvent(input$node, {
graph_proxy("g") %>%
graph_focus_node(input$node)
})
}

shinyApp(ui, server)
```



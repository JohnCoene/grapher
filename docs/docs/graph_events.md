---
id: graph_events
title: Graph Events
sidebar_label: Graph Events
---

## Description

Enables capturing events in Shiny.


## Usage

```r
capture_node_click(g)
capture_node_double_click(g)
capture_node_hover(g)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.


## Examples

```r
library(shiny)

graph_data <- make_data(1000)

ui <- fluidPage(
graphOutput("g", height = "100vh")
)

server <- function(input, output) {
output$g <- render_graph({
graph(graph_data) %>%
capture_node_click()
})

observeEvent(input$g_node_click, {
print(input$g_node_click)
})
}

shinyApp(ui, server)
```



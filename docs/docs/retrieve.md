---
id: retrieve
title: Retrieve
sidebar_label: Retrieve
---

## Description

Retrieve a node's data.


## Usage

```r
retrieve_node(g, id)
retrieve_link(g, source, target)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`id`     |     Id of the node to retrieve.
`source, target`     |     Source and target id of link.


## Examples

```r
library(shiny)

gdata <- make_data(100)

ui <- fluidPage(
sliderInput("node", "retrieve", 1, max = 100, value = 5),
graphOutput("g", height = "50vh"),
verbatimTextOutput("selected")
)

server <- function(input, output) {
output$g <- render_graph({
graph(gdata) %>%
graph_stable_layout(ms = 1500)
})

observeEvent(input$node, {
graph_proxy("g") %>%
retrieve_node(input$node)
})

output$selected <- renderPrint({
print(input$g_retrieve_node)
})
}

if(interactive()) shinyApp(ui, server)
```



---
id: change_dimensions
title: Change Dimensions
sidebar_label: Change Dimensions
---

## Description

Change the dimensions of the graph.


## Usage

```r
change_dimensions(g, is_3d = FALSE)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`is_3d`     |     Whether to plot in 3 dimensions or 2 dimensions.


## Examples

```r
library(shiny)

N <- 500
graph_data <- make_data(N)

ui <- fluidPage(
radioButtons("dims", "Dimensions", choices = list("3D" = TRUE, "2D" = FALSE)),
graphOutput("graph")
)

server <- function(input, output) {

output$graph <- renderGraph({
graph_data %>%
graph() %>%
graph_layout_live(time_step = 5)
})

observeEvent(input$dims, {
graph_proxy("graph") %>%
change_dimensions(input$dims)
})

}

shinyApp(ui, server)
```



---
id: graph_camera_position
title: Graph Camera Position
sidebar_label: Graph Camera Position
---

## Description

Position the camera, this only works on a stable graph :
 see [`graph_stable_layout`](#graphstablelayout) and examples.


## Usage

```r
graph_camera_position(g, x = NULL, y = NULL, z = NULL)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`x, y, z`     |     Coordinates of camera position.


## Examples

```r
library(shiny)

gdata <- make_data(100)

ui <- fluidPage(
actionButton("mv", "Move camera"),
graphOutput("g", height = "80vh")
)

server <- function(input, output) {
output$g <- render_graph({
graph(gdata) %>%
graph_stable_layout(ms = 5000)
})

observeEvent(input$mv, {
graph_proxy("g") %>%
graph_camera_position(
sample(1:500, 1),
sample(1:500, 1),
sample(1:500, 1)
)
})
}

shinyApp(ui, server)
```



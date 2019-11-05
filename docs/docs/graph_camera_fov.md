---
id: graph_camera_fov
title: graph camera fov
sidebar_label: graph camera fov
---

# `graph_camera_fov`

Camera FOV


## Description

Adjust the camera field of view.


## Usage

```r
graph_camera_fov(g, fov = 75L)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`fov`     |     The field of view of the camera.


## Examples

```r
library(shiny)

graph_data <- make_data(500)

colors <- list(
"#000000", "#121420",
"#1B2432", "#2C2B3C"
)

ui <- fluidPage(
sliderInput("fov", "Field of view", 45, 120, 75, step = 5),
graphOutput("graph")
)

server <- function(input, output) {

output$graph <- renderGraph({
graph_data %>%
graph() %>%
graph_live_layout(time_step = 5)
})
r
observeEvent(input$fov, {
graph_proxy("graph") %>%
graph_camera_fov(input$fov)
})

}

shinyApp(ui, server)
```



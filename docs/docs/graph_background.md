---
id: graph_background
title: graph background
sidebar_label: graph background
---

# `graph_background`

Background


## Description

Customise the background color and trasnparency of the visualisation.


## Usage

```r
graph_background(g, color = "#000000", alpha = 1)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`color`     |     Background color of the visualisation.
`alpha`     |     Transparency of background, a numeric between `0` and `1` .


## Examples

```r
make_data() %>%
graph() %>%
graph_background("#d3d3d3", .2)

# as proxy
library(shiny)

graph_data <- make_data(500)

colors <- list(
"#000000", "#121420",
"#1B2432", "#2C2B3C"
)

ui <- fluidPage(
selectInput("bg", "background color", choices = colors),
graphOutput("graph")
)

server <- function(input, output) {

output$graph <- renderGraph({
graph_data %>%
graph() %>%
graph_live_layout(time_step = 5)
})

observeEvent(input$bg, {
graph_proxy("graph") %>%
graph_background(input$bg)
})

}

shinyApp(ui, server)
```



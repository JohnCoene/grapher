---
id: update_link
title: Update Link
sidebar_label: Update Link
---

## Description

Update a link source, and target color.


## Usage

```r
update_link_source_color(g, source, target, val)
update_link_target_color(g, source, target, val)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`source, target`     |     Source and Target ids of link to update.
`val`     |     The updated value to assign.


## Examples

```r
library(shiny)

N <- 200
g <- make_data(N)

ui <- fluidPage(
numericInput("link", "link", 5, min = 1, max = N, step = 1L),
graphOutput("g", height = "80vh")
)

server <- function(input, output) {
output$g <- render_graph({
graph(g)
})

observeEvent(input$link, {
sel <- dplyr::slice(g$links, input$link)
graph_proxy("g") %>%
update_link_source_color(sel$source, sel$target, "blue") %>%
update_link_target_color(sel$source, sel$target, "red")
})
}

if(interactive()) shinyApp(ui, server)
```



---
id: update_nodes
title: Update Nodes
sidebar_label: Update Nodes
---

## Description

Update multiple nodes size and color.


## Usage

```r
update_nodes_color(g, data, id, val, var = "color")
update_nodes_size(g, data, id, val, var = "size")
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`data`     |     A data.frame containing `id` , `val` , and `var`  of nodes to update.
`id`     |     Bare column name containing node ids to udapte.
`val`     |     Bare column name containing new values to set.
`var`     |     The name of the variable to update.


## Examples

```r
library(shiny)

g <- make_data(200)

colors <- c("red", "green", "blue", "yellow")

ui <- fluidPage(
actionButton("update", "Update random nodes"),
graphOutput("g", height = "80vh")
)

server <- function(input, output) {
output$g <- render_graph({
graph(g) %>%
define_node_size(size) %>%
graph_stable_layout(ms = 2500)
})

observeEvent(input$update, {
nodes_sample <- g$nodes %>%
dplyr::sample_n(100) %>%
dplyr::mutate(
color = sample(colors, 100, replace = TRUE),
size = runif(100, 20, 100)
)

graph_proxy("g") %>%
update_nodes_color(nodes_sample, id, color) %>%
update_nodes_size(nodes_sample, id, size)
})
}

if(interactive()) shinyApp(ui, server)
```



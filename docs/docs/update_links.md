---
id: update_links
title: Update Links
sidebar_label: Update Links
---

## Description

Update multiple links source and target color.


## Usage

```r
update_links_source_color(g, data, source, target, val)
update_links_target_color(g, data, source, target, val)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`data`     |     A data.frame containing nodes data.
`source, target`     |     Source and target ids of link to update.
`val`     |     The updated value to assign.


## Examples

```r
library(shiny)

g <- make_data(200)

colors <- c("red", "green", "blue", "yellow")

ui <- fluidPage(
actionButton("update", "Update random links"),
graphOutput("g", height = "80vh")
)

server <- function(input, output) {
output$g <- render_graph({
graph(g) %>%
graph_stable_layout(ms = 2500)
})

observeEvent(input$update, {
links_sample <- g$links %>%
dplyr::sample_n(100) %>%
dplyr::mutate(
source_color = sample(colors, 100, replace = TRUE),
target_color = sample(colors, 100, replace = TRUE)
)

graph_proxy("g") %>%
update_links_source_color(links_sample, source, target, source_color) %>%
update_links_target_color(links_sample, source, target, target_color)
})
}

if(interactive()) shinyApp(ui, server)
```



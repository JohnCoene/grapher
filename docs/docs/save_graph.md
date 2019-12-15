---
id: save_graph
title: Save Graph
sidebar_label: Save Graph
---

## Description

Save the graph as HTML or JSON file.


## Usage

```r
save_graph_html(g, file, title = "grapher", background = "#000000", ...)
save_graph_json(g, file)
```


## Arguments

Argument      |Description
------------- |----------------
`g`     |     An object of class `graph` as returned by [`graph`](#graph) or a `graph_proxy`  as returned by a function of the same name.
`file`     |     Name of file to save graph, passed to [saveWidget](#savewidget) if `save_graph_html` is used or passed to [write](#write) if /code save_graph_json is used.
`title`     |     The title of the page, corresponds to `<title>` HTML tag.
`background`     |     HTML background color, ensure this is a valid hex color as this is passed to [saveWidget](#savewidget) which is very strict.
`...`     |     Other arguments passed to [saveWidget](#savewidget) .


## Details

Serialising the data to JSON can take some time depending on the size
 of the graph you want to visualise. The `save_graph_json` will serialise
 the graph to JSON, enabling you to later load it with the [`graph`](#graph) 
 function, this will only work with Shiny .


## Examples

```r
# save as HTML
make_data(10)
graph(data) %>%
save_graph("grapher.html")

# use case of JSON
# create directory to hold json file
dir <- "./tmp"
dir.create(dir)
file <- paste0(dir, "/graph.json")

# create and save large graph as JSON
graph_data <- make_data(1000)
graph(graph_data) %>%
graph_static_layout() %>%
save_graph_json(file)

# function to delete temp
on_start <- function(){
onStop(function(){
unlink(dir, recursive = TRUE, force = TRUE)
})
}

library(shiny)

# make the directory accessible from shiny
shiny::addResourcePath("graph", dir)

ui <- fluidPage(
graphOutput("g", height = "100vh")
)

server <- function(input, output){
output$g <- renderGraph({
graph(paste0("./graph/graph.json"))
})
}

shinyApp(ui, server, onStart = on_start)
```



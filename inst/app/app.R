library(shiny)
library(dplyr)
library(grapher)

gdata <- make_data(2000)
gdata$nodes$color <- "#FFFFFF"

ui <- fluidPage(
  fluidRow(
    column(
      3,
      h1("grapher"),
      h3("Shiny usage demo, there's a lot more to it."),
      p("Color represents the cluster."),
      fluidRow(
        column(6, br(), actionButton("addNode", "Add nodes")),
        column(6, numericInput("node2add", "# nodes to add", value = 15, min = 1, max = 30))
      ),
      fluidRow(
        column(6, br(), actionButton("dropNode", "Drop a node")),
        column(6, numericInput("node2drop", "Node to drop", value = 50, min = 1, max = 2000))
      ),
      fluidRow(
        column(4, br(), actionButton("addLink", "Add a link")),
        column(4, numericInput("addLinkSource", "Source", value = 20, min = 1, max = 2000)),
        column(4, numericInput("addLinkTarget", "target", value = 550, min = 1, max = 2000))
      ),
      fluidRow(
        column(4, actionButton("stabilize", "Freeze"))
      )
    ),
    column(9, graphOutput("g", height = "100vh"))
  )  
)

server <- function(input, output){

  # graph
  output$g <- render_graph({
    graph(gdata) %>% 
      graph_cluster() %>%  
      scale_link_color(cluster)
  })

  # proxy
  p <- graph_proxy("g")

  observeEvent(input$dropNode, {
    graph_drop_node(p, input$node2drop) 
  })

  observeEvent(input$addNode, {
    add <- tibble::tibble(
      id = runif(input$node2add, 2000, 5000),
      size = 40
    )
    graph_nodes(p, add, id, size = size)
  })

  observeEvent(input$addLink, {
    add <- tibble::tibble(
      source = input$addLinkSource,
      target = input$addLinkTarget
    )
    graph_links(p, add, source, target)
  })

  observeEvent(input$stabilize, {
    graph_stable_layout(p)
  })

}

shinyApp(ui, server)

#' Retrieve
#' 
#' Retrieve a node's data.
#' 
#' @inheritParams graph_nodes
#' @param id Id of the node to retrieve.
#' 
#' @examples 
#' library(shiny)
#' 
#' gdata <- make_data(100)
#' 
#' ui <- fluidPage(
#'  sliderInput("node", "retrieve", 1, max = 100, value = 5),
#'  graphOutput("g", height = "50vh"),
#'  verbatimTextOutput("selected")
#' )
#' 
#' server <- function(input, output) {
#'  output$g <- render_graph({
#'    graph(gdata) %>% 
#'    graph_stable_layout(ms = 1500)
#'  })
#' 
#'  observeEvent(input$node, {
#'    graph_proxy("g") %>% 
#'      retrieve_node(input$node)
#'  })
#' 
#'  output$selected <- renderPrint({
#'    print(input$g_retrieve_node)
#'  })
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @export 
retrieve_node <- function(g, id) UseMethod("retrieve_node")

#' @export 
#' @method retrieve_node graph_proxy
retrieve_node.graph_proxy <- function(g, id) {
  id <- as.character(id)
  g$session$sendCustomMessage("retrieve-node", list(id = g$id, node_id = id))
  return(g)
}
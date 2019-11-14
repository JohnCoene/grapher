#' Retrieve
#' 
#' Retrieve a node's data.
#' 
#' @inheritParams graph_nodes
#' @param id Id of the node to retrieve.
#' @param source,target Source and target id of link.
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
#' @name retrieve
#' @export 
retrieve_node <- function(g, id) UseMethod("retrieve_node")

#' @export 
#' @method retrieve_node graph_proxy
retrieve_node.graph_proxy <- function(g, id) {
  assert_that(has_it(id))
  id <- as.character(id)
  g$session$sendCustomMessage("retrieve-node", list(id = g$id, node_id = id))
  return(g)
}

#' @rdname retrieve
#' @export 
retrieve_link <- function(g, source, target) UseMethod("retrieve_link")

#' @export 
#' @method retrieve_link graph_proxy
retrieve_link.graph_proxy <- function(g, source, target){
  assert_that(has_it(source))
  assert_that(has_it(target))

  source <- as.character(source)
  target <- as.character(target)
  g$session$sendCustomMessage("retrieve-link", list(id = g$id, source = source, target = target))
  return(g)
}
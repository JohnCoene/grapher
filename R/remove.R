#' Remove Nodes & Edges
#' 
#' Remove nodes and edges from the graph.
#' 
#' @inheritParams graph_nodes
#' @param data A data.frame holding nodes id or links source and target.
#' @param id Bare column name holding node ids to remove.
#' @param source,target Bare column names holding source and target defining
#' links to remove.  
#' 
#' @examples 
#' library(shiny)
#' 
#' N <- 250
#' 
#' data <- make_data(N)
#' 
#' ui <- fluidPage(
#'   actionButton("rm", "remove random nodes"),
#'   graphOutput("g", height = "90vh")
#' )
#' 
#' server <- function(input, output) {
#'   output$g <- render_graph({
#'     graph(data) 
#'   })
#' 
#' observeEvent(input$rm, {
#'   graph_proxy("g") %>% 
#'     graph_nodes_remove(
#'       dplyr::slice(data$nodes, sample(1:N, 2)), 
#'       id
#'     ) 
#'   })
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @name remove
#' @export 
graph_nodes_remove <- function(g, data, id) UseMethod("graph_nodes_remove")

#' @export
#' @method graph_nodes_remove graph_proxy
graph_nodes_remove.graph_proxy <- function(g, data, id){
  assert_that(has_it(data))

  id_enquo <- enquo(id)
  ids <- pull(data, !!id_enquo)

  msg <- list(id = g$id, data = as.list(ids))
  g$session$sendCustomMessage("remove-nodes", msg)
  invisible(g)
}

#' @rdname remove
#' @export 
graph_links_remove <- function(g, data, source, target) UseMethod("graph_links_remove")

#' @export
#' @method graph_links_remove graph_proxy
graph_links_remove.graph_proxy <- function(g, data, source, target){
  assert_that(has_it(data))

  src_enquo <- enquo(source)
  tgt_enquo <- enquo(target)
  links <- select(data, source = !!src_enquo, target = !!tgt_enquo) %>% purrr::transpose()

  msg <- list(id = g$id, links = as.list(links))
  g$session$sendCustomMessage("remove-links", msg)
  invisible(g)
}
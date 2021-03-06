#' Remove Nodes & Edges
#' 
#' Remove nodes and edges from the graph.
#' 
#' @inheritParams graph_nodes
#' @param data A data.frame holding nodes id or links source and target.
#' @param id Id or bare column name holding node ids to remove.
#' @param source,target Bare column names or vectors of length one 
#' holding source and target defining links to remove.  
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
#'     graph_drop_nodes(
#'       dplyr::slice(data$nodes, sample(1:N, 2)), 
#'       id
#'     ) 
#'   })
#' }
#' 
#' \dontrun{shinyApp(ui, server)}
#' 
#' @name remove
#' @export 
graph_drop_nodes <- function(g, data, id) UseMethod("graph_drop_nodes")

#' @export
#' @method graph_drop_nodes graph_proxy
graph_drop_nodes.graph_proxy <- function(g, data, id){
  assert_that(has_it(data))

  id_enquo <- enquo(id)
  ids <- pull(data, !!id_enquo)

  msg <- list(id = g$id, data = as.list(ids))
  g$session$sendCustomMessage("remove-nodes", msg)
  invisible(g)
}

#' @rdname remove
#' @export 
graph_drop_node <- function(g, id) UseMethod("graph_drop_node")

#' @export
#' @method graph_drop_node graph_proxy
graph_drop_node.graph_proxy <- function(g, id){
  assert_that(has_it(id))

  msg <- list(id = g$id, data = as.list(id))
  g$session$sendCustomMessage("remove-nodes", msg)
  invisible(g)
}

#' @rdname remove
#' @export 
graph_drop_links <- function(g, data, source, target) UseMethod("graph_drop_links")

#' @export
#' @method graph_drop_links graph_proxy
graph_drop_links.graph_proxy <- function(g, data, source, target){
  assert_that(has_it(data))

  src_enquo <- enquo(source)
  tgt_enquo <- enquo(target)
  links <- select(data, source = !!src_enquo, target = !!tgt_enquo) %>% purrr::transpose()

  msg <- list(id = g$id, links = as.list(links))
  g$session$sendCustomMessage("remove-links", msg)
  invisible(g)
}

#' @rdname remove
#' @export 
graph_drop_link <- function(g, source, target) UseMethod("graph_drop_link")

#' @export
#' @method graph_drop_link graph_proxy
graph_drop_link.graph_proxy <- function(g, source, target){
  assert_that(has_it(source))
  assert_that(has_it(target))

  links <- list(
    source = source,
    target = target
  )

  msg <- list(id = g$id, links = links)
  g$session$sendCustomMessage("remove-links", msg)
  invisible(g)
}
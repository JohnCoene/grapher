#' Draw or Redraw a Graph
#' 
#' Draw or re-draw a graph.
#' 
#' @inheritParams graph_nodes
#' 
#' @details If used on a \code{\link{graph_proxy}} then
#' the graph is re-draw, if used on a static visualisation
#' (\code{\link{graph}}) then the graph is simply drawn. The
#' latter is only useful if \code{draw} was set to \code{FALSE}
#' in the initialisation function (\code{\link{graph}}).
#' 
#' @examples
#' make_data() %>% 
#'   graph(draw = FALSE) %>% 
#'   graph_draw()
#' 
#' @export 
graph_draw <- function(g) UseMethod("graph_draw")

#' @export 
#' @method graph_draw graph
graph_draw.graph <- function(g) {
  g$x$draw <- TRUE
}

#' @export 
#' @method graph_draw graph
graph_draw.graph_proxy <- function(g) {
  msg <- list(id = g$id)
  g$session$sendCustomMessage("draw", msg)
}

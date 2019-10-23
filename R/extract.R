#' Extract Graph
#' 
#' Extract the graph as list, useful if one wants to 
#' further process it or generate the offline layout
#' using nodejs as it can be imported with 
#' \href{ngraph.fromjson}{https://github.com/anvaka/ngraph.fromjson}.
#' 
#' @inheritParams graph_nodes
#' @param json = FALSE
#' 
#' @examples 
#' data <- make_data(10)
#' 
#' g <- graph(data) 
#' 
#' lst <- extract_graph(g)
#' 
#' # json read to import oin ngraph
#' json <- extract_graph(g, json = TRUE)
#' 
#' @return A \code{list} of nodes and edges.
#' 
#' @export 
extract_graph <- function(g, json = FALSE) UseMethod("extract_graph")

#' @export 
#' @method extract_graph graph
extract_graph.graph <- function(g, json = FALSE){
  graph <- .render_graph(g)

  if(json)
    graph <- jsonlite::toJSON(graph, auto_unbox = TRUE)

  invisible(graph)
}
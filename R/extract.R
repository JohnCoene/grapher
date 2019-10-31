#' Extract Graph
#' 
#' Extract the graph as list, useful if one wants to 
#' further process it or generate the offline layout
#' using nodejs as it can be imported with 
#' \href{ngraph.fromjson}{https://github.com/anvaka/ngraph.fromjson}.
#' 
#' @inheritParams graph_nodes
#' @param json Whether to return JSON, if \code{FALSE} returns a list.
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
    graph <- jsonify::to_json(graph, unbox = TRUE)

  invisible(graph)
}

#' Save
#' 
#' Save the graph as HTML file.
#' 
#' @inheritParams graph_nodes
#' @param file Name of file to save graph, passed to 
#' \link[htmlwidgets]{saveWidget}.
#' @param title The title of the page, corresponds to \code{<title>} HTML tag.
#' @param background HTML background color, ensure this is a valid hex
#' color as this is passed to \link[htmlwidgets]{saveWidget} which is very strict.
#' @param ... Other arguments passed to
#' \link[htmlwidgets]{saveWidget}.
#' 
#' @examples 
#' \dontrun{
#' make_data(10)
#'  graph(data) %>% 
#'  save_graph("grapher.html")
#' }
#' 
#' @export 
save_graph <- function(g, file, title = "grapher", background = "#000000", ...){
  assert_that(has_it(file))

  htmlwidgets::saveWidget(g, file = file, title = title, background = background, ...)
}
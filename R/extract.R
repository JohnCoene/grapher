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
#' Save the graph as HTML or JSON file.
#' 
#' @inheritParams graph_nodes
#' @param file Name of file to save graph, passed to 
#' \link[htmlwidgets]{saveWidget} if \code{save_graph_html} is used 
#' or passed to \link[base]{write} if /code{save_graph_json} is used.
#' @param title The title of the page, corresponds to \code{<title>} HTML tag.
#' @param background HTML background color, ensure this is a valid hex
#' color as this is passed to \link[htmlwidgets]{saveWidget} which is very strict.
#' @param ... Other arguments passed to
#' \link[htmlwidgets]{saveWidget}.
#' 
#' @section Formats:
#' \itemize{
#'   \item{\code{save_graph_html} - Save visualisation as standalone HTML file.}
#'   \item{\code{save_graph_json} - Save the graph as JSON to later re-use with the \code{\link{graph}} function.}
#' }
#' 
#' @details Serialising the data to JSON can take some time depending on the size
#' of the graph you want to visualise. The \code{save_graph_json} will serialise
#' the graph to JSON, enabling you to later load it with the \code{\link{graph}}
#' function, \emph{this will only work with Shiny}.
#' 
#' @examples 
#' # save as HTML
#' \dontrun{
#' make_data(10)
#'  graph(data) %>% 
#'  save_graph("grapher.html")
#' }
#' 
#' # use case of JSON
#' \dontrun{
#' # create directory to hold json file
#' dir <- "./tmp"
#' dir.create(dir)
#' file <- paste0(dir, "/graph.json")
#' 
#' # create and save large graph as JSON
#' graph_data <- make_data(1000)
#' graph(graph_data) %>% 
#'  graph_static_layout() %>% 
#'  save_graph_json(file)
#' 
#' # function to delete temp
#' on_start <- function(){
#'  onStop(function(){
#'    unlink(dir, recursive = TRUE, force = TRUE)
#'  })
#' }
#' 
#' library(shiny)
#' 
#' # make the directory accessible from shiny
#' shiny::addResourcePath("graph", dir)
#' 
#' ui <- fluidPage(
#'  graphOutput("g", height = "100vh")
#' )
#' 
#' server <- function(input, output){
#'  output$g <- renderGraph({
#'    graph(paste0("./graph/graph.json"))
#'  })
#' }
#' 
#' shinyApp(ui, server, onStart = on_start)
#' }
#' 
#' @name save_graph
#' @export 
save_graph_html <- function(g, file, title = "grapher", background = "#000000", ...) UseMethod("save_graph_html")

#' @export
#' @method save_graph_html graph
save_graph_html.graph <- function(g, file, title = "grapher", background = "#000000", ...){
  assert_that(has_it(file))
  htmlwidgets::saveWidget(g, file = file, title = title, background = background, ...)
}

#' @name save_graph
#' @export 
save_graph_json <- function(g, file) UseMethod("save_graph_json")

#' @export
#' @method save_graph_json graph
save_graph_json.graph <- function(g, file){
  assert_that(has_it(file))
  g <- graph_renderer(g)
  g <- jsonify::to_json(g$x, unbox = TRUE)
  write(g, file = file)
}
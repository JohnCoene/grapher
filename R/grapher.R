#' Initialise
#'
#' Initialise a grapher graph.
#' 
#' @param data A named \code{list} containing \code{nodes} and \code{links} 
#' where the former's first column are the node ids and the latter's first
#' and second columns are source and target, every other column is added as
#' respective meta-data. Can also be an object of class \code{igraph} from the
#' \link[igraph]{igraph} package.
#' If \code{NULL} data must be later supplied with \code{\link{graph_nodes}}
#' and \code{\link{graph_links}}.
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param elementId Id of element.
#' @param draw If \code{FALSE} the graph is not rendered. 
#' 
#' @examples 
#' g <- make_data(50) # mock data
#' 
#' # from a list
#' graph(g)
#' 
#' # from igraph
#' ig <- igraph::make_ring(10)
#' graph(ig)
#' 
#' # from tidygraph
#' tbl_graph <- tidygraph::create_ring(20)
#' graph(tbl_graph)
#' 
#' # from data.frames
#' # pass only links
#' graph() %>% 
#'   graph_links(g$links, source, target)
#' 
#' # pass nodes and links
#' graph() %>% 
#'   graph_nodes(g$nodes, id) %>% 
#'   graph_links(g$links, source, target)
#' 
#' @importFrom stats runif
#' @import htmlwidgets
#' @import assertthat
#' @import dplyr
#' @import purrr
#'
#' @export
graph <- function(data = NULL, draw = TRUE, width = "100%", height = "100vh", elementId = NULL) UseMethod("graph")

#' @export
graph.default <- function(data = NULL, draw = TRUE, width = "100%", height = "100vh", elementId = NULL) {

  # forward options using x
  x = list(
    draw = draw,
    layout = list()
  )

  as_widget(x, width, height, elementId)
}

#' @export
#' @method graph igraph
graph.igraph <- function(data = NULL, draw = TRUE, width = "100%", height = "100vh", elementId = NULL) {

  g_df <- igraph::as_data_frame(data, "both")
  nodes <- g_df$vertices
  links <- g_df$edges

  nodes <- .prepare_graph(nodes, 1, "id")
  links <- .prepare_graph(links, 1:2, c("source", "target"))

  # forward options using x
  x = list(
    links = links,
    nodes = nodes,
    draw = draw,
    layout = list()
  )

  as_widget(x, width, height, elementId)
}

#' @export
#' @method graph list
graph.list <- function(data = NULL, draw = TRUE, width = "100%", height = "100vh", elementId = NULL) {

  links <- data$links
  nodes <- data$nodes

  nodes <- .prepare_graph(nodes, 1, "id")
  links <- .prepare_graph(links, 1:2, c("source", "target"))

  x = list(
    links = links,
    nodes = nodes,
    draw = draw,
    layout = list()
  )

  as_widget(x, width, height, elementId)
}

#' @export
#' @method graph tbl_graph
graph.tbl_graph <- function(data = NULL, draw = TRUE, width = "100%", height = "100vh", elementId = NULL) {

  links <- data %>% 
    tidygraph::activate(edges) %>% 
    tibble::as_tibble()
  nodes <- data %>% 
    tidygraph::activate(nodes) %>% 
    tibble::as_tibble()

  nodes <- .prepare_graph(nodes, 1, "id")
  links <- .prepare_graph(links, 1:2, c("source", "target"))

  x = list(
    links = links,
    nodes = nodes,
    draw = draw,
    layout = list()
  )

  as_widget(x, width, height, elementId)
}

#' Shiny bindings for graph
#'
#' Output and render functions for using graph within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId,id output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a graph
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#' @param session A valid shiny session.
#'
#' @name graph-shiny
#'
#' @export
graphOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'graph', width, height, package = 'grapher')
}

#' @rdname graph-shiny
#' @export
renderGraph <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, graphOutput, env, quoted = TRUE)
}

#' @rdname graph-shiny
#' @export
render_graph <- renderGraph

#' @rdname graph-shiny
#' @export
graphProxy <- function(id, session = shiny::getDefaultReactiveDomain()) {
	proxy <- list(id = id, session = session)
	class(proxy) <- "graph_proxy"
	return(proxy)
}

#' @rdname graph-shiny
#' @export
graph_proxy <- graphProxy

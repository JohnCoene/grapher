#' Initialise
#'
#' Initialise a grapher graph.
#' 
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param elementId Id of element.
#' @param draw If \code{FALSE} the graph is not rendered. 
#' 
#' @examples 
#' g <- make_data(50)
#' 
#' graph() %>% 
#'   graph_links(g$links, source, target)
#' 
#' @importFrom stats runif
#' @import htmlwidgets
#' @import assertthat
#' @import dplyr
#' @import purrr
#'
#' @export
graph <- function(draw = TRUE, width = "100%", height = "100vh", elementId = NULL) {

  # forward options using x
  x = list(
    draw = draw,
    layout = list()
  )

  attr(x, 'TOJSON_ARGS') <- list(dataframe = "rows")

  # create widget
  htmlwidgets::createWidget(
    name = 'graph',
    x,
    width = width,
    height = height,
    package = 'grapher',
    elementId = elementId,
    preRenderHook = graph_renderer,
    sizingPolicy = htmlwidgets::sizingPolicy(
      padding = 0,
      browser.fill = TRUE
    )
  )
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

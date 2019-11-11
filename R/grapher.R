#' Initialise
#'
#' Initialise a grapher graph.
#' 
#' @param data A named \code{list} containing \code{nodes} and \code{links} 
#' where the former's first column are the node ids and the latter's first
#' and second columns are source and target, every other column is added as
#' respective meta-data. Can also be an object of class \code{igraph} from the
#' \link[igraph]{igraph} package or an object of class \code{tbl_graph} from 
#' the \link[tidygraph]{tidygraph} package. If a character string is passed the string is
#' assumed to be the path to either a \code{.gexf} file or a \code{.gv} 
#' \href{https://en.wikipedia.org/wiki/DOT_(graph_description_language)}{dot file}.
#' The thrid file type acceted is JSON, it must be the output of 
#' \code{\link{save_graph_json}}. If a \code{data.frame} is passed it is assumed
#' to be links where the first column indicates the source, and the second the 
#' target of the links. This argument can also be of class \code{graphframe} from the 
#' \href{graphframes}{https://spark.rstudio.com/graphframes/} package.
#' If \code{NULL} data \emph{must} be later supplied with \code{\link{graph_nodes}}
#' and \code{\link{graph_links}}.
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param elementId Id of element.
#' @param draw If \code{FALSE} the graph is not rendered. 
#' @param directed Whether the graph is directed, if passing an object of class 
#' \code{igraph} to \code{data} then this is inferred from the object.
#' 
#' @details if the variables \code{x}, \code{y}, and \code{z}
#' are included in the \code{nodes} the rendered visualisation 
#' is stable 2/3 dimensional and the force layout algorithm is not run.
#' 
#' @examples 
#' g <- make_data() # mock data
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
#' # from gexf
#' graph("http://gephi.org/datasets/LesMiserables.gexf")
#' 
#' # from dot file
#' fl <- system.file("example/dotfile.gv", package = "grapher")
#' graph(fl)
#' 
#' # from single data.frame
#' # assumes edges
#' graph(g$links)
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
#' @importFrom grDevices col2rgb rgb
#' @import htmlwidgets
#' @import assertthat
#' @import dplyr
#' @import purrr
#' 
#' @seealso \code{\link{graph_nodes}} and \code{\link{graph_links}} to add nodes and links.
#'
#' @export
graph <- function(data = NULL, directed = TRUE, draw = TRUE, width = "100%", height = NULL, elementId = NULL) UseMethod("graph")

#' @export
graph.default <- function(data = NULL, directed = TRUE, draw = TRUE, width = "100%", height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    draw = draw,
    directed = directed,
    layout = list()
  )

  as_widget(x, width, height, elementId)
}

#' @export
#' @method graph data.frame
graph.data.frame <- function(data = NULL, directed = TRUE, draw = TRUE, width = "100%", height = NULL, elementId = NULL) {

  names(data)[1:2] <- c("source", "target")

  # forward options using x
  x = list(
    links = data,
    nodes = NULL,
    draw = draw,
    directed = directed,
    layout = list()
  )

  as_widget(x, width, height, elementId)
}

#' @export
#' @method graph igraph
graph.igraph <- function(data = NULL, directed = TRUE, draw = TRUE, width = "100%", height = NULL, elementId = NULL) {

  g_df <- igraph::as_data_frame(data, "both")
  nodes <- g_df$vertices
  links <- g_df$edges

  nodes <- .prepare_graph(nodes, 1, "id")
  links <- .prepare_graph(links, 1:2, c("source", "target"))

  # forward options using x
  x = list(
    links = links,
    nodes = nodes,
    igraph = data, # store igraph object for later
    directed = igraph::is_directed(data),
    draw = draw,
    layout = list()
  )

  as_widget(x, width, height, elementId)
}

#' @export
#' @method graph list
graph.list <- function(data = NULL, directed = TRUE, draw = TRUE, width = "100%", height = NULL, elementId = NULL) {

  links <- data$links
  nodes <- data$nodes

  nodes <- .prepare_graph(nodes, 1, "id")
  links <- .prepare_graph(links, 1:2, c("source", "target"))

  x = list(
    links = links,
    nodes = nodes,
    directed = directed,
    draw = draw,
    layout = list()
  )

  as_widget(x, width, height, elementId)
}

#' @export
#' @method graph tbl_graph
graph.tbl_graph <- function(data = NULL, directed = TRUE, draw = TRUE, width = "100%", height = NULL, elementId = NULL) {

  links <- data %>% 
    tidygraph::activate(edges) %>% 
    tibble::as_tibble() %>% 
    .prepare_graph(1:2, c("source", "target"))
  
  nodes <- data %>% 
    tidygraph::activate(nodes) %>% 
    tibble::as_tibble() %>% 
    .prepare_graph(1, "id")

  if(!is.null(nodes))
    nodes <- mutate(nodes, id = as.character(id))

  if(!is.null(nodes)){
    nodes <- mutate(nodes, tg_id = 1:dplyr::n())

    nodes_to_join <- dplyr::select(nodes, id, tg_id)

    links_clean <- select(links, source, target)
    links_meta <- select(links, -source, -target)

    links_clean <- links_clean %>% 
      dplyr::left_join(
        nodes_to_join, by = c("source" = "tg_id")
      ) %>% 
      dplyr::left_join(
        nodes_to_join, by = c("target" = "tg_id")
      ) %>% 
      select(source = id.x, target = id.y) 
    
    links <- bind_cols(links_clean, links_meta) %>% 
      mutate(source = as.character(source)) %>% 
      mutate(target = as.character(target))
    nodes <- select(nodes, -tg_id)
  }

  x = list(
    links = links,
    nodes = nodes,
    directed = directed,
    draw = draw,
    layout = list()
  )

  as_widget(x, width, height, elementId)
}

#' @export
#' @method graph character
graph.character <- function(data = NULL, directed = TRUE, draw = TRUE, width = "100%", height = NULL, elementId = NULL) {

  # determine extension
  exts <- strsplit(basename(data), split = "\\.")[[1]][-1]

  if(exts != "json"){
    data <- tryCatch(suppressWarnings(readLines(data)), error = function(e) e)
    assert_that(!inherits(data, "error"), msg = "Cannot read file.")  
    
    data <- paste(data, collapse = "\n")
  } 

  x = list(
    links = list(),
    nodes = list(),
    directed = directed,
    draw = draw,
    layout = list()
  )

  if(exts == "gexf")
    x$gexf <- data
  else if(exts == "gv")
    x$dot <- data
  else 
    x$json <- data

  as_widget(x, width, height, elementId)
}

#' @export
#' @method graph graphframes
graph.graphframes <- function(data = NULL, directed = TRUE, draw = TRUE, width = "100%", height = NULL, elementId = NULL){

  links <- data %>% 
    graphframes::gf_edges() %>% 
    sparklyr::collect()

  nodes <- data %>% 
    graphframes::gf_vertices() %>% 
    sparklyr::collect()

  nodes <- .prepare_graph(nodes, 1, "id")
  links <- .prepare_graph(links, 1:2, c("source", "target"))

  x = list(
    links = links,
    nodes = nodes,
    directed = directed,
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

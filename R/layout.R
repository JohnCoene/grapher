#' Live Layout
#' 
#' Layout the graph live on the canvas using a physics simulator.
#' 
#' @inheritParams graph_nodes
#' @param spring_length Used to compute Hook's law, default of \code{30} is generally ideal.
#' @param sping_coeff Hook's law coefficient, where \code{1} is a solid spring.
#' @param gravity Coulomb's law coefficient. It's used to repel nodes thus should be negative 
#' if positive nodes attract each other.
#' @param theta Theta coefficient from Barnes Hut simulation, between \code{0} and \code{1}. 
#' The closer it's to \code{1} the more nodes the algorithm will have to go through.
#' Setting it to one makes Barnes Hut simulation no different from
#' brute-force forces calculation (each node is considered).
#' @param drag_coeff Drag force coefficient. Used to slow down system, thus should be less than \code{1}. 
#' The closer it is to 0 the less tight system will be.
#' @param time_step Default time step $dt$ for forces integration.
#' @param is_3d Whether to plot in 3 dimensions or 2 dimensions.
#' 
#' @details Calculates forces acting on each body and then deduces 
#' their position via Newton's law. There are three major forces in the system:
#' 
#' \itemize{
#'   \item{Spring force keeps connected nodes together via \href{https://en.wikipedia.org/wiki/Hooke's_law}{Hooke's law}.}
#'   \item{Each body repels each other via \href{https://en.wikipedia.org/wiki/Coulomb's_law}{Coulomb's law}.}
#'   \item{To guarantee we get to "stable" state the system has a drag force which slows entire simulation down.}
#' }
#' 
#' Body forces are calculated in \eqn{n*lg(n)} time with help of Barnes-Hut algorithm. 
#' \href{https://en.wikipedia.org/wiki/Euler_method}{Euler} method is then used to 
#' solve ordinary differential equation of Newton's law and get position of bodies.
#' 
#' @examples 
#' data <- make_data(20)
#' 
#' graph(data) %>% 
#'  graph_live_layout(time_step = 5L)
#' 
#' @export 
graph_live_layout <- function(g, spring_length = 30L, sping_coeff = .0008,
  gravity = -1.2, theta = .8, drag_coeff = .02, time_step = 20L, is_3d = TRUE) UseMethod("graph_live_layout")

#' @export 
#' @method graph_live_layout graph
graph_live_layout.graph <- function(g, spring_length = 30L, sping_coeff = .0008,
  gravity = -1.2, theta = .8, drag_coeff = .02, time_step = 20L, is_3d = TRUE) {
  
  physics <- list(
    springLength = spring_length,
    springCoeff = sping_coeff,
    gravity = gravity,
    theta = theta,
    dragCoeff = drag_coeff,
    timeStep = time_step,
    is3d = is_3d
  )

  g$x$layout$physics <- physics

  return(g)
}

#' Layout Static
#' 
#' Layout the graph given using an igraph algorithm rather 
#' than the built-in force layout.
#' 
#' @inheritParams graph_nodes
#' @param method The igraph function to compute node positions.
#' @param dim Number of dimensions to use, passed to \code{method}.
#' @param scaling A vector or 2 values defining the output range to
#' rescale the coordinates, set \code{NULL} to not use any scaling.
#' @param ... Any other argument to pass to \code{method}.
#' 
#' @examples 
#' graph_data <- make_data(200)
#' 
#' g <- graph(graph_data)
#' 
#' # layout without scaling
#' graph_static_layout(g, scaling = NULL)
#' 
#' # layout with scaling
#' graph_static_layout(g)
#' 
#' @note This function will overwrite \code{x}, \code{y}, \code{z} variables 
#' previously passed to \code{\link{graph_nodes}}. 
#' 
#' @seealso \code{\link{graph_offline_layout}} to compute the same layout as
#' \code{\link{graph_live_layout}} but in R rather than in the browser.
#' 
#' @export 
graph_static_layout <- function(g, method = igraph::layout_nicely, dim = 3, scaling = c(-200, 200), ...) UseMethod("graph_static_layout")

#' @export
#' @method graph_static_layout graph
graph_static_layout.graph <- function(g, method = igraph::layout_nicely, dim = 3, scaling = c(-200, 200), ...){

  if(!length(g$x$igraph)){
    assert_that(was_passed(g$x$links))

    g$x$igraph <- g$x$links %>% 
      select(source, target) %>% 
      igraph::graph_from_data_frame(directed = g$x$directed)
  }

  vertices <- igraph::as_data_frame(g$x$igraph, "vertices")
  lay_out <- method(g$x$igraph, dim = dim, ...) %>% 
    as.data.frame() %>% 
    bind_cols(vertices) %>% 
    purrr::set_names(c("x", "y", "z", "id"))

  if(!is.null(scaling)){
    lay_out$x <- scales::rescale(lay_out$x, to = scaling)
    lay_out$y <- scales::rescale(lay_out$y, to = scaling)
    lay_out$z <- scales::rescale(lay_out$z, to = scaling)
  }

  if(length(g$x$nodes))
    lay_out <- left_join(g$x$nodes, lay_out, by = "id")
  
  g$x$nodes <- lay_out
  g$x$customLayout <- TRUE

  return(g)
}

#' Offline Layout From File
#' 
#' Add layout computed offline via nodejs. 
#' Note that \code{\link{graph_offline_layout}} uses the same algorithm.
#' 
#' @inheritParams graph_nodes
#' @param positions Path to binary positions file as computed
#' by \href{ngraph.offline.layout}{https://github.com/anvaka/ngraph.offline.layout},
#' generally \code{positions.bin}.
#' 
#' @seealso \code{\link{graph_offline_layout}} to run the same algorithm without 
#' having to export the graph and use nodejs.
#' 
#' @export 
graph_bin_layout <- function(g, positions) UseMethod("graph_bin_layout")

#' @export 
#' @method graph_bin_layout graph
graph_bin_layout.graph <- function(g, positions){
  assert_that(has_it(positions))
  assert_that(was_passed(g$x$nodes))

  # maximum should be n node * x/y/z 
  MAX <- nrow(g$x$nodes) * 3

  to_read = file(positions, "rb")
  endian <- readBin(to_read, integer(), n = MAX, endian = "little")
  close(to_read)
  m <- matrix(endian, ncol = 3) %>% 
    as.data.frame() %>% 
    set_names(c("x", "y", "z")) %>% 
    transpose()

  g$x$offline_nodes <- m
  g$x$customLayout <- TRUE

  # force data to be passed for coordinates to work JS side
  if(ncol(g$x$nodes) == 1)
    g$x$nodes$RANDOM <- 0L

  return(g)
}

#' Pin Nodes
#' 
#' Pin nodes in place.
#' 
#' @inheritParams graph_nodes
#' @param data A data.frame holding nodes to pin.
#' @param id Either the bare name of the column 
#' containing node ids to pin or an integer 
#' (vector of length one) of node id to pin.
#' 
#' @examples 
#' library(shiny)
#' 
#' N <- 500
#' graph_data <- make_data(N)
#' 
#' ui <- fluidPage(
#'   actionButton("pin", "pin node"),
#'   numericInput("node", "node to pin", 1, min = 1, max = N, step = 1),
#'   actionButton("pinall", "pin ALL node"),
#'   graphOutput("graph")
#' )
#' 
#' server <- function(input, output) {
#' 
#'   output$graph <- renderGraph({
#'     graph_data %>% 
#'       graph() %>% 
#'       graph_live_layout(time_step = 5)
#'   })
#' 
#'   observeEvent(input$pin, {
#'     graph_proxy("graph") %>% 
#'       pin_node(input$node)
#'   })
#' 
#'   observeEvent(input$pinall, {
#'     graph_proxy("graph") %>% 
#'     pin_nodes(graph_data$nodes, id)
#'   })
#' 
#' }
#' 
#' \dontrun{shinyApp(ui, server)}
#' 
#' @name pin_nodes
#' @export 
pin_nodes <- function(g, data, id) UseMethod("pin_nodes")

#' @export
#' @method pin_nodes graph_proxy
pin_nodes.graph_proxy <- function(g, data, id){

  assert_that(has_it(data), has_it(id))

  nodes <- pull(data, id) %>% 
    as.list() # for list in case only one node

  msg <- list(id = g$id, nodes = nodes)

  g$session$sendCustomMessage("pin-nodes", msg)

  return(g)
}

#' @rdname pin_nodes
#' @export 
pin_node <- function(g, id) UseMethod("pin_node")

#' @export
#' @method pin_node graph_proxy
pin_node.graph_proxy <- function(g, id){

  assert_that(has_it(id))

  msg <- list(id = g$id, nodes = as.list(id))

  g$session$sendCustomMessage("pin-nodes", msg)

  return(g)
}

#' Change Dimensions
#' 
#' Change the dimensions of the graph.
#' 
#' @inheritParams graph_nodes
#' @param is_3d Whether to plot in 3 dimensions or 2 dimensions.
#' 
#' @examples 
#' library(shiny)
#' 
#' N <- 500
#' graph_data <- make_data(N)
#' 
#' ui <- fluidPage(
#'   radioButtons("dims", "Dimensions", choices = list("3D" = TRUE, "2D" = FALSE)),
#'   graphOutput("graph")
#' )
#' 
#' server <- function(input, output) {
#' 
#'   output$graph <- renderGraph({
#'     graph_data %>% 
#'       graph() %>% 
#'       graph_live_layout(time_step = 5)
#'   })
#' 
#'   observeEvent(input$dims, {
#'     graph_proxy("graph") %>% 
#'       change_dimensions(input$dims)
#'   })
#' 
#' }
#' 
#' \dontrun{shinyApp(ui, server)}
#' 
#' @export 
change_dimensions <- function(g, is_3d = FALSE) UseMethod("change_dimensions")

#' @export
#' @method change_dimensions graph
change_dimensions.graph <- function(g, is_3d = FALSE){
  g$x$layout$physics$is3d <- is_3d
  return(g)
}

#' @export
#' @method change_dimensions graph_proxy
change_dimensions.graph_proxy <- function(g, is_3d = FALSE){
  
  msg <- list(id = g$id, is3d = is_3d)

  g$session$sendCustomMessage("change-dim", msg)

  return(g)
}

#' Stabilize
#' 
#' Stabilize the layout of the graph. 
#' 
#' @inheritParams graph_nodes
#' @param stable Whether to stabilise the graph.
#' @param ms Milliseconds before stabilizing the graph.
#' 
#' @examples
#' gdata <- make_data(100)
#' 
#' graph(gdata) %>%
#'  graph_stable_layout(ms = 5000)
#'  
#' # as proxy
#' library(shiny)
#' 
#' graph_data <- make_data(200)
#' 
#' ui <- fluidPage(
#'   actionButton("stable", "stabilize"),
#'   graphOutput("g")
#' )
#' 
#' server <- function(input, output){
#'   output$g <- renderGraph({
#'     graph(graph_data) %>% 
#'       graph_live_layout(time_step = 1)
#'   })
#' 
#'   gp <- graph_proxy("g")
#' 
#'   observeEvent(input$stable, {
#'     graph_stable_layout(gp)
#'   })
#' }
#' 
#' \dontrun{shinyApp(ui, server)}
#' 
#' @export 
graph_stable_layout <- function(g, stable = TRUE, ms = 0L) UseMethod("graph_stable_layout")

#' @export
#' @method graph_stable_layout graph
graph_stable_layout.graph <- function(g, stable = TRUE, ms = 0L){
  g$x$stable <- ms
  return(g)
}

#' @export
#' @method graph_stable_layout graph_proxy
graph_stable_layout.graph_proxy <- function(g, stable = TRUE, ms = 0L){
  msg <- list(id = g$id, stable = stable, ms = ms)
  g$session$sendCustomMessage("stable", msg)
  return(g)
}

#' Hide Links
#' 
#' Hide links over a certain length, based on computations by \code{graph_static_layout}.
#' Nodes will actually be hidden in resulting visualisation but not removed.
#' 
#' @details This is the technique used by \href{Andrei Kashcha}{https://github.com/anvaka},
#' in his \href{package managers visualisation project}{https://anvaka.github.io/pm}, though
#' the latter does not use ngraph.pixel (which grapher uses) and hides links based on the 
#' length in pixels. Hiding distant edges allows to undo the hairball while still being
#' able to discern smaller communities.
#' 
#' @inheritParams graph_nodes
#' @param length Length above which links should be hidden.
#' 
#' @examples
#' gdata <- make_data(500)
#' 
#' g <- graph(gdata) %>%
#'   graph_static_layout(scaling = c(-1000, 1000)) %>% 
#'   graph_cluster() %>% 
#'   scale_link_color(cluster) 
#' 
#' # hide links longer than 100
#' hide_long_links(g, 100)
#' 
#' # or get computed lengths
#' lengths <- compute_links_length(g)
#' 
#' # define threshold
#' threshold <- quantile(lengths$length, .2)
#' 
#' hide_long_links(g, threshold)
#' 
#' @name link_distance
#' @export
hide_long_links <- function(g, length = 1) UseMethod("hide_long_links")

#' @export
#' @method hide_long_links graph
hide_long_links.graph <- function(g, length = 1){
  assert_that(was_passed(g$x$links))
  assert_that(has_coords(g$x$nodes))

  n <- select(g$x$nodes, id, x, y, z)

  links_with_dist <- g$x$links %>% 
    left_join(n, by = c("source" = "id")) %>% 
    left_join(n, by = c("target" = "id"), suffix = c(".source", ".target")) %>% 
    mutate(
      l = .compute_dist(x.source, y.source, z.source, x.target, y.target, z.target)
    ) %>% 
    mutate(
      hidden = case_when(
        l > length ~ TRUE,
        TRUE ~ FALSE
      )
    ) %>% 
    select(hidden)

  g$x$links <- bind_cols(g$x$links, links_with_dist)

  return(g)
}

#' @rdname link_distance
#' @export
compute_links_length <- function(g){
  assert_that(was_passed(g$x$links))
  assert_that(has_coords(g$x$nodes))

  n <- select(g$x$nodes, id, x, y, z)

  g$x$links %>% 
    left_join(n, by = c("source" = "id")) %>% 
    left_join(n, by = c("target" = "id"), suffix = c(".source", ".target")) %>% 
    mutate(
      length = .compute_dist(x.source, y.source, z.source, x.target, y.target, z.target)
    ) %>% 
    select(source, target, length)
}

#' Remove Coordinates
#' 
#' Removes coordinates (\code{x}, \code{y}, and \code{z}) from the 
#' graph. This is useful if you have used the \code{graph_static_layout}
#' to then \code{hide_long_links} but nonetheless want to use the default 
#' force layout (\code{graph_live_layout}). 
#' 
#' @inheritParams graph_nodes
#' 
#' @examples
#' gdata <- make_data(500)
#' 
#' graph(gdata) %>%
#'   graph_static_layout() %>% 
#'   hide_long_links(20) %>% # hide links
#'   remove_coordinates() 
#' 
#' @export
remove_coordinates <- function(g) UseMethod("remove_coordinates")

#' @export 
#' @method remove_coordinates graph
remove_coordinates.graph <- function(g){
  assert_that(has_coords(g$x$nodes))
  
  # remove coordinates
  g$x$nodes$x <- NULL
  g$x$nodes$y <- NULL
  g$x$nodes$z <- NULL

  # remove setting
  g$x$customLayout <- NULL

  return(g)
}

#' Offline Layout
#' 
#' Compute the force layout (same as \code{\link{graph_live_layout}})
#' but before rendering in the browser.
#' 
#' @inheritParams graph_live_layout
#' @param steps Number of steps to run the layout algorithm.
#' 
#' @details This method is not necessarily faster than rendering
#' in the browser as the graph has to be serialised to JSON once
#' more to be processed by the \href{ngraph.forcelayout3d}{https://github.com/anvaka/ngraph.forcelayout3d}
#' algorithm then reimported in grapher.
#' 
#' @examples
#' gdata <- make_data(500)
#' 
#' graph(gdata) %>%
#'   graph_offline_layout(steps = 100) 
#' 
#' @seealso \code{\link{graph_static_layout}} for other "offline" layout methods. 
#' 
#' @export
graph_offline_layout <- function(g, steps = 500, spring_length = 30L, sping_coeff = .0008,
  gravity = -1.2, theta = .8, drag_coeff = .02, time_step = 20L, is_3d = TRUE) UseMethod("graph_offline_layout")

#' @export
#' @method graph_offline_layout graph
graph_offline_layout.graph <- function(g, steps = 500, spring_length = 30L, sping_coeff = .0008,
  gravity = -1.2, theta = .8, drag_coeff = .02, time_step = 20L, is_3d = TRUE){

  physics <- list(
    springLength = spring_length,
    springCoeff = sping_coeff,
    gravity = gravity,
    theta = theta,
    dragCoeff = drag_coeff,
    timeStep = time_step,
    is3d = is_3d
  )

  # initialises
  ctx <- V8::new_context()

  # source dependencies
  invisible(ctx$source(system.file("offline-layout/layout.js", package = "grapher")))
  ctx$source(system.file("htmlwidgets/lib/ngraph/ngraph.graph.min.js", package = "grapher"))
  invisible(ctx$source(system.file("htmlwidgets/lib/fromjson/ngraph.fromjson.js", package = "grapher")))
  
  # create graph and settings
  ctx$assign("json", extract_graph(g, json = TRUE))
  ctx$assign("settings", physics)
  ctx$eval("var graph = from_json(json);")

  # create layout
  ctx$eval("var l = layout(graph, settings);")
  trash <- purrr::map(1:steps, function(x){
   ctx$eval("var step = l.step();") 
  })
  rm(trash)
  ctx$assign("nodes", list())
  ctx$eval("graph.forEachNode(function(node){
    var pos = l.getNodePosition(node.id);
    pos.id = node.id;
    nodes.push(pos);
  })")

  # extracted positoned nodes
  positioned <- ctx$get("nodes") 

  # add to grapher
  if(!is.null(g$x$nodes))
    g$x$nodes <- left_join(g$x$nodes, positioned, by = "id")
  else
    g$x$nodes <- positioned

  g$x$customLayout <- TRUE

  return(g)
  
}
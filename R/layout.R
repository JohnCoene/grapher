#' Live Layout
#' 
#' Layout the graph live on the canvas using a physics simulator.
#' 
#' @inheritParams graph_nodes
#' @param spring_length Used to compute Hook's law, default of \code{30} is generally idea.
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

#' Layout Offline
#' 
#' @inheritParams graph_nodes
#' @param method The igraph function to compute node positions.
#' @param dim Number of dimensions to use, passed to \code{method}.
#' 
#' @examples 
#' graph_data <- make_data(10)
#' 
#' graph() %>% 
#'   graph_nodes(graph_data$nodes, id) %>% 
#'   graph_links(graph_data$links, source, target) %>% 
#'   graph_offline_layout()
#' 
#' @note This function will overwrite \code{x}, \code{y}, \code{z} variables 
#' previously passed to \code{\link{graph_nodes}}. 
#' 
#' @export 
graph_offline_layout <- function(g, method = igraph::layout_nicely, dim = 3) UseMethod("graph_offline_layout")

#' @export
#' @method graph_offline_layout graph
graph_offline_layout.graph <- function(g, method = igraph::layout_nicely, dim = 3){

  assert_that(was_passed(g$x$links))

  ig <- g$x$links %>% 
    select(source, target) %>% 
    igraph::graph_from_data_frame()
    
  vertices <- igraph::as_data_frame(ig, "vertices")
  lay_out <- method(ig, dim = dim) %>% 
    as.data.frame() %>% 
    bind_cols(vertices) %>% 
    purrr::set_names(c("x", "y", "z", "id")) 

  if(length(g$x$nodes))
    lay_out <- left_join(g$x$nodes, lay_out, by = "id")
  
  g$x$nodes <- lay_out
  g$x$customLayout <- TRUE

  return(g)
}
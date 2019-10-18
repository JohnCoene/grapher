#' Layout
#' 
#' Adjust graph layout
#' 
#' @export 
graph_layout <- function(g, spring_length = 30L, sping_coeff = .0008,
  gravity = -1.2, theta = .8, drag_coeff = .02, time_step = 20L, is_3d = TRUE) UseMethod("graph_layout")

#' @export 
#' @method graph_layout graph
graph_layout.graph <- function(g) {
  
  layout <- list(
    springLength = spring_length,
    springCoeff = sping_coeff,
    gravity = gravity,
    theta = theta,
    dragCoeff = drag_coeff,
    timeStep = time_step,
    is3d = is_3d
  )

  g$x$layout$physics <- layout

  return(g)
}
#' Background
#' 
#' Customise the background color and trasnparency of the visualisation.
#' 
#' @inheritParams graph_nodes
#' @param color Background color of the visualisation.
#' @param alpha Transparency of background, a numeric between \code{0} and \code{1}.
#' 
#' @examples
#' make_data() %>% 
#'   graph() %>% 
#'   graph_background("#d3d3d3", .2)
#' 
#' @export 
graph_background <- function(g, color = "#000", alpha = 1) UseMethod("graph_background")

#' @export
#' @method graph_background graph
graph_background.graph <- function(g, color = "#000", alpha = 1){
  g$x$layout <- list(
    clearColor = color,
    clearAlpha = alpha
  )
  return(g)
}
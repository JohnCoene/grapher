#' Definitions
#' 
#' Define variables to use for color and size.
#' 
#' @inheritParams graph_nodes
#' @param var Bare name of variable to define.
#' 
#' @section Defaults:
#' Nodes:
#' * `color`
#' * `size`
#' 
#' Edges
#' * `fromColor`
#' * `toColor`
#' 
#' @examples
#' # generate data
#' # add custom color
#' data <- make_data()
#' data$nodes$myColor <- "#0000ff"
#' 
#' graph(data) %>% 
#'   define_nodes_color(myColor)
#' 
#' @name definitions
#' @export
define_nodes_color <- function(g, var) UseMethod("define_nodes_color")

#' @export
#' @method define_nodes_color graph
define_nodes_color.graph <- function(g, var) {
  assert_that(has_it(var))
  g$x$style$nodes$color <- deparse(substitute(var))
  return(g)
}

#' @rdname definitions
#' @export
define_nodes_size <- function(g, var) UseMethod("define_nodes_size")

#' @export
#' @method define_nodes_size graph
define_nodes_size.graph <- function(g, var) {
  assert_that(has_it(var))
  g$x$style$nodes$size <- deparse(substitute(var))
  return(g)
}

#' @rdname definitions
#' @export
define_links_from_color <- function(g, var) UseMethod("define_links_from_color")

#' @export
#' @method define_links_from_color graph
define_links_from_color.graph <- function(g, var) {
  assert_that(has_it(var))
  g$x$style$links$fromColor <- deparse(substitute(var))
  return(g)
}

#' @rdname definitions
#' @export
define_links_to_color <- function(g, var) UseMethod("define_links_to_color")

#' @export
#' @method define_links_to_color graph
define_links_to_color.graph <- function(g, var) {
  assert_that(has_it(var))
  g$x$style$links$toColor <- deparse(substitute(var))
  return(g)
}

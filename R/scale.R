#' Scale Node Color
#' 
#' Scale nodes color.
#' 
#' @inheritParams graph_nodes
#' @param variable Bare column name of variable to scale against.
#' @param palette Color palette.
#' 
#' @examples
#' graph_data <- make_data(100)
#' graph_data$nodes$var <- runif(100, 1, 10)
#' 
#' graph() %>% 
#'   graph_nodes(graph_data$nodes, id, var) %>% 
#'   graph_links(graph_data$links, source, target) %>% 
#'   scale_node_color(var)
#' 
#' @export
scale_node_color <- function(g, variable, palette = c("0xFE4A49", "0xFED766", "0x009FB7", "0xF79256")) UseMethod("scale_node_color")

#' @export 
#' @method scale_node_color graph
scale_node_color.graph <- function(g, variable, palette = c("0xFE4A49", "0xFED766", "0x009FB7", "0xF79256")){
  assert_that(has_it(variable))
  assert_that(was_passed(g$x$nodes))

  var <- deparse(substitute(variable))
  
  scl <- scale_colour(g$x$nodes[[var]], palette)
  g$x$nodes$color <- scl(g$x$nodes[[var]])

  return(g)
}

#' Scale Edge Color
#' 
#' Scale nodes color.
#' 
#' @inheritParams graph_nodes
#' @inheritParams scale_node_color
#' 
#' @name scale_link_color
#' @export
scale_link_source_color <- function(g, variable, palette = c("0xFE4A49", "0xFED766", "0x009FB7", "0xF79256")) UseMethod("scale_link_source_color")

#' @export 
#' @method scale_link_source_color graph
scale_link_source_color.graph <- function(g, variable, palette = c("0xFE4A49", "0xFED766", "0x009FB7", "0xF79256")){
  assert_that(has_it(variable))
  assert_that(was_passed(g$x$links))

  var <- deparse(substitute(variable))
  
  scl <- scale_colour(g$x$links[[var]], palette)
  g$x$links$fromColor <- scl(g$x$links[[var]])

  return(g)
}

#' @rdname scale_link_color
#' @export
scale_link_target_color <- function(g, variable, palette = c("0xFE4A49", "0xFED766", "0x009FB7", "0xF79256")) UseMethod("scale_link_target_color")

#' @export 
#' @method scale_link_target_color graph
scale_link_target_color.graph <- function(g, variable, palette = c("0xFE4A49", "0xFED766", "0x009FB7", "0xF79256")){
  assert_that(has_it(variable))
  assert_that(was_passed(g$x$links))

  var <- deparse(substitute(variable))
  
  scl <- scale_colour(g$x$links[[var]], palette)
  g$x$links$toColor <- scl(g$x$links[[var]])

  return(g)
}

#' @rdname scale_link_color
#' @export
scale_link_color <- function(g, variable, palette = c("0xFE4A49", "0xFED766", "0x009FB7", "0xF79256")) UseMethod("scale_link_color")

#' @export 
#' @method scale_link_color graph
scale_link_color.graph <- function(g, variable, palette = c("0xFE4A49", "0xFED766", "0x009FB7", "0xF79256")){
  assert_that(has_it(variable))
  assert_that(was_passed(g$x$nodes))

  var <- deparse(substitute(variable))
  nodes <- select_(g$x$nodes, "id", var)
  links <- g$x$link_ids
  
  scl <- scale_colour(g$x$edges[[var]], palette)
  g$x$edges$toColor <- scl(g$x$edges[[var]])

  return(g)
}
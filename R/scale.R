#' Scale Node Color
#' 
#' Scale nodes color.
#' 
#' @inheritParams graph_nodes
#' @param variable Bare column name of variable to scale against.
#' @param palette Color palette.
#' @param red,green,blue The possible range of values (light) that the
#' red, green, and blue channels can take, must be vectors ranging from
#' \code{0} to \code{1}.
#' 
#' @examples
#' graph_data <- make_data(100)
#' graph_data$nodes$var <- runif(100, 1, 10)
#' 
#' # scale by variable
#' graph() %>% 
#'   graph_nodes(graph_data$nodes, id, var) %>% 
#'   graph_links(graph_data$links, source, target) %>% 
#'   scale_node_color(var)
#' 
#' # scale by coordinate position
#' graph(graph_data) %>% 
#'  graph_layout_static() %>% 
#'  scale_node_color_coords()
#' 
#' @name scale_node_color
#' @export
scale_node_color <- function(g, variable, palette = graph_palette()) UseMethod("scale_node_color")

#' @export 
#' @method scale_node_color graph
scale_node_color.graph <- function(g, variable, palette = graph_palette()){
  assert_that(has_it(variable))
  assert_that(was_passed(g$x$nodes))

  var <- deparse(substitute(variable))

  assert_that(has_var(g$x$nodes, var))
  
  scl <- scale_colour(g$x$nodes[[var]], palette)
  g$x$nodes$color <- scl(g$x$nodes[[var]]) %>% to_hex()
  g$x$style$nodes$color <- "color"

  return(g)
}

#' @rdname scale_node_color
#' @export
scale_node_color_coords <- function(g, red = c(.01, .99), green = red, blue = red) UseMethod("scale_node_color_coords")

#' @export 
#' @method scale_node_color_coords graph
scale_node_color_coords.graph <- function(g, red = c(.01, .99), green = red, blue = red){
  assert_that(was_passed(g$x$nodes))
  assert_that(has_coords(g$x$nodes))

  g$x$nodes <- mutate(g$x$nodes, color = scale_rgb(x, y, z, red, green, blue))

  # force style set
  g$x$style$nodes$color <- "color"

  return(g)
}

#' Scale Node Size
#' 
#' Scale nodes size.
#' 
#' @inheritParams graph_nodes
#' @param variable Bare column name of variable to scale against.
#' @param range Output range.
#' 
#' @examples
#' graph_data <- make_data()
#' 
#' graph_data %>% 
#'   graph() %>% 
#'   scale_node_size(size, c(10, 100))
#' 
#' @export
scale_node_size <- function(g, variable, range = c(20, 70)) UseMethod("scale_node_size")

#' @export 
#' @method scale_node_size graph
scale_node_size.graph <- function(g, variable, range = c(20, 70)){
  assert_that(has_it(variable))
  assert_that(was_passed(g$x$nodes))

  var <- deparse(substitute(variable))

  assert_that(has_var(g$x$nodes, var))
  
  g$x$nodes$size <- scales::rescale(g$x$nodes[[var]], to = range)
  g$x$style$nodes$size <- "size"

  return(g)
}

#' Scale Link Color
#' 
#' Scale links color, note that links colors are split in two.
#' 
#' @inheritParams graph_nodes
#' @inheritParams scale_node_color
#' 
#' @section Functions:
#' \itemize{
#'   \item{\code{scale_link_source_color}, \code{scale_link_target_color} - Scale source and target color of links according to links variables.}
#'   \item{\code{scale_link_color} - Scale the source and target color of nodes according the values of nodes at either ends of each respective link.}
#'   \item{\code{scale_link_color_coords} - Compute rgb colors based on the coordinates (layout) of nodes at either end of each link.}
#' }
#' 
#' @examples
#' g <- make_data(1000)
#' 
#' # color by cluster
#' graph(g) %>% 
#'   graph_cluster() %>% 
#'   scale_link_color(cluster)
#' 
#' # color by coordinates
#' graph(g) %>% 
#'   graph_layout_offline() %>% 
#'   scale_link_color_coords()
#' 
#' @name scale_link_color
#' @export
scale_link_source_color <- function(g, variable, palette = graph_palette()) UseMethod("scale_link_source_color")

#' @export 
#' @method scale_link_source_color graph
scale_link_source_color.graph <- function(g, variable, palette = graph_palette()){
  assert_that(has_it(variable))
  assert_that(was_passed(g$x$links))

  var <- deparse(substitute(variable))

  assert_that(has_var(g$x$links, var))
  
  scl <- scale_colour(g$x$links[[var]], palette)
  g$x$links$fromColor <- scl(g$x$links[[var]]) %>% to_hex()
  g$x$style$links$fromColor <- "fromColor"

  return(g)
}

#' @rdname scale_link_color
#' @export
scale_link_target_color <- function(g, variable, palette = graph_palette()) UseMethod("scale_link_target_color")

#' @export 
#' @method scale_link_target_color graph
scale_link_target_color.graph <- function(g, variable, palette = graph_palette()){
  assert_that(has_it(variable))
  assert_that(was_passed(g$x$links))

  var <- deparse(substitute(variable))

  assert_that(has_var(g$x$links, var))
  
  scl <- scale_colour(g$x$links[[var]], palette)
  g$x$links$toColor <- scl(g$x$links[[var]]) %>% to_hex()
  g$x$style$links$toColor <- "toColor"

  return(g)
}

#' @rdname scale_link_color
#' @export
scale_link_color <- function(g, variable, palette = graph_palette()) UseMethod("scale_link_color")

#' @export 
#' @method scale_link_color graph
scale_link_color.graph <- function(g, variable, palette = graph_palette()){
  assert_that(has_it(variable))
  assert_that(was_passed(g$x$nodes))

  # get nodes data
  var <- deparse(substitute(variable))
  nodes <- select_(g$x$nodes, "id", var)

  # build scaling dunction
  scl <- scale_colour(nodes[[var]], palette)

  # apply to source nodes
  source <- g$x$links %>% 
    select(id = source) %>% 
    inner_join(nodes, by = "id")
  to_color <- scl(source[[var]]) %>% to_hex()

  target <- g$x$links %>% 
    select(id = target) %>% 
    inner_join(nodes, by = "id")
  from_color <- scl(target[[var]]) %>% to_hex()

  # using fromColor and toColor
  # force style set
  g$x$links$fromColor <- NULL
  g$x$links$toColor <- NULL
  g$x$style$links$fromColor <- "fromColor"
  g$x$style$links$toColor <- "toColor"

  g$x$links <- bind_cols(g$x$links, tibble::tibble(fromColor = from_color, toColor = to_color))

  return(g)
}

#' @rdname scale_link_color
#' @export
scale_link_color_coords <- function(g, red = c(.01, .99), green = red, blue = red) UseMethod("scale_link_color_coords")

#' @export 
#' @method scale_link_color_coords graph
scale_link_color_coords.graph <- function(g, red = c(.01, .99), green = red, blue = red){
  assert_that(was_passed(g$x$nodes))
  assert_that(has_coords(g$x$nodes))

  nodes <- select(g$x$nodes, id, x, y, z)

  links_color <- g$x$links %>% 
    left_join(nodes, by = c("source" = "id")) %>% 
    left_join(nodes, by = c("target" = "id"), suffix = c(".source", ".target")) %>% 
    mutate(
      fromColor = scale_rgb(x.source, y.source, z.source, red, green, blue),
      toColor = scale_rgb(x.target, y.target, z.target, red, green, blue)
    ) %>% 
    select(fromColor, toColor)

  # using fromColor and toColor
  # force style set
  g$x$links$fromColor <- NULL
  g$x$links$toColor <- NULL
  g$x$style$links$fromColor <- "fromColor"
  g$x$style$links$toColor <- "toColor"

  g$x$links <- bind_cols(g$x$links, links_color)

  return(g)
}

#' Color Palettes
#' 
#' Bright and light color palettes for examples and defaults.
#' 
#' @return A vector of hex colors.
#' 
#' @examples
#' # preview_palettes
#' graph_palette()
#' graph_palette_light()
#' 
#' graph_data <- make_data(200)
#' 
#' graph_data %>% 
#'   graph() %>% 
#'   graph_cluster() %>% 
#'   scale_link_color(cluster, palette = graph_palette_light())
#' 
#' @name graph_palette
#' @export 
graph_palette <- function() {
  pal <- c(
    "#6f63bb", "#8a60b0", "#ba43b4", "#c7519c", "#d63a3a", "#ff7f0e",
    "#ffaa0e", "#ffbf50", "#bcbd22", "#78a641", "#2ca030", "#12a2a8",
    "#1f83b4"
  )

  structure(pal, class = c("pal", class(pal)))
}

#' @rdname graph_palette
#' @export
graph_palette_light <- function(){
  pal <- c(
    "#C70E7B", "#FC6882","#007BC3","#54BCD1","#EF7C12","#F4B95A",
    "#009F3F","#8FDA04", "#AF6125","#F4E3C7","#B25D91","#EFC7E6", 
    "#EF7C12","#F4B95A"
  )
  structure(pal, class = c("pal", class(pal)))
}

#' @export 
print.pal <- function(x, ...){
  map(x, function(color){
    style <- crayon::make_style(color)
    style(tolower(color))
  }) %>% 
    unlist() %>% 
    cat("\n")
}
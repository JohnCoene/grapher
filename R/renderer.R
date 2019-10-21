 graph_renderer <- function(g) {

  g$x$data <- .render_graph(g)

  return(g)
} 
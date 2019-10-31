as_widget <- function(x, width, height, elementId){
  # default variables to get
  x$style <- list(
    nodes = list(
      size = .get_default_style(x$nodes, "size", x$styles$nodes),
      color = .get_default_style(x$nodes, "color", x$styles$nodes)
    ),
    links = list(
      fromColor = .get_default_style(x$links, "fromColor", x$styles$links),
      toColor = .get_default_style(x$links, "toColor", x$styles$links)
    )
  ) %>% 
    keep(function(x){
      if(is.null(x))
        return(FALSE)
      return(TRUE)
    })

  x$layout$clearColor <- "#000000"
  x$layout$clearAlpha <- 1

  attr(x, 'TOJSON_FUNC') <- use_jsonify

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

use_jsonify <- function(x){
  jsonify::to_json(x, unbox = TRUE)
}

graph_renderer <- function(g) {

  if(length(g$x$nodes)){
    nms <- names(g$x$nodes)
    has_positional <- sum(c("x", "y", "z") %in% nms)
    if(has_positional > 1)
      g$x$customLayout <- TRUE
  }

  if(!length(g$x$gexf) && !length(g$x$dot))
    g$x$data <- .render_graph(g)

  # remove nodes and links
  g$x$nodes <- NULL
  g$x$links <- NULL
  g$x$igraph <- NULL

  return(g)
} 

.render_graph <- function(g){

  ERROR <- paste0(
    "You must initialise the graph with at least one ", 
    crayon::yellow("node"), 
    " or one ", 
    crayon::yellow("link"), ".\n"
  )

  assert_that(
    length(g$x$nodes) != 0 || length(g$x$links) != 0,
    msg = ERROR
  )

  nodes <- list()
  if(length(g$x$nodes)){

    nodes <- select(g$x$nodes, id) %>% 
      unlist() %>% 
      unname() %>% 
      map(function(x){
        list(id = x)
      })

    node_metas <- select(g$x$nodes, -id) %>% 
      purrr::transpose() %>% 
      map(function(x){
        list(data = x)
      })

    if(length(node_metas))
      nodes <- map2(nodes, node_metas, 
        function(id, meta){
          list(id, meta) %>% 
            flatten()
        }) 
  }

  links <- list()
  if(length(g$x$links)){
    links <- g$x$links %>%
      select(fromId = source, toId = target) %>%  
      transpose()

    link_metas <- g$x$links %>%
      select(-source, -target) %>%  
      purrr::transpose() %>% 
      map(function(x){
        list(data = x)
      })

    if(length(link_metas))
      links <- map2(links, link_metas, 
        function(id, meta){
          list(id, meta) %>% 
            flatten()
        })

  }

  list(nodes = nodes, links = links)
}
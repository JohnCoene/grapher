as_widget <- function(x, width, height, elementId){
  attr(x, 'TOJSON_ARGS') <- list(dataframe = "rows")

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

graph_renderer <- function(g) {
  g$x$data <- .render_graph(g)
  return(g)
} 


.render_graph <- function(g){

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
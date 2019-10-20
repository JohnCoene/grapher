 graph_renderer <- function(g) {

  nodes <- NULL
  if(length(g$x$nodes)){

    nodes <- select(g$x$nodes, id) %>% 
      unlist() %>% 
      unname()

    node_metas <- select(g$x$nodes, -id) %>% 
      purrr::transpose()

    if(length(node_metas))
      nodes <- map2(nodes, node_metas, 
        function(id, meta){
          list(id, meta)
        })
  }

  g$x$nodes <- nodes

  links <- NULL
  if(length(g$x$links)){
    links <- g$x$links %>%
      select(source, target) %>%  
      transpose() %>% 
      map(unname)

    link_metas <- g$x$links %>%
      select(-source, -target) %>%  
      purrr::transpose() 

    if(length(link_metas))
      links <- map2(links, link_metas, 
        function(id, meta){
          list(id, meta)
        })

  }

  g$x$links <- links

  return(g)
} 
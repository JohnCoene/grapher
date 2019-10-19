 graph_renderer <- function(g) {

   node_ids <- NULL
   if(length(g$x$node_ids))
    node_ids <- g$x$node_ids %>% 
      unlist() %>% 
      unname()
  
  if(length(g$x$node_metas))
    g$x$nodes <- g$x$node_metas %>% 
      purrr::transpose() %>% 
      map2(node_ids, function(meta, id){
        list(id, meta)
      })
  else
    g$x$nodes <- node_ids

  link_ids <- NULL
  if(length(g$x$link_ids))
    link_ids <- g$x$link_ids %>% 
      transpose() %>% 
      map(unname)

  if(length(g$x$link_metas))
    g$x$links <- g$x$link_metas %>% 
      purrr::transpose() %>% 
      map2(link_ids, 
          function(meta, id){
            list(id, meta)
          })
  else
    g$x$links <- link_ids

  g$x$node_ids <- NULL
  g$x$node_metas <- NULL 
  g$x$link_ids <- NULL
  g$x$link_metas <- NULL  

  return(g)
} 
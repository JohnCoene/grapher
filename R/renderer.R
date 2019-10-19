 graph_renderer <- function(g) {

   node_ids <- NULL
   if(length(g$x$nodes)){
     node_ids <- select(g$x$nodes, id) %>% 
        unlist() %>% 
        unname()
    
     node_metas <- select(g$x$nodes, -id)
      g$x$nodes <- node_metas %>% 
        purrr::transpose() %>% 
        map2(node_ids, function(meta, id){
          list(id, meta)
        })
   }

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

  g$x$link_ids <- NULL
  g$x$link_metas <- NULL  

  return(g)
} 
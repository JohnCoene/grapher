#' Add Nodes
#' 
#' Add nodes to the graph.
#' 
#' @param g An object of class \code{graph} as 
#' returned by \code{\link{graph}} or a \code{graph_proxy}
#' as returned by a function of the same name.
#' @param data A data.frame containing nodes data.
#' @param id The bare column names containing the nodes ids.
#' @param ... Any other bare named column containing 
#' meta data to attach to the nodes.
#' 
#' @examples 
#' graph_data <- make_data()
#' 
#' graph() %>% 
#'   graph_nodes(graph_data$nodes, id)
#' 
#' @seealso \code{\link{graph_links}} to add links.
#' 
#' @export
graph_nodes <- function(g, data, id, ...) UseMethod("graph_nodes")

#' @export
#' @method graph_nodes graph
graph_nodes.graph <- function(g, data, id, ...){
  
  assert_that(has_it(data))
  assert_that(has_it(id))

  id_enquo <- enquo(id)
  node_ids <- select(data, id = !!id_enquo)

  args <- rlang::quos(...)
  node_metas <- list()
  if(!rlang::is_empty(args))
    node_metas <- select(data, ...)
  
  g$x$node_ids <- node_ids
  g$x$node_metas <- node_metas

  return(g)
}

#' @export
#' @method graph_nodes graph_proxy
graph_nodes.graph_proxy <- function(g, data, id, ...){
  
  assert_that(has_it(data))
  assert_that(has_it(id))

  id_enquo <- enquo(id)
  nodes <- select(data, !!id_enquo) %>% 
    unlist() %>% 
    unname()

  args <- rlang::quos(...)
  if(!rlang::is_empty(args))
    nodes <- select(data, ...) %>% 
      transpose() %>% 
      map2(nodes, function(meta, id){
        list(id, meta)
      })
  
  msg <- list(id = g$id, nodes = nodes)

  g$session$sendCustomMessage("add-nodes", msg)

  return(g)
}

#' Add Links
#' 
#' Add links to a graph.
#' 
#' @param g An object of class \code{graph} as 
#' returned by \code{\link{graph}} or a \code{graph_proxy}
#' as returned by a function of the same name.
#' @param data A data.frame containing links data.
#' @param source,target The bare column names containing 
#' the links source and target.
#' @param ... Any other bare named column containing 
#' meta data to attach to the links.
#' 
#' @examples 
#' graph_data <- make_data()
#' 
#' graph() %>% 
#'   graph_nodes(graph_data$nodes, id) %>% 
#'   graph_links(graph_data$links, source, target)
#' 
#' @seealso \code{\link{graph_nodes}} to add nodes.
#' 
#' @export
graph_links <- function(g, data, source, target, ...) UseMethod("graph_links")

#' @export
#' @method graph_links graph
graph_links.graph <- function(g, data, source, target, ...){
  
  assert_that(has_it(data))
  assert_that(has_it(source))
  assert_that(has_it(target))

  source_enquo <- enquo(source)
  target_enquo <- enquo(target)
  link_ids <- select(data, !!source_enquo, !!target_enquo) 

  link_metas <- list()
  args <- rlang::quos(...)
  if(!rlang::is_empty(args))
    link_metas <- select(data, ...)
  
  g$x$link_ids <- link_ids
  g$x$link_metas <- link_metas

  return(g)
}

#' @export
#' @method graph_links graph_proxy
graph_links.graph_proxy <- function(g, data, source, target, ...){
  
  assert_that(has_it(data))
  assert_that(has_it(source))
  assert_that(has_it(target))

  source_enquo <- enquo(source)
  target_enquo <- enquo(target)
  links <- select(data, !!source_enquo, !!target_enquo) %>% 
    transpose() %>% 
    map(unname)

  args <- rlang::quos(...)
  if(!rlang::is_empty(args))
    links <- select(data, ...) %>% 
      transpose() %>% 
      map2(links, function(meta, link){
        list(link, meta)
      })
  
  msg <- list(id = g$id, links = links)

  g$session$sendCustomMessage("add-links", msg)

  return(g)
}
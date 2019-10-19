#' Cluster
#' 
#' Cluster nodes on the graph.
#' 
#' @inheritParams graph_nodes
#' @param method The igraph function to create the cluster.
#' @param quiet Set to \code{TRUE} to \emph{not print} number 
#' of clusters in the console.
#' 
#' @examples 
#' graph_data <- make_data()
#' 
#' graph() %>% 
#'   graph_links(graph_data$links, source, target) %>% 
#'   graph_cluster() 
#' 
#' @export 
graph_cluster <- function(g, method = igraph::cluster_walktrap, 
  quiet = !interactive(), ...) UseMethod("graph_cluster")

#' @export 
#' @method graph_cluster graph
graph_cluster.graph <- function(g, method = igraph::cluster_walktrap, 
  quiet = !interactive(), ...) {

  assert_that(was_passed(g$x$link_ids))

  ig <- igraph::graph_from_data_frame(g$x$link_ids)
  vertices <- igraph::as_data_frame(ig, "vertices") %>% 
    purrr::set_names(c("id"))

  communities <- method(ig, ...)
  membership <- igraph::as_membership(communities)
  
  # build color table
  grps <- unique(membership$membership)
  n_grps <- length(grps)
  
  if(!isTRUE(quiet))
    cat("Found #", crayon::blue(n_grps), "clusters\n")

  clusters <- tibble::tibble(
    cluster = membership$membership
  ) %>% 
    bind_cols(vertices)

  if(length(g$x$nodes))
    clusters <- left_join(g$x$nodes, clusters, by = "id")
  
  g$x$nodes <- clusters

  return(g)
}

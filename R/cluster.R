#' Cluster
#' 
#' Cluster nodes on the graph. This ultimately adds a \code{cluster}
#' column to the internal node data.frame. The latter can be used in
#' e.g.: \code{\link{scale_node_color}}.
#' 
#' @inheritParams graph_nodes
#' @param method The igraph function to create the cluster.
#' @param quiet Set to \code{TRUE} to \emph{not print} number 
#' of clusters in the console.
#' @param weights Bare column name of links weight if \code{NULL}
#' no weight is taken into account.
#' @param ... Other arguments passed to function specified as 
#' \code{method} argument.
#' 
#' @examples 
#' graph_data <- make_data(200)
#' 
#' graph(graph_data) %>% 
#'   graph_cluster(weights = weight) 
#' 
#' @export 
graph_cluster <- function(g, method = igraph::cluster_walktrap, 
  quiet = !interactive(), weights = NULL, ...) UseMethod("graph_cluster")

#' @export 
#' @method graph_cluster graph
graph_cluster.graph <- function(g, method = igraph::cluster_walktrap, 
  quiet = !interactive(), weights = NULL, ...) {

  if(!length(g$x$igraph)){
    assert_that(was_passed(g$x$links))

    g$x$igraph <- g$x$links %>%
      select(source, target) %>%  
      igraph::graph_from_data_frame(directed = g$x$directed)
  }

  w <- enquo(weights)
  if(!rlang::quo_is_null(w))
    weights <- pull(g$x$links, !!w)
  
  vertices <- igraph::as_data_frame(g$x$igraph, "vertices")
  names(vertices)[1] <- "id"

  communities <- method(g$x$igraph, weights = weights, ...)
  membership <- igraph::as_membership(communities)
  
  # build color table
  grps <- unique(membership$membership)
  n_grps <- length(grps)
  
  if(!isTRUE(quiet))
    cat("Found", crayon::blue(n_grps), "clusters\n")

  clusters <- tibble::tibble(
    cluster = as.factor(membership$membership)
  ) %>% 
    bind_cols(vertices)

  if(length(g$x$nodes))
    clusters <- left_join(g$x$nodes, clusters, by = "id")
  
  g$x$nodes <- clusters

  return(g)
}

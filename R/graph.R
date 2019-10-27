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
#' @details if the variables \code{x}, \code{y}, and \code{z}
#' are passed the rendered visualisation is stable 2/3D and
#' the force layout algorithm is not run.
#' 
#' @examples 
#' graph_data <- make_data()
#' 
#' graph() %>% 
#'   graph_nodes(graph_data$nodes, id)
#' 
#' # using a shiny proxy
#' library(shiny)
#' 
#' data1 <- make_data(150)
#' data2 <- make_data(50)
#' 
#' # nodes that do not overalp
#' # 120 = 30 new nodes added
#' noverlap <- 120
#' 
#' data2$nodes$id <- as.integer(data2$nodes$id) + noverlap
#' data2$links$source <- as.integer(data2$links$source) + noverlap
#' data2$links$target <- as.integer(data2$links$target) + noverlap
#' 
#' ui <- fluidPage(
#'   actionButton("add", "add"),
#'   graphOutput("g", height = "90vh")
#' )
#' 
#' server <- function(input, output) {
#'   output$g <- render_graph({
#'     graph(data1) 
#'   })
#' 
#'   observeEvent(input$add, {
#'     graph_proxy("g") %>% 
#'       graph_nodes(data2$nodes, id) %>% 
#'       graph_links(data2$links, source, target)
#'   })
#' }
#' 
#' \dontrun{shinyApp(ui, server)}
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
  g$x$nodes <- select(data, id = !!id_enquo, ...) %>% 
    .force_character()

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
#' # using the shiny proxy
#' library(shiny)
#' 
#' data1 <- make_data(150)
#' data2 <- make_data(50)
#' 
#' ui <- fluidPage(
#'   actionButton("add", "add"),
#'   graphOutput("g", height = "90vh")
#' )
#' 
#' server <- function(input, output) {
#'   output$g <- render_graph({
#'     graph(data1) 
#'   })
#' 
#'   observeEvent(input$add, {
#'     graph_proxy("g") %>% 
#'       graph_links(data2$links, source, target)
#'   })
#' }
#' 
#' \dontrun{shinyApp(ui, server)}
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
  g$x$links <- select(data, source = !!source_enquo, target = !!target_enquo, ...) %>% 
    .force_character()

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
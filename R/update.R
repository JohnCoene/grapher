#' Update Node
#' 
#' Update a node's color or size, works with /code{\link{graph_proxy}}.
#' 
#' @inheritParams graph_nodes
#' @param id Id of node to update.
#' @param var Variable name to update.
#' @param val New value to assign to \code{var}.
#' 
#' @examples 
#' library(shiny)
#' 
#' N <- 200
#' g <- make_data(N)
#' 
#' ui <- fluidPage(
#'  numericInput("node", "Node ID", 5, min = 1, max = N, step = 1L),
#'  selectInput("color", "New Color", c("red", "green", "blue")),
#'  graphOutput("g", height = "80vh")
#' )
#' 
#' server <- function(input, output) {
#'  output$g <- render_graph({
#'    graph(g)
#'  })
#' 
#'  observeEvent(c(input$color, input$node), {
#'    graph_proxy("g") %>% 
#'      update_node_color(input$node, input$color, "color")
#'  })
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @seealso \code{\link{update_nodes}} to update multiple nodes at once.
#' 
#' @name update_node
#' @export
update_node_size <- function(g, id, val, var = "size") UseMethod("update_node_size")

#' @export 
#' @method update_node_size graph_proxy
update_node_size.graph_proxy <- function(g, id, val, var = "size"){
  assert_that(has_it(id))
  assert_that(has_it(val))

  msg <- list(
    id = g$id, 
    node_id = as.character(id), 
    var = var, 
    val = val
  )
  g$session$sendCustomMessage("update-node", msg)
  return(g)
}

#' @rdname update_node
#' @export
update_node_color <- function(g, id, val, var = "color") UseMethod("update_node_color")

#' @export 
#' @method update_node_color graph_proxy
update_node_color.graph_proxy <- function(g, id, val, var = "color"){
  assert_that(has_it(id))
  assert_that(has_it(val))

  val <- to_hex(val)

  msg <- list(
    id = g$id, 
    node_id = as.character(id), 
    var = var, 
    val = gsub("\\#", "0x", val)
  )
  g$session$sendCustomMessage("update-node", msg)
  return(g)
}

#' Update Nodes
#' 
#' Update multiple nodes size and color.
#' 
#' @inheritParams graph_nodes
#' @param data A data.frame containing \code{id}, \code{val}, and \code{var}
#' of nodes to update.
#' @param id Bare column name containing node ids to udapte.
#' @param val Bare column name containing new values to set.
#' @param var The name of the variable to update. 
#' 
#' @examples 
#' library(shiny)
#' 
#' g <- make_data(200)
#' 
#' colors <- c("red", "green", "blue", "yellow")
#' 
#' ui <- fluidPage(
#'  actionButton("update", "Update random nodes"),
#'  graphOutput("g", height = "80vh")
#' )
#' 
#' server <- function(input, output) {
#'  output$g <- render_graph({
#'    graph(g) %>% 
#'      define_node_size(size) %>% 
#'      graph_stable_layout(ms = 2500)
#'  })
#' 
#'  observeEvent(input$update, {
#'    nodes_sample <- g$nodes %>% 
#'      dplyr::sample_n(100) %>% 
#'      dplyr::mutate(
#'        color = sample(colors, 100, replace = TRUE),
#'        size = runif(100, 20, 100)
#'      )
#' 
#'    graph_proxy("g") %>% 
#'      update_nodes_color(nodes_sample, id, color) %>% 
#'      update_nodes_size(nodes_sample, id, size)
#'  })
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @name update_nodes
#' @export
update_nodes_color <- function(g, data, id, val, var = "color") UseMethod("update_nodes_color")

#' @export 
#' @method update_nodes_color graph_proxy
update_nodes_color.graph_proxy <- function(g, data, id, val, var = "color"){
  assert_that(has_it(data))
  assert_that(has_it(val))
  assert_that(has_it(id))

  id_enquo <- enquo(id)
  val_enquo <- enquo(val)

  data <- data %>% 
    select(id = !!id_enquo, val = !!val_enquo) %>% 
    mutate(
      id = as.character(id),
      val = to_hex(val),
      val = gsub("\\#", "0x", val)
    ) %>% 
    transpose()

  msg <- list(
    id = g$id, 
    var = var,
    data = data
  )
  g$session$sendCustomMessage("update-nodes", msg)
  return(g)
}

#' @rdname update_nodes
#' @export
update_nodes_size <- function(g, data, id, val, var = "size") UseMethod("update_nodes_size")

#' @export 
#' @method update_nodes_color graph_proxy
update_nodes_size.graph_proxy <- function(g, data, id, val, var = "size"){
  assert_that(has_it(data))
  assert_that(has_it(val))
  assert_that(has_it(id))

  id_enquo <- enquo(id)
  val_enquo <- enquo(val)

  data <- data %>% 
    select(id = !!id_enquo, val = !!val_enquo) %>% 
    mutate(id = as.character(id)) %>% 
    transpose()

  msg <- list(
    id = g$id, 
    var = var,
    data = data
  )
  g$session$sendCustomMessage("update-nodes", msg)
  return(g)
}

#' Update Link
#' 
#' Update a link source, and target color.
#' 
#' @inheritParams graph_nodes
#' @param source,target Source and Target ids of link to update.
#' @param val The updated value to assign.
#' 
#' @examples 
#' library(shiny)
#' 
#' N <- 200
#' g <- make_data(N)
#' 
#' ui <- fluidPage(
#'  numericInput("link", "link", 5, min = 1, max = N, step = 1L),
#'  graphOutput("g", height = "80vh")
#' )
#' 
#' server <- function(input, output) {
#'  output$g <- render_graph({
#'    graph(g)
#'  })
#' 
#'  observeEvent(input$link, {
#'    sel <- dplyr::slice(g$links, input$link)
#'    graph_proxy("g") %>% 
#'      update_link_source_color(sel$source, sel$target, "blue") %>% 
#'      update_link_target_color(sel$source, sel$target, "red")
#'  })
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @name update_link
#' @export
update_link_source_color <- function(g, source, target, val) UseMethod("update_link_source_color")

#' @export
#' @method update_link_source_color graph_proxy
update_link_source_color.graph_proxy <- function(g, source, target, val){
  assert_that(has_it(source))
  assert_that(has_it(target))
  assert_that(has_it(val))

  val <- to_hex(val)

  msg <- list(
    id = g$id, 
    source = as.character(source),
    target = as.character(target), 
    val = gsub("\\#", "0x", val)
  )
  g$session$sendCustomMessage("update-link-source-color", msg)
  return(g)
}

#' @rdname update_link
#' @export
update_link_target_color <- function(g, source, target, val) UseMethod("update_link_target_color")

#' @export
#' @method update_link_target_color graph_proxy
update_link_target_color.graph_proxy <- function(g, source, target, val){
  assert_that(has_it(source))
  assert_that(has_it(target))
  assert_that(has_it(val))

  val <- to_hex(val)

  msg <- list(
    id = g$id, 
    source = as.character(source),
    target = as.character(target), 
    val = gsub("\\#", "0x", val)
  )
  g$session$sendCustomMessage("update-link-target-color", msg)
  return(g)
}
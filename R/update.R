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
#'      update_node_color(input$node, "color", input$color)
#'  })
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @name update_node
#' @export
update_node_size <- function(g, id, var, val) UseMethod("update_node_size")

#' @export 
#' @method update_node_size graph_proxy
update_node_size.graph_proxy <- function(g, id, var, val){
  assert_that(has_it(id))
  assert_that(has_it(var))
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
update_node_color <- function(g, id, var, val) UseMethod("update_node_color")

#' @export 
#' @method update_node_color graph_proxy
update_node_color.graph_proxy <- function(g, id, var, val){
  assert_that(has_it(id))
  assert_that(has_it(var))
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

#' Update Link
#' 
#' Update a link source, and target color.
#' 
#' @inheritParams graph_nodes
#' @param source,target Source and Target ids of link to update.
#' @param val The updated value to assign.
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
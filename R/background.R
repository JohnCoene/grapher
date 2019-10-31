#' Background
#' 
#' Customise the background color and trasnparency of the visualisation.
#' 
#' @inheritParams graph_nodes
#' @param color Background color of the visualisation.
#' @param alpha Transparency of background, a numeric between \code{0} and \code{1}.
#' 
#' @examples
#' make_data() %>% 
#'   graph() %>% 
#'   graph_background("#d3d3d3", .2)
#' 
#' # as proxy
#' library(shiny)
#' 
#' graph_data <- make_data(500)
#' 
#' colors <- list(
#'   "#000000", "#121420",
#'   "#1B2432", "#2C2B3C"
#' )
#' 
#' ui <- fluidPage(
#'   selectInput("bg", "background color", choices = colors),
#'   graphOutput("graph")
#' )
#' 
#' server <- function(input, output) {
#' 
#'   output$graph <- renderGraph({
#'     graph_data %>% 
#'       graph() %>% 
#'       graph_live_layout(time_step = 5)
#'   })
#' 
#'   observeEvent(input$bg, {
#'     graph_proxy("graph") %>% 
#'     graph_background(input$bg)
#'   })
#' 
#' }
#' 
#' \dontrun{shinyApp(ui, server)}
#' 
#' @export 
graph_background <- function(g, color = "#000000", alpha = 1) UseMethod("graph_background")

#' @export
#' @method graph_background graph
graph_background.graph <- function(g, color = "#000000", alpha = 1){
  g$x$layout <- list(
    clearColor = to_hex(color),
    clearAlpha = alpha
  )
  return(g)
}

#' @export
#' @method graph_background graph_proxy
graph_background.graph_proxy <- function(g, color = "#000000", alpha = 1){

  msg <- list(id = g$id, color = to_hex(color), alpha = alpha)

  g$session$sendCustomMessage("background", msg)
  return(g)
}

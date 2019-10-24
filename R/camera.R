#' Camera FOV
#' 
#' Adjust the camera field of view.
#' 
#' @inheritParams graph_nodes
#' @param fov The field of view of the camera.
#' 
#' @examples 
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
#'   sliderInput("fov", "Field of view", 45, 120, 75, step = 5),
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
#'   observeEvent(input$fov, {
#'     graph_proxy("graph") %>% 
#'       graph_camera_fov(input$fov)
#'   })
#' 
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @export
graph_camera_fov <- function(g, fov = 75L) UseMethod("graph_camera_fov")

#' @export 
#' @method graph_camera_fov graph_proxy
graph_camera_fov.graph_proxy <- function(g, fov = 75L) {

  msg <- list(id = g$id, fov = fov)

  g$session$sendCustomMessage("camera-fov", msg)
  
  return(g)
}
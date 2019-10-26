#' Run Demo Shiny App
#' 
#' A demo shiny demo to demonstrate some of the possibilites of grapher with \link[shiny]{shiny}.
#' 
#' @examples
#' \dontrun{grapher_demo}
#' 
#' @export
grapher_demo <- function() {
  app <- system.file("app/app.R", package = "grapher")
  shiny::shinyAppFile(app)
}
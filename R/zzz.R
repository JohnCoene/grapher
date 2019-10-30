.onAttach <- function(libname, pkgname) {
  shiny::registerInputHandler("grapherParser", function(data, ...) {
    jsonify::from_json(data, auto_unbox = TRUE)
  }, force = TRUE)
}
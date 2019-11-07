.onAttach <- function(libname, pkgname) {
  shiny::registerInputHandler("grapherParser", function(data, ...) {
    jsonify::from_json(jsonify::to_json(data, unbox = TRUE))
  }, force = TRUE)
}
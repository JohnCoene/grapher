.onAttach <- function(libname, pkgname) {
  shiny::registerInputHandler("grapherParser", function(data, ...) {
    jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
  }, force = TRUE)

  packageStartupMessage(
    "Welcome to grapher\n\n",
    "Docs: grapher.john-coene.com"
  )
}
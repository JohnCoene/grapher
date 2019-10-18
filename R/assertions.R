has_it <- function(x) {
  !missing(x)
}

on_failure(has_it) <- function(call, env) {
  paste0(
    "Missing`",
    crayon::red(deparse(call$x)), 
    "`."
  )
}
has_it <- function(x) {
  !missing(x)
}

on_failure(has_it) <- function(call, env) {
  paste0(
    "Missing `",
    crayon::red(deparse(call$x)), 
    "`."
  )
}

was_passed <- function(x) {
  !!length(x)
}

on_failure(was_passed) <- function(call, env) {
  variable <- gsub("g\\$x\\$", "", deparse(call$x))

  paste0(
    "Must have passed `",
    crayon::red(variable), 
    "`."
  )
}

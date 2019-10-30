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

has_coords <- function(x) {
  nms <- names(x)
  total <- sum(c("x", "y", "z") %in% nms)

  if(total != 3L)
    return(FALSE)
  
  return(TRUE)
}

on_failure(has_coords) <- function(call, env) {
  paste0(
    "Must have computed 3D layout see `",
    crayon::blue("graph_static_layout"),
    "` or `", 
    crayon::blue("graph_offline_layout"), 
    "`."
  )
}

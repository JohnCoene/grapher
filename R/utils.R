globalVariables(
  c("source", "target", "nodes", "edges",
    "Depends", "Imports", "LinkingTo", "Package")
)

scale_colour <- function(x, palette){
  if(inherits(x, "numeric"))
    scales::col_numeric(palette, range(x), na.color = "#FFFFFF")
  else
    scales::col_factor(palette, unique(x), na.color = "#FFFFFF")
}

.prepare_graph <- function(x, n, nms){
  if(is.null(x))
    return(NULL)

  if(!ncol(x))
    return(NULL)

  names <- names(x)
  names[n] <- nms
  names(x) <- names
  return(x)
}

.force_character <- function(x){
  if(is.null(x))
    return(x)

  nms <- names(x)
  if(nms[1] == "id"){
    x$id <- as.character(x$id)
  } else {
    x$source <- as.character(x$source)
    x$target <- as.character(x$target)
  }
  return(x)
}

globalVariables(
  c("source", "target", "nodes", "edges")
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

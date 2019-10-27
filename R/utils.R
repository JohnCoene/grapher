globalVariables(
  c("source", "target", "nodes", "edges",
    "Depends", "Imports", "LinkingTo", "Package",
    "activate", "from", "id.x", "id.y", "name", "tg_id", "to")
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

.get_default_style <- function(object, var, style){
  nms <- names(object)
  if(var %in% nms && !is.null(style[[style]]))
    return(var)
  return(NULL)
}

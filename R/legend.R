#' Links Legend
#' 
#' Add an interactive edge legend using dat.gui.
#' 
#' @inheritParams graph_nodes
#' @param var The bare name of the link variable to use as group.
#' @param color The bare name of the link variable to get colors from.
#' @param title The title of the legend. 
#' 
#' @examples 
#' data <- make_data()
#' data$links$grp <- rep(letters[1:2], 5)
#' data$links$color <- rep(c("#FFFFFF", "#F00FFF"), 5)
#' 
#' graph(data) %>% graph_links_legend(grp, color)
#' 
#' @export 
graph_links_legend <- function(g, var, color, title = "legend") UseMethod("graph_links_legend")

#' @export 
#' @method graph_links_legend graph
graph_links_legend.graph <- function(g, var, color, title = "legend"){

  assert_that(was_passed(g$x$links))

  var_enquo <- enquo(var)
  color_enquo <- enquo(color)

  grps <- g$x$links %>% 
    select(!!var_enquo, !!color_enquo) %>% 
    distinct() %>% 
    transpose()

  vars <- unique(grps$color)

  legend <- map(grps, function(x){
      
      func = paste0("function(link){return(link.data.", names(x)[1], " == '", unname(x[1]), "');}")

      list(
        name = x[1] %>% unname() %>% unlist(),
        color = x[2] %>% unname() %>% unlist(),
        filter = JS(func)
      )
    })

  g$x$legend <- list(
    title = title,
    groups = legend
  )

  return(g)
}

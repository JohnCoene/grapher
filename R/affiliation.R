#' Affiliation Graph
#' 
#' Create an affiliation graph from a user-community structure.
#' 
#' @param links A data.frame containing \code{member}
#' and \code{community}.
#' @param member A person who is part of a \code{community}.
#' @param community A community, e.g.: a mailing list, a news group, etc.
#' @param coefficient,scale,weight You can explicitly specify the strength of a 
#' membership. That is how strongly a given \code{member} belongs to a 
#' \code{community}. The higher the strength the more likely it is for 
#' a member to have connections with other members of the community. 
#' By default the function does not require you to specify strength for the 
#' affiliation graph. If you do not specify the strength, it is assumed 
#' that strength is equally distributed among community members, and its 
#' value will be: \eqn{strength = (numberOfCommunityMembers, -coefficient) ^ 2 * scale}.
#' You specify the very strength of each relationship ising the \code{weight}
#' column.
#' @param seed A random seed for reproducibility.
#' 
#' @details Note: setting weight to 0 will prohibit the model from building 
#' connections for this user within current community. It's same as just not 
#' including user into the community.
#' 
#' @examples 
#' data <- tibble::tribble(
#'  ~"user",     ~"group",
#'  "user 0",     "group 1",
#'  "user 1",     "group 1",
#'  "user 2",     "group 1",
#'  "user 1",     "group 2",
#'  "user 2",     "group 2",
#'  "user 3",     "group 2"
#' )
#' 
#' g <- affiliation_graph(data, user, group)
#' graph(g)
#' 
#' # with weight
#' data$strength <- runif(6, 1, 10)
#' affiliation_graph(data, user, group, weight = strength)
#' 
#' @return A data.frame of \code{member} links.
#' 
#' @seealso \href{official documentation}{https://github.com/anvaka/ngraph.agmgen}
#' 
#' @export 
affiliation_graph <- function(links, member, community, weight = NULL, 
  seed = 42, coefficient = NULL, scale = NULL) UseMethod("affiliation_graph")

#' @export 
#' @method affiliation_graph data.frame
affiliation_graph.data.frame <- function(links, member, community, weight = NULL,
  seed = 42, coefficient = NULL, scale = NULL) {

  assert_that(has_it(member))
  assert_that(has_it(community))

  settings <- list(
    random = seed,
    coefficient = coefficient,
    scale = scale
  ) %>% 
    discard(is.null)

  member <- rlang::enquo(member)
  community <- rlang::enquo(community)
  weight <- rlang::enquo(weight)

  data <- select(links, !!member, !!community)
  lst <- data %>% 
    set_names(c("fromId", "toId")) %>% 
    transpose()
  if(!rlang::quo_is_null(weight))
    lst <- purrr::map2(lst, pull(links, !!weight), function(x, y){
      x$data <- list(y)
      return(x)
    })
    
  g <- list(links = lst, nodes = list())

  # initialise V8
  ctx <- V8::new_context()

  # source dependencies
  invisible(ctx$source(system.file("agmgen/ngraph.agmgen.js", package = "grapher")))
  ctx$source(system.file("htmlwidgets/lib/ngraph/ngraph.graph.min.js", package = "grapher"))
  invisible(ctx$source(system.file("htmlwidgets/lib/fromjson/ngraph.fromjson.js", package = "grapher")))
  
  ctx$assign("json", jsonify::to_json(g, unbox = TRUE))
  ctx$assign("settings", settings)
  ctx$eval("var g = from_json(json);")
  ctx$eval("var graph = agm(g, settings)")
  ctx$eval("var links = [];")
  ctx$eval("graph.forEachLink(function(link){
    links.push(link)
  })")

  ctx$get("links") %>% 
    set_names(c("source", "target", "id")) %>% 
    select(source, target)

}

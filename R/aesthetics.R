aes <- function(x, env = globalenv()) {
  if (rlang::is_quosure(x)) {
    if (!rlang::quo_is_symbolic(x)) {
      x <- rlang::quo_get_expr(x)
    }
    return(x)
  }

  if (rlang::is_symbolic(x)) {
    x <- rlang::new_quosure(x, env = env)
    return(x)
  }

  x
}

pull_aes_data <- function(x, data) {
  if(rlang::quo_is_symbolic(x))
    return(dplyr::pull(data, !!x))

  rep(rlang::quo_get_expr(x), nrow(data))
}

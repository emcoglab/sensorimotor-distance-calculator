render_pairs <- function(pairs, item_sep = " : ", pair_sep = "\n") {
  text_block <- pairs %>%
    map(paste, collapse = item_sep) %>%
    unlist %>%
    paste(collapse = pair_sep) %>%
    tolower
  return(text_block)
}

render_list <- function(list, item_sep = "\n") {
  text_block <- list %>%
    unlist %>%
    paste(collapse = item_sep) %>%
    tolower
  return(text_block)
}
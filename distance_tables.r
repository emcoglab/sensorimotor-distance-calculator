source("norms.r")

distance_table_for_word_pairs <- function(left_words, right_words, distance_type) {
  # Validate
  if (length(left_words) != length(right_words)) { stop('Pairs not matched') }
  
  if (length(left_words) == 0) {
    return (NULL)
  }
  
  table_data <- data.frame(
    W1 = left_words,
    W2 = right_words
  )
  names(table_data) <- c("Word 1", "Word 2")
  
  matrix_left <- matrix_for_words(left_words)
  matrix_right <- matrix_for_words(right_words)
  
  if (distance_type == "minkowski3") {
    distance_col_name <- "Minkowski-3 distance"
    distances <- diag(cdist(matrix_left, matrix_right, metric="minkowski", p=3))
  }
  else if(distance_type == "euclidean") {
    distance_col_name <- "Euclidean distance"
    distances <- diag(cdist(matrix_left, matrix_right, metric="euclidean", p=2))
  }
  else if(distance_type == "cosine") {
    distance_col_name <- "Cosine distance"
    distances <- diag(cdist(matrix_left, matrix_right, metric=function(x, y) {1 - (x %*% y / sqrt(x%*%x * y%*%y))} ))
  }
  else if(distance_type == "correlation") {
    distance_col_name <- "Correlation distance"
    distances <- diag(cdist(matrix_left, matrix_right, metric="correlation"))
  }
  else {
    stop("Unsupported distance type")
  }
  
  table_data[, distance_col_name] = distances
  
  return(table_data)
}

distance_table_for_one_many <- function(left_word, right_words, distance_type) {
  left_words <- rep(left_word, length(right_words))
  return(distance_table_for_word_pairs(left_words, right_words, distance_type))
}

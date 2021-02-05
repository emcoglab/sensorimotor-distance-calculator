source("calculate/norms.r")
source("calculate/distance.r")

# Return a data.frame suitable for rendering in a one-one distance comparison
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
  
  distances = distance_matrix(matrix_left, matrix_right, distance_type)
  
  table_data[, distance_col_name(distance_type)] = diag(distances)
  
  return(table_data)
}

# Return a data.frame suitable for rendering in a one-many distance comparison
distance_table_for_one_many <- function(left_word, right_words, distance_type) {
  left_words <- rep(left_word, length(right_words))
  return(distance_table_for_word_pairs(left_words, right_words, distance_type))
}

# Return a data.frame suitable for rendering in a many-many distance comparison
# as a matrix
distance_matrix_for_word_pairs <- function(left_words, right_words, distance_type) {
  
  if (length(left_words)  == 0) { return (NULL) }
  if (length(right_words) == 0) { return (NULL) }
  
  matrix_left <- matrix_for_words(left_words)
  matrix_right <- matrix_for_words(right_words)
  
  distances = distance_matrix(matrix_left, matrix_right, distance_type)
  
  table_data = data.frame(distances, row.names=left_words)
  names(table_data) <- right_words
  
  return(table_data)
}

# Given a distance matrix with row/column names, returns a data.frame with 
# columns `Word 1`, `Word 2`, `distance`
distance_list_from_matrix <- function(distance_matrix, distance_type) {
  # Convert row names to first column
  left_words = rownames(distance_matrix)
  rownames(distance_matrix) = NULL
  distance_matrix <- cbind(left_words, distance_matrix)
  list_table <- distance_matrix %>% pivot_longer(!left_words, names_to = "Word 2", values_to = "distance")
  names(list_table) <- c("Word 1", "Word 2", distance_col_name(distance_type))
  return(list_table)
}

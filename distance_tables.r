source("norms.r")

distance_table_for_word_pairs <- function(word_pairs, distance_type) {
  
  if (length(word_pairs) == 0) {
    return (NULL)
  }
  
  table_data <- as.data.frame(matrix(unlist(word_pairs), nrow=length(word_pairs)))
  names(table_data) <- c("Word 1", "Word 2")
  
  matrix_left <- matrix_for_words(table_data$`Word 1`)
  matrix_right <- matrix_for_words(table_data$`Word 2`)
  
  if (distance_type == "minkowski3") {
    pdist_fun <- nn_pairwise_distance(p=3)
    distances <- pdist_fun(matrix_left, matrix_right)
  }
  else if(distance_type == "euclidean") {
    pdist_fun <- nn_pairwise_distance(p=2)
    distances <- pdist_fun(matrix_left, matrix_right)
  }
  
  
  browser()
}

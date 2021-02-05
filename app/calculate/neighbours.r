source("calculate/distance.r")
source("calculate/norms.r")

neighbours_table <- function(word, distance_type, count, radius) {
  
  if (radius <= 0) { radius = Inf }
  
  mx = distance_matrix(vector_for_word(word), matrix_for_words(all_words), distance_type)
  argsort <- order(mx)
  nearest_idxs <- argsort[2:(count+1)]  # Skip the guaranteed nearest neighbour: the word itself
  nearest_words <- all_words[nearest_idxs]
  nearest_distances <- mx[nearest_idxs]
  
  if (!is.infinite(radius)) {
    nearest_distances <- nearest_distances[nearest_distances <= radius]
    nearest_words <- nearest_words[1:length(nearest_distances)]
  }
  
  table <- data.frame(order = 1:length(nearest_words),
                      Concept = nearest_words,
                      distance = nearest_distances)
  names(table) <- c("Order", "Concept", distance_col_name(distance_type))
  
  return(table)
}

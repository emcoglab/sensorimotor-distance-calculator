norms <- read.csv("/Users/cai/Box Sync/LANGBOOT Project/Model/FINAL_sensorimotor_norms_for_39707_words.csv",
                  header = TRUE)

random_norms <- function(n) {
  return(sample(norms$Word, n))
}

random_norm <- function() {
  return(random_norms(1)[1])
}

random_norm_pairs <- function(n) {
  pairs <- random_norms(2*n)
  dim(pairs) <- c(n, 2)
  # Convert matrix to list of rows
  return(split(pairs, rep(1:nrow(pairs), each = ncol(pairs))) %>% array)
}

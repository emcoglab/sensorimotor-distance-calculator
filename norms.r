norms <- read.csv("/Volumes/Mordin/web-app data/sensorimotor-shiny/FINAL_sensorimotor_norms_for_39707_words.csv",
                  header = TRUE)
norms$Word = tolower(norms$Word)

sensory_columns <- c("Auditory.mean", "Gustatory.mean", "Haptic.mean", "Interoceptive.mean", "Olfactory.mean", "Visual.mean")
motor_columns <- c("Foot_leg.mean", "Hand_arm.mean", "Head.mean", "Mouth.mean", "Torso.mean")
all_columns <- c(sensory_columns, motor_columns)

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

# Returns a n x 11 matrix for the supplied words
matrix_for_words <- function(words) {
  return(
    as.matrix(norms[norms$Word %in% words, all_columns])
  )
}

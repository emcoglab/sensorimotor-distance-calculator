source("meta.r")

# The norms
norms <- read.csv(paste0(data_dir, "FINAL_sensorimotor_norms_for_39707_words.csv"), header = TRUE)
norms$Word = norms$Word %>% tolower %>% str_squish

# List of all words in the norms
all_words <- norms$Word

# Relevant columns for norms data
sensory_columns <- c("Auditory.mean", "Gustatory.mean", "Haptic.mean", "Interoceptive.mean", "Olfactory.mean", "Visual.mean")
motor_columns <- c("Foot_leg.mean", "Hand_arm.mean", "Head.mean", "Mouth.mean", "Torso.mean")
all_columns <- c(sensory_columns, motor_columns)

# Dominance
dominance_column_sensorimotor <- "Dominant.sensorimotor"
dominance_column_perceptual <- "Dominant.perceptual"
dominance_column_action <- "Dominant.action"

# Return n random norms
random_norms <- function(n) {
  return(sample(norms$Word, n))
}

# Return a single random norm
random_norm <- function() {
  return(random_norms(1)[1])
}

# Return n random norm pairs
random_norm_pairs <- function(n) {
  pairs <- random_norms(2*n)
  dim(pairs) <- c(n, 2)
  # Convert matrix to list of rows
  return(split(pairs, rep(1:nrow(pairs), each = ncol(pairs))) %>% array)
}

# Returns a 11-dim vector for the supplied word
vector_for_word <- function(word) {
  v <- norms[norms$Word == word, all_columns]
  return(v)
}

# Returns a n x 11 matrix for the supplied words
matrix_for_words <- function(words) {
  # Use match to preserve the order from `words`
  mx <- as.matrix(norms[match(words, norms$Word), all_columns])
  return(mx)
}

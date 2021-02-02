# parses a block of word pairs.
# returns 3 lists:
#  1. list of pairs of words
#  2. list of words not in norms
#  3. list of malformed lines
get_word_pairs <- function(word_pairs_block) {
  
  left_words         <- list()
  right_words        <- list()
  words_not_in_norms <- list()
  malformed_lines    <- list()
  
  if (nchar(word_pairs_block) == 0) {
    return(list(
      "left_words" = left_words, 
      "right_words" = right_words,
      "words_not_in_norms" = words_not_in_norms, 
      "malformed_lines" = malformed_lines))
  }
  
  lines <- word_pairs_block %>% strsplit("\n")
  lines <- lines[[1]]
  
  for (line in lines) {
    bare_line <- str_trim(line)
    
    # Skip empty lines
    if (nchar(bare_line) == 0) { next }
    
    pair = bare_line %>% strsplit(":")
    pair = pair[[1]]
    if (!length(pair) == 2) {
      malformed_lines[length(malformed_lines)+1] = bare_line
      next
    }
    w1 <- str_trim(pair[1])
    w2 <- str_trim(pair[2])
    
    if (! w1 %in% norms$Word) {
      words_not_in_norms[length(words_not_in_norms)+1] <- w1
    }
    if (! w2 %in% norms$Word) { 
      words_not_in_norms[length(words_not_in_norms)+1] <- w2
    }
    if ((w1 %in% norms$Word) && (w2 %in% norms$Word)) { 
      left_words[length(left_words)+1] <- w1
      right_words[length(right_words)+1] <- w2
    }
  }
  
  left_words = unlist(left_words)
  right_words = unlist(right_words)
  
  
  return(list(
      "left_words" = left_words, 
      "right_words" = right_words,
      "words_not_in_norms" = words_not_in_norms, 
      "malformed_lines" = malformed_lines))
}

# Provides a text summary of word pairs
summarise_pairs <- function(left_words, right_words, words_not_in_norms, malformed_lines) {
  # Validate
  if (length(left_words) != length(right_words)) { stop('Pairs not matched') }
  
  message = ""
  if (length(left_words) == 0) {
    return(message)
  }
  if (length(malformed_lines) > 0) {
    message = paste0(message, prettyNum(length(malformed_lines)), " invalid lines (including \"", malformed_lines[1], "\"). ")
  }
  if (length(words_not_in_norms) > 0) {
    message = paste0(message, prettyNum(length(words_not_in_norms)), " concepts not found (including \"", words_not_in_norms[1], "\"). ")
  }
  message = paste0(prettyNum(length(left_words)), " valid pairs entered. ", message)
  return(message)
}

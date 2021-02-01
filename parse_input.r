# parses a block of word pairs.
# returns 3 lists:
#  1. list of pairs of words
#  2. list of words not in norms
#  3. list of malformed lines
get_word_pairs <- function(word_pairs_block) {
  
  word_pairs         <- list()
  words_not_in_norms <- list()
  malformed_lines    <- list()
  
  if (nchar(word_pairs_block) == 0) {
    return(list(
      "word_pairs" = word_pairs, 
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
      word_pairs[[length(word_pairs)+1]] <- list(w1, w2)
    }
  }
  
  return(list(
    "word_pairs" = word_pairs, 
    "words_not_in_norms" = words_not_in_norms, 
    "malformed_lines" = malformed_lines))
}

# Provides a text summary of word pairs
summarise_pairs <- function(word_pairs, words_not_in_norms, malformed_lines) {
  message = ""
  if (length(word_pairs) == 0) {
    return(message)
  }
  if (length(malformed_lines) > 0) {
    message = paste0(message, prettyNum(length(malformed_lines)), " invalid lines (including \"", malformed_lines[1], "\"). ")
  }
  if (length(words_not_in_norms) > 0) {
    message = paste0(message, prettyNum(length(words_not_in_norms)), " concepts not found (including \"", words_not_in_norms[1], "\"). ")
  }
  message = paste0(prettyNum(length(word_pairs)), " valid pairs entered. ", message)
  return(message)
}

# provides a text summary of a word, potentially missing
summarise_word <- function(word, is_missing) {
  if(nchar(word) == 0) {
    return("")
  }
  if(is_missing) {
    return(paste0("Word \"", word, "\" not found in norms."))
  }
  else {
    return("")
  }
}

# Provides a text summary of list of words
summarise_words <- function(words, missing) {
  message = ""
  if (length(words) == 0) {
    return(message)
  }
  if (length(missing) > 0) {
    message = paste0(message, prettyNum(length(missing)), " concepts not found (including \"", missing[1], "\"). ")
  }
  message = paste0(prettyNum(length(words)), " words entered. ", message)
  return(message)
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

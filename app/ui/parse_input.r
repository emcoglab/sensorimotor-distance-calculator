# The canonical form of a word
canonise_word <- function(word) {
  return(word %>% str_trim %>% tolower)
}

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
  
  lines <- word_pairs_block %>% strsplit("\n") %>% unlist
  
  for (line in lines) {
    bare_line <- str_trim(line)
    
    # Skip empty lines
    if (nchar(bare_line) == 0) { next }
    
    pair = bare_line %>% strsplit("[:,;\t]") %>% unlist
    pair = Filter(function(s) {s != ""}, pair)
    if (!length(pair) == 2) {
      malformed_lines[length(malformed_lines)+1] = bare_line
      next
    }
    w1 <- canonise_word(pair[1])
    w2 <- canonise_word(pair[2])
    
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

# parses a block of words.
# returns 2 lists:
#  1. list of words (in norms)
#  2. list of words not in norms
get_words <- function(words_block) {
  
  words   <- list()
  missing <- list()
  
  if (nchar(words_block) == 0) {
    return(list(
      "words" = words, 
      "missing" = missing))
  }
  
  lines <- words_block %>% strsplit("\n")
  lines <- lines[[1]]
  
  for (line in lines) {
    bare_line <- str_trim(line)
    
    # Skip empty lines
    if (nchar(bare_line) == 0) { next }
    
    word <- canonise_word(bare_line)
    
    if (word %in% norms$Word) {
      words[length(words)+1] <- word
    }
    else {
      missing[length(missing)+1] <- word
    }
  }
  
  words = unique(unlist(words))
  missing = unique(unlist(missing))
  
  return(list(
    "words" = words, 
    "missing" = missing))
}

# tries to convert `input` to a float.
# params:
#  input
#  default - on failure, this is returned as result
#  empty_to_default - if true (not the default), an empty string results in a successful parse to the default value
# returns list of:
#  value: float
#  success: bool
try_parse_float <- function(input, default_value, empty_to_default = FALSE) {

  if (empty_to_default && (nchar(input) == 0)) {
    return(list(
      value=default_value,
      success=TRUE,
      original=input
    ))
  }
  
 ret = tryCatch(
    { 
      return(list(
        value=as.double(input),
        success=TRUE,
        original=input
      ))
    },
    warning=function(w) {
      return(list(
        value=default_value,
        success=FALSE,
        original=input
      )) 
    }
  )
  return(ret)
}

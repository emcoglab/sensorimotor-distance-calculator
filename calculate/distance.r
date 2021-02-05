distance_name <- function(distance_type) {
  if (distance_type == "minkowski3") {
    return("Minkowski-3")
  }
  else if(distance_type == "euclidean") {
    return("Euclidean")
  }
  else if(distance_type == "cosine") {
    return("cosine")
  }
  else if(distance_type == "correlation") {
    return("correlation")
  }
  else {
    stop("Unsupported distance type")
  }
}

distance_col_name <- function(distance_type) {
  name <- paste0(distance_name(distance_type), " distance")
  name <- capitalize(tolower(name))  # Just the first letter is capitalised
  return(name)
}

distance_matrix <- function(matrix_left, matrix_right, distance_type) {
  if (distance_type == "minkowski3") {
    distances <- cdist(matrix_left, matrix_right, metric="minkowski", p=3)
  }
  else if(distance_type == "euclidean") {
    distances <- cdist(matrix_left, matrix_right, metric="euclidean", p=2)
  }
  else if(distance_type == "cosine") {
    distances <- cdist(matrix_left, matrix_right, metric=function(x, y) {1 - (x %*% y / sqrt(x%*%x * y%*%y))} )
  }
  else if(distance_type == "correlation") {
    distances <- cdist(matrix_left, matrix_right, metric="correlation")
  }
  else {
    stop("Unsupported distance type")
  }
  return(distances)
}

distance_col_name <- function(distance_type) {
  if (distance_type == "minkowski3") {
    distance_col_name <- "Minkowski-3 distance"
  }
  else if(distance_type == "euclidean") {
    distance_col_name <- "Euclidean distance"
  }
  else if(distance_type == "cosine") {
    distance_col_name <- "Cosine distance"
  }
  else if(distance_type == "correlation") {
    distance_col_name <- "Correlation distance"
  }
  else {
    stop("Unsupported distance type")
  }
  return(distance_col_name)
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

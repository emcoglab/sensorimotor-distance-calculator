# Gets the canonical display name for a distance_type
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
  else if(distance_type == "mahalanobis") {
    return("Mahalanobis")
  }
  else {
    stop("Unsupported distance type")
  }
}

# Gets the display column name for a distance type
distance_col_name <- function(distance_type) {
  name <- paste0(distance_name(distance_type), " distance")
  name <- capitalize(tolower(name))  # Just the first letter is capitalised
  return(name)
}

# Computes a distance matrix from two data matrices
distance_matrix <- function(matrix_left, matrix_right, distance_type, covariance_matrix = NULL) {
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
    # For some reason, when you tell rdist to do "correlation distance", it
    # actually does square root of half the correlation distance
    # this is probably to make it a metric distance.
    # either way, this is not what we want, and we correct it here
    distances <- cdist(matrix_left, matrix_right, metric="correlation") ^ 2 * 2
  }
  else if(distance_type == "mahalanobis") {
    invCov = solve(covariance_matrix)
    distances <- cdist(matrix_left, matrix_right, metric=function(x, y) {sqrt(t(x-y) %*% invCov %*% (x-y))})
  }
  else {
    stop("Unsupported distance type")
  }
  return(distances)
}

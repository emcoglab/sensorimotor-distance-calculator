# A set of distance choices with canonical names
distance_choices <-  list(
  "Euclidean distance"   = "euclidean",
  "Minkowski-3 distance" = "minkowski3",
  "Cosine distance"      = "cosine",
  "Correlation distance" = "correlation")
distance_default <- "minkowski3"

# A distance selector with a given id (to which _distance is appended)
distance_select_with_id <- function(inputId) {
  return(
    selectInput(
      inputId = paste0(inputId, "_distance"),
      label = "Distance select",
      choices = distance_choices,
      selected = distance_default))
}

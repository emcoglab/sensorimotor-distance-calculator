distance_select_with_id <- function(inputId) {
  return(
    selectInput(
      inputId = paste("distance_", inputId, sep=""),
      label = "Distance select",
      choices = distance_choices,
      selected = distance_default))
}

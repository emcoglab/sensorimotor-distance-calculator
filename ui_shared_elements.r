distance_select_with_id <- function(inputId) {
  return(
    selectInput(
      inputId = paste0("distance_", inputId),
      label = "Distance select",
      choices = distance_choices,
      selected = distance_default))
}

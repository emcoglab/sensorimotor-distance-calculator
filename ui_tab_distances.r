source("ui_shared_elements.r")


distance_choices <-  list(
  "Euclidean distance"   = "euclidean",
  "Minkowski-3 distance" = "minkowski3",
  "Cosine distance"      = "cosine",
  "Correlation distance" = "correlation")
distance_default <- "minkowski3"

tab_one_to_one <- tabPanel(
  title = "One-to-one",
  h3("Calculate the distance between concept pairs"),
  distance_select_with_id("one_to_one"),
  helpText(
    "Enter pairs of concepts separated by colons, with each pair on a ",
    "separate line."),
  textAreaInput(
    inputId = "word_pairs",
    label = "Concept pairs",
    rows = 10),
  conditionalPanel(
    condition = "input.word_pairs.length == 0",
    actionButton("show_me", label = "Random word pairs"),
  ),
  conditionalPanel(
    condition = "input.word_pairs.length > 0",
    actionButton("clear", label = "Clear"),
  ),
  textOutput("summary_pairs"),
  helpText(
    "Calculate distances between pairs of concepts' ",
    "vector representations. Select the distance ",
    "type from the drop-down, and enter pairs of ",
    "concepts in the text box. Click the 'show me' ",
    "button to start with random concepts.")
)

tab_distances <- tabPanel(
  title = "Calculate distances",
  sidebarPanel(
    tabsetPanel(
      tab_one_to_one,
      id = "distance_mode",
      type = "pills"
    )),
  mainPanel(
    tableOutput(outputId = "pairs_table"),
  ))

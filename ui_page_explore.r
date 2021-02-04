source("ui_shared_elements.r")

page_explore <- tabPanel(
  title = "Explore sensorimotor space",
  sidebarLayout(
    sidebarPanel(
      h3("Explore sensorimotor space"),
      distance_select_with_id("explore"),
      selectInput(
        inputId = "explore_dominance",
        label = "Colour concepts by their dominance in",
        choices = list(
          "Sensorimotor modality" = "sensorimotor",
          "Perceptual modality" = "perceptual",
          "Action modality" = "action"
        ),
        selected = "sensorimotor"
      ),
      helpText(
        "Plot a t-SNE arrangement of all sensorimotor concepts. Select the ",
        "distance type from the drop-down. Chose whether to colour points by ",
        "dominance in perceptual, action or sensorimor components. Click an ",
        "entry in the legend to hide those points; double-click to hide other ",
        "points. Mouse-over the plot to show other controls. Legend colours ",
        "are selected at random."
      ),
    ),
    mainPanel(
      plotlyOutput(outputId = "explore_tsne_plot",
                   height='80vh')
    )
  )
)

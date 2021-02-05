source("ui/shared_elements.r")

page_explore <- tabPanel(
  title = "Explore sensorimotor space",
  sidebarLayout(
    sidebarPanel(
      h3("Explore sensorimotor space"),
      distance_select_with_id("explore"),
      radioButtons(
        inputId = "explore_dominance",
        label = "Colour concepts by their dominance in",
        choices = list(
          "Sensorimotor modality" = "sensorimotor",
          "Perceptual modality" = "perceptual",
          "Action modality" = "action"
        ),
        selected = "sensorimotor"
      ),
      helpText(includeMarkdown("ui/help_text/explore.md")),
    ),
    mainPanel(
      withSpinner(
        plotlyOutput(outputId = "explore_tsne_plot",
                     height='60vh')
      )
    )
  )
)

source("ui/shared_elements.r")

page_explore <- tabPanel(
  title = "Explore sensorimotor space",
  sidebarLayout(
    sidebarPanel(
      h3("Explore sensorimotor space"),
      aboutText(includeMarkdown("ui/page_text/explore.md")),
      distance_select_with_id("explore"),
      radioButtons(
        inputId = "explore_dominance",
        label = "Colour concepts by their dominance in",
        choices = list(
          "Sensorimotor dimension" = "sensorimotor",
          "Perceptual modality" = "perceptual",
          "Action effector" = "action"
        ),
        selected = "sensorimotor"
      ),
      helpText(includeMarkdown("ui/help_text/dominance_colouring.md")),
    ),
    mainPanel(
      helpText(includeMarkdown("ui/help_text/t-sne.md")),
      withSpinner(
        plotlyOutput(
          outputId = "explore_tsne_plot",
          height='60vh'
        )
      )
    )
  )
)

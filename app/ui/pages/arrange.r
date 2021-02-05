source("ui/shared_elements.r")

page_arrange <- tabPanel(
  title = "Arrange concepts",
  sidebarLayout(
    sidebarPanel(
      h3("Arrange concepts"),
      textAreaInput(
        inputId = "arrange_words",
        label = "Other concepts",
        rows = 10
      ),
      conditionalPanel(
        condition = "input.arrange_words.length == 0",
        actionButton("arrange_button_random", label = "Random words"),
      ),
      conditionalPanel(
        condition = "input.arrange_words.length > 0",
        actionButton("arrange_button_clear", label = "Clear"),
      ),
      textOutput("arrange_words_summary"),
      distance_select_with_id("arrange"),
      selectInput(
        inputId = "arrange_show_lines",
        label = "Connecting lines",
        choices = list(
          "Show lines" = TRUE,
          "Hide lines" = FALSE
        ),
        selected = TRUE),
      helpText(includeMarkdown("ui/help_text/arrange.md")),
    ),
    mainPanel(
      withSpinner(
        plotlyOutput(outputId = "arrange_mds_plot")
      )
    )
  )
)

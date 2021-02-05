source("ui/shared_elements.r")

page_visualise <- tabPanel(
  title = "Visualise concepts",
  sidebarLayout(
    sidebarPanel(
      h3("Visualise concepts"),
      helpText(includeMarkdown("ui/help_text/text_entry_words.md")),
      textAreaInput(
        inputId = "visualise_words",
        label = "Concepts",
        rows = 10
      ),
      conditionalPanel(
        condition = "input.visualise_words.length == 0",
        actionButton("visualise_button_random", label = "Random words"),
      ),
      conditionalPanel(
        condition = "input.visualise_words.length > 0",
        actionButton("visualise_button_clear", label = "Clear"),
      ),
      textOutput("visualise_words_summary") %>% tagAppendAttributes(class = 'summary'),
      distance_select_with_id("visualise"),
      checkboxInput(
        inputId = "visualise_show_lines",
        label = "Show connecting lines",
        value = FALSE),
      helpText(includeMarkdown("ui/help_text/visualise.md")),
    ),
    mainPanel(
      withSpinner(
        plotlyOutput(outputId = "visualise_mds_plot")
      )
    )
  )
)

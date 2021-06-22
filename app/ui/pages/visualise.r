source("ui/shared_elements.r")

page_visualise <- tabPanel(
  title = "Visualise concepts",
  sidebarLayout(
    sidebarPanel(
      h3("Visualise concepts"),
      aboutText(includeMarkdown("ui/page_text/visualise.md")),
      textAreaInput(
        inputId = "visualise_words",
        label = "Concepts",
        rows = 10
      ),
      helpText(includeMarkdown("ui/help_text/text_entry_words.md")),
      conditionalPanel(
        condition = "input.visualise_words.length == 0",
        actionButton("visualise_button_random", label = "Random words"),
      ) %>% tagAppendAttributes(class = "inline"),
      conditionalPanel(
        condition = "input.visualise_words.length > 0",
        actionButton("visualise_button_clear", label = "Clear"),
      ) %>% tagAppendAttributes(class = "inline"),
      summaryText("visualise_words_summary"),
      distance_select_with_id("visualise"),
      checkboxInput(
        inputId = "visualise_show_lines",
        label = "Show connecting lines",
        value = TRUE
      ),
      helpText(includeMarkdown("ui/help_text/connecting_lines.md")),
    ),
    mainPanel(
      withSpinner(
        plotlyOutput(outputId = "visualise_mds_plot")
      )
    )
  )
)

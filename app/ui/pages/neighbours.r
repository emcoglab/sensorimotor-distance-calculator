source("ui/shared_elements.r")

page_neighbours <- tabPanel(
  title = "Find neighbours",
  sidebarLayout(
    sidebarPanel(
      h3("Find neighbours"),
      aboutText(includeMarkdown("ui/page_text/neighbours.md")),
      textInput(
        inputId = "neighbour_word",
        label = "Concept"
      ),
      helpText(includeMarkdown("ui/help_text/text_entry_word.md")),
      conditionalPanel(
        condition = "input.neighbour_word.length == 0",
        actionButton("neighbour_word_button_random", label = "Random word"),
      ) %>% tagAppendAttributes(class = "inline"),
      conditionalPanel(
        condition = "input.neighbour_word.length > 0",
        actionButton("neighbour_word_button_clear", label = "Clear"),
      ) %>% tagAppendAttributes(class = "inline"),
      summaryText("neighbour_word_summary"),
      selectInput(
        choices=c(10, 20, 30, 40, 50, 100, 200),
        label="Number",
        inputId="neighbours_count"
      ),
      helpText(includeMarkdown("ui/help_text/neighbour_count.md")),
      textInput(
        inputId = "neighbour_radius",
        label = "Within distance",
        placeholder = "Any distance"
      ),
      helpText(includeMarkdown("ui/help_text/neighbour_distance.md")),
      conditionalPanel(
        condition = "input.neighbour_radius.length > 0",
        actionButton("neighbour_button_any_distance", label = "Any distance"),
        summaryText("neighbour_radius_summary"),
      ) %>% tagAppendAttributes(class = "inline"),
      distance_select_with_id("neighbours"),
    ),
    mainPanel(
      checkboxInput("will_show_results_neighbours", label="") %>% tagAppendAttributes(class = 'hidden'),
      conditionalPanel(
        condition = "input.will_show_results_neighbours",
        downloadButton(outputId = "neighbour_table_download",
                       label = "Download [.csv]"),
        tableOutput(outputId = "neighbours_table")
      )
    )
  )
)

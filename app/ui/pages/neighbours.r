source("ui/shared_elements.r")

page_neighbours <- tabPanel(
  title = "Find neighbours",
  sidebarLayout(
    sidebarPanel(
      h3("Find neighbours"),
      helpText(includeMarkdown("ui/help_text/text_entry_word.md")),
      textInput(
        inputId = "neighbour_word",
        label = "Concept"
      ),
      conditionalPanel(
        condition = "input.neighbour_word.length == 0",
        actionButton("neighbour_word_button_random", label = "Random word"),
      ),
      conditionalPanel(
        condition = "input.neighbour_word.length > 0",
        actionButton("neighbour_word_button_clear", label = "Clear"),
      ),
      textOutput("neighbour_word_summary") %>% tagAppendAttributes(class = 'summary'),
      selectInput(
        choices=c(10, 20, 30, 40, 50, 100, 200),
        label="Number",
        inputId="neighbours_count"
      ),
      textInput(
        inputId = "neighbour_radius",
        label = "Within distance",
        placeholder = "Any distance"
      ),
      conditionalPanel(
        condition = "input.neighbour_radius.length > 0",
        actionButton("neighbour_button_any_distance", label = "Any distance"),
      ),
      textOutput("neighbour_radius_summary") %>% tagAppendAttributes(class = 'summary'),
      distance_select_with_id("neighbours"),
      helpText(includeMarkdown("ui/help_text/neighbours.md")),
    ),
    mainPanel(
      checkboxInput("will_show_table_neighbours", label="") %>% tagAppendAttributes(class = 'hidden'),
      conditionalPanel(
        condition = "input.will_show_table_neighbours",
        tableOutput(outputId = "neighbours_table"),
        downloadButton(outputId = "neighbour_table_download",
                       label = "Download [.csv]")
      )
    )
  )
)

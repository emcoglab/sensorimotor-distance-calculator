source("ui_shared_elements.r")

page_neighbours <- tabPanel(
  title = "Find neighbours",
  sidebarLayout(
    sidebarPanel(
      h3("Find neighbours"),
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
      textOutput("neighbour_word_summary"),
      helpText(
        "Find nearest neighbours of a concept via its vector representation. ",
        "Select the number of neighbours to find, optionally restrict to a ",
        "maximum distance, and selec the distance type from the drop down."
      ),
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
      textOutput("neighbour_radius_summary"),
      distance_select_with_id("neighbours"),
    ),
    mainPanel(
      tableOutput(outputId = "neighbours_table"),
      conditionalPanel(
        # TODO: based on table output, not words input... or hidden shared input?
        condition = "input.neighbour_word.length > 0",
        downloadButton(outputId = "neighbour_table_download",
                       label = "Download [.csv]")
      )
    )
  )
)

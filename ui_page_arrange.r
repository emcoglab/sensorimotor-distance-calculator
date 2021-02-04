source("ui_shared_elements.r")

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
        actionButton("arrange_button_random", label = "Randoms"),
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
      helpText(
        "Plot an MDS (multidimensional scaling) arrangemet of concepts using ",
        "their vector representations. Enter a list of concepts in the text ",
        "box (maximum of 20), click the 'Refresh graph' button to update the ",
        "graph. Change the distance measure and whether to connect concept ", 
        "points with lines using the drop-downs. Click the 'show me' button ",
        "to start with a random concept."
      ),
    ),
    mainPanel(
      plotlyOutput(outputId = "arrange_mds_plot")
    )
  )
)

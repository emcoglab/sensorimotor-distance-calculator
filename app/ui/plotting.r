source("meta.r")
source("calculate/norms.r")
source("calculate/distance.r")

# Returns data.frame of positions for given words after MDS
get_mds_positions_for_words <- function(words, distance_type, max_words = Inf) {

  if (length(words) < 3) { return(NULL) }
  if (length(words) > max_words) { words = words[1:max_words] }

  data_matrix <- matrix_for_words(words)
  d <- distance_matrix(data_matrix, data_matrix, distance_type)

  if (distance_type %in% c("euclidean", "minkowski3")) {
    # Use metric MDS
    points <- cmdscale(d)
  }
  else if (distance_type %in% c("cosine", "correlation")) {
    # In case the distances are very far from metric, `isoMDS` and `sammon` may
    # crash or produce degenerate solutions due to its use of cmdscale to
    # produce the initial configuration.
    # Therefore we provide a random initial configuration.
    # First we set the random seed to make the output reproducible
    set.seed(0)
    initial_positions <- matrix(runif(length(words) * 2), nrow=length(words))
    # isoMDS has a tendency to produce degenerate solutions, so we prefer sammon
    fit <- sammon(d, y = initial_positions, k = 2)
    points <- fit$points
  }
  else { stop("Unsupported distance function.")}


  positions <- data.frame(points)
  positions <- cbind(words, positions)
  names(positions) <- c("Word", "x", "y")

  return(positions)
}

# Returns a plot for a data.frame of mds positions,
# with or without connecting lines
mds_plot <- function(mds_positions, with_lines) {

  if (is.null(mds_positions)) {
    return(NULL)
  }

  axis <- list(
    title = "",
    showgrid = FALSE,
    showticklabels = FALSE,
    zeroline = FALSE,
    fixedrange = TRUE)

  nodes <- plot_ly(mds_positions) %>%
    config(
      toImageButtonOptions = list(
        format = "svg",
        filename = "mds-plot",
        width = 600,
        height = 700
      )
    ) %>%
    add_trace(x = ~x, y = ~y, type = 'scatter', mode="markers+text", text = ~Word, textposition='bottom')

  if (with_lines) {
    fig <- layout(
      nodes,
      shapes= get_mds_line_segments(mds_positions),
      xaxis = axis, yaxis = axis
    )
  }
  else {
    fig <- layout(
      nodes,
      xaxis = axis, yaxis = axis
    )
  }

  return(fig)
}

# Helper function to get all line segments between points
get_mds_line_segments <- function(mds_positions) {
  segments = list()
  for (i in 1:nrow(mds_positions)) {
    for (j in 1:nrow(mds_positions)) {
      if(i == j) { next }
      segments[[length(segments)+1]] <- list(
        type = "line",
        line = list(color = 'lightblue', width = 0.5),
        x0 = mds_positions[i, "x"],
        y0 = mds_positions[i, "y"],
        x1 = mds_positions[j, "x"],
        y1 = mds_positions[j, "y"]
      )
    }
  }
  return(segments)
}

# Get (load) a data.frame of t-sne positions for all the norms
get_tsne_positions <- function(distance_type, dims) {
  infile <- paste0(data_dir, "t-SNE_", dims, "_", distance_name(distance_type), "_cache.bin")
  con <- file(infile, "rb")
  dim <- readBin(con, "integer", 2)
  Mat <- matrix( readBin(con, "numeric", prod(dim)), dim[1], dim[2])
  close(con)

  ret <- data.frame(Mat)
  ret <- cbind(all_words, ret)
  if (dims == 3) {
    names(ret) <- c("Word", "x", "y", "z")
  }
  else if (dims == 2) {
    names(ret) <- c("Word", "x", "y")
  }
  else { stop("Only supports 2- or 3-dimensional plotting!") }

  return(ret)
}

# A plotly plot for t-sne exploration
tsne_plot <- function(tsne_positions, dominance, dims) {

  # Dominance colouring
  if (dominance == "sensorimotor") {
    tsne_positions["Dominance"] = norms[dominance_column_sensorimotor]
  }
  else if (dominance == "perceptual") {
    tsne_positions["Dominance"] = norms[dominance_column_perceptual]
  }
  else if (dominance == "action") {
    tsne_positions["Dominance"] = norms[dominance_column_action]
  }
  else { stop("Invalid dominance selection.") }

  # Set up figure
  if (dims == 3) {
    fig <- plot_ly(tsne_positions) %>%
      config(
        toImageButtonOptions = list(
          format = "svg",
          filename = "tsne-plot",
          width = 600,
          height = 700
        )
      ) %>%
      add_trace(type="scatter3d",
                mode="markers",
                marker=list(
                  size=2,
                  opacity=0.7
                ),
                x=~x, y=~y, z=~z,
                hoverinfo='text', text=~Word,
                color=~Dominance, colors="Set3")
  }
  else if (dims == 2) {
    fig <- plot_ly(tsne_positions) %>%
      config(
        toImageButtonOptions = list(
          format = "svg",
          filename = "tsne-plot",
          width = 600,
          height = 700
        )
      ) %>%
      add_trace(type="scatter",
                mode="markers",
                marker=list(
                  size=2,
                  opacity=0.7
                ),
                x=~x, y=~y,
                hoverinfo='text', text=~Word,
                color=~Dominance, colors="Set3")
  }
  else { stop("Only supports 2- or 3-dimensional plotting!") }

  fig <- fig %>%
    layout(
      scene=list(
        xaxis=list(
          showspikes=FALSE,
          visible=FALSE),
        yaxis=list(
          showspikes=FALSE,
          visible=FALSE),
        zaxis=list(
          showspikes=FALSE,
          visible=FALSE)
      ),
      legend=list(
        x=0, y=1,
        title=list(text='Click to turn on/off'),
        itemsizing="constant"))

  return(fig)
}

source("meta.r")
source("norms.r")
source("distance.r")

get_mds_positions_for_words <- function(words, distance_type) {
  
  if (length(words) < 3) { return(NULL) }
  if (length(words) > 20) { words = words[1:20] }
  
  data_matrix <- matrix_for_words(words)
  d <- distance_matrix(data_matrix, data_matrix, distance_type)
  
  fit <- cmdscale(d)
  
  ret <- data.frame(fit)
  ret <- cbind(words, ret)
  names(ret) <- c("Word", "x", "y")
  
  return(ret)
}

mds_plot <- function(mds_positions, with_lines) {
  
  if (is.null(mds_positions)) {
    return(NULL)
  }
  
  axis <- list(title = "", showgrid = FALSE, showticklabels = FALSE, zeroline = FALSE)
  
  nodes <- plot_ly(mds_positions) %>% add_trace(x = ~x, y = ~y, type = 'scatter', mode="markers+text", text = ~Word, textposition='bottom')
  
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

get_tsne_positions <- function(distance_type, dims) {
  infile <- paste0(data_dir, "t-SNE_", dims, "_", distance_name(distance_type), "_cache.bin")
  con <- file(infile, "rb")
  dim <- readBin(con, "integer", 2)
  Mat <- matrix( readBin(con, "numeric", prod(dim)), dim[1], dim[2])
  close(con)
  
  ret <- data.frame(Mat)
  ret <- cbind(all_words, ret)
  names(ret) <- c("Word", "x", "y", "z")
  
  return(ret)
}

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
  else { stop("Not implemented yet") }
  
  fig <- fig %>%
    layout(
      legend=list(
        x=0, y=1, 
        itemsizing="constant"))
  
  return(fig)
}

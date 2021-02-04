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

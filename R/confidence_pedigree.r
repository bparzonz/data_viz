# Load libraries
library(plotly)
# Load Dataframe
df_confidence <- data.frame(confidence = c(3,3,3,5,3,2,3,5,
                                2,2,NA,2,2,2,3,5,
                                2,4,3,2,2,2,3,5),
                comments = c("1", "2", "3", 
            "4", "5", "6",
            "7", "8", "9",
            "10", "11", "12",
            "13", "14", "15",
            "16", "17", "18",
            "19", "20", "21",
            "22", "23", "24"))

# Create Matrix
m <- matrix(df_confidence[,1], nrow = 8, ncol = 3)
commentmatrix <- matrix(df_confidence[,2], nrow = 8, ncol = 3)

# plot matrix
t <- list(
  family = "Times New Roman",
  size = 16,
  color = 'black')

confidence_pedigree <- plot_ly(
    x = c("EMD", "O&S", "P&D"), 
    y = c("Overall Assessment", "Budget Equals Estimate", "Risk Assessment (Cost Schedule Technical)",
    "Crosschecks", "Cost & Methodology", "Schedule Baseline", "Engineering Technical Baseline", "Requirements Definition"),
    z = m,
    zmin = 1,
    zmax = 5, 
    colors = colorRamp(c("red", "yellow", "green")),
    #colors = list([1, "FF0000"], [2, "ff6600"], [3, "FFCC00"], [4, "99ff00"], [5, "33ff00"]),
    type = "heatmap",
    hoverinfo = "text",
    text = commentmatrix) %>% 
    layout(title = list(text = "<i>Confidence Pedigree<i>", x = .1),
          xaxis = list(side = "top", 
                      title = "Program Phase <br> <br>", 
                      mirror = TRUE,
                      linewidth = 2,
                      linecolor = "black",
                      showline = TRUE), 
          yaxis = list(categoryorder = "trace", 
                      title = "Confidence Enablers <br> <br> <br> <br> <br> <br> <br> <br>",
                      mirror = TRUE,
                      linewidth = 2,
                      linecolor = "black",
                      showline = TRUE), 
          margin = list(l=10, r=10, b=10, t=10),
          font = t) %>%
    colorbar(tickvals = c(1, 2, 3, 4, 5))

confidence_pedigree


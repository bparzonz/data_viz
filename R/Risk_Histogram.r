### Load libraries
library(plotly)
library(ggplot2)

# This dataframe would normally contain a montecarlo output in powerbi. 
# To make it function here, rnorm() is used. Use the hash text instead in powerbi.
x <- rnorm(5000)  #Values[,1] #grab first columns vlaues in dataframe as a list
pe <- rnorm(5000) #Values[,2] #grab second columns vlaues in dataframe as a list 
meanvalues <- rnorm(5000)

### Get stats
# Statistics cannot be retrieved from a plotly object. To get around this, a ggplot object is rendered simultaneously with the same parameters.
gghist = ggplot(as.data.frame(x), aes(x = x)) + geom_histogram(bins = 100, aes(y = ..density..))
fig <- plot_ly(x = x, type = "histogram", histnorm = "probability density", name = "Histogram", nbinsx = 100, color = I("#094780"))

# create CDF function and overlay onto histogram
cdf <- ecdf(x)
fig <- fig %>% add_lines(x = x, y = cdf(x), name = "CDF", yaxis = "y2", xaxis = "x1", color = I("red")) 

# calculate y1 (histogram) max for accurate tickmark intervals (so both y axises line up). This is done using the fucntion below to store the needed statistics in a usuable dataframe.     
get_hist <- function(p) {
    d <- ggplot_build(p)$data[[1]]
    data.frame(x = d$x, xmin = d$xmin, xmax = d$xmax, y = d$y)
}

histstats <- get_hist(gghist) # store dataframe from function

y1max <- max(histstats$y) # find the max min value.

### Create formating for the first and second y axis
ay <- list(
    dtick = y1max/5,
    range  = c(0,y1max),
    showticklabels = FALSE
)

by <- list(
  tickformat = ".1f",
  overlaying = "y",
  side = "right",
  range = c(0,1),
  dtick = .2)

### The following functions dynamically caluclate desired statistics and plot a line segment displaying where it would appear on the cdf
# calculate mean cordinates to draw a mean line for selected data
#meancordinates <- function(xdata) {
 #   xcord = mean(xdata)
  #  meancord = list(xcord = xcord, meanycord = cdf(xcord))
   # return(meancord)
    #}
#mean = meancordinates(x)

#add mean cordinates to line segment and plot to graph
#fig <- fig %>% add_segments(
 #   x = mean$xcord, xend = mean$xcord, 
  #  y = 0, yend = mean$meanycord,
   # name = "Mean",
    #yaxis = "y2",
    #xaxis = "x1",
    #color = I("purple"))

# calculate median cordinates to draw a median line for selected data
# calculate the PE cordinates to draw a PE line for selected data
estimatedcoordinates = function(data) { 
    xcord = data[1]
    pointcord = list(xcord = xcord, ycord = cdf(xcord))
    return(pointcord)
}

point = estimatedcoordinates(pe)
mean = estimatedcoordinates(meanvalues)

# add alternate mean input coordinate to line segment and plot to graph
fig <- fig %>% add_segments(
    x = mean$xcord, xend = mean$xcord, 
    y = 0, yend = mean$ycord,
    name = "Mean",
    yaxis = "y2",
    xaxis = "x1",
    color = I("yellow"))

# add PE cordinates to line segment and plot to graph
fig <- fig %>% add_segments(
    x = point$xcord, xend = point$xcord, 
    y = 0, yend = point$ycord,
    name = "Point Estimate",
    yaxis = "y2",
    xaxis = "x1",
    color = I("green"))

# add second y axis to plot
fig <- fig %>% layout(
    showlegend = FALSE,
    yaxis = ay, 
    yaxis2 = by,
    margin = (r = 20)
)

# graph

fig
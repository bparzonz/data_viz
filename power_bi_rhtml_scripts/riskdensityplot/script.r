source('./r_files/flatten_HTML.r')

############### Library Declarations ###############
libraryRequireInstall("ggplot2");
libraryRequireInstall("plotly");
####################################################

################### Actual code ####################
#create dataframe with monecarlo data

# plot histogram of risk density using monte carlo output
x <- Values[,1] #grab first columns vlaues in dataframe as a list
pe <- Values[,2] #grab second columns vlaues in dataframe as a list 
meanvalues <- Values[,3] #grab third columns vlaues in dataframe as a list 

# create histogram with 100 bins using ggplot. Ggplot is used and then converted to plotly becuase 
# the histogram statistics cant be easily grabbed from a plotly object
gghist = ggplot(as.data.frame(x), aes(x = x)) + geom_histogram(bins = 100, aes(y = ..density..));  
fig = plot_ly(x = x, type = "histogram", histnorm = "probability density", name = "Histogram", nbinsx = 100, color = I("#094780")); #convert ggplot to plotly object

# use function ecdf to create CDF function and overlay onto histogram
cdf = ecdf(x);

# calculate y1 (histogram) max for accurate tickmark intervals. This is done becuase plotly does a poor job of overlaying 
# the cdf with the histogram. The next few steps makes sure that the axises and tixk marks lay right on top of each other

# The get_hist function grabs statistics from the ggplot histogram object, importantly the 100 y bin values
get_hist = function(p) {
    d = ggplot_build(p)$data[[1]]
    data.frame(x = d$x, xmin = d$xmin, xmax = d$xmax, y = d$y)
};

histstats = get_hist(gghist); 

# grab the largest bin value and save it as y1max
y1max = max(histstats$y);

# add formating for the first and second y axis
ay <- list(
    dtick = y1max/5, # there will be a tick mark at every 1/5 of the y1max interval. 
    range  = c(0,y1max),
    showticklabels = FALSE # dont show these labels. This is done becuase the number count can be quite large and hard to fit
);

# formating the cdf axis tick marks (2nd axis) to align with the histogram tick marks. 
# There will be a tick mark at every 1/5 interval (aligning with the 1/5 y1 intervals)
by = list(
  tickformat = ".1f",
  overlaying = "y",
  side = "right",
  range = c(0,1),
  dtick = .2);


fig = fig %>% add_lines(x = x, y = cdf(x), name = "CDF", yaxis = "y2", xaxis = "x1", color = I("red")) ;

# calculate mean cordinates to draw a mean line for selected data
estimatedcoordinates = function(data) { 
    xcord = data[1]
    pointcord = list(xcord = xcord, ycord = cdf(xcord))
    return(pointcord)
};

point = estimatedcoordinates(pe);
mean = estimatedcoordinates(meanvalues);

# add alternate mean input coordinate to line segment and plot to graph
fig <- fig %>% add_segments(
    x = mean$xcord, xend = mean$xcord, 
    y = 0, yend = mean$ycord,
    name = "Mean",
    yaxis = "y2",
    xaxis = "x1",
    color = I("yellow")
);

# add PE cordinates to line segment and plot to graph
fig <- fig %>% add_segments(
    x = point$xcord, xend = point$xcord, 
    y = 0, yend = point$ycord,
    name = "Point Estimate",
    yaxis = "y2",
    xaxis = "x1",
    color = I("green")
);

# add second y axis to plot
fig <- fig %>% layout(
    showlegend = FALSE,
    yaxis = ay, 
    yaxis2 = by,
    margin = (r = 20)
);

# graph
internalSaveWidget(fig, 'out.html');
####################################################

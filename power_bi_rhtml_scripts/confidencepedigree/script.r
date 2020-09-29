source('./r_files/flatten_HTML.r')

############### Library Declarations ###############
libraryRequireInstall("ggplot2");
libraryRequireInstall("plotly");
libraryRequireInstall("stringr");
####################################################

################### Actual code ####################
# Load Dataframe
df = Values;

### Create Matrix
# Create x, y, z values for confidence level matrix and comment matrix
# Every row has the same comment, but different confidence values. 
# The comments need to be duplicated and the matrix reformatted.
df[,ncol(df)] = as.character(df[,ncol(df)]);
numrow = length(df[,2]); # the number of rows needed is the number of rows that have confidence values. The first column
# that has confidence values should be the second (after the column with row headers)
numcol = length(df)-2; # the number of columns needed are all except the first (which contains the row headers), 
# and the last (which contains the comments)

# commentmatrix is a function that duplicates the comment column for the number of columns with confidence values
commentmatrix = function(comments_column){
    commentvector = vector()
    i = 0
    while(i < numcol){
        commentvector = append(commentvector, comments_column)
        i = i + 1
        }
    return(commentvector)
};

zconflv = unname(unlist(df[,2:(ncol(df)-1)])); # Retrieve and store the confidence values.   
# Currently, they're stored within a dataframe which contains labeled lists, but they need to be extracted as a vector.
# Uname and unlist will acheive this for us.

zcomment = commentmatrix(df[,ncol(df)]); # use the commentmatrix function and store the output

# str_wrap allows for the tasteful wrapping of strings to make the comments more easily readible
zcomment = str_wrap(string = zcomment,
                             width = 20,
                             indent = 1,
                             exdent = 1);

# create matricies to be used by the heatmap
conflevelmatrix = matrix(data = zconflv, nrow = numrow , ncol = numcol);
commentmatrix = matrix(data = zcomment, nrow = numrow, ncol = numcol);

# plot matrix to heatmap
# create plotly figure
fig = plot_ly(
    x = c(colnames(df[2:(ncol(df)-1)])), # x values are the column names
    y = df[,1], # y values are row names
    z = conflevelmatrix, # z values are the confidence values
    zmin = 1,
    zmax = 5, 
    colors = colorRamp(c("red", "yellow", "green")), # colorRamp assigns scaled colors to each of the confidence values
    type = "heatmap", # type of plotly opject
    hoverinfo = "text", # turns on hover over text, and sets it to whatever value "text" is set to
    text = commentmatrix) %>% # sets text to the values in the comment matrix

# layout applies various formatting to the heatmap
    layout(xaxis = list(side = "top",  
                        linecolor = "black",
                        showline = TRUE,
                        tickangle = -45),
           yaxis = list(categoryorder = "trace", # makes sure that the categories maintain the order 
                                                 # that they are in in the dataframe
                        mirror = TRUE,
                        linewidth = 2,
                        linecolor = "black",
                        showline = TRUE),
           margin = list(l=10, r=10, b=10, t=10)) %>%
           
    colorbar(tickvals = c(1, 2, 3, 4, 5));
####################################################

############# Create and save widget ###############
internalSaveWidget(fig, 'out.html');
####################################################

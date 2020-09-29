source('./r_files/flatten_HTML.r')

############### Library Declarations ###############
libraryRequireInstall("ggplot2");
libraryRequireInstall("plotly")
####################################################

################### Actual code ####################
df <- Values[,c(1,2,3,4)]; #where column one is WBS# or unique WBS name, 2 is WBS, is parents, and 4 is estimate  

####################################################

############# Create and save widget ###############
fig <- plot_ly(df, ids = ~df[,1], labels = ~df[,2], parents = ~df[,3], values = ~df[,4], 
type = 'sunburst', branchvalues = 'total', textinfo = 'none');
internalSaveWidget(fig, 'out.html');
####################################################

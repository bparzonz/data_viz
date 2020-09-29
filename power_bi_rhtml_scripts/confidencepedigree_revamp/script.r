source('./r_files/flatten_HTML.r')

############### Library Declarations ###############
libraryRequireInstall("ggplot2");
libraryRequireInstall("plotly");
libraryRequireInstall("stringr");
libraryRequireInstall("reshape2");
####################################################

################### Actual code ####################
df = Values[,1:ncol(Values)-1];

df = melt(df, id.vars = "Confidence Enablers");

df$text = Values[, ncol(Values)];

fig = ggplot(df, aes(x = variable, 
                        y = df[,1], 
                        label = value, 
                        fill = as.factor(value),
                        text = stringr::str_wrap(
                          string = text,
                          width = 25,
                          indent = 1, # let's add extra space from the margins
                          exdent = 1  # let's add extra space from the margins
                        )
                      )
                    ) + 
              xlab("Program Phase") +
              ylab("") + 
              theme_minimal() +
              theme(legend.position = "none", 
              axis.text = element_text(size = 12), 
              axis.title = element_text(size = 15)) +
              geom_text(color = "black") +
              geom_tile(color = "black") +
              scale_fill_manual(values = c("red", "orange", "yellow", "#66CC00", "darkgreen")
            );


####################################################

############# Create and save widget ###############
fig = ggplotly(fig, tooltip = "text") %>% config(displayModeBar = F);
internalSaveWidget(fig, 'out.html');
####################################################

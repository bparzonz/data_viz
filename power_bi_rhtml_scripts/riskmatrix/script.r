source('./r_files/flatten_HTML.r')

############### Library Declarations ###############
libraryRequireInstall("ggplot2");
libraryRequireInstall("plotly");
libraryRequireInstall("dplyr");
libraryRequireInstall("stringr");
####################################################

################### Actual code ####################
# Create the data in the risk matrix
Consequence_score <- rep(c(1,2,4,6,12),5) # the rep function sequences the column values 5 times (1,2,4,6,12,1,2,4,6,12...)
Likelihood_score <- rep(c(1,2,4,6,12),each=5) # the rep function repeats each value in the column 5 times (1,1,1,1,1,2,2,2,2,2...)
Consequence <- rep(c(1:5),5)
Likelihood <- rep(c(1:5),each=5)
df <- data.frame(Consequence,Likelihood)
# Create two new columns based on the consequence and likelihood scores using the dplyr mutate function
# There are 4 risk levels. The risk levels are calculated by the case_when function below
df <- mutate(df, risk_score = Consequence_score * Likelihood_score,
             Risk = case_when(risk_score >= 0 & risk_score < 6 ~ 1,
                              risk_score >= 6 & risk_score < 12 ~ 2,
                              risk_score >= 12 & risk_score < 32  ~ 3,
                              risk_score >= 32 ~ 4));


# Create the riskmap using ggplot
risk_p <- ggplot(df,aes(x = Consequence, y = Likelihood, fill = Risk, )) + #creates a bargraph with the risk dataframe
  geom_tile() +
  scale_fill_gradientn(colours = c("#008000","#EEEE00","orange","red"), guide = FALSE) + # fill the 4 risk levels with green, yellow, orange, and red
  scale_x_continuous(breaks = 0:5, expand = c(0, 0)) + # put in spaces between each risk and likelihood level
  scale_y_continuous(breaks = 0:5, expand = c(0, 0)) +
  theme_bw()+ # use ggplot balck and white theme
  geom_hline(yintercept = seq(1.5,5.5), color = "white") + # add white lines inbetween each risk and likelihood level
  geom_vline(xintercept = seq(1.5,5.5), color = "white") +
  theme(legend.position = "none") + # don't show legend
  guides(color = guide_legend()) + # color the hover texts the same as the risk dot colors
# Randomly place dots for the program risks in the appropriate risk and likelihood square
  geom_jitter(data = Values,
              inherit.aes = FALSE, width= 0.3,height = 0.3,
              aes(y = Likelihood,
                  x = Consequence, 
                  col = Type,
                  text = paste("<b>ID#:</b>",ID,"<br>",
                               "<b>Type:</b>",Type,"<br>",
                               "<b>Risk:</b>",Risk,"<br>",
                               "<b>Plan:</b>",Plan))) +
# Set the color values for dot placednfor each risk. If your program has more than 8 risks then the risk matrix wont render properly
  scale_color_manual(values = c("#9400D3", "#009fdf", "#aaaaaa", "#AFB326", "#00FFFD", "#B36F24", "#010FE0", "#FF00ED"));
####################################################

############# Create and save widget ###############
# convert the ggplot object to plotly object
p = config(ggplotly(risk_p,tooltip = "text"));
internalSaveWidget(p, 'out.html');
####################################################

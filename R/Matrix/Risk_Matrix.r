### Load libraries
library(ggplot2)
library(plotly)
library(dplyr)
library(stringr)

### Load the dataframe
# xslx::read.xlsx requires rJava to function. rJava requries a Java8 install which is no longer offered by Oracle, and must be
# replaced with the opensource version on github. xlsx is powerful, but if this install is not possible other excel readers are available that are not Java based.
# Keeping the dataframe order is essentail to making the plot function. The dataframe order is:
# ID, Title, Risk, Type, Interim, Consequence, Likelihood
risk <- read.csv(file.choose(new = FALSE))

### Creating heatmap background for Risk Matrix
# setting the score in order to calculate the risk level
Consequence_score <- rep(c(1,2,4,6,12),5)
Likelihood_score <- rep(c(1,2,4,6,12),each = 5)
Consequence <- rep(c(1:5),5)
Likelihood <- rep(c(1:5),each = 5)
df <- data.frame(Consequence,Likelihood)
df <- mutate(df, risk_score = Consequence_score * Likelihood_score,
             Risk = case_when(risk_score >= 0 & risk_score < 6 ~ 1,
                              risk_score >= 6 & risk_score < 12 ~ 2,
                              risk_score >= 12 & risk_score < 32  ~ 3,
                              risk_score >= 32 ~ 4))


# Plotting using ggplot
risk_p <- ggplot(df,aes(x =Consequence, y = Likelihood, fill=Risk)) +
  geom_tile() +
  scale_fill_gradientn(colours = c("#008000","#EEEE00","orange","red"),guide = FALSE) +
  scale_x_continuous(breaks = 0:5, expand = c(0, 0)) +
  scale_y_continuous(breaks = 0:5, expand = c(0, 0)) +
  theme_bw()+
  geom_hline(yintercept = seq(1.5,5.5), color = "white") +
  geom_vline(xintercept = seq(1.5,5.5), color = "white") +
  theme(legend.position = "none") +
  # theme(axis.title.x=element_blank()) +
  # theme(axis.title.y=element_blank()) +
  # theme(plot.margin = unit(c(5,5,5,9),"cm")) +
  guides(color = guide_legend()) +
  geom_jitter(data = risk,
              inherit.aes = FALSE, width= 0.3,height = 0.3,
              aes(y = Likelihood,
                  x = Consequence, 
                  col = Type,
                  text = paste("<b>ID#:</b>",ID,"<br>",
                               "<b>Type:</b>",Type,"<br>",
                               "<b>Risk:</b>",Risk,"<br>",
                               "<b>Plan:</b>",Plan))) +
  scale_color_manual(values = c("#9400D3", "#009fdf", "#aaaaaa", "#AFB326", "#00FFFD", "#B36F24", "#010FE0", "#FF00ED") # there are 8 colors available to be applied depending on risk type.
  # If there are more than 8 risk types in the data frame then the plot will not load.
  )

### convert ggplot object to interactive plotly object and display %>% layout(autosize = FALSE, margin = list(r = 200, b = 200)) , width = 1000, height = 800
config(ggplotly(risk_p,tooltip = "text")) 
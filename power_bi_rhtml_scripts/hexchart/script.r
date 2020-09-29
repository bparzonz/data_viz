source('./r_files/flatten_HTML.r')

############### Library Declarations ###############
libraryRequireInstall("ggplot2");
libraryRequireInstall("plotly");
libraryRequireInstall("scales");
####################################################

################### Actual code ####################

### Values dataframe must be saved to a new object; power BI cannot make edits to original dataframe ###
data = Values;

### Coercing the required felids to be the approrpiate type, just in they are not imported that way. ###
### schedule_text must be formated as text (string), as month/day/year when in power BI###

data$schedule_text = as.Date(data$schedule_text, "%m/%d/%Y");
data$PE_Date = as.Date(gsub("T.*","", data$PE_Date), "%Y-%m-%d");
data$ME_Date = as.Date(gsub("T.*","", data$ME_Date), "%Y-%m-%d");
data$PP_Date = as.Date(gsub("T.*","", data$PP_Date), "%Y-%m-%d");
data$program_cost = as.numeric(data$program_cost);
data$PE_Cost = as.numeric(data$PE_Cost);
data$ME_Cost = as.numeric(data$ME_Cost);
data$PP_Cost = as.numeric(data$PP_Cost);

### Setting an empty vector to hold the percentile calculations for each observation ###
x = vector();

### A loop that goes through each risk iteration, checks to see if how many values in each column are less than the selected row,
### and sets a boolean 1 for true, and 0 for false. It then sums the total, and takes a ratio to the total number of observations. ###

for (i in 1:nrow(data)) {
    x[i] = percent(sum(data$schedule_text <= data$schedule_text[i] & 
                        data$program_cost <= data$program_cost[i])/
                        nrow(data))};

### New column set to the percentile vector. ###

data$percentile = x;

### Calculating the percentiles of the input Point, Mean, and Program Plan using the same method as above ###
pe_percent <- percent(sum(data$schedule_text <= data$PE_Date[1] & 
                        data$program_cost <= data$PE_Cost[1])/nrow(data));

me_percent <- percent(sum(data$schedule_text <= data$ME_Date[1] & 
                        data$program_cost <= data$ME_Cost[1])/nrow(data));

pp_percent <- percent(sum(data$schedule_text <= data$PP_Date[1] & 
                        data$program_cost <= data$PP_Cost[1])/nrow(data));

### each subsequent object is a subset of observations that equal the percentile calculated for point, mean, and program plan ###
### for efficieny, all but the necessary columns are dropped from the subsetted dataframes ###

jcl_pe <- subset(data, percentile == pe_percent);
jcl_pe <- jcl_pe[c("schedule_text", "program_cost")];
jcl_me <- subset(data, percentile == me_percent);
jcl_me <- jcl_me[c("schedule_text", "program_cost")]; 
jcl_pp <- subset(data, percentile == pp_percent);
jcl_pp <- jcl_pp[c("schedule_text", "program_cost")];

### Format extreme points as similar dataframe. This makes sure that the indifference curves reach the edge of the displayed data.
### Subtracting 1 from the minimum of schedule text makes sure that the curve is plotted sequetially (values are monotonic and in order) ###
pe_frame <- data.frame("schedule_text" = c(min(jcl_pe$schedule_text)-1, max(data$schedule_text)), "program_cost" = c(max(data$program_cost), min(jcl_pe$program_cost)));
me_frame <- data.frame("schedule_text" = c(min(jcl_me$schedule_text)-1, max(data$schedule_text)), "program_cost" = c(max(data$program_cost), min(jcl_me$program_cost)));
pp_frame <- data.frame("schedule_text" = c(min(jcl_pp$schedule_text)-1, max(data$schedule_text)), "program_cost" = c(max(data$program_cost), min(jcl_pp$program_cost)));

### Combine the dataframes ###
jcl_pe <- rbind(jcl_pe, pe_frame);
jcl_me <- rbind(jcl_me, me_frame);
jcl_pp <- rbind(jcl_pp, pp_frame);

### Plot ###
density_plot = ggplot(data, aes(x = schedule_text, y = program_cost)) +
                geom_hex(aes(), bins = 80) +
                geom_line(data = jcl_pe, aes(x = schedule_text, y = program_cost, text = sprintf('Cost: %s<br>Schedule: %s', formatC(program_cost, format="d", big.mark=","), format(schedule_text, "%m/%d/%Y")), group = 1), linetype = "dotted") +
                geom_line(data = jcl_me, aes(x = schedule_text, y = program_cost, text = sprintf('Cost: %s<br>Schedule: %s', formatC(program_cost, format="d", big.mark=","), format(schedule_text, "%m/%d/%Y")), group = 1), linetype = "dotted") +
                geom_line(data = jcl_pp, aes(x = schedule_text, y = program_cost, text = sprintf('Cost: %s<br>Schedule: %s', formatC(program_cost, format="d", big.mark=","), format(schedule_text, "%m/%d/%Y")), group = 1), linetype = "dotted") +

                geom_point(aes(x = PE_Date, y = PE_Cost, text = sprintf('Point Estimate<br>Cost: %s<br>Schedule: %s<br>Success: %s', formatC(PE_Cost, format="d", big.mark=","), format(PE_Date, "%m/%d/%Y"), pe_percent)), colour = "blue", size = 2) +
                geom_point(aes(x = ME_Date, y = ME_Cost, text = sprintf('Mean Estimate<br>Cost: %s<br>Schedule: %s<br>Success: %s', formatC(ME_Cost, format="d", big.mark=","), format(ME_Date, "%m/%d/%Y"), me_percent)), colour = "blue", size = 2) +
                geom_point(aes(x = PP_Date, y = PP_Cost, text = sprintf('Program Plan<br>Cost: %s<br>Schedule: %s<br>Success: %s', formatC(PP_Cost, format="d", big.mark=","), format(PP_Date, "%m/%d/%Y"), pp_percent)), colour = "blue", size = 2) +
                
                ggtitle(label = "Joint Cost Schedule Analysis") +
                xlab(label = "Schedule") +
                ylab(label = "Program Cost") +
                theme_bw() + 
                theme(legend.title = element_blank()) +
                guides(fill = FALSE) +
                scale_y_continuous(labels = comma) +
                scale_x_date(labels = date_format("%m-%Y")) +
                scale_fill_gradient(low = "grey", high = "#228B22");

####################################################

############# Create and save widget ###############
p = ggplotly(density_plot, tooltip = c("text", "fill"));
internalSaveWidget(p, 'out.html');
####################################################

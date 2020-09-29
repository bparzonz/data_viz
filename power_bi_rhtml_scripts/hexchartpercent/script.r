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
data$program_cost = as.numeric(data$program_cost);
data$select_percent = percent(data$select_percent);

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

### jcl_select is a subset of observations that equal the percentile input from select_percent ###
### for efficieny, all but the necessary columns are dropped from the subsetted dataframe ###
jcl_select <- subset(data, percentile == select_percent);
jcl_select <- jcl_select[c("schedule_text", "program_cost")];

### Format extreme points as similar dataframe. This makes sure that the indifference curves reach the edge of the displayed data.
### Subtracting 1 from the minimum of schedule text makes sure that the curve is plotted sequetially (values are monotonic and in order) ###
select_frame <- data.frame("schedule_text" = c(min(jcl_select$schedule_text)-1, max(data$schedule_text)), "program_cost" = c(max(data$program_cost), min(jcl_select$program_cost)));

### Combine the dataframes ###
jcl_select <- rbind(jcl_select, select_frame);

### Plot ###
density_plot = ggplot(data, aes(x = schedule_text, y = program_cost)) +
                geom_hex(aes(), bins = 80) +
                geom_line(data = jcl_select, aes(x = schedule_text, y = program_cost, text = sprintf('Cost: %s<br>Schedule: %s', formatC(program_cost, format="d", big.mark=","), format(schedule_text, "%m/%d/%Y")), group = 1), 
                    linetype = "dotted") +
                ggtitle(label = "Joint Cost/Schedule Analysis") +
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
p = ggplotly(density_plot, tooltip = c("fill", "text"));
internalSaveWidget(p, 'out.html');
####################################################

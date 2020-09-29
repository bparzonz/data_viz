
library(ggplot2)
library(scales)
library(shadowtext)
library(plyr)
# library(gridExtra)

data <- read.csv(file.choose(new = FALSE))

data$program_cost <- as.numeric(data$program_cost)
data$schedule <- as.Date(data$schedule, "%m/%d/%Y")
data$pe_date <- as.Date(data$pe_finish_date, "%m/%d/%Y")
data$me_date <- as.Date(data$me_finish_date, "%m/%d/%Y")
data$pp_date <- as.Date(data$pp_finish_date, "%m/%d/%Y")

# data$difference_in_dates_pe = data$schedule - data$pe_date
# data$difference_in_dates_me = data$schedule - data$me_date
# data$difference_in_dates_pp = data$schedule - data$pp_date

data$PE_def =  ifelse(data$program_cost <= data$pe_cost &
                      data$schedule <= data$pe_date, 
                      "Within PE Parameters", 0)

data$ME_def =  ifelse(data$program_cost <= data$me_cost &
                      data$schedule <= data$me_date,
                       "Within ME Parameters", 0)

data$PP_def =  ifelse(data$program_cost <= data$pp_cost &
                      data$schedule <= data$pp_date,
                      "Within PP Parameters", 0)


data$categories = ifelse(data$PE_def == "Within PE Parameters" & data$ME_def == 0 & data$PP_def == 0, 
                    "Within Point Estimate Parameters",
                    ifelse(data$PE_def == 0 & data$ME_def == "Within ME Parameters" & data$PP_def == 0, 
                        "Within Mean Estimate Parameters",
                        ifelse(data$PE_def == 0 & data$ME_def == 0 & data$PP_def == "Within PP Parameters", 
                            "Within Program Plan Parameters", 
                            ifelse(data$PE_def == "Within PE Parameters" & data$ME_def == "Within ME Parameters" & data$PP_def == 0, 
                                ifelse(data$pe_cost <= data$me_cost, 
                                    "Within Point Estimate Parameters", 
                                    "Within Mean Estimate Parameters"),
                                ifelse(data$PE_def == "Within PE Parameters" & data$ME_def == 0 & data$PP_def == "Within PP Parameters",
                                    ifelse(data$pe_cost <= data$pp_cost, 
                                        "Within Point Estimate Parameters",
                                        "Within Program Plan Parameters"),
                                    ifelse(data$PE_def == 0 & data$ME_def == "Within ME Parameters" & data$PP_def == "Within PP Parameters", 
                                        ifelse(data$me_cost <= data$pp_cost, 
                                            "Within Mean Estimate Parameters",
                                            "Within Program Plan Parameters"),
                                        ifelse(data$PE_def == "Within PE Parameters" & data$ME_def == "Within ME Parameters" & data$PP_def == "Within PP Parameters", 
                                            ifelse(data$pe_cost <= data$me_cost & data$pe_cost<= data$pp_cost, 
                                                "Within Point Estimate Parameters",
                                                ifelse(data$me_cost <= data$pe_cost & data$me_cost <= data$pp_cost, 
                                                    "Within Mean Estimate Parameters",
                                                    "Within Program Plan Parameters")
                                            ),
                                            "Out of Scope"
                                        )
                                    )
                                )
                            )
                        )
                    )
                )

#PE_vector <- table(data$PE_def)
#ME_vector <- table(data$ME_def)
#PP_vector <- table(data$PP_def)

#PE_stat <- (PE_vector[names(PE_vector) == "Within PE Paramenters"]/nrow(data))
#ME_stat <- (ME_vector[names(ME_vector) == "Within ME Paramenters"]/nrow(data))
#PP_stat <- (PP_vector[names(PP_vector) == "Within PP Paramenters"]/nrow(data))

#stat_table <- cbind(c("Point Estimate","Mean Estimate", "Program Plan"),
#                    c(PE_stat, ME_stat, PP_stat))

density_plot <- ggplot(data) +
                geom_hex(aes(x = data$schedule, y = data$program_cost, color = data$categories), bins = 50) +
                scale_fill_gradient(low = NULL, high = "grey") +
                geom_segment(aes(x = pe_date, y = min(data$program_cost), xend = pe_date, yend = pe_cost), linetype = "dashed") +
                geom_segment(aes(x = me_date, y = min(data$program_cost), xend = me_date, yend = me_cost), linetype = "dashed") +
                geom_segment(aes(x = pp_date, y = min(data$program_cost), xend = pp_date, yend = pp_cost), linetype = "dashed") +
                geom_segment(aes(x = min(data$schedule), y = pe_cost, xend = pe_date, yend = pe_cost), linetype = "dashed") +
                geom_segment(aes(x = min(data$schedule), y = me_cost, xend = me_date, yend = me_cost), linetype = "dashed") +
                geom_segment(aes(x = min(data$schedule), y = pp_cost, xend = pp_date, yend = pp_cost), linetype = "dashed") +
                geom_shadowtext(aes(x = data$pe_date, y = data$pe_cost, label = "Point Estimate")) +
                geom_shadowtext(aes(x = data$me_date, y = data$me_cost, label = "Mean Estimate")) +
                geom_shadowtext(aes(x = data$pp_date, y = data$pp_cost, label = "Program Plan")) +
                #annotation_custom(tableGrob(stat_table, rows = NULL), xmin = unit(11.5,"npc"), xmax = unit(14,"npc"),  ymin = 3.7, ymax = 7) +
                ggtitle(label = "ADSR JCL Analysis") +
                xlab(label = "Schedule") +
                ylab(label = "Program Cost") +
                theme_bw() + 
                guides(fill = FALSE) +
                scale_y_continuous(labels = comma)

density_plot


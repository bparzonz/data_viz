library(ggplot2)
library(RColorBrewer)

dataset <- read.csv(file.choose(new = FALSE))
dataset <- dataset[,1:6]

n <- 60
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))

scale <- if(length(dataset$Year) < 30) {
  scale_x_continuous(breaks = seq(min(dataset$Year), max(dataset$Year)))
} else if (length(dataset$Year) >= 30  & length(dataset$Year) <= 60) {
  scale_x_continuous(breaks = seq(min(dataset$Year), max(dataset$Year), by = 2))   
} else {
  scale_x_continuous(breaks = seq(min(dataset$Year), max(dataset$Year), by = 5))
}

plot <- ggplot(dataset, aes(x = Year, y = Escalation)) +
  geom_point(aes(color = "#094780"), size = 3) +
  
  geom_hline(aes(yintercept = mean(dataset$Escalation), color = col_vector[1]), linetype = "dashed") +
  geom_hline(aes(yintercept = median(dataset$Escalation), color = col_vector[2]), linetype = "dashed") +
  
  theme(axis.text.x = element_text(colour = "#942832")) +
  theme(axis.text.y = element_text(colour = "#942832")) +
  
  scale +
  scale_y_continuous(breaks = round(seq(min(dataset$Escalation), max(dataset$Escalation), by = 0.02),2))

addline <- function(data){
  
  c <- list(unlist(unique(dataset[3])), paste("Mean ", round(mean(dataset$Escalation), 3)), paste("Median", round(median(dataset$Escalation),3)))
  t <- list("#094780", col_vector[1], col_vector[2])
  
  for (i in 1:data){
    line = geom_hline(aes(yintercept = dataset[1,3+i], color = col_vector[2+i]))
    plot = plot + line
    
    c[3+i] = paste(unlist(names(dataset)[3+i]), " Escalation :", round(dataset[1 ,3+i], 3))
    t[3+i] = col_vector[2+i]
  }
  
  m = scale_color_manual(name = "", values = t, labels = c)
  
  plot = plot + m
  
  return(plot)
  
}

addline(NCOL(dataset)-3)


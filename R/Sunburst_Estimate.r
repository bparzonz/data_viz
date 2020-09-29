### Load libraries
library(plotly)

### Load the dataframe
# This dataframe is hardcoded how the data should appear in powerbi. Order is essential: ID, Lables, Parents, Estimate.
# If the estimate values do not sum perfectly to thier parent value, the plot will not display. Make sure to double check your data for rounding errors.
df <- data.frame(
  ids = c("LCC Blast Door Aquisition", 
  "EMD", "PROD", 
  "EMD - Contractor Costs", "EMD - Government Costs",
  "EMD - Data", "EMD - PMP", "EMD - SEPM", "EMD - ST&E", "EMD - Training", 
  "EMD - NSWC SE", "EMD - NSWC PM", "EMD - Termination for Convenience",
  "EMD - DMS", "EMD - OGC's ECO", "EMD - Remaining",
  "EMD - Excavation for Egress", "EMD - Helo Checkout", "EMD - Repair of Door", "EMD - Training Videos",
  "EMD - A&AS", "EMD - Gov't TDY", "EMD - Withholds",
  "PROD - Contractor Costs", "PROD - Government Costs",
  "PROD - PMP", "PROD - SEPM",
  "PROD - NSWC PM", "PROD - NSWC SE",
  "PROD - OGC ECO", "PROD - OGC Remaining",
  "PROD - A&AS", "PROD - Travel", "PROD - Withholds"
  ),
  labels = c("LCC Blast<br>Door Aquisition", 
  "EMD", "PROD", 
  "Contractor<br>Costs", "Government<br>Costs",
  "Data", "PMP", "SEPM", "ST&E", "Training", 
  "NSWC SE", "NSWC PM", "Termination for<br>Convenience",
  "DMS", "OGC's ECO", "Remaining",
  "Excavation<br>for Egress", "Helo<br>Checkout", "Repair of<br>Door", "Training<br>Videos",
  "A&AS", "Gov't TDY", "Withholds",
  "Contractor<br>Costs", "Government<br>Costs",
  "PMP", "SEPM",
  "NSWC PM", "NSWC SE",
  "OGC ECO", "OGC Remaining",
  "A&AS", "Travel", "Withholds"
  ),
  parents = c("", 
  "LCC Blast Door Aquisition", "LCC Blast Door Aquisition",
  "EMD", "EMD",
  "EMD - Contractor Costs", "EMD - Contractor Costs", "EMD - Contractor Costs", "EMD - Contractor Costs", "EMD - Contractor Costs", 
  "EMD - SEPM", "EMD - SEPM", "EMD - SEPM",
  "EMD - Government Costs", "EMD - Government Costs", "EMD - Government Costs",
  "EMD - DMS", "EMD - DMS", "EMD - DMS", "EMD - DMS",
  "EMD - Remaining", "EMD - Remaining", "EMD - Remaining",
  "PROD", "PROD",
  "PROD - Contractor Costs", "PROD - Contractor Costs",
  "PROD - SEPM", "PROD - SEPM",
  "PROD - Government Costs", "PROD - Government Costs",
  "PROD - OGC Remaining", "PROD - OGC Remaining", "PROD - OGC Remaining"
  ),
  estimate = c(8.198, 
  6.933, 1.265, 
  4.181, 2.752,
  0.502, 0.387, 2.559, 0.668, 0.065, 
  0.661, 1.885, 0.013,
  0.280, 0.326, 2.146,
  0.066, 0.005, 0.065, 0.144,
  1.581, 0.112, 0.453,
  0.940, 0.325,
  0.802, 0.138,
  0.105, 0.033,
  0.056, 0.269,
  0.215, 0.025, 0.029
  )
)
 
## Plot 
fig <- plot_ly(df, ids = ~ids, labels = ~labels, parents = ~parents, values = df$estimate, 
type = 'sunburst', branchvalues = 'total', textinfo = 'none') # labels are turned off

fig
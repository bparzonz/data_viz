# Load libraries
import plotly.graph_objects as go
import pandas as pd
import plotnine as plt
# Load  Dataframe
data = {"EMD": [3,3,3,5,3,2,3,5],
        "P&D": [2,4,3,1,2,2,3,5],
        "O&S": [2,2,"",1,2,2,3,5],
        "Comments": ["1", "2", "3", "4", "5", "6", "7", "Key performance requirements well-defined"]}

# create dataframe
df = pd.DataFrame(data, columns = ["EMD", "P&D", "O&S", "Comments"])
# transpose dataframe
df = df.T

# create axis labels
Phase = ["EMD", "P&D", "O&S"] 
Confidence_Enablers = ["Overall Assessment  ", "Budget Equals Estimate  ", "Risk Assessment  <br>(Cost Schedule Technical)  ", 
                                "Crosschecks  ", "Cost & Methodology  ", "Schedule Baseline  ", 
                                "Engineering Technical Baseline  ", "Requirements Definition  "]

# create heatmap formatting

font = go.layout.Font(family = "Times New Roman",
                  size = 10,
                  color = 'black')
title = go.layout.Title(text = "<i>Program 'Confidence' Pedigree<i>",
                        font = {"size": 18})
xaxistitle = go.layout.xaxis.Title(text = "<b>Program Phase</b>",
                                  font = {"size": 16})
xaxis = go.layout.XAxis(side = "top",
                        title = xaxistitle,
                        mirror = True,
                        linewidth = 2,
                        linecolor = "black",
                        showline = True)
yaxistitle = go.layout.yaxis.Title(text = "<b>Confidence Enablers<b>",
                                  font = {"size": 16})                        
yaxis = go.layout.YAxis(title = yaxistitle,
                        mirror = True,
                        linewidth = 2,
                        linecolor = "black",
                        showline = True)
layout = go.Layout(font = font,
                   xaxis = xaxis,
                   yaxis = yaxis,
                   plot_bgcolor = "white",
                   title = title)

# make dataframe usable by heatmap (create array)
def get_zvals_as_array(x):
  df2 = x.iloc[0:3]
  result = []
  for (columnName, columnData) in df2.iteritems():
    column = columnData.values
    result.append(column)
  return result

zvalues = get_zvals_as_array(df)

def get_comments_as_array(x):
  df2 = x.iloc[-1]
  result = []
  for (columnName, columnData) in df2.iteritems():
    column = []
    column1 = columnData
    column.append(column1)
    column.append(column1)
    column.append(column1)
    result.append(column)
  return result


textvalues = get_comments_as_array(df)
# create heatmap

fig = go.Figure(data = go.Heatmap(z = zvalues,
                                  x = Phase,
                                  y = Confidence_Enablers,
                                  hoverongaps = False,
                                  colorscale = "rdylgn",
                                  #showscale = False,
                                  hoverinfo = "text",
                                  text = textvalues),
                layout = layout)

# plot
fig.show()



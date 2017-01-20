
rm(list = ls())

################
### Packages ###
################
# install.packages("devtools", dependencies = T)
# install.packages("igraph", dependencies = T)
# install_github("arcdiagram", username = "gastonstat")
library(devtools)
library(igraph)
library(arcdiagram)


#####################
### Data Cleaning ###
#####################
rawdata <- read.csv("io2013.csv", stringsAsFactors = F, header = F)
graph_df <- rawdata
names(graph_df) <- c("outflow", "inflow", "amount")
graph_df$outflow <- as.numeric(substr(graph_df$outflow, 1, 2))
graph_df$inflow <- as.numeric(substr(graph_df$inflow, 1 ,2))

grob <- graph.data.frame(graph_df, directed = T)
edgelist <- get.edgelist(grob)

png("arcplot_2013.png", width = 2750, height = 2750, res = 300, bg = "black")
arcplot(
  edgelist, 
  lwd.arcs = E(grob)$amount/1000,
  col.arcs = "#77777765", 
  show.nodes = F, 
  cex.labels = 0.75, 
  font = 1
)
dev.off()



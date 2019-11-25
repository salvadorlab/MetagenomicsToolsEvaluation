library(xlsx)
library(devtools)
library(factoextra)
library(ggfortify)
library(tidyverse)#for pca visualization
library(ggplot2)

# this pca analysis is done with relative abundance of bacteria and viruses composition in the samples
# the report from the company is based only on bacterial pyhlum relative abundance (viruses do not classify by phylum)

#tutorial for pca
# http://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/118-principal-component-analysis-in-r-prcomp-vs-princomp/#prcomp-and-princomp-functions

setwd("/Users/rx32940/Dropbox/5.Rachel-projects/Metagenomic_Analysis/Kraken2-standard/custom/genus")

data_genus <- read.csv("./bracken_count_custom_phylum.csv",sep = ",",header=TRUE)
rownames(data_genus) <- data_genus$X
#data_genus <- select(data_genus, -Name) 
data_genus <-  select(data_genus, -X) 
data_genus <- data_genus[-c(1),]


data2_genus <- data.frame(lapply(data_genus, function(x) as.numeric(as.character(x))))
data2_genus <-t(data2_genus)
data2_genus[is.na(data2_genus)] <- 0
data2_genus <- as.data.frame(data2_genus)
data2_genus$Tissues <- as.list(rep(c("Kidney","Lung","Spleen"),4))
pca_genus <- prcomp(data2_genus[,-c(624)],center=TRUE,scale. = TRUE) # do PCA analysis without Tissue column
summary(pca_genus)
data2_genus$Tissues <- factor(unlist(data2_genus$Tissues))
class(data2_genus$Tissues) <- "factor"
plot <- autoplot(pca_genus,data = data2_genus,colour ="Tissues",label = TRUE, label.hjust = 2) 

plot <- plot + ggtitle("PCA Analysis for Clark in the Genus Level") +
  theme_bw()
plot
ggsave("./pca_G_plot_kraken2.png",plot)

eigenvalues_genus <- fviz_eig(pca_genus)
eigenvalues_genus
pca <- fviz_pca_ind(pca_genus,col.var="cos2")

png("./pca_P_plot_Kraken2.png")

dev.off()

##################################################
# anaylyze abundance distribution of each sample #
##################################################

summary_tables <- data.frame(Date=as.Date(character()),
                             File=character(), 
                             User=character(), 
                             stringsAsFactors=FALSE)
# bind summary for each sample to the big summary table column by column
summary_tables <- rbind.fill(summary_tables,as.data.frame(sapply(data_genus, function(x) as.data.frame(as.list(summary(x)))))) %>% select(-c(1,2,3))
# add row names
row.names(summary_tables) <- c("Min.",   "1st Qu.",    "Median",      "Mean",   "3rd Qu.",      "Max." )
# transpose
summary_tables <- t(summary_tables)

write.csv(summary_tables,"sample_abundance_distribution.csv")

plot(density(data_genus$R22.K))

library(xlsx)
library(devtools)
library(factoextra) #for pca visualization

# this pca analysis is done with relative abundance of bacteria and viruses composition in the samples
# the report from the company is based only on bacterial pyhlum relative abundance (viruses do not classify by phylum)

#tutorial for pca
# http://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/118-principal-component-analysis-in-r-prcomp-vs-princomp/#prcomp-and-princomp-functions



data_genus <- read_csv("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/KRAKEN2:BRACKEN/phylum_composition_combined.csv")
rownames(data_genus) <- data_genus$X1
data_genus <- select(data_genus, -X1)


data2_genus <- data.frame(lapply(data_genus, function(x) as.numeric(as.character(x))))
data2_genus <-t(data2_genus)
pca_genus <- prcomp(data2_genus,center=TRUE,scale. = TRUE)
summary(pca_genus)

eigenvalues_genus <- fviz_eig(pca_genus)
eigenvalues_genus
png("pca_genus_plot.png")
fviz_pca_ind(pca_genus,col.var="cos2")
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

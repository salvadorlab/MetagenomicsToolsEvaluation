library(xlsx)
library(devtools)
library(factoextra) #for pca visualization

# this pca analysis is done with relative abundance of bacteria and viruses composition in the samples
# the report from the company is based only on bacterial pyhlum relative abundance (viruses do not classify by phylum)

#tutorial for pca
# http://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/118-principal-component-analysis-in-r-prcomp-vs-princomp/#prcomp-and-princomp-functions



setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis")

data <- read.xlsx2("relative_abundance_genus.xlsx",1,header=T,colIndex = 1:13)
#rownames(data) <- data[,1]
data <- data[,-1]

data2 <- data.frame(lapply(data, function(x) as.numeric(as.character(x))))
data2<-t(data2)
pca <- prcomp(data2,center=TRUE,scale. = TRUE)
summary(pca)

eigenvalues <- fviz_eig(pca)
fviz_pca_ind(pca,col.var="cos2")

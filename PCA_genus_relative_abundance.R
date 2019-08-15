library(xlsx)
setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis")

data <- read.xlsx2("relative_abundance_genus.xlsx",1,header=T,rownames=T,colClasses = NA)
prcomp()
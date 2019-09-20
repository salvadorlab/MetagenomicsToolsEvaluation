library("phyloseq")
library(dplyr)
library(ggplot2)

##########################################################
# Clark data                                             #
##########################################################
setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/CLARK:CLARK(s)")

data <- read.csv("all_samples_absolute_lineage.csv",fill=T)
otu_data <- data %>%select(-c(1,3,4,5,6,7))
rownames(otu_data) <- otu_data[,1]
otu_data <- otu_data[,-1]

# OTU table (read counts)
otu_data <- otu_data[,c("R22.K","R26.K","R27.K","R28.K","R22.L","R26.L","R27.L","R28.L","R22.S","R26.S","R27.S","R28.S")]
colnames(otu_data) <- factor(colnames(otu_data),levels = c("R22.K","R26.K","R27.K","R28.K","R22.L","R26.L","R27.L","R28.L","R22.S","R26.S","R27.S","R28.S"))
OTU <- otu_table(otu_data,taxa_are_rows = T)


tax_data <- data %>% select(c(2,3,4,5,6,7)) #select lineage from the merged abundance table
tax_data$x1 <- tax_data[,1] # move the lowest taxon to the leftmost column
rownames(tax_data) <- tax_data[,1] # make the lowest taxon the rownames
tax_data <-tax_data[,-1] # remove lowest from the first column (only at the leftmost column)
colnames(tax_data) <- c("Domain","Phylum","Class","Order","Family","Genus") # taxonomy ranks
tax_data <- as.matrix(tax_data) # taxonomy table need to be in matrix format

# taxonomy table
TAX <- tax_table(tax_data)

# samples annotation
annotation <- read.csv("../Samples_annotation.csv",header = T)
rownames(annotation) <- annotation$X
annotation <- annotation[,-1]
annotation <- annotation[c("R22.K","R26.K","R27.K","R28.K","R22.L","R26.L","R27.L","R28.L","R22.S","R26.S","R27.S","R28.S"),]
rownames(annotation)<-factor(rownames(annotation),levels = c("R22.K","R26.K","R27.K","R28.K","R22.L","R26.L","R27.L","R28.L","R22.S","R26.S","R27.S","R28.S"))
sample_ann <- sample_data(annotation)
########################## Clark data transformation done ###################################################### 


##########################################################
# KRAKEN2:BRACKEN data                                   #
##########################################################
setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/KRAKEN2:BRACKEN/genus/data")


files <- list.files(".")

for (file in files){
  current <- read.table(file, sep = "\t", header = T) %>% select(c(1,6))
  sample_name <- file #extract sample name
  colnames(current)[2]<- sample_name
  current[,2] <- as.numeric(as.character(current[,2])) 
  if (sample_name != "R22.K.tsv"){
    all_kraken <- full_join(all_kraken, current, by = NULL) # combine samples into one table
  }
  else{
    all_kraken <- current 
  }
}
########################### kraken/bracken #############################################

# create a phyloseq object
obj <- phyloseq(OTU,TAX,sample_ann)

# plot absolute abundance bar plot
plot_bar(obj,fill="Domain")

# plot phylogenetic tree
library("ape")
random_tree = rtree(ntaxa(obj), rooted=TRUE, tip.label=taxa_names(obj))
plot(random_tree)

# plot heatmap
plot_heatmap(obj_Tree,taxa.label = "Domain")

# alpha diversity of the samples
estimate_richness(obj)
# deseq for differential abundance, also distance functions 
plot_richness(obj, x = "Tissue",color = "Subject",measures = c("Observed", "Chao1", "Shannon", "InvSimpson"),title = "Alpha diversity for each sample") +
  geom_point(size=4)

##############################################################
# DESEQ2                                                     #
##############################################################

# install DESeq2
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")

#BiocManager::install("DESeq2")

library("DESeq2")
packageVersion("DESeq2")

# major sample covariate, Tissue, as the study design factor. comparing samples composition taken from different tissues
head(sample_ann$Subject) # can also do an analysis with respect to Subject
deseq_obj <- phyloseq_to_deseq2(obj,  ~ Tissue ) # format into DESEQ object
deseq_analysis <- DESeq(deseq_obj, test="Wald", fitType = "parametric")

# analysis DESeq results
result <- results(deseq_analysis,cooksCutoff = FALSE)
alpha <- 0.05 # set alpha to reject null, 0.05 for 95% confidence level
sign_diff <- result[which(result$padj < alpha),] # include only samples with adjusted p values lower than alpha, null rejected
# final result table with lineage annotation added
sign_diff <- cbind(as(sign_diff, "data.frame"), as(TAX[rownames(sign_diff), ], "matrix")) 
sign_diff
dim(sign_diff) # first number shown # of DA taxa 

### plot OTU that were significantly different between the two tissues
library("ggplot2")

# organize Phylum orders based on log2 fold change
x <- tapply(sign_diff$log2FoldChange,sign_diff$Phylum, function(x) max(x))
x <- sort(x,TRUE) # sort logfoldchanges in phylums with decreasing order
sign_diff$Phylum <- factor(as.character(sign_diff$Phylum), levels=names(x)) # keep the order

x <- tapply(sign_diff$log2FoldChange,sign_diff$Genus, function(x) max(x))
x <- sort(x,TRUE) # sort logfoldchanges in phylums with decreasing order
sign_diff$Genus <- factor(as.character(sign_diff$Genus), levels=names(x))

#plot for log fold change
quartz() # for "polygon edge not found" error
log_plot <- ggplot(sign_diff, aes(x=Genus, y=log2FoldChange, color=Phylum)) + # try taxonomy level for x and y axes
  geom_point(size=6) + 
  theme(axis.text.x = element_text(angle = -90, hjust = 0, vjust=0.5))
log_plot



# distance matrix

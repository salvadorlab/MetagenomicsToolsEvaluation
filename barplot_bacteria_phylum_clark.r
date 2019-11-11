library(xlsx)
library(dplyr)
library(tidyr)
library(ggplot2)
setwd("/Users/rachel/Dropbox/5.Rachel-projects/Metagenomic_Analysis/Clark-s/genus/results")

all_files <- list.files(".")


# to add up domain percentage, ignore genus
for (file in all_files){
  current <- read.csv(file,header = T) %>% select(1,5)
  #current_total <- sum(as.numeric(as.character(current$Count)))
  
  #current <- current %>% mutate(percentage=as.numeric(as.numeric(as.character(current$Count))/current_total * 100)) %>% select(1,3)
  current <- current[order(current$Proportion_All...,decreasing = T),]
  colnames(current)[2] <- sample_name <- unlist(strsplit(file,"_"))[1]
  
  sum_rest <- summarise(current,sum_rest = sum(current[-c(1:12),2]))#sum rest percentage except for the top 10 phylum
  sum_rest$Name <- "other"# name the sum as other
  colnames(sum_rest)[1] <- sample_name # change the percentage(current name is "sum_rest") colname to name for rbind
  
  top_10 <- head(current,12) # top 10 phylum and UNKNOWN
  current <- rbind(sum_rest,top_10) #bind sum of others to top 10 phylum and UNKNOWN
  
  if (sample_name != "R22.K"){
    unclassified <- full_join(unclassified, current, by = NULL) # combine samples into one table
  }
  else{
    unclassified <- current 
  }
  
}
keys_to_gather <- colnames(unclassified)[-2] #exclude Name column from rest of the sample names
unclassified_gather <- gather(unclassified, keys_to_gather, key = "samples", value = "percentage") #gather so can plot stacked bar plot
uniq_phylum <- unique(unclassified_gather$Name)[-c(1:3)] # unique phylums exclude UNKNOWN and other(this list is for ordering purpose happening next)
unclassified_gather$Name <- factor(unclassified_gather$Name, levels = c("UNKNOWN","other","Rattus",uniq_phylum)) #order the bar plot so UNKNOWN and other can separate from rest of phylum
unclassified_gather$samples <- factor(unclassified_gather$samples,levels = c("R22.K","R26.K","R27.K","R28.K","R22.L","R26.L","R27.L","R28.L","R22.S","R26.S","R27.S","R28.S"))

color_palette <- c("darkolivegreen4","yellow","cyan2","darkseagreen1","coral","#50FFB1","#083D77","#EBEBD3","#0AD3FF","lavender","lightpink","#BCF4F5","#A491D3","#EB5E55","#FC9F5B","#FFB7C3","#CFCFEA","#E76B74","#34D1BF","#5B4E77","#EA638C",
                   "#E8E1EF","#CDACA1","#C7FFDA","#CD8987","#93B5C6","#50FFB1","#083D77","#EBEBD3","#0AD3FF","#B91372","#CBFF8C","#FFEAD0","#F76F8E","#33658A","#EDD382","#CC2936",
                   "antiquewhite","chartreuse2","coral","darkgoldenrod1","cyan2","darkseagreen1","lavender","lightpink","#CD8987","#93B5C6")


new_plot <- ggplot(unclassified_gather, aes(x=samples, y=percentage, fill=Name))+
  geom_bar(stat = "identity") +
  scale_fill_manual(values = color_palette)

new_plot

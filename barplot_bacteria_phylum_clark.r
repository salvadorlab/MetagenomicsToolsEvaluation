library(xlsx)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggforce) # package help zoom in on ggplot 
setwd("/Users/rx32940/Dropbox/5.Rachel-projects/Metagenomic_Analysis/Clark/genus/results")

all_files <- list.files(".")


# to add up domain percentage, ignore genus
for (file in all_files){
  current <- read.csv(file,header = T) %>% select(1,4)
  #current_total <- sum(as.numeric(as.character(current$Count))) -current$Count[length(current$Count)]
  
  #current <- current %>% mutate(percentage=as.numeric(as.numeric(as.character(current$Count))/current_total * 100)) %>% select(1,3)
  current <- current[order(current$Count,decreasing = T),]
  colnames(current)[2] <- sample_name <- unlist(strsplit(file,"_"))[1]
  
  sum_rest <- summarise(current,sum_rest = sum(as.numeric(as.character(current[-c(1:6),2]))))#sum rest percentage except for the top 10 phylum
  sum_rest$Name <- "other"# name the sum as other
  colnames(sum_rest)[1] <- sample_name # change the percentage(current name is "sum_rest") colname to name for rbind
  
  top_10 <- head(current,6) # top 10 phylum and UNKNOWN
  current <- rbind(sum_rest,top_10) #bind sum of others to top 10 phylum and UNKNOWN
  
  if (sample_name != "R22.K"){
    unclassified <- full_join(unclassified, current, by = NULL) # combine samples into one table
  }
  else{
    unclassified <- current 
  }
  
}

keys_to_gather <- colnames(unclassified)[-2] #exclude Name column from rest of the sample names
unclassified <- unclassified[-c(3),] # to remove the unknown row from classified only proportions

#write.table(unclassified, "../classifiedOnly_count_clark_genus_custom.csv",quote=FALSE,sep=",",row.names = FALSE)
#write.table(unclassified, "../classifiedOnly_percentage_clark_genus_custom.csv",quote=FALSE,sep=",",row.names = FALSE)

unclassified_gather <- gather(unclassified, keys_to_gather, key = "samples", value = "Reads") #gather so can plot stacked bar plot
unclassified_gather[is.na(unclassified_gather)] <- 0
uniq_phylum <- unique(unclassified_gather$Name)[-c(1:2)] # unique phylums exclude Chrodata and other(this list is for ordering purpose happening next)
unclassified_gather$Name <- factor(unclassified_gather$Name, levels = c("Rattus","other",uniq_phylum)) #order the bar plot so UNKNOWN and other can separate from rest of phylum
unclassified_gather$samples <- factor(unclassified_gather$samples,levels = c("R22.K","R26.K","R27.K","R28.K","R22.L","R26.L","R27.L","R28.L","R22.S","R26.S","R27.S","R28.S"))

color_palette <- c("darkolivegreen4","yellow","cyan2","darkseagreen1","coral","#50FFB1","#083D77","#EBEBD3","#0AD3FF","lavender","lightpink","#BCF4F5","#A491D3","#EB5E55","#FC9F5B","#FFB7C3","#CFCFEA","#E76B74","#34D1BF","#5B4E77","#EA638C",
                   "#E8E1EF","#CDACA1","#C7FFDA","#CD8987","#93B5C6","#50FFB1","#083D77","#EBEBD3","#0AD3FF","#B91372","#CBFF8C","#FFEAD0","#F76F8E","#33658A","#EDD382","#CC2936",
                   "antiquewhite","chartreuse2","coral","darkgoldenrod1","cyan2","darkseagreen1","lavender","lightpink","#CD8987","#93B5C6")


new_plot <- ggplot(unclassified_gather, aes(x=samples, y=as.numeric(Reads), fill=Name))+
  geom_bar(stat = "identity") +
  scale_fill_manual(values = color_palette)+
  facet_zoom(ylim = c(0,100000),show.area = FALSE)+ # library(ggforce), zoom in at part of the plot (too little in proportion, hard to see)
  ylab("Reads")+
  ggtitle("Clark-s Genus Level Relative Abundance with Custom Database") +
  theme(axis.text.x = element_text(angle = 90))
new_plot

ggsave("../clark_genus_custom_Absolute.png",new_plot)

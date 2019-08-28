library(xlsx)
library(dplyr)
library(tidyr)
library(ggplot2)
setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/CLARK:CLARK(s)/results")

all_files <- list.files(".")

unclassified <- data.frame(Date=as.Date(character()),
                        File=character(), 
                        User=character(), 
                        stringsAsFactors=FALSE)
classified <- data.frame(Date=as.Date(character()),
                           File=character(), 
                           User=character(), 
                           stringsAsFactors=FALSE)

# to add up domain percentage, ignore genus
for (file in all_files){
  current <- read.xlsx2(file,1) %>% select(1,3,10,11)
  
  # to add up domain percentage, ignore genus
  current_unclassified <- select(current,c(1,2,3)) %>% 
    spread(key = "Lineage",fill = NA, value = Proportion_All...) %>% 
    select(2,3,4,5)
  
  # relative abundance for each domain including the unknown
  current_unclassified <- summarise(current_unclassified, Bacteria = sum(as.numeric(as.character(current_unclassified[,2])),na.rm = T),
                  Archaea = sum(as.numeric(as.character(current_unclassified[,1])),na.rm = T),
                  Viruses = sum(as.numeric(as.character(current_unclassified[,4])),na.rm = T),
                  UNKNOWN = sum(as.numeric(as.character(current_unclassified[,3])),na.rm = T))
    current_unclassified$sample <- unlist(strsplit(file,"_."))[1] # add sample id to the data before binding
    unclassified <- rbind(unclassified,current_unclassified) # bind single-sample table to overall table
  
  # relative abundance for each domain excluding the unknown   
  current_classified <- select(current,c(1,2,4)) %>% 
    spread(key = "Lineage",fill = NA, value = Proportion_Classified...) %>% 
    select(2,3,4,5)
  current_classified <- summarise(current_classified, Bacteria = sum(as.numeric(as.character(current_classified[,2])),na.rm = T),
                                  Archaea = sum(as.numeric(as.character(current_classified[,1])),na.rm = T),
                                  Viruses = sum(as.numeric(as.character(current_classified[,4])),na.rm = T))
  current_classified$sample <- unlist(strsplit(file,"_."))[1] # add sample id to the data
  classified <- rbind(classified,current_classified) # bind single sample table to overall table
  
}

# gather the data frame for plotting
classified_gather <- gather(classified, "Bacteria", "Archaea", "Viruses",key = "Domains", value = "percentage")
unclassified_gather <- gather(unclassified, "Bacteria", "Archaea", "Viruses","UNKNOWN", key = "Domains", value = "percentage")

#factor for ordering of the stack
classified_gather$Domains <- factor(classified_gather$Domains,levels = c("Archaea","Viruses","Bacteria"))
#plotting without unknown composition
classified_plot <- ggplot(classified_gather, aes(x=sample, y= percentage, fill=Domains))+
  geom_bar(stat = "identity") + 
  geom_text(aes(label=paste(percentage,"%")),size = 2,position = position_stack(vjust = 0.5))+
  ylab("Relative abundance") +
  xlab("samples")
classified_plot
ggsave(file="../exclude_UNKNOWN.png",plot = classified_plot)

#factor for ordering of the stack
unclassified_gather$Domains <- factor(unclassified_gather$Domains,levels = c("UNKNOWN","Archaea","Viruses","Bacteria"))
#plotting with unknown composition
unclassified_plot <- ggplot(unclassified_gather, aes(x=sample, y= percentage, fill=Domains))+
  geom_bar(stat = "identity") + 
  geom_text(aes(label=paste(percentage,"%")),size = 2,position = position_stack(vjust = 0.5))+
  ylab("Relative Abundance") +
  xlab("samples")
unclassified_plot
ggsave(file="../include_UNKNOWN.png",plot = unclassified_plot)

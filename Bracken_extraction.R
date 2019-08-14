library(tidyverse)
library(dplyr)
library(plyr)
library(ggplot2)
setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/domain/")

all_samples <- list.files(".") # list all files in dir

all_tables <-data.frame(Date=as.Date(character()),
                               File=character(), 
                               User=character(), 
                               stringsAsFactors=FALSE)
for (file in all_samples){
  # read all sample files, row= domain name, col = fraction of totoal reads
  current <- read.table(file,header = T,fill=F,sep="\t",quote="") %>% select(1,7) %>% spread(name,fraction_total_reads) 
  current$name <- file # change row name to sample name
  assign(file,current) # variable name to sample name, not necessary
  all_tables <- rbind.fill(all_tables,current) # combine samples
}


all_tables <- all_tables %>% select(-c(1,2,3))
all_tables[is.na(all_tables)] <- 0
row.names(all_tables) <- all_samples
#all_tables <- t(all_tables)
write.csv(all_tables,"genus_classfication.csv")

#keys <- colnames(all_tables)[!(colnames(all_tables) == "sample")]
all_tables <- gather(all_tables,"Archaea","Bacteria","Viruses", key="Domain", value = "percentage")

write.csv(all_tables,"genus_classfication_gathered.csv")

plot <- ggplot(data = all_tables, aes(x=name, y = percentage, fill=Domain)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=paste(percentage * 100,"%")),size = 2,position = position_stack(vjust = 0.5))+
  ylab("percentage of classfied sequences") +
  xlab("samples")

plot
ggsave(file="domain_classification.png",plot = plot)

library(tidyverse)
library(dplyr)
library(plyr)
library(ggplot2)

setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/KRAKEN2:BRACKEN/Domain")

all_samples <- list.files(".") # list all files in dir

all_tables <-data.frame(Date=as.Date(character()),
                               File=character(), 
                               User=character(), 
                               stringsAsFactors=FALSE)
#table for percentage only
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

all_tables$Domain <- factor(all_tables$Domain, levels = c("Archaea","Viruses","Bacteria"))
plot <- ggplot(data = all_tables, aes(x=name, y = percentage, fill=Domain)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=paste(percentage * 100,"%")),size = 2,position = position_stack(vjust = 0.5))+
  ylab("percentage of classfied sequences") +
  xlab("samples") +
  scale_fill_manual(values=c("limegreen","#FF9999","gold"))
  

plot
ggsave(file="domain_classification.png",plot = plot)


##################################################
# for unclassifed vs. Domain classified sequences#
##################################################
all_tables_reads <-data.frame(Date=as.Date(character()),
                        File=character(), 
                        User=character(), 
                        stringsAsFactors=FALSE)
#table for # of reads only
for (file in all_samples){
  # read all sample files, row= domain name, col = fraction of totoal reads
  current <- read.table(file,header = T,fill=F,sep="\t",quote="") %>% select(1,6) %>% spread(name,new_est_reads) 
  current$name <- file # change row name to sample name
  assign(file,current) # variable name to sample name, not necessary
  all_tables_reads <- rbind.fill(all_tables_reads,current) # combine samples
}

all_tables_reads <- all_tables_reads %>% select(-c(1,2,3))
#unclassified sequences from Kraken2 result that were excluded from Bracken analysis (only kracken2 results didn't classify into domains but still under root were redistributed)
all_tables_reads$UNKNOWN <- c(594901, 1305714, 529387, 552439, 582552, 409537, 649297, 1093414, 508946, 2189917, 2710704, 2528341)
#find the total number of sequences
all_tables_reads$Total <- all_tables_reads$UNKNOWN + all_tables_reads$Archaea + all_tables_reads$Bacteria + all_tables_reads$Viruses
#conver into percentage
all_tables_reads$Archaea <- all_tables_reads$Archaea/all_tables_reads$Total*100
all_tables_reads$Bacteria <- all_tables_reads$Bacteria/all_tables_reads$Total*100
all_tables_reads$Viruses<- all_tables_reads$Viruses/all_tables_reads$Total*100
all_tables_reads$UNKNOWN <- all_tables_reads$UNKNOWN/all_tables_reads$Total*100
#delete total
all_tables_reads <- all_tables_reads %>% select(-c("Total"))


all_tables_reads <- gather(all_tables_reads,"Archaea","Bacteria","Viruses","UNKNOWN" ,key="Domain", value = "percentage")
all_tables_reads$Domain <- factor(all_tables_reads$Domain, levels = c("UNKNOWN","Archaea","Viruses","Bacteria"))
plot_unknown <- ggplot(data = all_tables_reads, aes(x=name, y = percentage, fill=Domain)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=paste(format(round(percentage, 2), nsmall = 2),"%")),size = 2,position = position_stack(vjust = 0.5))+
  ylab("Relative Abundance") +
  xlab("samples") +
  scale_fill_manual(values=c("grey","limegreen","#FF9999","gold"))
plot_unknown
ggsave(file="../domain_classification_unkown.png",plot = plot_unknown,width = 10, height = 6)

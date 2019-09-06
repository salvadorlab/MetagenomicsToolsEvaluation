library(xlsx)
library(dplyr)
library(tidyr)
library(ggplot2)
setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/CLARK:CLARK(s)/results_phylum")

all_files <- list.files(".")


# to add up domain percentage, ignore genus
for (file in all_files){
  current <- read.xlsx2(file,1,header = T) %>% select(1,9)
  current_total <- sum(as.numeric(as.character(current$Count)))

  
  current <- current %>% mutate(percentage=as.numeric(as.numeric(as.character(current$Count))/current_total * 100)) %>% select(1,3)
  current[order(current$percentage)]
  colnames(current)[2] <-  unlist(strsplit(file,"_."))[1]
  
  if (sample_name != "R22.K"){
    unclassified <- full_join(unclassified, current, by = NULL) # combine samples into one table
  }
  else{
    unclassified <- current 
  }
  
}
colnames(unclassified)[-1]
unclassified_gather <- gather(unclassified, colnames(unclassified)[-1], key = "samples", value = "percentage")
ggplot(unclassified_gather, aes(x=samples, y=percentage, fill=Name))+
  geom_bar(stat = "identity") 

# this program process tax ids for the taxa to feed into full_lineage_query.py for lineage to create taxa table for kraken

library(xlsx)
#convert excel str to numbers

setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/KRAKEN2:BRACKEN/genus/")
data <- read.xlsx("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/KRAKEN2:BRACKEN/genus/taxid_only_all_braken.xlsx",1,header=F)

j <- 1
new_data <- data.frame()
for (i in data[,1]){
  taxid <- as.numeric(unlist(strsplit(i,"\\t"))[2])
  current_data <- data.frame(taxid)
  new_data <- rbind(new_data,current_data)
  j <- j+1
}

write.table(new_data,"taxid_only_all_braken.txt",sep="\n",quote = FALSE, col.names = F, row.names = F)

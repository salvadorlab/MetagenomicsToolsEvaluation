library(xlsx)
library(dplyr)

setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/CLARK:CLARK(s)/results_phylum")

all_files <- list.files(".")

for (file in all_files){
  current <- read.xlsx2(file,1) %>% select(1,2,3,11) 
  sample_name <- unlist(strsplit(file,"_."))[1] #extract sample name
  colnames(current)[4] <- sample_name # rename proportion with sample name
  # if else feed the first sample R22.K into the overall table
  current[,4] <- as.numeric(as.character(current[,4])) * (1/100)
  if (sample_name != "R22.K"){
    all_samples <- full_join(all_samples, current, by = NULL) # combine samples into one table
  }
  else{
    all_samples <- current 
  }
}

all_samples <- arrange(all_samples,Lineage) 

write.csv(all_samples, "../all_samples_phylum.csv")

# all_samples.csv was imported into excel file, formatted and saved as all_samples_CLARK.xlsx

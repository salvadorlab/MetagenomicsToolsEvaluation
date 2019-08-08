library(readxl) # from tidyverse package
library(dplyr)

setwd("/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis")

sheets <- seq(2,24,2) # skip Metaphlan2 format sheets 
samples <- excel_sheets("Kraken2_Metagenomic_profiling.xlsx")[sheets] # get the name of the sheets

# format needed info from sheets
for (i in samples) {
   assign(i, read_excel("Kraken2_Metagenomic_profiling.xlsx", sheet=i) %>% 
    select(2,4,6) %>% 
    filter(`Rank Code` %in% c("U","D"))) %>%
    select(1,3)
}


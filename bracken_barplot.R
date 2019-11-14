library(xlsx)
library(dplyr)
library(tidyr)
library(ggplot2)
setwd("/Users/rx32940/Dropbox/5.Rachel-projects/Metagenomic_Analysis/Kraken2-standard/custom/phylum/results")

all_files <- list.files(".")


# top 20 phylum + rest added to "other" category + Chordata sequences
for (file in all_files){
  current <- read.table(file,header = T,fill=F,sep="\t",quote="") 
  
  current <- current[order(current$new_est_reads,decreasing = T),]%>% select(1,7) #order with actual read, because proportion was rounded
  colnames(current)[2] <- file 
  
  #sum_rest <- summarise(current,sum_rest = sum(current[-c(1:20),2]))#sum rest percentage except for the top 20 phylum
  #sum_rest$name <- "other"# name the sum as other
  #colnames(sum_rest)[1] <- file # change the summed fraction(current name is "sum_rest") colname to name for rbind
  
 # top_20 <- head(current,21) # top 20 phylum and rat
  #current <- rbind(sum_rest,top_20) #bind sum of others to top 20 phylum and rat
  
  if (file != "R22.K"){
    prop_combined <- full_join(prop_combined, current, by = NULL) # combine samples into one table
  }
  else{
    prop_combined <- current 
  }
  
}

# create a table to show top ten species for each sample 
prop_combined[is.na(prop_combined)] <- 0
rownames(prop_combined) <- prop_combined$name
prop_combined <- prop_combined[,-1]
write.csv(prop_combined, "../bracken_%_custom_phylum.csv")


keys_to_gather <- colnames(prop_combined) #exclude Name column from rest of the sample names
prop_combined_gather <- gather(prop_combined, keys_to_gather, key = "samples", value = "percentage") #gather so can plot stacked bar plot
uniq_phylum <- unique(rownames(prop_combined))[-c(1)] # unique phylums exclude UNKNOWN and other(this list is for ordering purpose happening next)
prop_combined_gather$samples <- factor(prop_combined_gather$samples, levels = c("Chordata", uniq_phylum)) #order the bar plot so UNKNOWN and other can separate from rest of phylum
prop_combined_gather$samples <- factor(prop_combined_gather$samples,levels = c("R22.K","R26.K","R27.K","R28.K","R22.L","R26.L","R27.L","R28.L","R22.S","R26.S","R27.S","R28.S"))

color_palette <- c("darkolivegreen4","yellow","cyan2","darkseagreen1","coral","#50FFB1","#083D77","#EBEBD3","#0AD3FF","lavender","lightpink","#BCF4F5","#A491D3","#EB5E55","#FC9F5B","#FFB7C3","#CFCFEA","#E76B74","#34D1BF","#5B4E77","#EA638C",
                  "#E8E1EF","#CDACA1","#C7FFDA","#CD8987","#93B5C6","#50FFB1","#083D77","#EBEBD3","#0AD3FF","#B91372","#CBFF8C","#FFEAD0","#F76F8E","#33658A","#EDD382","#CC2936",
                  "antiquewhite","chartreuse2","coral","darkgoldenrod1","cyan2","darkseagreen1","lavender","lightpink","#CD8987","#93B5C6")

Relative <- ggplot(prop_combined_gather, aes(x=samples, y=percentage, fill=name))+
  geom_bar(stat = "identity") +
  scale_fill_manual(values = color_palette)+
  ggtitle("phylum Level Relative Abundance of the Classified Taxa")+
  labs(y="proportion")

# Chordata + top10 + combined other
Relative
ggsave("../phylum_relative_top10.png",Relative)


# absolute abundance for each taxa
# top 10 phylum + rest added to "other" category + Chordata sequences
for (file in all_files){
  current_abs <- read.table(file,header = T,fill=F,sep="\t",quote="") %>% select(1,6)
  
  current_abs <- current_abs[order(current_abs$new_est_reads,decreasing = T),]
  colnames(current_abs)[2] <- file # <- unlist(strsplit(file,"_."))[1]
  
  sum_rest <- summarise(current_abs,sum_rest = sum(current_abs[-c(1:10),2]))#sum rest percentage except for the top 10 phylum
  sum_rest$name <- "other"# name the sum as other
  colnames(sum_rest)[1] <- file # change the summed fraction(current name is "sum_rest") colname to name for rbind
  
  top_10 <- head(current_abs,11) # top 10 phylum and RAT
  current_abs <- rbind(sum_rest,top_10) #bind sum of others to top 10 phylum and RAT
  
  if (file != "R22.K"){
    absolute_combined <- full_join(absolute_combined, current_abs, by = NULL) # combine samples into one table
  }
  else{
    absolute_combined <- current_abs 
  }
  
}
keys_to_gather <- colnames(absolute_combined)[-2] #exclude Name column from rest of the sample names
absolute_combined_gather <- gather(absolute_combined, keys_to_gather, key = "samples", value = "Read_Counts") #gather so can plot stacked bar plot
uniq_phylum <- unique(absolute_combined_gather$name)[-c(1,2)] # unique phylums exclude UNKNOWN and other(this list is for ordering purpose happening next)
absolute_combined_gather$name <- factor(absolute_combined_gather$name, levels = c("Chordata","other", uniq_phylum)) #order the bar plot so UNKNOWN and other can separate from rest of phylum
absolute_combined_gather$samples <- factor(absolute_combined_gather$samples,levels = c("R22.K","R26.K","R27.K","R28.K","R22.L","R26.L","R27.L","R28.L","R22.S","R26.S","R27.S","R28.S"))


absolute <- ggplot(absolute_combined_gather, aes(x=samples, y=Read_Counts, fill=name))+
  geom_bar(stat = "identity") +
  scale_fill_manual(values = color_palette)+
  ggtitle("phylum Level Absolute Abundance of the Classified Taxa")+
  labs(y="Reads")

# Chordata + top10 + combined other
absolute
ggsave("../phylum_absolute_top10.png",absolute)

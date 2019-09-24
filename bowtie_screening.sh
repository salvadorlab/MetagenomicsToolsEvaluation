#!/bin/bash
#PBS -q batch                                                          
#PBS -N species_classify                                           
#PBS -l nodes=1:ppn=2 -l mem=30gb                                        
#PBS -l walltime=30:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/Metagenomic_taxon_profile                       
#PBS -e /scratch/rx32940/Metagenomic_taxon_profile                         
#PBS -j oe     


module load Bowtie2/2.3.4.1-foss-2016b

DATA="/scratch/rx32940/Metagenomic_taxon_profile/Data"
bowtie2-build $DATA/refSeq/rn6.fa $DATA/host_DB

for file in $DATA/rawProcessed/*; do
    SAMPLE=$(basename "$file")
    bowtie2 -f --reorder -x host_DB -U $file --un $DATA/hostCleaned/$SAMPLE.fna 
done


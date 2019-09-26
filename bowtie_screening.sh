#!/bin/bash
#PBS -q highmem_q                                                        
#PBS -N hostclean                                           
#PBS -l nodes=1:ppn=4 -l mem=200gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/Metagenomic_taxon_profile                       
#PBS -e /scratch/rx32940/Metagenomic_taxon_profile                         
#PBS -j oe     


module load Bowtie2/2.3.4.1-foss-2016b

DATA="/scratch/rx32940/Metagenomic_taxon_profile/Data"
# bowtie2-build $DATA/refSeq/rn6.fa $DATA/host_DB # build index for reference genome, in .bt2 format
# echo "bowtie-build done"


SAMPLE="mgm4860394"
mkdir $DATA/hostCleaned/$SAMPLE

echo "$SAMPLE start"
bowtie2 -f --reorder -x $DATA/host_DB -U $DATA/rawProcessed/$SAMPLE.fna --un $DATA/hostCleaned/$SAMPLE/$SAMPLE.fna  # -x ask for the basename of the index files
echo "$SAMPLE done"



#!/bin/bash
#PBS -q batch                                                            
#PBS -N Kraken-test                                            
#PBS -l nodes=1:ppn=2 -l mem=10gb                                        
#PBS -l walltime=5:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/Metagenomic_taxon_profile                       
#PBS -e /scratch/rx32940/Metagenomic_taxon_profile                         
#PBS -j oe   

# assembly based binning 
module load MetaBAT/2.12.1-foss-2018a-linux_x86_64

path="/scratch/rx32940/Metagenomic_taxon_profile/Data/02.Assembly"
runMetaBat.sh $path/R22.L/R22.L.scafSeq.fa $path/alignment/R22.L.bowtie.sorted.bam
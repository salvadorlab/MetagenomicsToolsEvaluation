#!/bin/bash
#PBS -q batch                                                            
#PBS -N MetaBAT                                            
#PBS -l nodes=1:ppn=2 -l mem=10gb                                        
#PBS -l walltime=5:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/Metagenomic_taxon_profile                       
#PBS -e /scratch/rx32940/Metagenomic_taxon_profile                         
#PBS -j oe   

# assembly based binning 
module load MetaBAT/2.12.1-foss-2018a-linux_x86_64

path="/scratch/rx32940/Metagenomic_taxon_profile"
#runMetaBat.sh $path/Data/02.Assembly/R22.L/R22.L.scaftigs.fa $path/Data/02.Assembly/alignment/R22.L.bowtie.sorted.bam

jgi_summarize_bam_contig_depths --outputDepth $path/MetaBAT-output/depth.txt $path/Data/02.Assembly/alignment/R22.L.bowtie.sorted.bam 
metabat2 -m 500 -i $path/Data/02.Assembly/R22.L/R22.L.scaftigs.fa -a $path/MetaBAT-output/depth.txt -o bin > $path/MetaBAT-output/R22.L.txt
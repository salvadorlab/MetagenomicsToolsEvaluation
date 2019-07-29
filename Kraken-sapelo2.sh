#!/bin/bash
#PBS -q batch                                                            
#PBS -N Kraken-test                                            
#PBS -l nodes=1:ppn=4 -l mem=20gb                                        
#PBS -l walltime=20:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/Metagenomic_taxon_profile                       
#PBS -e /scratch/rx32940/Metagenomic_taxon_profile                         
#PBS -j oe   

module load Kraken2/2.0.7-beta-foss-2018a-Perl-5.26.1

path='/scratch/rx32940/Metagenomic_taxon_profile/'
kraken2 --threads 4 --paired $path/Data/01.Data/hostclean/R22.L/R22.L_1_kneaddata_paired_1.fastq $path/Data/01.Data/hostclean/R22.L/R22.L_1_kneaddata_paired_2.fastq > $path/Kraken_output.txt
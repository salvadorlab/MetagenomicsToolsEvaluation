#!/bin/bash
#PBS -q batch                                                            
#PBS -N MetaPhlAn2-test                                            
#PBS -l nodes=1:ppn=2 -l mem=20gb                                        
#PBS -l walltime=10:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/Metagenomic_taxon_profile                       
#PBS -e /scratch/rx32940/Metagenomic_taxon_profile                         
#PBS -j oe     


cd $PBS_O_WORKDIR

module load MetaPhlAn2/2.7.8-foss-2016b-Python-2.7.14

metaphlan2.py /project/lslab/lab_shared/leptoData/Metagenomics_Analyzed_Results/01.Data/R22.K_1_kneaddata_paired_1.fastq --input_type fastq > /scratch/rx32940/Metagenomic_taxon_profile/R22.K_metaPhlAn2.txt
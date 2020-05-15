#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N test                                            
#PBS -l nodes=1:ppn=12 -l mem=100gb                                        
#PBS -l walltime=60:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/
#PBS -e /scratch/rx32940/                     
#PBS -j oe   

module load Bowtie2/2.3.5.1-foss-2018a
module load Trimmomatic/0.36-Java-1.8.0_144
module load FastQC/0.11.8-Java-1.8.0_144 
module load SAMtools/1.10-GCC-8.2.0-2.31.1

cd $PBS_O_WORKDIR

seq_path="/scratch/rx32940/kraken2_052020/kneaddata"
# build database for host reference (refseq for R.rattus and R.norvegicus_Rnor_6.0) for kneaddate cleaning
# bowtie2-build $seq_path/reference_seq/GCF_000001895.5_Rnor_6.0_genomic.fna $seq_path/ref_db/
bowtie2-build $seq_path/reference_seq/GCF_011064425.1_Rrattus_CSIRO_v1_genomic.fna $seq_path/ref_db/
# host clean with KneadData (downloaded to sapelo2 home dir: pip install --user kneaddate)
# kneaddata --trimmomatic /usr/local/apps/eb/Trimmomatic/0.33-Java-1.8.0_144

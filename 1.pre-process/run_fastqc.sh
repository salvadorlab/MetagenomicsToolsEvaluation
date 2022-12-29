#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=fastqc_raw
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=1         
#SBATCH --time=100:00:00
#SBATCH --mem=10G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

ml FastQC/0.11.9-Java-11

DATA="/scratch/rx32940/metagenomics/data"

for file in $DATA/rawdata/*/*fastq;
do

sample=$(basename $file ".fastq")

fastqc -o $DATA/fastqc/raw $file

done

# for file in $DATA/cleaned/*_kneaddata_paired_*.fastq;
# do

# sample=$(basename $file ".fastq")

# fastqc -o $DATA/fastqc/cleaned $file

# done
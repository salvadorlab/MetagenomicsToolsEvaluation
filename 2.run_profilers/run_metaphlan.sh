#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=metaphlan3
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12          
#SBATCH --time=128:00:00
#SBATCH --mem=200G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

source activate metaphlan

################################################################
# 1) download database 
#  
################################################################
# ml bzip2/1.0.8-GCCcore-10.2.0
# wget https://www.dropbox.com/sh/7qze7m7g9fe2xjg/AAAlyQITZuUCtBUJxpxhIroIa/mpa_v30_CHOCOPhlAn_201901_marker_info.txt.bz2?dl=1
# bunzip2 mpa_v30_CHOCOPhlAn_201901_marker_info.txt.bz2\?dl\=1.bz2 

################################################################
# 2) run metaphlan3
#  
################################################################
INPUT="/scratch/rx32940/metagenomics/data/cleaned"
OUT="/scratch/rx32940/metagenomics/metaphlan3/output"
DB="/scratch/rx32940/metagenomics/metaphlan3/db"

# for file in $INPUT/*_kneaddata_paired_1.fastq;
# do

# sample=$(basename $file '_1_kneaddata_paired_1.fastq')

# time metaphlan $INPUT/${sample}_1_kneaddata_paired_1.fastq,$INPUT/${sample}_1_kneaddata_paired_2.fastq \
# --input_type fastq --add_viruses \
# -o $OUT/${sample}.txt \
# --bowtie2out $DB/${sample}.bowtie2.bz2 \
# --nproc 12 \
# --unknown_estimation \
# --bowtie2db $DB \
# --sample_id_key $sample \
# --sample_id_key $sample \
# -t rel_ab_w_read_stats

# done


################################################################
# 2) merge outputs
#  
################################################################
META="/scratch/rx32940/metagenomics/metaphlan3"
python $META/merge_metaphlan_tables_absolute.py $(ls $OUT/*) -o $META/metaphlan3_all_samples.txt
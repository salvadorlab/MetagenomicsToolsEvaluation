#!/bin/bash


source activate metaphlan2

path='/Users/rx32940/Desktop'
metaphlan2.py $path/01.Data/hostclean/R22.L/R22.L_1_kneaddata_paired_1.fastq,$path/01.Data/hostclean/R22.L/R22.L_1_kneaddata_paired_2.fastq --input_type fastq --bowtie2out $path/01.Data/R22.L.bowtie2out.bz2 > $path/01.Data/R22.L_metaPhlAn2.txt
# metaphlan2.py metagenome.fastq --bowtie2out metagenome.bowtie2.bz2 --nproc 5 --input_type fastq > profiled_metagenome.txt

#metaphlan2.py $path/01.Data/R22.K.bowtie2out.bz2 --input_type bowtie2out > $path/01.Data/profiled_metagenome.txt
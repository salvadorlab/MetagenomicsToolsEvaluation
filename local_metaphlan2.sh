#!/bin/bash


source activate metaphlan2

path='/Users/rx32940/Desktop'
metaphlan2.py $path/01.Data/rawdata/R22.K/R22.K_1.fq.gz,$path/01.Data/rawdata/R22.K/R22.K_1.fq.gz --input_type fastq --bowtie2out $path/01.Data/R22.K.bowtie2out.bz2 > $path/01.Data/R22.K_metaPhlAn2.txt
#metaphlan2.py metagenome.fastq --bowtie2out metagenome.bowtie2.bz2 --nproc 5 --input_type fastq > profiled_metagenome.txt
#
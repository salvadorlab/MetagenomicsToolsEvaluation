#!/bin/bash

metaphlan2.py $path/Data/01.Data/hostclean/R22.K/R22.K_1_kneaddata_paired_1.fastq $path/Data/01.Data/hostclean/R22.K/R22.K_1_kneaddata_paired_2.fastq --input_type fastq --bowtie2out $path/R22.K.bowtie2out.bz2 > $path/R22.K_metaPhlAn2.txt
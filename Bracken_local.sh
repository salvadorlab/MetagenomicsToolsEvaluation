#!/bin/bash

source activate metagenomics

path='/Users/rx32940/Downloads/kraken'

for file in $path/kraken_output/*.txt; do
    echo $file
    sample=$(basename $file .txt)
    echo $sample
    est_abundance.py -k $path/minikraken2_v1_8GB/database100mers.kmer_distrib -i $path/kraken_output/$sample.txt -l S -o $path/bracken_output/$sample.txt.bracken
done
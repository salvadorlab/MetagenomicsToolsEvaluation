#!/bin/bash

path='/scratch/rx32940/Metagenomic_taxon_profile'
for file in $path/kraken_output/*kreport; do
    sample=$(basename $file .kreport)
    $path/bracken/Bracken-2.5/bracken -d $path/kraken/minikraken2_v1_8GB_201904_UPDATE -i $path/kraken_output/$sample.kreport -o $path/bracken/output/phylum/$sample -l P -t 10
done

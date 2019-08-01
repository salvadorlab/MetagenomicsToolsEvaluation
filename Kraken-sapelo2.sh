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
module load KronaTools/2.7


path='/scratch/rx32940/Metagenomic_taxon_profile'

for dir in $path/Data/01.Data/hostclean/*; do
    echo $dir
    sample=$(echo $dir | awk -F'[/]' '{print $8}')
    kraken2 --use-names --db $path/kraken/minikraken2_v1_8GB_201904_UPDATE --report --threads 4 --report $sample.report.txt --paired $path/Data/01.Data/hostclean/$sample/${sample}_1_kneaddata_paired_1.fastq $path/Data/01.Data/hostclean/$sample/${sample}_1_kneaddata_paired_2.fastq > $path/kraken_output/$sample.txt
    cat $path/kraken_output/$sample.txt | cut -f 2,3 > $path/kraken_output/$sample.krona
    ktImportTaxonomy evolved-6.kraken.krona
done
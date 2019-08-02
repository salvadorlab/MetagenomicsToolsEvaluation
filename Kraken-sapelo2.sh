#!/bin/bash
#PBS -q batch                                                            
#PBS -N Kraken-test                                            
#PBS -l nodes=1:ppn=2 -l mem=10gb                                        
#PBS -l walltime=5:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/Metagenomic_taxon_profile                       
#PBS -e /scratch/rx32940/Metagenomic_taxon_profile                         
#PBS -j oe   

module load Kraken2/2.0.7-beta-foss-2018a-Perl-5.26.1
# Bracken not usable on sapelo2, will run it locally, can't find "/usr/local/apps/eb/Bracken/2.2-foss-2016b/bin/src/est_abundance.py"
# krona not usable either, can't update taxonomy labels, no access for the folder

path='/scratch/rx32940/Metagenomic_taxon_profile'
for dir in $path/Data/01.Data/hostclean/*; do
    sample=$(echo $dir | awk -F'[/]' '{print $8}')
    kraken2 --use-names --db $path/kraken/minikraken2_v1_8GB_201904_UPDATE --threads 4 --use-mpa-style --report $path/kraken_output/$sample.report.txt --paired $path/Data/01.Data/hostclean/$sample/${sample}_1_kneaddata_paired_1.fastq $path/Data/01.Data/hostclean/$sample/${sample}_1_kneaddata_paired_2.fastq > $path/kraken_output/$sample.txt
    # time bracken -d $path/kraken/minikraken2_v1_8GB_201904_UPDATE -i $path/kraken_output/$sample.txt -l S -o $path/kraken_output/$sample.txt.bracken
    cat $path/kraken_output/$sample.txt | cut -f 2,3 > $path/kraken_output/$sample.krona
done
#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N clark_results                                        
#PBS -l nodes=1:ppn=12 -l mem=500gb                                        
#PBS -l walltime=20:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/
#PBS -e /scratch/rx32940/                     
#PBS -j oe 

path="/scratch/rx32940/clark_0613"
DB="/scratch/rx32940/clark_0613/database"
seq_path="/scratch/rx32940/clark_0613/hostclean_seq"

###################################################################
#
# Building the database(s)
# select among 'bacteria', 'viruses', 'plasmid', 'plastid', 'protozoa', 'fungi', 'human' and/or 'custom'
# genomes from NCBI/RefSeq will be downloaded if they are not present in $DB
# 
# *** Custom database built with cp Bacteria, Human, Viruses databases into Custom
#     Wget Univec_core from NCBI's ftp: https://ftp.ncbi.nlm.nih.gov/pub/UniVec/UniVec_Core
###################################################################

# download databases provided by clark that matches kraken2's standard library 
# each category submit separate for speed 

# $path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard bacteria 
# $path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard viruses 
# $path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard human 

# build custom database after added Univec_core
# $path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard custom 

###################################################################
#
# Setting Taxonomy rank
# The default taxonomy rank is species
#
###################################################################

# $path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard custom bacteria viruses human --phylum 
# $path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard custom bacteria viruses human --genus
$path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard custom bacteria viruses human --species

# use one sample to build the discriminative database
$path/CLARKSCV1.2.6.1/classify_metagenome.sh -n 12 -O $seq_path/R22.K_1_kneaddata_unmatched_1.fastq -R $path/output_species/R22.K

# classify each sequence
# for file in $seq_path/*; do
#     sample=$(basename "$file" "_1_kneaddata_unmatched_1.fastq")
#     $path/CLARKSCV1.2.6.1/classify_metagenome.sh -n 24 -O $seq_path/${sample}_1_kneaddata_unmatched_1.fastq -R $path/output_genus/$sample
# done

# echo "classify_metagenome done"

# analyze result from clark
# for file in /scratch/rx32940/clark_0613/output_genus/*; do 
#    sample_csv=$(basename "$file" ".csv")
#    $path/CLARKSCV1.2.6.1/estimate_abundance.sh -F /scratch/rx32940/clark_0613/output_genus/$sample_csv.csv -D $DB/standard > /scratch/rx32940/clark_0613/output_genus/${sample_csv}_abundance.txt
# done

# echo "regular abundance estimation done"

# build spaced database for clark-s 
# cd $path/CLARKSCV1.2.6.1
# ./buildSpacedDB.sh
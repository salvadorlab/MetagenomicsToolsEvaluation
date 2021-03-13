#!/bin/bash
#PBS -q batch                                                            
#PBS -N clarks_abundance                                       
#PBS -l nodes=1:ppn=12 -l mem=100gb                                        
#PBS -l walltime=300:00:00                                                
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

# reset custom db, added refseq for Rattus into custom db along with univec_core
# no need to set_targets separately with custom db. straight set_target with rest of the db, default is species level
# set targets is species level, provide full taxonomic lineage in the report. can do conversion in R to speed up the analysis


##################################################################
#
# clark cannot process pair end reads with unmatching read id 
# order of forward and backward reads not matching
# used this tool to mach the order of the forward and reverse file:
# fastq-pair: https://github.com/linsalrob/fastq-pair.git
# no need to submit to sapelo2, run this part locally
#
###################################################################

# cd /scratch/rx32940/clark_0613/hostclean_seq

# cat /scratch/rx32940/kraken2_052020/kneaddata/metagenomic_samples.txt | \
# while read sample; do
# fastq_pair ${sample}_1_kneaddata_paired_1.fastq ${sample}_1_kneaddata_paired_2.fastq
# done


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
$path/CLARKSCV1.2.6.1/classify_metagenome.sh -n 1 -P $seq_path/R22.K_1_kneaddata_paired_1.fastq.paired.fq $seq_path/R22.K_1_kneaddata_paired_2.fastq.paired.fq -R $path/output_species_rat/R22.K

# classify each sequence
# cat /scratch/rx32940/kraken2_052020/kneaddata/metagenomic_samples.txt | \
# while read sample;
# do
#    #  sample=$(basename "$file" "_1_kneaddata_unmatched_1.fastq")
#     $path/CLARKSCV1.2.6.1/classify_metagenome.sh -n 12 -P $seq_path/${sample}_1_kneaddata_paired_1.fastq.paired.fq $seq_path/${sample}_1_kneaddata_paired_2.fastq.paired.fq -R $path/output_species_rat/$sample
# done

# $path/CLARKSCV1.2.6.1/classify_metagenome.sh -n 12 -P $path/samples.R.txt $path/samples.L.txt -R $path/output_species/samples.results.txt

# analyze result from clark
# for file in /scratch/rx32940/clark_0613/output_species_rat/*.csv; do 
#    sample_csv=$(basename "$file" ".csv")
#    $path/CLARKSCV1.2.6.1/estimate_abundance.sh -F /scratch/rx32940/clark_0613/output_species_rat/$sample_csv.csv -D $DB/standard > /scratch/rx32940/clark_0613/output_species_rat/${sample_csv}_abundance.txt
# done

# echo "regular abundance estimation done"

# # build spaced database for clark-s 
# cd $path/CLARKSCV1.2.6.1
# ./buildSpacedDB.sh

# classify each sequence with spaced database (clark-s)
# cat /scratch/rx32940/kraken2_052020/kneaddata/metagenomic_samples.txt | \
# while read sample;
# do
#    #  sample=$(basename "$file" "_1_kneaddata_unmatched_1.fastq")
#     $path/CLARKSCV1.2.6.1/classify_metagenome.sh -n 12 -P $seq_path/${sample}_1_kneaddata_paired_1.fastq.paired.fq $seq_path/${sample}_1_kneaddata_paired_2.fastq.paired.fq -R $path/output_species_rat_spaced/$sample --spaced
# done

# analyze result from clark
for file in /scratch/rx32940/clark_0613/output_species_rat_spaced/*.csv; do 
   sample_csv=$(basename "$file" ".csv")
   $path/CLARKSCV1.2.6.1/estimate_abundance.sh -F /scratch/rx32940/clark_0613/output_species_rat_spaced/$sample_csv.csv -D $DB/standard > /scratch/rx32940/clark_0613/output_species_rat_spaced/${sample_csv}_abundance.txt
done

# echo "spaced abundance estimation done"
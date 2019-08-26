#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N run_clark                                            
#PBS -l nodes=1:ppn=2 -l mem=200gb                                        
#PBS -l walltime=50:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/CLARK                       
#PBS -e /scratch/rx32940/CLARK                         
#PBS -j oe     

# building Clark-s database

path="/scratch/rx32940"

# set up the database
$path/CLARK/CLARKSCV1.2.6.1/set_targets.sh $path/CLARK/DB bacteria viruses --species
$path/CLARK/CLARKSCV1.2.6.1/set_targets.sh $path/CLARK/DB bacteria viruses --genus

echo "set target done"


# database of discriminative 31-mers
$path/CLARK/CLARKSCV1.2.6.1/classify_metagenome.sh -P $path/Metagenomic_taxon_profile/Data/01.Data/hostclean/R22.K/R22.K_1_kneaddata_paired_1.fastq $path/Metagenomic_taxon_profile/Data/01.Data/hostclean/R22.K/R22.K_1_kneaddata_paired_2.fastq -R /scratch/rx32940/CLARK/output/result

echo "classify_metagenome done"

# databases of discriminative spaced 31-mers
$path/CLARK/CLARKSCV1.2.6.1/buildSpacedDB.sh

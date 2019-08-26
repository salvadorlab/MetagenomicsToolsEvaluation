#!/bin/bash
#PBS -q bahl_salv_q                                                           
#PBS -N loop_base_clark                                            
#PBS -l nodes=1:ppn=2 -l mem=100gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/CLARK                       
#PBS -e /scratch/rx32940/CLARK                         
#PBS -j oe     

# building Clark-s database

path="/scratch/rx32940"
data_path="/scratch/rx32940/Metagenomic_taxon_profile/Data/01.Data/hostclean"

# set up the database
#$path/CLARK/CLARKSCV1.2.6.1/set_targets.sh $path/CLARK/DB bacteria viruses --species
#$path/CLARK/CLARKSCV1.2.6.1/set_targets.sh $path/CLARK/DB bacteria viruses --genus

#echo "set target done"


# database of discriminative 31-mers
# couldn't get a list of fastq files to run together, try to run individually now

for file in $data_path/*; do
    sample=$(basename "$file")
    $path/CLARK/CLARKSCV1.2.6.1/classify_metagenome.sh -P $data_path/$sample/${sample}_1_kneaddata_paired_1.fastq $data_path/$sample/${sample}_1_kneaddata_paired_2.fastq -R $path/CLARK/output/$sample.txt
done
#echo "classify_metagenome done"

# analyze result from regular clark
#$path/CLARK/CLARKSCV1.2.6.1/estimate_abundance.sh -F /scratch/rx32940/CLARK/output/result.csv -D $path/CLARK/DB > /scratch/rx32940/CLARK/output/result_abundance.txt

# databases of discriminative spaced 31-mers
#$path/CLARK/CLARKSCV1.2.6.1/buildSpacedDB.sh

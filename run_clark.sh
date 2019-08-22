#!/bin/bash
#PBS -q batch                                                            
#PBS -N run_clark                                            
#PBS -l nodes=1:ppn=4 -l mem=200gb                                        
#PBS -l walltime=100:00:00                                                
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
$path/CLARK/CLARKSCV1.2.6.1/classify_metagenome.sh -P $path/CLARK/sample.L.txt $path/CLARK/sample.R.txt -R /scratch/rx32940/CLARK/output/result

echo "classify_metagenome done"

# databases of discriminative spaced 31-mers
$path/CLARK/CLARKSCV1.2.6.1/buildSpacedDB.sh

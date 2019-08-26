#!/bin/bash
#PBS -q batch                                                           
#PBS -N run_clark                                            
#PBS -l nodes=1:ppn=2 -l mem=20gb                                        
#PBS -l walltime=30:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/CLARK                       
#PBS -e /scratch/rx32940/CLARK                         
#PBS -j oe     

# building Clark-s database

path="/scratch/rx32940"

# set up the database
#$path/CLARK/CLARKSCV1.2.6.1/set_targets.sh $path/CLARK/DB bacteria viruses --species
#$path/CLARK/CLARKSCV1.2.6.1/set_targets.sh $path/CLARK/DB bacteria viruses --genus

#echo "set target done"


# database of discriminative 31-mers
$path/CLARK/CLARKSCV1.2.6.1/classify_metagenome.sh -P $path/CLARK/sample.R.txt $path/CLARK/sample.L.txt -R /scratch/rx32940/CLARK/output/result.txt

#echo "classify_metagenome done"

# analyze result from regular clark
#$path/CLARK/CLARKSCV1.2.6.1/estimate_abundance.sh -F /scratch/rx32940/CLARK/output/result.csv -D $path/CLARK/DB > /scratch/rx32940/CLARK/output/result_abundance.txt

# databases of discriminative spaced 31-mers
#$path/CLARK/CLARKSCV1.2.6.1/buildSpacedDB.sh

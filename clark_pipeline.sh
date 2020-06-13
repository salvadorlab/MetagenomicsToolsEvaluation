#!/bin/bash
#PBS -q bahl_salv_q                                                            
#PBS -N clark_virus                                        
#PBS -l nodes=1:ppn=1 -l mem=100gb                                        
#PBS -l walltime=200:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/
#PBS -e /scratch/rx32940/                     
#PBS -j oe 

path="/scratch/rx32940/clark_0613"
DB="/scratch/rx32940/clark_0613/database"

###################################################################
#
# Selecting the database(s)
# select among 'bacteria', 'viruses', 'plasmid', 'plastid', 'protozoa', 'fungi', 'human' and/or 'custom'
# genomes from NCBI/RefSeq will be downloaded if they are not present in $DB
#
###################################################################

# download databases provided by clark that matches kraken2's standard library 
#(clark didn't provide an UniVec database)
# added univec_core database from https://ftp.ncbi.nlm.nih.gov/pub/UniVec/UniVec_Core
# each category submit separate for speed 

# $path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard bacteria 
$path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard viruses 
# $path/CLARKSCV1.2.6.1/set_targets.sh $DB/standard human 
 

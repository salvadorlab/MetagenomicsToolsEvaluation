#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N ratdb_kraken2                                            
#PBS -l nodes=1:ppn=4 -l mem=200gb                                        
#PBS -l walltime=200:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/kraken                       
#PBS -j oe   

module load BLAST+/2.7.1-foss-2016b-Python-2.7.14 # for dust masker and segmasker

DBNAME='/scratch/rx32940/kraken/DB'
RATDB='/scratch/rx32940/kraken/RATDB'

#build a standard Kraken2 database
#kraken2-build --standard --threads 4 --db $DBNAME

# build library with rat reference genome
kraken2-build --download-taxonomy --db $RATDB

kraken2-build --download-library bacteria --db $RATDB

kraken2-build --download-library archaea --db $RATDB

kraken2-build --download-library archaea --db $RATDB

kraken2-build --add-to-library /scratch/rx32940/kraken/GCF_000001895.5_Rnor_6.0_genomic.fna --db $RATDB

kraken2-build --build --threads 4 --db $RATDB

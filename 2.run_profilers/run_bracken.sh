#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=bracken
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=1           
#SBATCH --time=128:00:00
#SBATCH --mem=200G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

################################################################
# 1) download database https://benlangmead.github.io/aws-indexes/k2
#  bracken db was downloaded with kraken2 standard database
################################################################


################################################################
# 2) bracken classify and correction
#  the output of bracken is based on the output of kraken2 analysis with standard database (--report output)
################################################################

source activate kraken2

KRAKEN_DB="/scratch/rx32940/metagenomics/kraken2/standard/db"
OUT="/scratch/rx32940/metagenomics/bracken/standard/output"
KRAKEN_OUT="/scratch/rx32940/metagenomics/kraken2/standard/output"

for file in $KRAKEN_OUT/*.kreport;
do
SAMPLE=$(basename $file '.kreport')
time bracken -d ${KRAKEN_DB} -i $KRAKEN_OUT/${SAMPLE}.report \
-o $OUT/${SAMPLE}.bracken
done 

################################################################
# convert to biom format
# use bracken's kraken style report generated in the original folder of the kraken2 report used
################################################################

kraken-biom $OUT/*_bracken_species.report -o $OUT/../bracken.std.biom --fmt json # convert kraken2 report to biom format


conda deactivate
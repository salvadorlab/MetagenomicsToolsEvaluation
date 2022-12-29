#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=centrifuge
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12           
#SBATCH --time=128:00:00
#SBATCH --mem=200G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

ml Centrifuge/1.0.4-beta-foss-2019b

################################################################
# 1) download database 
# (h+p+v+c: human genome, prokaryotic genomes, and viral genomes including 106 SARS-CoV-2 complete genomes)
################################################################

# CDB="/scratch/rx32940/metagenomics/centrifuge/db"
# cd $CDB
# wget https://zenodo.org/record/3732127/files/h+p+v+c.tar.gz?download=1

################################################################
# 1) run centrifuge
################################################################
CDB="/scratch/rx32940/metagenomics/centrifuge/db"
OUT="/scratch/rx32940/metagenomics/centrifuge/output"
INPUT="/scratch/rx32940/metagenomics/data/cleaned"

for file in $INPUT/*_kneaddata_paired_1.fastq;
do

sample=$(basename $file '_1_kneaddata_paired_1.fastq')
time centrifuge -x $CDB/hpvc -p 12 --report-file $OUT/$sample.report.txt \
-S $OUT/$sample.txt \
-1 $INPUT/${sample}_1_kneaddata_paired_1.fastq -2 $INPUT/${sample}_1_kneaddata_paired_2.fastq
    
centrifuge-kreport -x $CDB/hpvc $OUT/$sample.txt > $OUT/$sample.kreport

done

################################################################
# convert centrifuge output to biom
################################################################
source activate kraken2

kraken-biom $OUT/*.kreport -o $OUT/../centrifuge.biom --fmt json # convert centrifuge converted report to biom format
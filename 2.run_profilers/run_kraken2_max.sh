#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=run_max
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12           
#SBATCH --time=128:00:00
#SBATCH --mem=200G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

source activate kraken2 # v2.1.2
################################################################
# 1) download database from https://lomanlab.github.io/mockcommunity/mc_databases.html
# maxikraken2_1903_140GB (March 2019, 140GB)
#  allowing hashes to be generated from genomes that are 
# not “complete” or “representative”, for the following database types:
# archaea
# bacteria
# fungi
# protozoa
# viral
# human
################################################################

# MAXDB="/scratch/rx32940/metagenomics/kraken2/maxikraken2/db"
# cd $MAXDB
# wget -c https://refdb.s3.climb.ac.uk/maxikraken2_1903_140GB/hash.k2d
# wget https://refdb.s3.climb.ac.uk/maxikraken2_1903_140GB/opts.k2d
# wget https://refdb.s3.climb.ac.uk/maxikraken2_1903_140GB/taxo.k2d

################################################################
# 2) run kraken2 with maxikraken2 db
#
################################################################

DBNAME="/scratch/rx32940/metagenomics/kraken2/maxikraken2/db"
OUT="/scratch/rx32940/metagenomics/kraken2/maxikraken2/output"
INPUT="/scratch/rx32940/metagenomics/data/cleaned"

for file in $INPUT/*_kneaddata_paired_1.fastq;
do

sample=$(basename $file '_1_kneaddata_paired_1.fastq')
# time kraken2 -db $DBNAME --threads 12 \
# --use-mpa-style --use-names --report $OUT/$sample.kreport --output $OUT/$sample.out \
# --paired $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq

# sample=$(basename $file '_1_kneaddata_paired_1.fastq')
# kraken2 -db $DBNAME --threads 12 \
# --use-names --output $OUT/$sample.out \
# --paired $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq

# form biom conversion
time kraken2 -db $DBNAME --threads 12 \
--report $OUT/$sample.report --output $OUT/$sample.out \
--paired $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq

done

################################################################
# 2) combine reports for each sample
# use krakenTools (available in the kraken2 conda env)
################################################################
OUT="/scratch/rx32940/metagenomics/kraken2/maxikraken2/output"

combine_mpa.py -i $(echo $OUT/*kreport) -o $OUT/../kraken2_max_all.kreport

combine_kreports.py -r $(echo $OUT/*.report) -o $OUT/../kraken2_max_all.report # combine reports

kraken-biom $OUT/*.report -o $OUT/../kraken2.max.biom --fmt json # convert kraken2 report to biom format


conda deactivate
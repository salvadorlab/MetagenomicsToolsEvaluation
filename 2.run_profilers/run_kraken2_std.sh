#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=report
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=1            
#SBATCH --time=128:00:00
#SBATCH --mem=300G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL 

source activate kraken2 # v2.1.2

################################################################
# 1) download database https://benlangmead.github.io/aws-indexes/k2
#  standard: built on 5/17/2021
################################################################

# DBNAME="/scratch/rx32940/metagenomics/kraken2/standard/db"
# cd $DBNAME
# wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20210517.tar.gz

################################################################
# 2) run kraken2 with standard db
#
################################################################
DBNAME="/scratch/rx32940/metagenomics/kraken2/standard/db"
OUT="/scratch/rx32940/metagenomics/kraken2/standard/output"
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

# this is specifically for bracken analysis, where non mpa style kraken report is needed.
time kraken2 -db $DBNAME --threads 12 \
--report $OUT/$sample.report --output $OUT/$sample.out \
--paired $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq



done

################################################################
# 2) combine reports for each sample
# use krakenTools (available in the kraken2 conda env)
# kraen-biom: https://github.com/smdabdoub/kraken-biom
################################################################
OUT="/scratch/rx32940/metagenomics/kraken2/standard/output"

combine_mpa.py -i $(echo $OUT/*kreport) -o $OUT/../kraken2_std_all.kreport #combine mpa

combine_kreports.py -r $(echo $OUT/*.report) -o $OUT/../kraken2_std_all.report # combine reports

kraken-biom $OUT/*.report -o $OUT/../kraken2.std.biom --fmt json # convert kraken2 report to biom format

conda deactivate
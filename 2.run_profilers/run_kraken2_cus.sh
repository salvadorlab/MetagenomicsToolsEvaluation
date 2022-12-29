#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=kraken_cus_db
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12            
#SBATCH --time=128:00:00
#SBATCH --mem=500G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL 

source activate kraken2 # v2.1.2
# ml Kraken2/2.1.1-gompi-2020b # to build db
################################################################
# 1) build standard database
# resources:
#   - highmem_p
#   - 300G
#   - 12 CPU
################################################################


DBNAME="/scratch/rx32940/metagenomics/kraken2/custom/db"
# time kraken2-build --download-taxonomy --db $DBNAME
# time kraken2-build --download-library bacteria --db $DBNAME
# time kraken2-build --download-library archaea --db $DBNAME
# time kraken2-build --download-library viral --db $DBNAME
# time kraken2-build --download-library human --db $DBNAME
# time kraken2-build --download-library UniVec_Core --db $DBNAME
# time kraken2-build --add-to-library $DBNAME/GCF_015227675.2_mRatBN7.2_genomic.fna --db $DBNAME
# time kraken2-build --add-to-library $DBNAME/GCF_011064425.1_Rrattus_CSIRO_v1_genomic.fna --db $DBNAME
# echo "Build"
# time kraken2-build --build --db $DBNAME --threads 12

################################################################
# 2) run kraken2 with customized db
#
################################################################
# DBNAME="/scratch/rx32940/metagenomics/kraken2/custom/db"
# OUT="/scratch/rx32940/metagenomics/kraken2/custom/output"
# INPUT="/scratch/rx32940/metagenomics/data/cleaned"

# for file in $INPUT/*_kneaddata_paired_1.fastq;
# do

# sample=$(basename $file '_1_kneaddata_paired_1.fastq')
# time kraken2 -db $DBNAME --threads 12 \
# --use-mpa-style --use-names --report $OUT/$sample.kreport --output $OUT/$sample.out \
# --paired $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq

# sample=$(basename $file '_1_kneaddata_paired_1.fastq')
# kraken2 -db $DBNAME --threads 12 \
# --use-names --output $OUT/$sample.out \
# --paired $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq

# # # form biom conversion
# time kraken2 -db $DBNAME --threads 12 \
# --report $OUT/$sample.report --output $OUT/$sample.out \
# --paired $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq

# done

################################################################
# 2) combine reports for each sample
# use krakenTools (available in the kraken2 conda env)
################################################################
OUT="/scratch/rx32940/metagenomics/kraken2/custom/output"

combine_mpa.py -i $(echo $OUT/*kreport) -o $OUT/../kraken2_cus_all.kreport

combine_kreports.py -r $(echo $OUT/*.report) -o $OUT/../kraken2_cus_all.report # combine reports

kraken-biom $OUT/*.report -o $OUT/../kraken2.cus.biom --fmt json # convert kraken2 report to biom format

conda deactivate
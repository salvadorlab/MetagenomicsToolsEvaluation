#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=mini_kraken2
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
# 1) download database ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/old/minikraken2_v2_8GB_201904.tgz
#  8GB Kraken 2 Database built from the Refseq bacteria, archaea, and viral libraries and the GRCh38 human genome
################################################################

# DBNAME="/scratch/rx32940/metagenomics/kraken2/minikraken/db/minikraken2_v2_8GB_201904_UPDATE"
# cd $DBNAME
# wget ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/old/minikraken2_v2_8GB_201904.tgz

################################################################
# 2) run kraken2 with minikraken2V2 db
#
################################################################
DBNAME="/scratch/rx32940/metagenomics/kraken2/minikraken/db/minikraken2_v2_8GB_201904_UPDATE"
OUT="/scratch/rx32940/metagenomics/kraken2/minikraken/output"
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
OUT="/scratch/rx32940/metagenomics/kraken2/minikraken/output"

combine_mpa.py -i $(echo $OUT/*kreport) -o $OUT/../kraken2_mini_all.kreport

combine_kreports.py -r $(echo $OUT/*.report) -o $OUT/../kraken2_mini_all.report # combine reports

kraken-biom $OUT/*.report -o $OUT/../kraken2.mini.biom --fmt json # convert kraken2 report to biom format

conda deactivate
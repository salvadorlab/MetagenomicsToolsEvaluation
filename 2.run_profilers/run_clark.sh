#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=clark_s_bacteria
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12            
#SBATCH --time=128:00:00
#SBATCH --mem=500G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

ml GCC/10.3.0
################################################################
# 1) build database 
# 
################################################################

# CLARK="/scratch/rx32940/metagenomics/CLARK/CLARKSCV1.2.6.1"
# DIR_DB="/scratch/rx32940/metagenomics/CLARK/db"

# $CLARK/set_targets.sh $DIR_DB bacteria viruses human --species
# $CLARK/set_targets.sh $DIR_DB bacteria --species
# $CLARK/set_targets.sh $DIR_DB viruses --species

################################################################
# 2) run clark
# 
################################################################

# CLARK="/scratch/rx32940/metagenomics/CLARK/CLARKSCV1.2.6.1"
# DBNAME="/scratch/rx32940/metagenomics/CLARK/db"
# OUT="/scratch/rx32940/metagenomics/CLARK/clark/output"
# INPUT="/scratch/rx32940/metagenomics/data/cleaned"
# FILES="/scratch/rx32940/metagenomics/CLARK/input_files"

# # build input files for classify_metagenome.sh
# # ls $INPUT/*_1_kneaddata_paired_1.fastq > $CLARK/samples.R.txt # paired 1
# # ls $INPUT/*_1_kneaddata_paired_2.fastq > $CLARK/samples.L.txt # paired 2
# # ls *_1_kneaddata_paired_2.fastq | awk -F'_' '{print "\/scratch\/rx32940\/metagenomics\/CLARK\/clark\/output\/"$1}' > $CLARK/results.txt # result name

# echo "run classify_metagenome.sh"
# time $CLARK/classify_metagenome.sh -P $FILES/samples.R.txt $FILES/samples.L.txt -R $FILES/results.txt -n 12
# time $CLARK/classify_metagenome.sh -P $FILES/samples.R.txt $FILES/samples.L.txt -R $FILES/results.bacteria.txt -n 12
# time $CLARK/classify_metagenome.sh -P $FILES/samples.R.txt $FILES/samples.L.txt -R $FILES/results.viruses.txt -n 12

# for file in $INPUT/*_kneaddata_paired_1.fastq;
# do
# sample=$(basename $file '_1_kneaddata_paired_1.fastq')
# echo $sample
# echo $file
# time $CLARK/classify_metagenome.sh -P $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq -R $FILES/results.txt -n 12
# done

################################################################
# 3) build clark-s database
#  running this task requires both running set_targets.sh & classify_metagenome.sh together
################################################################

CLARK="/scratch/rx32940/metagenomics/CLARK/CLARKSCV1.2.6.1"
DBNAME="/scratch/rx32940/metagenomics/CLARK/db"
OUT="/scratch/rx32940/metagenomics/CLARK/clark/output"
INPUT="/scratch/rx32940/metagenomics/data/cleaned"
FILES="/scratch/rx32940/metagenomics/CLARK/input_files"

# echo "run buildSpacedDB.sh"
cd $CLARK/
time ./set_targets.sh $DBNAME bacteria --species
# time ./set_targets.sh $DBNAME viruses --species
# time ./buildSpacedDB.sh 

################################################################
# 2) run clark-s
# 
################################################################

CLARK="/scratch/rx32940/metagenomics/CLARK/CLARKSCV1.2.6.1"
DBNAME="/scratch/rx32940/metagenomics/CLARK/db"
OUT="/scratch/rx32940/metagenomics/CLARK/clark/output"
INPUT="/scratch/rx32940/metagenomics/data/cleaned"
FILES="/scratch/rx32940/metagenomics/CLARK/input_files"

# # echo "run classify_metagenome.sh spaced"
# # time $CLARK/classify_metagenome.sh -P $FILES/samples.R.txt $FILES/samples.L.txt -R $FILES/results.spaced.txt -n 12 --spaced
# # time $CLARK/classify_metagenome.sh -P $FILES/samples.R.txt $FILES/samples.L.txt -R $FILES/results.bacteria.spaced.txt -n 12 --spaced
# # time $CLARK/classify_metagenome.sh -P $FILES/samples.R.txt $FILES/samples.L.txt -R $FILES/results.viruses.spaced.txt -n 12 --spaced


for file in $INPUT/*_kneaddata_paired_1.fastq;
do
sample=$(basename $file '_1_kneaddata_paired_1.fastq')
echo $sample
echo $file
time $CLARK/classify_metagenome.sh -P $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq -R $FILES/results_spaced_bacteria.txt -n 12 --spaced
# time $CLARK/classify_metagenome.sh -P $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq -R $FILES/results_spaced_viruses.txt -n 12 --spaced
done

################################################################
# 2) summarise clark output
# 
################################################################
# CLARK="/scratch/rx32940/metagenomics/CLARK/CLARKSCV1.2.6.1"
# DBNAME="/scratch/rx32940/metagenomics/CLARK/db"
# OUT="/scratch/rx32940/metagenomics/CLARK/clark/output"

# for file in $OUT/*.csv;
# do
# sample=$(basename $file ".csv")
# $CLARK/estimate_abundance.sh --mpa -D $DBNAME -F $file > $OUT/$sample.summary.csv 

# done
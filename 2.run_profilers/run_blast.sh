#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=blastn_lca
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12         
#SBATCH --time=128:00:00
#SBATCH --mem=300G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL


DBNAME="/scratch/rx32940/metagenomics/blastn/db/nt"
OUT="/scratch/rx32940/metagenomics/blastn"
INPUT="/scratch/rx32940/metagenomics/data/cleaned"


############################################################
#
#  merge pair-end reads
#
##################################################

# source activate megan
# for file in $INPUT/*_1_kneaddata_paired_1.fastq;
# do
# sample=$(basename $file '_1_kneaddata_paired_1.fastq')
# fastq-join $INPUT/${sample}_1_kneaddata_paired_1.fastq $INPUT/${sample}_1_kneaddata_paired_2.fastq -o $OUT/merged_fastq/${sample}_%.fastq
# cat $OUT/merged_fastq/${sample}*.fastq > $OUT/merged_fastq/${sample}_merged.fastq # include paired-end reads that can be joined, and pairend reads cannot be joined (un1 & un2).
# done
# conda deactivate

############################################################
#
#  convert fastq to fasta 
#
##################################################
# ml seqtk/1.3-GCC-8.3.0

# for file in $OUT/merged_fastq/*_merged.fastq;
# do
# sample=$(basename $file '_merged.fastq')
# seqtk seq -a $file > $OUT/fasta/${sample}_merged.fasta
# done

############################################################
#
# download database
# 
##################################################
# ml BioPerl/1.7.2-GCCcore-8.3.0
# ml BLAST+/2.11.0-gompi-2020b

# DB="/scratch/rx32940/metagenomics/blastn/db"

# cd $DB
# time update_blastdb.pl --num_threads 12 --force --decompress nt 

############################################################
#
# blastn 
# only the forward reads were used since reverse reads were paired with forward, matching both would be redundant
# 
##################################################
# source activate ncbi

# for file in  $OUT/fasta/*_merged.fasta;
# do
# sample=$(basename $file '_merged.fasta')
# echo $sample
# time blastn -query $file -db $DBNAME -outfmt 0 -num_alignments 1 -num_descriptions 1 -out $OUT/output/$sample.txt -num_threads 12

# wait
# done
# conda deactivate
############################################################
#
# lca
# use MEGAN's standalone blast2lca tool to get summarise redundant mapping reads based on their lca
# 
##################################################
source activate megan

for file in $OUT/output/R*.[K,L,S].txt;
do
sample=$(basename $file '.txt')
blast2lca -i $file -m BlastN -f BlastText -o $OUT/output/${sample}_lca.txt 

# get taxon id rather than taxa name
blast2lca -i $file -m BlastN -f BlastText -o $OUT/output/${sample}_lcaTaxID.txt -tid
done

######################################################################
# only get the classified reads
######################################################################

# for file in $OUT/output/R{22,26,27,28}.{K,L,S}_lcaTaxID.txt
# do
# sample=$(basename $file '_lcaTaxID.txt')

# # classified=$(cat $file | grep "d__" -v| wc -l)
# # all=$(cat $file | wc -l)
# # echo "$sample Percent Unclassified at domain level:"
# # echo "scale=3;$classified/$all" | bc # get 3 digits after decimal
# # classified_s=$(cat $file | grep "s__" -v| wc -l)
# # echo "$sample Percent Unclassified at species level:"
# # echo "scale=3;$classified_s/$all" | bc # get 3 digits after decimal

# # cat $file | grep "d__" > $OUT/output/${sample}_lcaTaxID_filtered.txt

# # # ########only keep columns with right taxnomy assignment (drop rows with extra column, ex. multiple species assignment)
# # delimiter=';'
# # cut -d "$delimiter" -f 1-30 "$OUT/output/${sample}_lcaTaxID_filtered.txt" > $OUT/output/${sample}_lcaTaxID_filtered2.txt

# python $OUT/summarise_megan_lca.py $OUT/output/${sample}_lca_filtered2.txt $OUT/output/${sample}_lcaTaxID_filtered2.txt $OUT/output/${sample}.summary.txt

# done


# conda deactivate

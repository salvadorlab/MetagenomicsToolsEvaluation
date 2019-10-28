#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N customdb_kraken2                                            
#PBS -l nodes=1:ppn=4 -l mem=200gb                                        
#PBS -l walltime=60:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/kraken                       
#PBS -j oe   

module load BLAST+/2.7.1-foss-2016b-Python-2.7.14 # for dust masker and segmasker

KPATH='/scratch/rx32940/kraken' # can not use PATH as variable name
DIR='/scratch/rx32940/Metagenomic_taxon_profile'
DBNAME='/scratch/rx32940/kraken/DB'
RATDB='/scratch/rx32940/kraken/RATDB'

#build a standard Kraken2 database
#kraken2-build --standard --threads 4 --db $DBNAME

#build library with rat reference genome
# kraken2-build --download-taxonomy --db $RATDB

# kraken2-build --download-library bacteria --db $RATDB

# kraken2-build --download-library archaea --db $RATDB

# kraken2-build --download-library viral --db $RATDB

# kraken2-build --download-library UniVec_Core --db $RATDB

# kraken2-build --add-to-library /scratch/rx32940/kraken/GCF_000001895.5_Rnor_6.0_genomic.fna --db $RATDB

# kraken2-build --build --threads 4 --db $RATDB

# build kmer distribution for bracken standard database
$DIR/bracken/Bracken-2.5/bracken-build -d $DBNAME -t 4 -k 35 -l 100 -x /scratch/rx32940/kraken/kraken2/kraken2

# build kmer distribution for bracken custom database
#$DIR/bracken/Bracken-2.5/bracken-build -d $RATDB -t 4 -k 35 -l 100 -x /scratch/rx32940/kraken/kraken2/kraken2

#to classify sample with standard database
for dir in $DIR/Data/01.Data/hostclean/*; do
    sample=$(basename "$dir")
    kraken2 --use-names --db $DBNAME --threads 4 --report $KPATH/output/kraken_out/$sample.kreport --paired $DIR/Data/01.Data/hostclean/$sample/${sample}_1_kneaddata_paired_1.fastq $DIR/Data/01.Data/hostclean/$sample/${sample}_1_kneaddata_paired_2.fastq > $KPATH/output/kraken_out/$sample.txt
    $DIR/bracken/Bracken-2.5/bracken -d $DBNAME -i $KPATH/output/kraken_out/$sample.kreport -o $KPATH/output/bracken_out/phylum/$sample -l P -t 10
    $DIR/bracken/Bracken-2.5/bracken -d $DBNAME -i $KPATH/output/kraken_out/$sample.kreport -o $KPATH/output/bracken_out/genus/$sample -l P -t 10
done

# to classify sample with custom database
# for dir in $DIR/Data/01.Data/hostclean/*; do
#     sample=$(basename "$dir")
#     kraken2 --use-names --db $RATDB --threads 4 --report $KPATH/output/custom_out/$sample.kreport --paired $DIR/Data/01.Data/hostclean/$sample/${sample}_1_kneaddata_paired_1.fastq $DIR/Data/01.Data/hostclean/$sample/${sample}_1_kneaddata_paired_2.fastq > $KPATH/output/custom_out/$sample.txt
#     $DIR/bracken/Bracken-2.5/bracken -d $RATDB -i $KPATH/output/custom_out/$sample.kreport -o $KPATH/output/custom_bracken/phylum/$sample -l P -t 10
#     $DIR/bracken/Bracken-2.5/bracken -d $RATDB -i $KPATH/output/custom_out/$sample.kreport -o $KPATH/output/custom_bracken/genus/$sample -l P -t 10
# done
#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=kaiju_classify
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12            
#SBATCH --time=128:00:00
#SBATCH --mem=200G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

source activate kaiju
ml bzip2/1.0.8-GCCcore-10.2.0


KAIJU="/scratch/rx32940/metagenomics/kaiju"

################################################################
# 1) download database 
#  Completely assembled and annotated reference genomes of Archaea, Bacteria, and viruses from the NCBI RefSeq database.
################################################################

# time kaiju-makedb -s refseq -t 12

################################################################
# 2) run kaiju
#  
################################################################

DB="/scratch/rx32940/metagenomics/kaiju/refseq"
INPUT="/scratch/rx32940/metagenomics/data/cleaned"
OUT="/scratch/rx32940/metagenomics/kaiju/output"


for file in $INPUT/*_kneaddata_paired_1.fastq;
do

sample=$(basename $file '_1_kneaddata_paired_1.fastq')

time kaiju -t $DB/nodes.dmp -f $DB/kaiju_db_refseq.fmi \
-i $INPUT/${sample}_1_kneaddata_paired_1.fastq -j $INPUT/${sample}_1_kneaddata_paired_2.fastq \
-o $OUT/$sample.txt \
-z 12

done
################################################################
# 3) summarise kaiju output
#  
################################################################


kaiju2table -t $DB/nodes.dmp -n $DB/names.dmp -r species -l superkingdom,phylum,class,order,family,genus,species -o $OUT/kaiju.summary.tsv $(ls $OUT/*txt)


conda deactivate

################################################################
# 4) convert kaiju to kraken2 kreport format
#  cp seqid2taxid.map from kraken2's customized database, add taxa rows to seqid2taxid.map if not existed in the file already (this will show when running make_kreport.py)
################################################################
conda activate kraken2

DB="/scratch/rx32940/metagenomics/kaiju/refseq"
OUT="/scratch/rx32940/metagenomics/kaiju/output"
KRAKEN="/scratch/rx32940/metagenomics/kraken2"
KAIJU="/scratch/rx32940/metagenomics/kaiju"

# make taxonomy from kraken2's standard database
# 
make_ktaxonomy.py --nodes $KAIJU/refseq/nodes.dmp --names $KAIJU/refseq/names.dmp --seqid2taxid $KAIJU/refseq/seqid2taxid.map -o $KAIJU/refseq/kraken_db.ktaxonomy
for file in $OUT/*.txt;
do

sample=$(basename $file '.txt')
make_kreport.py -i $file -t $KAIJU/refseq/kraken_db.ktaxonomy -o $OUT/$sample.kreport
done

# convert kraken format report to biom format

kraken-biom $OUT/*.kreport -o $OUT/../kaiju.cus.biom --fmt json # convert kraken2 report to biom format
#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=kneaddata_clean
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12            
#SBATCH --time=128:00:00
#SBATCH --mem=100G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL 

DB="/scratch/rx32940/metagenomics/data/kneaddata_db"
INPUT="/scratch/rx32940/metagenomics/data/rawdata"
OUTPUT="/scratch/rx32940/metagenomics/data/cleaned"



# build kneaddata database for host to filter out
# bowtie2-build $DB/rattus_human.fasta $DB/rattus_human_db

for file in $INPUT/*/;
do
(sample=$(basename $file)
echo "#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=$sample
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12            
#SBATCH --time=128:00:00
#SBATCH --mem=100G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL" > sub.sh


echo "source activate kneaddata" >> sub.sh
echo "kneaddata --i $INPUT/$sample/${sample}_1.fastq --i $INPUT/$sample/${sample}_2.fastq -db $DB/rattus_human_db -o $OUTPUT/" >> sub.sh
echo "conda deactivate" >> sub.sh 

sbatch sub.sh ) &

wait
done



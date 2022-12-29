#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=nf_mag
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12      
#SBATCH --time=128:00:00
#SBATCH --mem=300G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

ml Nextflow/22.04.5
ml Miniconda3/4.10.3
 
OUTDIR="/scratch/rx32940/metagenomics/asm/mag_output"

nextflow run nf-core/mag -profile singularity --input $OUTDIR/../nf_mag_samples.csv \
--outdir $OUTDIR -resume \
--email rx32940@uga.edu \
--multiqc_title ${sample}_multiqc \
--skip_krona False \
--skip_binning True \
-w /scratch/rx32940/metagenomics/asm


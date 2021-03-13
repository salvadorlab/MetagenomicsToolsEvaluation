#!/bin/bash
#PBS -q highmem_q
#PBS -N merge-test
#PBS -l nodes=1:ppn=1 -l mem=300gb
#PBS -l walltime=300:00:00
#PBS -M rx32940@uga.edu
#PBS -m abe
#PBS -o /scratch/rx32940/
#PBS -e /scratch/rx32940/
#PBS -j oe

module load PEAR/0.9.8-foss-2016b


seqpath="/scratch/rx32940/clark_0613/hostclean_seq"
pear -f $seqpath/R22.K_1_kneaddata_paired_1.fastq -r $seqpath/R22.K_1_kneaddata_paired_2.fastq -o $seqpath/R22.K_1_kneaddata_paired_merged.fastq

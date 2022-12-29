# Lepto-Metagenomics


This repository include scripts for profiling microbial communities of 12 rat tissue samples using 9 different metagenomics profiling software. Also include profiling of 3 simulated samples of [mice gut microbiome](https://repository.publisso.de/resource/frl:6421672) obtained from [CAMI Challenge](https://www.microbiome-cosi.org/cami)

All the profiling results and their downstream characterization statistics (alpha/beta diversity, differential abundant taxa) were compared and contrast.


## Software included:
    
* BLASTN
* DIAMOND (BLASTX/MEGAN)
* Centrifuge
* CLARK
* CLARK-s
* KRAKEN2 (4 different databases)
    * minikraken
    * standard
    * maxikraken
    * customized (standard + with rat genomes built in)
* Bracken
* Kaiju
* METAPHLAN3

---

### 1.pre-process  

- Quality check sequenced reads
- Map reads to host genomes to filter out host contaminations
- adapter trimming 

### 2.run_profilers  

- include metagenomics pipeline for 9 different profilers
- from database building/downloading
- to summarise profiling results
- convert profiles to [BIOM format](https://biom-format.org/) 

### 3.MAG  

- script to run nextflow pipeline MAG
- assemble and bin metagenomics reads 

### 4.benchmark_downstream_analysis

- read profiling results of all software listed in 2.run_profilers into R
- compare and contrast profiling results of all software listed
- conduct alpha & beta diversity characterization for each sample
- conduct differential abundant analysis for each sample
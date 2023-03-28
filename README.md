# Genome_assembly
Pipeline for Genome Assembly using HiFi and HiC Technologies and Evaluating the Quality of Assembled Genomes

## assembly_pipeline.sh
runs the genome assembly with hifiasm, followed by Quality Evaluation using Sequencing Stats, K-mer Plots (Merqury), and BUSCO Scores

### Run as:
```
bash assembly_pipeline.sh  *HIFI.fastq.gz *HiC.R1.fastq.gz HiC.R2.fastq.gz PREFIX SAVE_DIR
```


## Modules:

### hifiasm.sh 
Genome assembly and contiguity statistics

### Run as:
```
bash hifiasm.sh *HIFI.fastq.gz *HiC.R1.fastq.gz HiC.R2.fastq.gz PREFIX HIFIASM_DIR RESULT_DIR Nthreads
```

### MERYL.sh 
builds meryl database

### Run as:
```
bash MERYL.sh *HIFI.fastq.gz MERYL_DIR Nthreads
```

### BUSCO.sh
Calculates BUSCO scores

### Run as:
```
bash BUSCO.sh *hic.hap1.p_ctg.fasta BUSCO_DIR Nthreads BIN
bash BUSCO.sh *hic.hap2.p_ctg.fasta BUSCO_DIR Nthreads BIN
```

### MERQURY.sh
Draws k-mer plots

### Run as:
```
bash MERQURY.sh MERYL_DATABASE *hic.hap1.p_ctg.fasta *hic.hap2.p_ctg.fasta PREFIX MERQURY_DIR MERQURY_PLOT_DIR RESULT_DIR
```


#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --mem=255000M

JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

HIFI=$1 #*.fastq.gz
HIC_R1=$2 #*.fastq.gz
HIC_R2=$3 #*.fastq.gz
PREFIX=$4
HIFIASM_DIR=$5
RESULT_DIR=$6
CPU=$7

cd $HIFIASM_DIR

# Hi-C phasing with paired-end short reads in two FASTQ files
/home/mjahani/bin/hifiasm/hifiasm -o $PREFIX --primary -t${CPU} --h1 $HIC_R1 --h2 $HIC_R2 $HIFI


#extract the fasta files
awk '/^S/{print ">"$2;print $3}' ${HIFIASM_DIR}/${PREFIX}.hic.hap1.p_ctg.gfa > ${RESULT_DIR}/${PREFIX}.hic.hap1.p_ctg.fasta
awk '/^S/{print ">"$2;print $3}' ${HIFIASM_DIR}/${PREFIX}.hic.hap2.p_ctg.gfa > ${RESULT_DIR}/${PREFIX}.hic.hap2.p_ctg.fasta

#module for genome tools
module load genometools
#calculate contiguity stats
gt seqstat -contigs -genome 790000000 ${RESULT_DIR}/${PREFIX}.hic.hap1.p_ctg.fasta > ${RESULT_DIR}/${PREFIX}.hic.hap1.p_ctg.GT.stats
gt seqstat -contigs -genome 790000000 ${RESULT_DIR}/${PREFIX}.hic.hap2.p_ctg.fasta > ${RESULT_DIR}/${PREFIX}.hic.hap2.p_ctg.GT.stats
##
echo "Program finished with exit code $? at: $(date)" >>$JOBINFO


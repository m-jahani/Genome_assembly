#!/bin/bash
#HIFIasm assembly and quality check
#Mojtaba jahani Sep 2021

ACCOUNT=def-rieseber
CPU=64 #N of cores
BIN=/home/mjahani/scratch/bin #scripts directory
#################################################ARGUMENTS###################################################
HIFI=$1 #*.fastq.gz
HIC_R1=$2 #*.fastq.gz
HIC_R2=$3 #*.fastq.gz
PREFIX=$4
SAVE_DIR=$5
#############################################################################################################

###############################################DIRECTORIES###################################################
HIFIASM_DIR=${SAVE_DIR%%\/}/${PREFIX}_HIFIasm_ASSEMBLY                    #/path/to/write/out/HIFIasm result
RESULT_DIR=${SAVE_DIR%%\/}/${PREFIX}_ASSEMBLY_RESULT_STAT
MERQURY_PLOT_DIR=${RESULT_DIR}/${PREFIX}_merqury_plots
MERYL_DIR=${HIFIASM_DIR}/meryl
MERQURY_DIR=${HIFIASM_DIR}/merqury
BUSCO_DIR_hap1=${HIFIASM_DIR}/BUSCO/hap1
BUSCO_DIR_hap2=${HIFIASM_DIR}/BUSCO/hap2                                   #/path/to/write/out/BUSCO scores
#############################################################################################################

#################################################SCRIPTS#####################################################
HIFIasm_SCRIPT=${BIN}/hifiasm.sh   
BUSCO_SCRIPT=${BIN}/BUSCO.sh 
MERYL_SCRIPT=${BIN}/MERYL.sh 
MERQURY_SCRIPT=${BIN}/MERQURY.sh 
###################################################RUN#######################################################

echo "### Step 0: Check output directories exist & create them as needed"
[ -d $HIFIASM_DIR ] || mkdir -p $HIFIASM_DIR
[ -d $RESULT_DIR ] || mkdir -p $RESULT_DIR
[ -d $MERYL_DIR ] || mkdir -p $MERYL_DIR
[ -d $MERQURY_DIR ] || mkdir -p $MERQURY_DIR
[ -d $BUSCO_DIR_hap1 ] || mkdir -p $BUSCO_DIR_hap1
[ -d $BUSCO_DIR_hap2 ] || mkdir -p $BUSCO_DIR_hap2
[ -d $MERQURY_PLOT_DIR ] || mkdir -p $MERQURY_PLOT_DIR

echo "### Step 1: HIFIasm assembly"
jid1=$(sbatch --cpus-per-task=${CPU} --job-name=HIFIasm_${PREFIX} --output=${RESULT_DIR}/${PREFIX}.hifiasm.log --account=${ACCOUNT} $HIFIasm_SCRIPT $HIFI $HIC_R1 $HIC_R2 $PREFIX $HIFIASM_DIR $RESULT_DIR $CPU)

echo "### Step 2.A: meryl database"
jid2=$(sbatch --cpus-per-task=${CPU} --job-name=Meryl_${PREFIX} --account=${ACCOUNT} $MERYL_SCRIPT $HIFI $MERYL_DIR)

echo "### Step 3.A: BUSCO for haplotype 1"
sbatch --dependency=afterany:${jid1/Submitted batch job /} --cpus-per-task=$CPU --job-name=BUSCO_${PREFIX} --output=${RESULT_DIR}/${PREFIX}.hic.hap1.p_ctg.BUSCO --account=${ACCOUNT} $BUSCO_SCRIPT ${RESULT_DIR}/${PREFIX}.hic.hap1.p_ctg.fasta $BUSCO_DIR_hap1 $CPU $BIN

echo "### Step 3.B: BUSCO for haplotype 2"
sbatch --dependency=afterany:${jid1/Submitted batch job /} --cpus-per-task=$CPU --job-name=BUSCO_${PREFIX} --output=${RESULT_DIR}/${PREFIX}.hic.hap2.p_ctg.BUSCO --account=${ACCOUNT} $BUSCO_SCRIPT ${RESULT_DIR}/${PREFIX}.hic.hap2.p_ctg.fasta $BUSCO_DIR_hap2 $CPU $BIN

#echo "### Step 2.B: Merqury"
sbatch --dependency=afterany:${jid1/Submitted batch job /}:${jid2/Submitted batch job /} --cpus-per-task=$CPU --job-name=Merqury_${PREFIX} --account=${ACCOUNT} $MERQURY_SCRIPT ${MERYL_DIR}/$(basename ${HIFI%%.fastq.gz}).meryl ${RESULT_DIR}/${PREFIX}.hic.hap1.p_ctg.fasta ${RESULT_DIR}/${PREFIX}.hic.hap2.p_ctg.fasta $PREFIX $MERQURY_DIR $MERQURY_PLOT_DIR $RESULT_DIR



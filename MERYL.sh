#!/bin/bash
#SBATCH --time=00:50:00
#SBATCH --mem=255000M
#SBATCH --output=%j_%x.out

source /home/mjahani/miniconda3/bin/activate merqury

HIFI=$1
MERYL_DIR=$2
CPU=$3


cd $MERYL_DIR

#Job variables
JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

meryl k=20 count output ${MERYL_DIR}/$(basename ${HIFI%%.fastq.gz}).meryl $HIFI
##
echo "Program finished with exit code $? at: $(date)" >>$JOBINFO


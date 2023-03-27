#!/bin/bash
#SBATCH --time=05:00:00
#SBATCH --mem=255000M

module load StdEnv/2020
module load gcc/9.3.0
module load openmpi/4.0.3
module load busco/5.2.2

ASSEMBLY=$1
BUSCO_DIR=$2
CPU=$3
BIN=$4


cd $BUSCO_DIR

cp -r ${BIN}/busco_downloads/ .

#Job variables
JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

busco -f -c $CPU -m genome -i $ASSEMBLY -o $(basename ${ASSEMBLY%%.fa*}) -l eudicots_odb10 --offline

rm -rf ./busco_downloads
##
echo "Program finished with exit code $? at: $(date)" >>$JOBINFO


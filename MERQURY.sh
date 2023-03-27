#!/bin/bash
#SBATCH --time=02:00:00
#SBATCH --mem=255000M
#SBATCH --output=%j_%x.out

source /home/mjahani/miniconda3/bin/activate merqury

MERYL_DATABASE=$1
HAP1=$2
HAP2=$3
PREFIX=$4
MERQURY_DIR=$5
MERQURY_PLOT_DIR=$6
RESULT_DIR=$7


cd $MERQURY_DIR

#Job variables
JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

#run merqury
$MERQURY/merqury.sh $MERYL_DATABASE $HAP1 $HAP2 $PREFIX


#Draw PDF plots
for HIST in *spectra-cn.hist
do
Rscript $MERQURY/plot/plot_spectra_cn.R -z ${HIST%%spectra-cn.hist}only.hist -f $HIST -o ${MERQURY_PLOT_DIR}/${HIST%%.hist} -p
done

Rscript $MERQURY/plot/plot_spectra_cn.R -z *dist_only.hist -f *spectra-asm.hist -o ${MERQURY_PLOT_DIR}/${PREFIX}.spectra-asm -p

#Copy stats
cp ${PREFIX}.completeness.stats ${PREFIX}.qv $RESULT_DIR

echo "Program finished with exit code $? at: $(date)" >>$JOBINFO

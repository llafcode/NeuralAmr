#!/bin/bash
USER_DIR=$HOME
CLASSPATH=lib/AmrUtils.jar:lib/Helper.jar:lib/jewelcli-0.7.6.jar:lib/meteor-1.5.jar

# options are: dev, test
DATASET=dev
DATA_PATHNAME="${2:-data/little-prince-input_data_neClusters_reEntrances_brackets}"
REF_PATH=${DATA_PATHNAME}/${DATASET}-nl.txt
REF_ANON_PATH=${DATA_PATHNAME}/${DATASET}-nl-anon.txt
ANONYMIZED_PATH=${DATA_PATHNAME}/${DATASET}-anonymized-alignments.txt
IDS_FILENAME=${DATA_PATHNAME}/${DATASET}-ids.txt

# Folder containing file(s) with ANONYMIZED predictions. In case there are multiple files, for example from different
# epoch runs, then the code automatically processes all of them and reports back the one with the highest multiBLEU score.
INPUT_PATH="${1:-models/little-prince-neClusters_reEntrances_brackets}"

java -cp ${CLASSPATH}	util.metrics.RecomputeMetrics \
--inputFolder ${INPUT_PATH} \
--referenceFilename ${REF_PATH} \
--referenceAnonymizedFilename ${REF_ANON_PATH} \
--anonymizedAlignmentsFilename ${ANONYMIZED_PATH} \
--idsFilename ${IDS_FILENAME} \
--isInputAnonymized \
--isMultipleFiles \
--isGridExperiment


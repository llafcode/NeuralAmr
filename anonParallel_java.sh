#!/bin/bash

# CLASSPATH=lib/BuildCorpora.jar:lib/Helper.jar:lib/buildcorpora/log4j-1.2.15.jar:lib/buildcorpora/json-simple-1.1.1.jar:lib/buildcorpora/stanford-corenlp-3.6.0.jar:lib/buildcorpora/stanford-corenlp-3.5.1-models.jar:lib/buildcorpora/commons-collections4-4.0-alpha1.jar:lib/buildcorpora/commons-math.jar:lib/buildcorpora/commons-lang3-3.4.jar:lib/buildcorpora/slf4j-api-1.7.5.jar
CLASSPATH=lib/AmrUtils.jar:lib/Helper.jar:lib/commons-collections4-4.0-alpha1.jar:lib/commons-lang3-3.4.jar:lib/stanford-corenlp-2017-04-14-build.jar:lib/models
USER_DIR=$HOME
TMP_DIR=tmp/
# Little Prince parallel corpus output folder with lots of files containing meta-data such as vocabs, histograms etc.
DATA_DIR=data/little-prince-meta
OUT_DIR=data/little-prince-input_data
# usually change suffix to reflect various flavours of dataset features controlled via settings.properties (e.g., output sense, brackets etc)
suffix=_neClusters_reEntrances_brackets

# Process AMR raw files
mkdir -p ${TMP_DIR}
mkdir -p ${DATA_DIR}

java -ea -cp ${CLASSPATH} util.apps.Preprocess

# move generated files to specified directory
mv ${TMP_DIR}/*.txt ${DATA_DIR}
mv ${TMP_DIR}/*.obj.gz ${DATA_DIR}

# Create anonymized dev, test NL files
cut -f 1,3 ${DATA_DIR}/test-dfs-linear.txt > ${DATA_DIR}/test-nl-anon.txt
cut -f 1,3 ${DATA_DIR}/dev-dfs-linear.txt > ${DATA_DIR}/dev-nl-anon.txt

# Create src, targ, alignment files without ids for Harvard seq2seq code
cut -f 2 ${DATA_DIR}/training-dfs-linear.txt | sed -e "s/\^[0-9.]*//g" > ${DATA_DIR}/training-dfs-linear_src.txt
cut -f 2 ${DATA_DIR}/dev-dfs-linear.txt | sed -e "s/\^[0-9.]*//g" > ${DATA_DIR}/dev-dfs-linear_src.txt
cut -f 2 ${DATA_DIR}/test-dfs-linear.txt | sed -e "s/\^[0-9.]*//g" > ${DATA_DIR}/test-dfs-linear_src.txt

cut -f 3 ${DATA_DIR}/training-dfs-linear.txt | tr '[:upper:]' '[:lower:]' > ${DATA_DIR}/training-dfs-linear_targ.txt
cut -f 3 ${DATA_DIR}/dev-dfs-linear.txt | tr '[:upper:]' '[:lower:]' > ${DATA_DIR}/dev-dfs-linear_targ.txt
cut -f 3 ${DATA_DIR}/test-dfs-linear.txt | tr '[:upper:]' '[:lower:]' > ${DATA_DIR}/test-dfs-linear_targ.txt

cut -f 2 ${DATA_DIR}/training-amr-nl-alignments-seq.txt > ${DATA_DIR}/training-amr-nl-alignments-seq_noIds.txt
cut -f 2 ${DATA_DIR}/dev-amr-nl-alignments-seq.txt > ${DATA_DIR}/dev-amr-nl-alignments-seq_noIds.txt
cut -f 1 ${DATA_DIR}/dev-nl.txt > ${DATA_DIR}/dev-ids.txt
cut -f 1 ${DATA_DIR}/test-nl.txt > ${DATA_DIR}/test-ids.txt

# Copy only the files needed for training seq2seq
mkdir -p ${OUT_DIR}${suffix}
cp ${DATA_DIR}/*_src.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/*_targ.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/*_noIds.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/training-amr-nl-alignments.txt ${OUT_DIR}${suffix}
# cp ${DATA_DIR}/training-amr-nl-alignments-hist.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/dev-anonymized-alignments.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/test-anonymized-alignments.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/dev-nl.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/dev-nl-anon.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/dev-ids.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/test-nl.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/test-nl-anon.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/test-ids.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/dev-raw-amr-ids.txt ${OUT_DIR}${suffix}
cp ${DATA_DIR}/test-raw-amr-ids.txt ${OUT_DIR}${suffix}
# cp ${DATA_DIR}/amr-roles-orderIds.txt ${OUT_DIR}${suffix}

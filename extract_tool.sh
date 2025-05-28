#!/bin/bash
# Extract all TalendJob (zip) to executor folder
#
#     Author  : tupn.hn@gmail.com
#     Version : 1.2.0
#     Modified: 2023.03.04
#
###############################################################################
# History change
# Date        - Author - Description
# 2022.04.01    TuPN     Create file
# 2023.03.04    TuPN     Just extract changed-file
#

# -------------------------------------------------------------
OUTPUT="../bin/"

if [ "$1" != "" ]; then
    FILES=`find -type f | grep \.zip$ | grep $@`;
    # FILES is empty, not found any match files
    if [ -z "${FILES}" ]; then
        echo "Not found any job match with pattern: $@"
        echo "Cannot extract no-jobs, please imput new pattern again!!!!"
        exit -1;
    else
        # found files, confirm extract again
        echo "Searching jobs..."
        cnt=0
        for file in $FILES; do
            cnt=$((cnt + 1))
            echo "  ${cnt} - ${file}"
        done

        # confirm to continue
        echo "Found ${cnt} jobs. Do you want to extract these jobs?"
        echo "Press (Y)/(Enter) to continue, otherwise for exit"
        read -n 1 yn
        if [ "$yn" != "" ] && [ "$yn" != "Y" ] && [ "$yn" != 'y' ]; then
            echo "...cancelled";
            exit 1;
        fi
    fi
else
    FILES=`find -type f | grep \.zip$ | sort`;
fi

# Progress bar
arrJobExtract=()
arrJobIgnore=()

# -------------------------------------------------------------
# Find all zip file and extract to OUTPUT folder
#
for file in ${FILES}; do
    echo
    echo "Job: ${file}"

    BASE_FILE=`echo ${file} | sed -e 's/_[0-9]\+\.[0-9]\+\.zip//g'`
    OUT_DIR=${OUTPUT}${BASE_FILE}

    mkdir -p ${OUT_DIR}

    # get old md5sum an compoare to check lastest
    md5file=${OUT_DIR}/hash-by-extract-tool.md5
    isLatest=false

    if [ -f "${md5file}" ]; then
        md5old=`cat ${md5file} | cut -d " " -f1`
        md5new=`md5sum ${file} | cut -d " " -f1`

        #debug
        if false; then
            echo "MD5 old: ${md5old}"
            echo "MD5 new: ${md5new}"
        fi

        if [ "${md5old}" == "${md5new}" ]; then
            isLatest=true
            echo "--> Job up to date, donot need extract again"
        else
            echo "--> Update job..."
        fi
    else
        echo "--> Extract new file..."
    fi



    # just extract if not latest
    if [ ${isLatest} != true ]; then
        echo "Extracting... ${file}"
        echo "    to ${OUTPUT}"

        if !  unzip -o ${file} -d ${OUT_DIR} | awk 'BEGIN {ORS=" "} {print "."}'; then
            echo "ERROR: Cannot unzip: ${file} in the forder ${OUT_DIR}" 1>&2;
            exit -1;
        fi

        # update md5
        echo "${md5new}" > ${md5file}

        arrJobExtract+=("${file}")

        echo
        echo "--> Success in folder: ${OUT_DIR}"
    else
        arrJobIgnore+=("${file}")
    fi

    # change mode execute
    find -type f | grep \.sh$ | xargs chmod 777
done

# -------------------------------------------------------------
# Print status
echo "--------------------------------------------------------"
echo "Extract success:"
total=0
ignoreCnt=0
extractCnt=0

for file in "${arrJobIgnore[@]}"; do
    total=$((total + 1))
    ignoreCnt=$((ignoreCnt + 1))

    echo "  ${total} - IGNORE - ${file}"
done

for file in "${arrJobExtract[@]}"; do
    total=$((total + 1))
    extractCnt=$((extractCnt + 1))

    echo "  ${total} - SUCCESS - ${file}"
done

echo "    Done. Extract ${extractCnt} and ingore ${ignoreCnt} jobs in all ${total} jobs."

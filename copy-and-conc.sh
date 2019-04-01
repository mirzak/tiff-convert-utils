#!/bin/sh

# Utility script that converts "PNG" and "PDF" files in to a single TIFF file
# with CCITT Group 4 (T.6) compression
#
# The input files are first converted to monochrome PBM files before they
# are converted to TIFF

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf output
mkdir ${script_dir}/output

cp ${script_dir}/input/* ${script_dir}/output
cd ${script_dir}/output

ret=0
cnt=0

for f in *.{pdf,PDF}; do
    if [ -f "${f}" ]; then
        echo "converting $f to ${cnt}.pbm"
        pdftoppm -mono "${f}" "${cnt}"
        let "cnt += 1"
    fi
done
for f in *.png; do
    if [ -f "${f}" ]; then
        echo "converting $f to ${cnt}.pbm"
        convert "${f}" "${cnt}.pbm"
        let "cnt += 1"
    fi
done

for f in *.pbm; do
    if [ -f "${f}" ]; then
        echo "converting $f to ${cnt}.tiff"
        convert "${f}" "${cnt}.pbm"
        ppm2tiff -c g4 "${f}" "${cnt}.tiff"
        let "cnt += 1"
    fi
done

TIFF_FILES=$(ls *.tiff | tr "\n" " ")

# Merge tiff`s if any
if [ ! -z "${TIFF_FILES}" ]; then
    echo "Running command to merge: "
    echo "    tiffcp -c g4 ${TIFF_FILES} receipts.tiff"
    tiffcp -c g4 ${TIFF_FILES} receipts.tiff
    echo "Conversion done: ${script_dir}/output/receipts.tiff"
else
    echo "No TIFF files found"
    ret=1
fi

cd -

exit $ret

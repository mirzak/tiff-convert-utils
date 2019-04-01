# TIFF convert utils

This is set of scripts that I use to convert various input formats to GC4 TIFF,
which is a common format to handle receipts.


### `input-to-cg4-tif.sh`
Utility script that converts "PNG" and "PDF" files in to a single TIFF file
with CCITT Group 4 (T.6) compression

The input files are first converted to monochrome PBM files before they
 are converted to TIFF

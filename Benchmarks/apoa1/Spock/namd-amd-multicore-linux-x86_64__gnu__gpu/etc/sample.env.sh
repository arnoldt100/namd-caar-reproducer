#! /usr/bin/env bash

# ----------------------------------------------------
#  Set your resource scheduler id here.
# 
# ----------------------------------------------------
export NCP_ACCOUNT_ID="stf016"

# ----------------------------------------------------
# The path the the parent directory containing
# the APOA1 input files.
# 
# ----------------------------------------------------
export APOA1_INPUT_FILES_PARENT_DIR="${NCP_TOP_LEVEL}/Benchmarks/apoa1/input_files"

# ----------------------------------------------------
# The fully qualified path to the directory to run the
# benchmark. This is your scratch working directory.
# 
# ----------------------------------------------------
export NCP_APOA1_SCRATCH_DIR="${MEMBERWORK}/stf016/apoa1_benchmark"

# ----------------------------------------------------
# Set the fully qualified path to the namd binary.
# 
# ----------------------------------------------------
export NCP_APOA1_NAMD2_BINARY="${NAMD_PREFIX}/${NAMD2_BINARY_NAME}"
export NCP_APOA1_NAMD3_BINARY="${NAMD_PREFIX}/${NAMD3_BINARY_NAME}"

# ----------------------------------------------------
# Set the fully qualified path to the directory where 
# the final results will be copied.
# 
# ----------------------------------------------------
export NCP_APOA1_RESULTS_DIR="${NCP_TOP_LEVEL}/Benchmarks/apoa1/Spock/namd-amd-multicore-linux-x86_64__gnu__gpu/apoa1_results"


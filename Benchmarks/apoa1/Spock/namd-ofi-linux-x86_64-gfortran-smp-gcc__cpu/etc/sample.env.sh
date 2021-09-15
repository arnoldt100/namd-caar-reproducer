#! /usr/bin/env bash

# ----------------------------------------------------
#  Set your resource scheduler id here.
# 
# ----------------------------------------------------
export NCP_ACCOUNT_ID="stf016"

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
export NCP_APOA1_NAMD_BINARY="${NAMD_PREFIX}/namd2"

# ----------------------------------------------------
# Set the fully qualified path to the directory where 
# the final results will be copied.
# 
# ----------------------------------------------------
export NCP_APOA1_RESULTS_DIR="${NCP_TOP_LEVEL}/Benchmarks/apoa1/Spock/namd-ofi-linux-x86_64-gfortran-smp-gcc__cpu/apoa1_results"


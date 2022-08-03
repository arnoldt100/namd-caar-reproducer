#! /usr/bin/env bash
# ----------------------------------------------------
# The path to the namd-caar-reproducer 
# scratch directory.
# 
# ----------------------------------------------------
export NCP_SCRATCH=${HOME}/scratch/namd

# ----------------------------------------------------
# The path to the namd-caar-reproducer package
# top-level directory.
# 
# ----------------------------------------------------
export NCP_TOP_LEVEL=${HOME}/namd-caar-reproducer

# ----------------------------------------------------
# The path to the top-level directory where all 
# dependent namd software is located. All namd 
# dependent software is located under this
# path.
# 
# ----------------------------------------------------
export NCP_PREFIX=${NCP_SCRATCH}/Software

# ----------------------------------------------------
# The path to the top-level directory where all
# namd benchmark results are located.
# 
# ----------------------------------------------------
export NCP_RESULTS=${NCP_SCRATCH}/Results

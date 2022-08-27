#! /usr/bin/env bash

# This is a sample script that can be used to set your
# runtime environment. Please copy and modify accordingly.

# ----------------------------------------------------
# The path to the namd-caar-reproducer 
# scratch directory.
# 
# ----------------------------------------------------
export NCP_MACHINE_NAME=Crusher

# ----------------------------------------------------
#
# Set the set of modules to load by defining the variable
# key to one of the following values:
#
#  key value                Description
#  ---------                -----------
#  "default"                Load the default modules.
#
# ----------------------------------------------------
export NCP_PE_KEY=default

# ----------------------------------------------------
# The path to the namd-caar-reproducer 
# scratch directory.
# 
# ----------------------------------------------------
export NCP_SCRATCH=/gpfs/alpine/scratch/arnoldt/stf006/scratch

# ----------------------------------------------------
# The path to the namd-caar-reproducer package
# top-level directory.
# 
# ----------------------------------------------------
export NCP_TOP_LEVEL=/ccs/home/arnoldt/namd-caar-reproducer

# ----------------------------------------------------
# The path to the top-level directory where all 
# dependent namd software is located. All namd 
# dependent software is located under this
# path.
# 
# ----------------------------------------------------
export NCP_PREFIX=/gpfs/alpine/scratch/arnoldt/stf006/sw

# ----------------------------------------------------
# The path to the top-level directory where all
# namd benchmark results are located.
# 
# ----------------------------------------------------
export NCP_RESULTS=/gpfs/alpine/scratch/arnoldt/stf006/result

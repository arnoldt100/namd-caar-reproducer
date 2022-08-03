#! /usr/bin/env bash

#-----------------------------------------------------
# Define the environmental variable                  -
# NAMD_UIUC_TOP_LEVEL which stores the path to the   -
# NAMD source.                                       -
#                                                    -
#-----------------------------------------------------
export NAMD_UIUC_TOP_LEVEL="${NCP_TOP_LEVEL}/sw/sources/namd"

#-----------------------------------------------------
# Define the environmental variable                  -
# NAMD_AMD_TOP_LEVEL which stores the path to the    -
# NAMD source from AMD developers.                   -
#                                                    -
#-----------------------------------------------------
export NAMD_AMD_TOP_LEVEL="${NCP_TOP_LEVEL}/sw/sources/namd-amd"

#-----------------------------------------------------
# Modify your PATH variable to access certain        -
# executables needed to build various things.        -
#                                                    -
#-----------------------------------------------------
export PATH="${NCP_TOP_LEVEL}/bin:${PATH}"

#-----------------------------------------------------
# Modify the environmental variable PYTHONPATH       -
#                                                    -
#-----------------------------------------------------
export PYTHONPATH="${NCP_TOP_LEVEL}/bin/lib:${PYTHONPATH}"

#-----------------------------------------------------
# We need to make available the modules needed       -
# to build and run NAMD.                             -
#                                                    -
#-----------------------------------------------------
module --ignore-cache use ${NCP_TOP_LEVEL}/runtime_environment




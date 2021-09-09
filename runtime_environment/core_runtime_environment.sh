#! /usr/bin/env bash

#-----------------------------------------------------
# Define the environmental variable                  -
# NCP_TOP_LEVEL which stores the path to the         -
# top level of this reproducer package.              -
#-----------------------------------------------------
export NCP_TOP_LEVEL=$(pwd)

#-----------------------------------------------------
# We need to make available the modules needed       -
# to build and run NAMD.                             -
#                                                    -
#-----------------------------------------------------
module --ignore-cache use ${NCP_TOP_LEVEL}/runtime_environment

#-----------------------------------------------------
# Modify your PATH variable to access certain        -
# executables needed to build various things.        -
#                                                    -
#-----------------------------------------------------
export PATH="${NCP_TOP_LEVEL}/bin:${PATH}"

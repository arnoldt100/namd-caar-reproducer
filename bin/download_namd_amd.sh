#! /usr/bin/env bash

#-----------------------------------------------------
# The github AMD NAMD ROCm repository.               -
#                                                    -
#-----------------------------------------------------
declare -r repository="git@github.com:ROCmSoftwarePlatform/NAMD.git"

# ----------------------------------------------------
# The destination folder of the cloned NAMD.         -
#                                                    -
# ----------------------------------------------------
declare -r destination="${NCP_TOP_LEVEL}/sw/sources/namd-amd"

# ----------------------------------------------------
# 
#  No edits needed below this comment section
# 
# ----------------------------------------------------

# We change to this package
cd ${NCP_TOP_LEVEL}

# Clone the repository from AMD.
git clone ${repository} ${destination}

# Now checkout the AMD developer branch.
cd ${destination}
git checkout -b developer-amd-3-0-alpha-6


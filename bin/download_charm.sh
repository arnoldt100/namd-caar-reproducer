#! /usr/bin/env bash

#-----------------------------------------------------
# Verify that the environmental variable             -
# NCP_TOP_LEVEL is set, otherwise exit.              -
#-----------------------------------------------------
ncp_error_message="The environmental variable NCP_TOP_LEVEL is not set."
${NCP_TOP_LEVEL:?"${ncp_error_message}"}

#-----------------------------------------------------
# Set the git URL for charm++                        -
#                                                    -
#-----------------------------------------------------
declare -r url="https://github.com/UIUC-PPL/charm"

#-----------------------------------------------------
# The destination folder of the downloaded TCL       -
# tarball.                                           -
#                                                    -
#-----------------------------------------------------
declare -r destination="${NCP_TOP_LEVEL}/sw/sources/charm"

# ----------------------------------------------------
# 
#  No edits needed below this comment section
# 
# ----------------------------------------------------


git clone "${url}" "${destination}"
cd ${destination}
git checkout v6.10.2

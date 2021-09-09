#! /usr/bin/env bash

#-----------------------------------------------------
# Set the tarball to download from sourceforge.      -
#                                                    -
#-----------------------------------------------------
declare -r tarball="tcl8.5.9-src.tar.gz"

#-----------------------------------------------------
# The URL of the TCL source.                         -
#                                                    -
#-----------------------------------------------------
declare -r source_to_download="https://sourceforge.net/projects/tcl/files/Tcl/8.5.9/${tarball}"

#-----------------------------------------------------
# The destination folder of the downloaded TCL       -
# source.                                            -
#                                                    -
#-----------------------------------------------------
declare -r destination="${NCP_TOP_LEVEL}/sw/sources/${tarball}"

# ----------------------------------------------------
# 
#  No edits needed below this comment section
# 
# ----------------------------------------------------

cd ${NCP_TOP_LEVEL}
wget -L ${source_to_download} -O ${destination}
declare -r dir1=$(dirname ${destination})
cd ${dir1}
tar xzf ${tarball}


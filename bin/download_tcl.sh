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
# tarball.                                           -
#                                                    -
#-----------------------------------------------------
declare -r destination="${NCP_TOP_EVEL}/sw/sources/${tarball}"

# ----------------------------------------------------
# 
#  No edits needed below this comment section
# 
# ----------------------------------------------------

# We change to this package toplevel. 
cd ${NCP_TOP_LEVEL}

# Download the tarball for sourceforge.
wget -L ${source_to_download} -O ${destination}

# Change to the directory containing the tarball and unpack the tarball.
declare -r dir1=$(dirname ${destination})
cd ${dir1}
tar xzf ${tarball}


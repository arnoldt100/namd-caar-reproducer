#! /usr/bin/env bash


#-----------------------------------------------------
# The URL of the TCL source.                         -
#                                                    -
#-----------------------------------------------------
declare -r source_to_download="https://sourceforge.net/projects/tcl/files/Tcl/8.5.9/tcl8.5.9-src.tar.gz"

#-----------------------------------------------------
# The destination folder of the downloaded TCL       -
# source.                                            -
#                                                    -
#-----------------------------------------------------
declare -r destination="${NCP_TOP_LEVEL}/sw/sources"

# ----------------------------------------------------
# 
#  No edits needed below this comment section
# 
# ----------------------------------------------------

wget -L ${source_to_download} -o ${destination}



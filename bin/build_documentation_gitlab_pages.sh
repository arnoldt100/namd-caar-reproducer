#! /usr/bin/env bash

# ----------------------------------------------------
# This script builds documentation for gitlab-pages.
#
# ----------------------------------------------------

cd ${NCP_TOP_LEVEL}/documentation

make -f Makefile-gitlab-pages clean && make -f Makefile-gitlab-pages html

if [[ $? != 0 ]]; then
    echo "Failed to create documentation."
    exit 1
else
    echo "Created documentation."
fi


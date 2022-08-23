#! /usr/bin/env bash

cd ${NCP_TOP_LEVEL}/documentation
make clean && make html
if [[ $? != 0 ]]; then
    echo "Failed to create documentation."
    exit 1
else
    echo "Created documentation."
fi


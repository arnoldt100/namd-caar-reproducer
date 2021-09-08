#! /usr/bin/env bash

export NCP_TOP_LEVEL=$(pwd)
export PATH="${NCP_TOP_LEVEL}/bin:${PATH}"
module --ignore-cache use ${NCP_TOP_LEVEL}/runtime_environment

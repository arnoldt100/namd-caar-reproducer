-- -*- lua -*-

help(
[[
This module sets critical environmental and path variables needed for building and running NAMD.
]])

-- A list of prerequisite modules.
load("PrgEnv-gnu/8.0.0")
load("cray-fftw/3.3.8.10")

-- Define the machine name.
local machine_name = "Spock"

-- No modifcations needed below this line
setenv('MACHINE_NAME',machine_name)


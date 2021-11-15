-- -*- lua -*-

help(
[[
This module sets critical environmental and path variables needed for building and running NAMD.
]])

-- The Lua module version number for loading
-- the Cray GNU programming environment. 
local pe_gnu_version = "8.2.0"

-- The Lua module version number for loading
-- the Cray FFTW environment. 
local cray_fftw_version = "3.3.8.11"

-- A list of prerequisite modules.
load("PrgEnv-gnu/" .. pe_gnu_version)
load("cray-fftw/" .. cray_fftw_version)
load("gnuplot/5.4-stable")

-- Define the machine name.
local machine_name = "Spock"

-- No modifcations needed below this line
setenv('MACHINE_NAME',machine_name)


-- -*- lua -*-

help(
[[
This module sets critical environmental and path variables needed for building and running NAMD
on Crusher.
]])

-- -------------------------------------------------
-- Set the set of modules to load by defining the variable
-- key to one of the following values:
--
--  key value                Description
--  ---------                -----------
--  "default"                Load the default modules.
-- 
-- -------------------------------------------------
local key="default"

-- -------------------------------------------------
-- Set the machine name.
--
-- -------------------------------------------------
local machine_name = "Crusher"

-- ------------------------------------------------
-- Set the amd programming environment module name.
-- 
-- -------------------------------------------------
local amd_pe_module = {}
amd_pe_module["default"] = "PrgEnv-amd/8.3.3"

-- ------------------------------------------------
-- Set the Cray fftw version module name.
-- 
-- -------------------------------------------------
local cray_fftw_module = {}
cray_fftw_module["default"] = "cray-fftw/3.3.8.13"

-- -------------------------------------------------
-- Set the Cray python version module name.
--
-- -------------------------------------------------
local cray_python_module = {}
cray_python_module["default"] = "cray-python/3.9.12.1"

-- -------------------------------------------------
-- Set the ROCM module name.
-- 
-- -------------------------------------------------
local rocm_module = {}
rocm_module["default"] = "rocm/5.1.0"

-- -------------------------------------------------
-- Set the craype-accel-amd-xxx module file name.  These modules adds
-- references and options required to build apps for accelerator target
-- amd-gfx90a (AMD MI200 GPU).
-- 
-- -------------------------------------------------
local accel_module = {}
accel_module["default"] = "craype-accel-amd-gfx90a" 

-- -------------------------------------------------
-- No edits needed below this comment.
-- 
-- -------------------------------------------------

-- -------------------------------------------------
-- Set the machine name
--
-- -------------------------------------------------
setenv('MACHINE_NAME',machine_name)

-- -------------------------------------------------
-- Load the Programming environment.
--
-- -------------------------------------------------
load (amd_pe_module[key])

-- -------------------------------------------------
-- Load modules to target the accelerators and compile with HIP.
--
-- -------------------------------------------------
load (rocm_module[key])
load (accel_module[key])

-- -------------------------------------------------
-- Load module for the cray fftw emvironment
--
-- -------------------------------------------------
load (cray_fftw_module[key])

-- -------------------------------------------------
-- Load the python module.
--
-- -------------------------------------------------
load (cray_python_module[key])


help([[
This module sets up the runtime environment of 
for NAMD witn charmm++ arch ofi-linux-x86_64,
GNU progrmamming environment. This version runs
CPUs only.
]])

-- -----------------------------------------------------
--  Load dependent modules
--
-- -----------------------------------------------------

-- Set the name of the modulefile that laods the correct charm++
-- runtime environment
charm_module = "Spock/charm++/" .. "multicore-linux-x86_64-gfortran-gcc"
load(charm_module)

load("Spock/tcl/8.5.9")

local charm_arch=os.getenv("CHARMARCH")
local namd_arch_file="Linux-x86_64-g++"
local machine_name=os.getenv("MACHINE_NAME")
local namd_top_level = os.getenv("NAMD_TOP_LEVEL")

-- -------------------------------------------------
-- Define the machine name.
--
-- -------------------------------------------------
-- setenv("NCP_MACHINE_NAME",machine_name)

-- -----------------------------------------------------
--  Set the NAMD top level environmental variable.
-- This variable is the path to the NAMD source.
--
-- -----------------------------------------------------
setenv("NAMD_TOP_LEVEL",namd_top_level)

-- -------------------------------------------------
--  Define the environment variable NAMD_PREFIX.
-- 
-- -------------------------------------------------
local prefix=pathJoin(os.getenv("NCP_TOP_LEVEL"),"sw",machine_name,"NAMD",namd_arch_file,charm_arch,"cpu") 
setenv("NAMD_PREFIX",prefix)

-- ------------------------------------------------
--  Set the name of the NAMD binary.
--
-- ------------------------------------------------
setenv("NAMD_BINARY_NAME","namd2")

-- -------------------------------------------------
-- Define the NAMD_BUILD_TARGET
--
-- -------------------------------------------------
setenv("NCP_TARGET_BUILD","namd-multicore-linux-x86_64__gnu__cpu")

-------------------------------------------------
-- Define the NAMD arch.
--
-- -------------------------------------------------
setenv("NAMD_ARCH","Linux-x86_64-g++")

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

-- Set the name of the modulefile that loads the correct charm++
-- runtime environment
charm_module = "Spock/charm++/" .. "ofi-linux-x86_64-slurmpmi2-smp-gcc"


local charm_arch=os.getenv("CHARMARCH")
local namd_arch_file="Linux-x86_64-g++"
local machine_name=os.getenv("MACHINE_NAME")
local namd_top_level = os.getenv("NAMD_AMD_TOP_LEVEL")
local rocm_version = "rocm/4.3.0"

load(charm_module)
load("Spock/tcl/8.5.9")
load(rocm_version)

-- -------------------------------------------------
-- Define the machine name.
--
-- -------------------------------------------------
setenv("NCP_MACHINE_NAME",machine_name)

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
local prefix=pathJoin(os.getenv("NCP_TOP_LEVEL"),"sw",machine_name,"NAMD",namd_arch_file,charm_arch,"gpu") 
setenv("NAMD_PREFIX",prefix)

-- ------------------------------------------------
--  Set the name of the NAMD binary.
--
-- ------------------------------------------------
setenv("NAMD_BINARY_NAME","namd3")
setenv("NAMD2_BINARY_NAME","namd2")
setenv("NAMD3_BINARY_NAME","namd3")

-- -------------------------------------------------
-- Define the NAMD_BUILD_TARGET
--
-- -------------------------------------------------
setenv("NCP_TARGET_BUILD","namd-amd-ofi-linux-x86_64_slurmpmi2__gnu__gpu")

-------------------------------------------------
-- Define the NAMD arch.
--
-- -------------------------------------------------
setenv("NAMD_ARCH","Linux-x86_64-g++")


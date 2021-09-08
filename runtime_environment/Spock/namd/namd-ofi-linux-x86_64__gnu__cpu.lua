
help([[
This module sets up the runtime environment of 
for NAMD witn charmm++ arch ofi-linux-x86_64,
GNU progrmamming environment. This version runs
CPUs only.
]])

local namd_arch_file="Linux-x86_64-g++"
local charm_arch="ofi-linux-x86_64-gfortran-smp-gcc"
local machine_name="Spock"
local ncp_top_level = pathJoin(os.getenv("NCP_TOP_LEVEL"), "namd-uiuc")
local project_bin_path=pathJoin(ncp_top_level,"bin")
namd_bin_path=pathJoin(os.getenv("NAMD_INSTALL_DIR"),machine_name,namd_arch_file,charm_arch,"cpu","namd2")

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
setenv("NAMD_TOP_LEVEL",ncp_top_level)

-- -------------------------------------------------
--  Add to to the PATH variable the project's bin
--  directory.
-- 
-- -------------------------------------------------
prepend_path("PATH",project_bin_path)

-- -------------------------------------------------
--  Define the environment variable NAMD_BIN_PATH.
-- 
-- -------------------------------------------------
setenv("NAMD_BIN_PATH", namd_bin_path)

-- -------------------------------------------------
-- Define the NAMD_BUILD_TARGET
--
-- -------------------------------------------------
setenv("NCP_BUILD_TARGET","namd-ofi-linux-x86_64__gnu__cpu")

-- -----------------------------------------------------
--  Load dependent modules
--
-- -----------------------------------------------------
depends_on("PrgEnv-gnu/8.0.0")
depends_on("Spock/charm++/" .. charm_arch)
depends_on("Spock/tcl/8.5.9")
depends_on("cray-fftw/3.3.8.10")

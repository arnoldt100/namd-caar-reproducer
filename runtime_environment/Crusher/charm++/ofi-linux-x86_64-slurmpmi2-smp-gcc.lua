--*- lua -*-

help(
[[
This module loads charm++ 7.0.0, arch=ofi-linux-x86_64-slurmpmi2-smp-gcc]])

-- A list of prerequisite modules.
load("Crusher/Crusher_core_runtime_environment")

local machine_name = os.getenv("MACHINE_NAME")
local software_name = "charm++"
local charm_version = "v7.0.0-rc2"
local charmarch="ofi-linux-x86_64-slurmpmi2-smp-gcc"
local ncp_top_level = os.getenv("NCP_TOP_LEVEL")
local parent_directory = pathJoin(ncp_top_level,"sw","sources","charm")
local charm_target_build = "ofi-linux-x86_64:slurmpmi2:smp:gnu"

-- Set the path to the charm++ top level directory.
local charm_base_dir=parent_directory

-- Set the paths to the charm++ lib, bin, and include directory.
local charm_bin_dir=pathJoin(charm_base_dir,charmarch,'bin')
local charm_lib_dir=pathJoin(charm_base_dir,charmarch,'lib')
local charm_include_dir=pathJoin(charm_base_dir,charmarch,'include')

-- No modfications needed below this line

setenv("CHARMARCH",charmarch)
setenv("CHARMBASE",charm_base_dir)
setenv("CHARM_TARGET_BUILD",charm_target_build)
prepend_path('PATH',charm_bin_dir)
prepend_path('LD_LIBRARY_PATH',charm_lib_dir)
prepend_path('C_INCLUDE_PATH',charm_include_dir)
prepend_path('CPLUS_INCLUDE_PATH',charm_include_dir)

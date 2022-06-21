--*- lua -*-

help(
[[
This module loads charm++ 7.0.0, arch=multicore-linux-x86_64-gfortran]])

-- A list of prerequisite modules.
load("Crusher/Crusher_core_runtime_environment")

local machine_name = os.getenv("MACHINE_NAME")
local software_name = "charm++"
local charm_version = "v7.0.0-rc2"
local charmarch="multicore-linux-x86_64-gcc"
local ncp_top_level = os.getenv("NCP_TOP_LEVEL")
local parent_directory = pathJoin(ncp_top_level,"sw","sources","charm")
local charm_build_target = "multicore-linux-x86_64:gnu"

-- Set the path to the charm++ top level directory.
local charm_base_dir=parent_directory

-- Set the paths to the charm++ lib, bin, and include directory.
local charm_bin_dir=pathJoin(charm_base_dir,charmarch,'bin')
local charm_lib_dir=pathJoin(charm_base_dir,charmarch,'lib')
local charm_include_dir=pathJoin(charm_base_dir,charmarch,'include')

-- No modfications needed below this line

setenv("CHARMARCH",charmarch)
setenv("CHARMBASE",charm_base_dir)
setenv("CHARM_TARGET_BUILD",charm_build_target)
prepend_path('PATH',charm_bin_dir)
prepend_path('LD_LIBRARY_PATH',charm_lib_dir)
prepend_path('C_INCLUDE_PATH',charm_include_dir)
prepend_path('CPLUS_INCLUDE_PATH',charm_include_dir)

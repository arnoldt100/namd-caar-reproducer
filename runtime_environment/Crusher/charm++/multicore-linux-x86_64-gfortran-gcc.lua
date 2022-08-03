--*- lua -*-

help(
[[
This module loads charm++ 7.0.0, arch=multicore-linux-x86_64-gfortran]])

-- -------------------------------------------------
-- We need the machine name.
--
-- -------------------------------------------------
local machine_name = os.getenv("NCP_MACHINE_NAME")
local prefix = os.getenv("NCP_PREFIX")

-- A list of prerequisite modules that need to be loaded.
local crusher_core_module = machine_name .. "/" .. machine_name .. "_core_runtime_environment"
prereq(crusher_core_module)

local software_name = "charm++"
local charm_version = "v7.0.0-rc2"
local charmarch="multicore-linux-x86_64-gcc"
local charm_build_target = "multicore-linux-x86_64:gnu"

-- Set the path to the charm++ top level directory.
local ncp_top_level = os.getenv("NCP_TOP_LEVEL")
local old_charm_base_dir=pathJoin(ncp_top_level,"sw","sources","charm")
local new_charm_base_dir=pathJoin(prefix,"charm",machine_name,charmarch)

-- Set the paths to the charm++ lib, bin, and include directory.
local charm_bin_dir=pathJoin(new_charm_base_dir,charmarch,'bin')
local charm_lib_dir=pathJoin(new_charm_base_dir,charmarch,'lib')
local charm_include_dir=pathJoin(new_charm_base_dir,charmarch,'include')

-- No modfications needed below this line

setenv("ORIGINALCHARMBASE",old_charm_base_dir)
setenv("CHARMARCH",charmarch)
setenv("CHARMBASE",new_charm_base_dir)
setenv("CHARM_TARGET_BUILD",charm_build_target)
prepend_path('PATH',charm_bin_dir)
prepend_path('LD_LIBRARY_PATH',charm_lib_dir)
prepend_path('C_INCLUDE_PATH',charm_include_dir)
prepend_path('CPLUS_INCLUDE_PATH',charm_include_dir)

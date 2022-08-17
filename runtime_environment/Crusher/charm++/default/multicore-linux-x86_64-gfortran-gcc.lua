--*- lua -*-

help(
[[
This module loads charm++ 7.0.0, arch=multicore-linux-x86_64-gfortran and defines the
installation paths.
]])

local function compute_path(machine_name,charmarch)
    local software_name = "charm"
    local tcl_version = "v7.0.0-rc2"
    local ncp_pe_key = os.getenv("NCP_PE_KEY")
    local ncp_prefix = os.getenv("NCP_PREFIX") 
    local program = "ncp_paths_tcl.py "
    local options = {}
    table.insert(options," " .. "--machine-name " .. machine_name)
    table.insert(options," " .. "--software-name " .. software_name)
    table.insert(options," " .. "--software-version " .. tcl_version)
    table.insert(options," " .. "--charmarch " .. charmarch)
    table.insert(options," " .. "--ncp-pe-key " .. ncp_pe_key)
    table.insert(options," " .. "--ncp-prefix " .. ncp_prefix)
    table.insert(options," " .. "--path " .. "prefix")

    local command = "ncp_paths_charm.py"
    for i,v in ipairs(options) do
        command = command .. v
    end

    local result = subprocess(command)
    return result
end

-- We need the machine name.
local machine_name = os.getenv("NCP_MACHINE_NAME")

-- A list of prerequisite modules that need to be loaded.
local crusher_core_module = machine_name .. "/" .. machine_name .. "_core_runtime_environment"
prereq(crusher_core_module)

-- Define the charmarch
local charmarch="multicore-linux-x86_64-gcc"

-- In this section we compute the new charm base dir.
local new_charm_base_dir = compute_path(machine_name,charmarch)


-- Set the path to the charm++ top level directory.
local ncp_top_level = os.getenv("NCP_TOP_LEVEL")
local old_charm_base_dir=pathJoin(ncp_top_level,"sw","sources","charm")

-- Set the paths to the charm++ lib, bin, and include directory.
local charm_bin_dir=pathJoin(new_charm_base_dir,charmarch,'bin')
local charm_lib_dir=pathJoin(new_charm_base_dir,charmarch,'lib')
local charm_include_dir=pathJoin(new_charm_base_dir,charmarch,'include')

-- No modfications needed below this line

setenv("ORIGINALCHARMBASE",old_charm_base_dir)
setenv("CHARMARCH",charmarch)
setenv("CHARMBASE",charm_installation_directory)
setenv("CHARM_TARGET_BUILD",charm_build_target)
prepend_path('PATH',charm_bin_dir)
prepend_path('LD_LIBRARY_PATH',charm_lib_dir)
prepend_path('C_INCLUDE_PATH',charm_include_dir)
prepend_path('CPLUS_INCLUDE_PATH',charm_include_dir)

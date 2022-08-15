-- -*- lua -*-

help(
[[
This module loads tcl 8.5.9 and defines installation paths.  
]])

local function create_path(machine_name)
    local software_name = "TCL"
    local tcl_version = "8.5.9"
    local ncp_pe_key = os.getenv("NCP_PE_KEY")
    local ncp_prefix = os.getenv("NCP_PREFIX") 
    local program = "ncp_paths_tcl.py "
    local options = {}
    table.insert(options," " .. "--machine-name " .. machine_name)
    table.insert(options," " .. "--software-name " .. software_name)
    table.insert(options," " .. "--software-version " .. tcl_version)
    table.insert(options," " .. "--ncp-pe-key " .. ncp_pe_key)
    table.insert(options," " .. "--ncp-prefix " .. ncp_prefix)
    table.insert(options," " .. "--path " .. "prefix")

    local command = "ncp_paths_tcl.py"
    for i,v in ipairs(options) do
        command = command .. v
    end

    local result = subprocess(command)
    return result
end

-- Define the machine that TCL will be installed on.
local machine_name = os.getenv("NCP_MACHINE_NAME")

-- A list of prerequisite modules that need to be loaded.
local machine_core_module = machine_name .. "/" .. machine_name .. "_core_runtime_environment"
prereq(machine_core_module)

-- In this section we 
local tcl_installation_directory = create_path(machine_name)

-- No modifcations needed below this line

local tcl_lib_dir = pathJoin(tcl_installation_directory,"/lib")
local tcl_bin_dir = pathJoin(tcl_installation_directory,"/bin")
local tcl_include_dir = pathJoin(tcl_installation_directory,"/include")
local tcl_manpath_dir = pathJoin(tcl_installation_directory,"/man")

setenv("TCL_DIR",tcl_installation_directory)
prepend_path('MANPATH',tcl_manpath_dir)
prepend_path('PATH',tcl_bin_dir)
prepend_path('C_INCLUDE_PATH', tcl_include_dir)
prepend_path('CPLUS_INCLUDE_PATH', tcl_include_dir)
prepend_path('LD_LIBRARY_PATH',tcl_lib_dir)

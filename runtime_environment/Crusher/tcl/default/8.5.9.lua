-- -*- lua -*-

help(
[[
This module loads tcl 8.5.9. Installation paths are defined.  
]])

local machine_name = os.getenv("NCP_MACHINE_NAME")

-- A list of prerequisite modules that need to be loaded.
local machine_core_module = machine_name .. "/" .. machine_name .. "_core_runtime_environment"
prereq(machine_core_module)

local software_name = "tcl"
local tcl_version = "8.5.9"
local parent_directory = os.getenv("NCP_PREFIX")

local tcl_installation_directory = pathJoin(parent_directory,machine_name,software_name,tcl_version) 
local tcl_lib_dir = pathJoin(tcl_installation_directory,"/lib")
local tcl_bin_dir = pathJoin(tcl_installation_directory,"/bin")
local tcl_include_dir = pathJoin(tcl_installation_directory,"/include")
local tcl_manpath_dir = pathJoin(tcl_installation_directory,"/man")

-- -- No modifcations needed below this line
setenv("TCL_DIR",tcl_installation_directory)
prepend_path('MANPATH',tcl_manpath_dir)
prepend_path('PATH',tcl_bin_dir)
prepend_path('C_INCLUDE_PATH', tcl_include_dir)
prepend_path('CPLUS_INCLUDE_PATH', tcl_include_dir)
prepend_path('LD_LIBRARY_PATH',tcl_lib_dir)

-- -*- lua -*-

help(
[[
This module loads tcl 8.5.9  
]])

-- A list of prerequisite modules.
load("Crusher/Crusher_core_runtime_environment")

local machine_name = os.getenv("MACHINE_NAME")
local software_name = "tcl"
local tcl_version = "8.5.9"
local ncp_top_level = os.getenv("NCP_TOP_LEVEL")
local parent_directory = pathJoin(ncp_top_level,"sw",machine_name,software_name,tcl_version)

local tcl_installation_directory = parent_directory
local tcl_lib_dir = pathJoin(tcl_installation_directory,"/lib")
local tcl_bin_dir = pathJoin(tcl_installation_directory,"/bin")
local tcl_include_dir = pathJoin(tcl_installation_directory,"/include")
local tcl_manpath_dir = pathJoin(tcl_installation_directory,"/man")

-- -- No modifcations needed below this line
setenv("TCL_DIR",parent_directory)
prepend_path('MANPATH',tcl_manpath_dir)
prepend_path('PATH',tcl_bin_dir)
prepend_path('C_INCLUDE_PATH', tcl_include_dir)
prepend_path('CPLUS_INCLUDE_PATH', tcl_include_dir)
prepend_path('LD_LIBRARY_PATH',tcl_lib_dir)

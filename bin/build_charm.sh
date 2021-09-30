#! /usr/bin/env bash

#-----------------------------------------------------
# A build script for charm++.                        -
#                                                    -
# This script does 3 main tasks to build charm++:    -
# (1) Checks that certain prerequisites are met.     -
#     For example, ensure that key environmental     -
#     variables are set.                             -
#                                                    -
# (2) Declares all global variables that are used    -
#     throughout this script.                        -
#                                                    -
# (3) Calls the functions that builds charm++        -
#     for a specific network layer.                  -
#-----------------------------------------------------

#-----------------------------------------------------
# Function:                                          -
#    declare_global_variables                        -
#                                                    -
# Synopsis:                                          -
#   Declares gobal variables for use in this script. -
#   Note the environmental variable NCP_TOP_LEVEL    -
#   must be properly defined or the path to the      -
#   charm++ source will be incorrect.                -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function declare_global_variables () {

    #-----------------------------------------------------
    # Define this bash script name. This global variable
    # must be defined at this location.
    # 
    #-----------------------------------------------------
    declare -gr SCRIPT_NAME=${BASH_SOURCE:-"build_charm.sh"}

    #-----------------------------------------------------
    # Set the script launch directory.
    # 
    #-----------------------------------------------------
    declare -gr SCRIPT_LAUNCH_DIR=$(pwd)

    #-----------------------------------------------------
    # Declare an associative array for defining
    # various exit status codes.
    #
    #-----------------------------------------------------
    declare -grA EXIT_STATUS=( [failed_cd]=2
                               [failed_build_command]=3
                               [failed_make_command]=4 )

    #-----------------------------------------------------
    # The charm++ version.
    # 
    #-----------------------------------------------------
    declare -gr CHARM_VERSION="6.10.2"

    #-----------------------------------------------------
    # Location of charm++ source.
    #
    #-----------------------------------------------------
    declare -gr CHARM_SOURCE_DIRECTORY="${NCP_TOP_LEVEL}/sw/sources/charm"

    #-----------------------------------------------------
    # The machine name.
    # 
    #-----------------------------------------------------
    declare -gr MACHINE_NAME="Spock"
}

#-----------------------------------------------------
# Function:                                          -
#    change_dir                                      -
#                                                    -
# Synopsis:                                          -
#   Changes the execution directory of the script.   -
#   If the directory change fails, then the function -
#   prints a warning and the exit command is called  -
#   with an exit status of 2.                        -
#                                                    -
# Positional parameters:                             -
#   ${1} The directory to change to.                 -
#                                                    -
#-----------------------------------------------------
function change_dir () {
    cd ${1}
    if [ $? -ne 0 ];then
        local -r message="Error! The script failed to change to directory ${1}."
        local -ir my_exit_status=${EXIT_STATUS["failed_cd"]}

        echo "${message}"
        exit ${my_exit_status}
    fi
    return
}


#-----------------------------------------------------
# Function:                                          -
#    check_script_prerequisites                      -
#                                                    -
# Synopsis:                                          -
#   Checks that script prerequisites are met.        -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function check_script_prerequisites () {
    #-----------------------------------------------------
    # Verify that the environmental variable 
    # NCP_TOP_LEVEL is set, otherwise exit.
    #
    #-----------------------------------------------------
    ncp_error_message="The environmental variable NCP_TOP_LEVEL is not set."
    ${NCP_TOP_LEVEL:?"${ncp_error_message}"}
    return
}

#-----------------------------------------------------
# Function:                                          -
#    build_ofi_linux_x86_64_gcc_smp_gfortran         -
#                                                    -
# Synopsis:                                          -
#   Builds charmm++ with the OFI transport layer.    -
#   Debug symbols are included.                      -
#   This build is for the GNU programming            -
#   environment.                                     -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function build_ofi_linux_x86_64_gcc_smp_gfortran() {
    #-----------------------------------------------------
    # The target of the build.
    # 
    #-----------------------------------------------------
    local -r target='charm++'

    #-----------------------------------------------------
    # Define the charm++ arch. This variable selects 
    # the network transport layer to build. 
    #-----------------------------------------------------
    local -r charmarch='ofi-linux-x86_64'

    #-----------------------------------------------------
    # The libfabric include and library options need 
    # to be explicitly passed to the charm++ build 
    # command options.
    #-----------------------------------------------------
    local include_dir="$(pkg-config --cflags-only-I libfabric)"
    # The below bash string manipulation removes the "-I" at the beginning of the string
    # for we only need the directory path.
    include_dir=${include_dir##-I} 

    local library_dir="$(pkg-config --libs-only-L libfabric)"
    # The below bash string manipulation removes the "-L" at the beginning of the string
    # for we only need the directory path.
    library_dir=${library_dir##-L} 

    #-----------------------------------------------------
    # Define  the options to the charm++ build command.
    #-----------------------------------------------------
    local -r options=" gcc smp -g -j1 --incdir ${include_dir} --libdir ${library_dir}"

    #-----------------------------------------------------
    # Change to the charm++ source directory, and then
    # run the charm++ build command. 
    #-----------------------------------------------------
    change_dir "${CHARM_SOURCE_DIRECTORY}"

    echo "The charm++ build command: ./build ${target} ${charmarch} ${options}"

    ./buildold ${target} ${charmarch} ${options}
    if [ $? -ne 0 ];then
       local -r build_message="Error! The script ${SCRIPT_NAME} failed to build charm++."
       local -ir my_build_exit_status=${EXIT_STATUS["failed_build_command"]}
       echo "${build_message}"
       exit ${my_buildexit_status}
    fi

    make -j 4 
    if [ $? -ne 0 ];then
       local -r make_message="Error! The script ${SCRIPT_NAME} failed to build charm++."
       local -ir my_make_exit_status=${EXIT_STATUS["failed_make_command"]}
       echo "${make_message}"
       exit ${my_make_exit_status}
    fi

    change_dir "${SCRIPT_LAUNCH_DIR}"
    return
}

#-----------------------------------------------------
# Below are the primary function calls to execute    -
# the script.                                        -
#                                                    -
#-----------------------------------------------------

# Check some prerequisites are satisfied.
check_script_prerequisites

# Declaree global variables thar are used in this script.
declare_global_variables

# Call the function that builds charm++.
build_ofi_linux_x86_64_gcc_smp_gfortran

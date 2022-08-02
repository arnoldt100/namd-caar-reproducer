#! /usr/bin/env bash

#-----------------------------------------------------
# A build script for tcl.                            -
#                                                    -
# This script does 3 main tasks to build tcl.        -
# (1) Checks that certain prerequisites are met.     -
#     For example, ensure that key environmental     -
#     variables are set.                             -
#                                                    -
# (2) Declares all global variables that are used    -
#     throughout this script.                        -
#                                                    -
# (3) Calls the functions that builds tcl.           -
#-----------------------------------------------------

#-----------------------------------------------------
# Function:                                          -
#    declare_global_variables                        -
#                                                    -
# Synopsis:                                          -
#   Declares gobal variables for use in this script. -
#   Note the environmental variable NCP_TOP_LEVEL    -
#   must be properly defined or the path to the      -
#   tcl source will be incorrect.                    -
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
    declare -gr SCRIPT_NAME=${BASH_SOURCE:-"build_tcl.sh"}

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
                               [failed_configure_command]=3
                               [failed_make_clean]=4
                               [failed_make_install]=5 )

    #-----------------------------------------------------
    # TCL version                                        -
    #                                                    -
    #-----------------------------------------------------
    declare -gr TCL_VERSION='8.5.9'

    #-----------------------------------------------------
    # Path to tcl package.                               -
    #                                                    -
    #-----------------------------------------------------
    declare -gr TCL_SOURCE_PACKAGE="${NCP_TOP_LEVEL}/sw/sources/tcl${TCL_VERSION}"

    #-----------------------------------------------------
    # The machine name.
    # 
    #-----------------------------------------------------
    declare -gr MACHINE_NAME="${NCP_MACHINE_NAME}"

    #-----------------------------------------------------
    # Parent installation directory.                     -
    #                                                    -
    #-----------------------------------------------------
    declare -gr PREFIX_DIRECTORY="${TCL_DIR}"
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
        exit $my_exit_status
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
#    make_clean                                      -
#                                                    -
# Synopsis:                                          -
#   Performs the  command 'make clean' for tcl.      -
#   If the command fails, then this script will      -
#   exit with a predefined exit code.                -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function make_clean () {
    change_dir "${TCL_SOURCE_PACKAGE}/unix"
    make clean
    if [ $? -ne 0 ];then
        local -r message="Error! The script ${SCRIPT_NAME} failed to successfully do a make clean."
        local -ir my_exit_status=${EXIT_STATUS["failed_make_clean"]}
        exit $my_exit_status
    fi 
    change_dir "${SCRIPT_LAUNCH_DIR}"
}

#-----------------------------------------------------
# Function:                                          -
#    make_clean                                      -
#                                                    -
# Synopsis:                                          -
#   Performs the  configure for tcl.                 -
#   If the configure fails, then this script will    -
#   exit with a predefined exit code.                -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function configure_tcl () {
    change_dir "${TCL_SOURCE_PACKAGE}/unix"
    ./configure --prefix=${PREFIX_DIRECTORY} \
                --enable-64bit \
                --enable-threads \
                --enable-symbols
    if [ $? -ne 0 ];then
        local -r message="Error! The script ${SCRIPT_NAME} failed to successfully configure tcl."
        local -ir my_exit_status=${EXIT_STATUS["failed_configure_command"]}
        exit $my_exit_status
    fi 
    change_dir "${SCRIPT_LAUNCH_DIR}"
     
}


#-----------------------------------------------------
# Function:                                          -
#    make_and_install                                -
#                                                    -
# Synopsis:                                          -
#   Performs the make and "make install" command     -
#   If the commands fails, then this script will     -
#   exit with a predefined exit code.                -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function make_and_install () {
    change_dir "${TCL_SOURCE_PACKAGE}/unix"

    # Run the make command for tcl.
    make -j 2
    if [ $? -ne 0 ];then
        local -r message1="Error! The script ${SCRIPT_NAME} failed to successfully make tcl."
        local -ir my_exit_status1=${EXIT_STATUS["failed_make_install"]}
        exit $my_exit_status
    fi

    # Run the 'make install' command for tcl.
    make install
    if [ $? -ne 0 ];then
        local -r message2="Error! The script ${SCRIPT_NAME} failed to successfully 'make install' tcl."
        local -ir my_exit_status2=${EXIT_STATUS["failed_make_install"]}
        exit $my_exit_status
    fi

    change_dir "${SCRIPT_LAUNCH_DIR}"
}


#-----------------------------------------------------
# Below are the primary function calls to execute    -
# the script.                                        -
#                                                    -
#-----------------------------------------------------

declare_global_variables
configure_tcl
make_and_install

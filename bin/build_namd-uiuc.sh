#! /usr/bin/env bash

#-----------------------------------------------------
# A build script for namd.                           -
#                                                    -
# The software prerequisites for building NAMD       -
# are charm++, tcl, and fftw. See                    
# https://www.ks.uiuc.edu/Research/namd/2.14/ug/     -
#                                                    -
#                                                    -
#-----------------------------------------------------
declare -gr PROGNAME="$(basename ${0})"

#-----------------------------------------------------
# Function:                                          -
#    error_exit                                      -
#                                                    -
# Synopsis:                                          -
#   An error handling function.                      -
#   The prints the error and then forces the script  -
#   to exit with a status 1.                         -
#                                                    -
# Positional parameters:                             -
#   ${1} A string containing a descriptive error     -
#        message                                     -
#                                                    -
#-----------------------------------------------------
function error_exit () {
    echo
    echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    echo
    exit 1
}

#-----------------------------------------------------
# Function:                                          -
#    error_no_exit                                   -
#                                                    -
# Synopsis:                                          -
#   An error handling function.                      -
#   Prints an error message.                         -
#                                                    -
# Positional parameters:                             -
#   ${1} A string containing a descriptive error     -
#        message                                     -
#                                                    -
#-----------------------------------------------------
function error_no_exit () {
    echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    return
}


#-----------------------------------------------------
# Function:                                          -
#    declare_global_variables                        -
#                                                    -
# Synopsis:                                          -
#   Declares gobal variables for use in this script. -
#   Note the environmental variable NCP_TOP_LEVEL    -
#   must be properly defined or the path to the      -
#   charm++ and tcl  source will be incorrect.       -
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
    declare -gr SCRIPT_NAME=${BASH_SOURCE:-"build_namd-uiuc.sh"}

    #-----------------------------------------------------
    # Set the script launch directory.
    # 
    #-----------------------------------------------------
    declare -gr SCRIPT_LAUNCH_DIR=$(pwd)
    
    #-----------------------------------------------------
    # This vriable stores the machine name.
    # 
    #-----------------------------------------------------
    declare -g ncp_target_machine="NOT_DEFINED"
    
    #-----------------------------------------------------
    # This variable stores the namd build target.        -
    #                                                    -
    #-----------------------------------------------------
    declare -g ncp_target_build="NOT_DEFINED"

    declare -gr charm_base=${CHARMBASE}

    declare -g OPTS=""

    #-----------------------------------------------------
    # Declare an associative array for defining
    # various exit status codes.
    #
    #-----------------------------------------------------
    declare -grA EXIT_STATUS=( [failed_cd]=2
                               [failed_build_command]=3 
                               [failed_unsupported_target]=4
                               [failed_notset_variable]=5 )
}


#-----------------------------------------------------
# Function:                                          -
#    usage                                           -
#                                                    -
# Synopsis:                                          -
#   Prints the help usage message.                   -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function usage () {
    local -r column_width=50
    let separator_line_with=2*column_width+1
    local -r help_frmt1="%-${column_width}s %-${column_width}s\n"
    printf "\n"
    printf "Usage:\n"
    printf "\tbuild_namd.sh [ -h | --help ] --target-machine <name of machine> --target-build <name of build>\n\n"
    printf "${help_frmt1}" "option" "description"
    for ((ip=0; ip < ${separator_line_with}; ip++));do
        printf "%s" "-"
    done
    printf "\n"
    printf "${help_frmt1}" "-h | --help" "Prints the help message"
    printf "\n"
    printf "${help_frmt1}" "--target-machine <name of machine>" "The machine to build NAMD on."
    printf "${help_frmt1}" "--target-build" "The build target."
    printf "\n"
    printf "\n"
    printf "${help_frmt1}" "Available target machine: " "Spock"
    printf "${help_frmt1}" "Spock available target builds:" "namd-ofi-linux-x86_64__gnu__cpu"
    printf "${help_frmt1}" "" "namd-netlrts-linux-x86_64__gnu__cpu"
    printf "\n"
    printf "${help_frmt1}" "Available target machine: " "Summit"
    printf "${help_frmt1}" "Summit available target builds:" "None"
    printf "\n"
}


#-----------------------------------------------------
# Function:                                          -
#    warn_unsupported_target                         -
#                                                    -
# Synopsis:                                          -
#   Warns the user of an trying to build an          -
#   unsupported build.                               -
#                                                    -
# Positional parameters:                             -
#   ${1} The namd build target.                      -
#   ${2} The target machine.                         -
#                                                    -
#-----------------------------------------------------
function warn_unsupported_target () {
    local -r my_namd_target=${1}
    local -r my_target_machine=${2}
    local -ir my_exit_status=${EXIT_STATUS["failed_unsupported_target"]}
    echo "The build target '${my_namd_target}' of machine '${my_target_machine}' is not supported."
    usage
    exit ${my_exit_status}
}

#-----------------------------------------------------
# Function:                                          -
#    warn_unsupported_machine                        -
#                                                    -
# Synopsis:                                          -
#   Warns the user of an trying to build an          -
#   unsupported build.                               -
#                                                    -
# Positional parameters:                             -
#   ${1} The namd build target.                      -
#   ${2} The target machine.                         -
#                                                    -
#-----------------------------------------------------
function warn_unsupported_machine () {
    local -r my_namd_target=${1}
    local -r my_target_machine=${2}
    local -ir my_exit_status=${EXIT_STATUS["failed_unsupported_target"]}
    echo "The machine '${my_target_machine}' is not supported."
    usage
    exit ${my_exit_status}
}

#-----------------------------------------------------
# Function:                                          -
#    warn_unset_or_empty_variable                    -
#                                                    -
# Synopsis:                                          -
#   Warns of an unset or empty variable.             -
#                                                    -
# Positional parameters:                             -
#   ${1} The variable name.                          -
#                                                    -
#-----------------------------------------------------
function warn_unset_or_empty_variable () {
    local -r variable_name=${1}
    local -r error_message="The environmental variable ${variable_name} is empty or not set."
    local -ir my_exit_status=${EXIT_STATUS["failed_notset_variable"]}
    echo "${error_message}"
    exit ${my_exit_status}
}

#-----------------------------------------------------
# Function:                                          -
#    build_Spock_namd_ofi_linux_x86_64__gnu__cpu     -
#                                                    -
# Synopsis:                                          -
#   Configures and builds NAMD for CPU only.         -
#                                                    -
# Positional parameters:                             -
#   None                                             -
#                                                    -
#-----------------------------------------------------
function build_Spock_namd_ofi_linux_x86_64__gnu__cpu () {

    local -r machine_name="${MACHINE_NAME}"
    local -r namd_arch="${NAMD_ARCH}"
    local -r charm_arch="${CHARMARCH}"
    local -r prefix="${NAMD_PREFIX}"
    local -r namd_top_level="${NAMD_TOP_LEVEL}"
    local -r bin2="namd2"
    local -r nm_make_threads="8"
    local -r fftw_dir=${FFTW_DIR}
    cd ${namd_top_level}

    if [ -d ${namd_arch} ];then
        rm -rf ${namd_arch}
    fi

    local -r fftw_prefix=$(dirname ${fftw_dir})
    local config_options=( "${namd_arch}"
                     "--with-debug"
                     "--with-fftw3 --fftw-prefix ${fftw_prefix}"
                     "--tcl-prefix ${TCL_DIR}"
                     "--charm-base ${charm_base} --charm-arch ${charm_arch}"  )

    local config_command="./config"
    for opt in ${config_options[@]}; do
        config_command="${config_command} ${opt}"
    done

    ${config_command}
    if [[ $? != 0 ]];then
        local -r config_error_message="The configure command of build_Spock_namd_ofi_linux_x86_64__gnu__cpu failed."
        error_exit "${config_error_message}"
    fi

    cd ${namd_arch}

    make -j ${nm_make_threads}
    if [[ $? != 0 ]];then
        local -r make_error_message="The make command of build_Spock_namd_ofi_linux_x86_64__gnu__cpu failed."
    fi

    if [ ! -d ${prefix} ];then
        mkdir -p ${prefix}
    fi
    cp -rf ./${bin2} ${prefix}
    cd ${starting_directory}
    return
}


#-----------------------------------------------------
# Function:                                          -
#    build_namd_netlrts_linux_x86_64__gnu__cpu       -
#                                                    -
# Synopsis:                                          -
#   Prints the usage of this bash function.          -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function build_namd_netlrts_linux_x86_64__gnu__cpu {
    local -r machine_name="${MACHINE_NAME}"
    local -r namd_arch="${NAMD_ARCH}"
    local -r charm_arch="${CHARMARCH}"
    local -r prefix="${NAMD_PREFIX}"
    local -r namd_top_level="${NAMD_TOP_LEVEL}"
    local -r bin2="namd2"
    local -r nm_make_threads="8"
    local -r fftw_dir=${FFTW_DIR}
    cd ${namd_top_level}

    if [ -d ${namd_arch} ];then
        rm -rf ${namd_arch}
    fi

    local -r fftw_prefix=$(dirname ${fftw_dir})
    local config_options=( "${namd_arch}"
                     "--with-debug"
                     "--with-fftw3 --fftw-prefix ${fftw_prefix}"
                     "--tcl-prefix ${TCL_DIR}"
                     "--charm-base ${charm_base} --charm-arch ${charm_arch}"  )

    local config_command="./config"
    for opt in ${config_options[@]}; do
        config_command="${config_command} ${opt}"
    done

    ${config_command}
    if [[ $? != 0 ]];then
        local -r config_error_message="The configure command of build_namd_netlrts_linux_x86_64__gnu__cpu failed."
        error_exit "${config_error_message}"
    fi

    cd ${namd_arch}

    make -j ${nm_make_threads}
    if [[ $? != 0 ]];then
        local -r make_error_message="The make command of build_namd_netlrts_linux_x86_64__gnu__cpu failed."
    fi

    if [ ! -d ${prefix} ];then
        mkdir -p ${prefix}
    fi
    cp -rf ./${bin2} ${prefix}
    cd ${starting_directory}
    return
}

#-------------------------------------------------------
# Function:                                            -
#   validate_command_line                              -
#                                                      -
# Synopsis:                                            -
#   Validates this script command line.                -
#   Once the command line arguments are validated,     -
#   they are stored in the global variable OPTS.       -
#   The user command getopt to validate                -
#   the command line options.                          -
#   Please read the user man pages for getopt:         -
#   http://man7.org/linux/man-pages/man1/getopt.1.html -
#                                                      -
# Positional parameters:                               -  
#   ${@} This script command line arguments.           -
#                                                      -
#-------------------------------------------------------
function validate_command_line {
    local -r short_options_without_args="h,"
    local -r long_options_without_args="help,"
    local -r long_options_with_args="target-machine:,target-build:,"
    local -r long_options="${long_options_without_args}${long_options_with_args}"
    local -r short_options="${short_options_without_args}${short_options_with_args}"
    OPTS=$(getopt --options ${short_options} --long ${long_options} --name "${PROGNAME}" -- "$@")
    if [ $? != 0 ]; then
         usage
         error_exit "The getopt command failed ... exiting"
    fi
}

#-----------------------------------------------------
# Function:                                          -
#    parse_command_line                              -
#                                                    -
# Synopsis:                                          -
#   Parses the command line arguments.               -
#                                                    -
# Positional parameters:                             -
#   ${@} The command line arguments to this script.  -
#-----------------------------------------------------
function parse_command_line {
    eval set -- $@
    while true;do
        case ${1} in
            -h | --help ) 
                usage
                exit 0;;

            --target-machine)
                shift
                ncp_target_machine=${1};;

            --target-build)
                shift
                ncp_target_build=${1};;

            -- ) 
                shift
                break;;

            * ) 
                echo "Internal parsing error!"
                usage
                exit 1;;
        esac
        shift
    done
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
    if [ -z "${NCP_TOP_LEVEL}" ] ;then
        warn_unset_or_empty_variable "NCP_TOP_LEVEL"
    fi

    #-----------------------------------------------------
    # Verify that the environmental variable
    # NAMD_TOP_LEVEL is set, otherwise exit.
    #-----------------------------------------------------
    if [ -z "${NAMD_TOP_LEVEL}" ];then
        warn_unset_or_empty_variable "NAMD_TOP_LEVEL"
    fi

    #-----------------------------------------------------
    # Verify that the environmental variable
    # FFTW_DIR is set, otherwise exit.
    # 
    #-----------------------------------------------------
    if [ -z "${FFTW_DIR}" ];then
        warn_unset_or_empty_variable "FFTW_DIR"
    fi

    #-----------------------------------------------------
    # Verify that the environmental variable
    # TCL_DIR is set, otherwise exit.
    #
    #-----------------------------------------------------
    if [ -z "${TCL_DIR}" ];then
        warn_unset_or_empty_variable "TCL_DIR"
    fi

    #-----------------------------------------------------
    # Verify that the environmental variable             -
    # MACHINE_NAME, otherwise exit.                      -
    #-----------------------------------------------------
    if [ -z "${MACHINE_NAME}" ];then
        warn_unset_or_empty_variable "MACHINE_NAME"
    fi

    #-----------------------------------------------------
    # Verify that the environmental variable             -
    # CHARMARCH, otherwise exit.                         -
    #-----------------------------------------------------
    if [ -z "${CHARMARCH}" ];then
        warn_unset_or_empty_variable "CHARMARCH"
    fi

    #-----------------------------------------------------
    # Verify that the environmental variable             -
    # NAMD_PREFIX, otherwise exit.                       -
    #-----------------------------------------------------
    if [ -z "${NAMD_PREFIX}" ];then
        warn_unset_or_empty_variable "NAMD_PREFIX"
    fi

    #-----------------------------------------------------
    # Verify that the environmental variable             -
    # NAMD_ARCH, otherwise exit.                         -
    #-----------------------------------------------------
    if [ -z "${NAMD_ARCH}" ];then
        warn_unset_or_empty_variable "NAMD_ARCH"
    fi

    return
}

#-----------------------------------------------------
# Function:                                          -
#    main                                            -
#                                                    -
# Synopsis:                                          -
#   The main function of this bash script.           -
#                                                    -
# Positional parameters:                             -
#   $@ This script command line arguments.           -
#                                                    -
#-----------------------------------------------------
function main () {
    # Check some prerequisites.
    check_script_prerequisites

    # Declare all global variables.
    declare_global_variables

    # Validate the command line options and arguments.
    validate_command_line $@

    # Parses the command line options.
    parse_command_line ${OPTS}
    if [ $? != 0 ]; then
         error_exit 'The function parse_command_line failed ... exiting'
    fi
    
    # Using a case statement we call the appropiate fucntion
    # to build NAMD.
    case ${ncp_target_machine} in
        "Spock" )
            case ${ncp_target_build} in

                "namd-ofi-linux-x86_64__gnu__cpu" )
                    build_Spock_namd_ofi_linux_x86_64__gnu__cpu;;

                "namd-netlrts-linux-x86_64__gnu__cpu" )
                    build_namd_netlrts_linux_x86_64__gnu__cpu;;

                *)
                    warn_unsupported_target "${ncp_target_build}" "${ncp_target_machine}"
                    exit 1;;
            esac;;

        "Summit" )
            case ${ncp_target_build} in

                *)
                    warn_unsupported_target "${ncp_target_build}" "${ncp_target_machine}"
            esac;;

         * ) 
                warn_unsupported_machine "${ncp_target_machine}" "${ncp_target_machine}"
    esac

}


#-----------------------------------------------------
# Below are the primary function calls to execute    -
# the script. In this script we call the function    -
# main.                                              -
#-----------------------------------------------------
main $@

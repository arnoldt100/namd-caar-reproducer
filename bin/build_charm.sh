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
    echo "${SCRIPT_NAME}: ${1:-"Unknown Error"}" 1>&2
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
function error_no_exit {
    echo "${SCRIPT_NAME}: ${1:-"Unknown Error"}" 1>&2
    return
}

#-----------------------------------------------------
# Function:                                          -
#    usage                                           -
#                                                    -
# Synopsis:                                          -
#   Prints the usage message.                        -
#                                                    -
# Positional parameters:                             -
#   None                                             -
#                                                    -
#-----------------------------------------------------
function usage {
    local -r column_width=50
    let separator_line_with=2*column_width+1
    local -r help_frmt1="%-${column_width}s %-${column_width}s\n"
    printf "\n"
    printf "Usage:\n"
    printf "\tbuild_charm++.sh [ -h | --help ] --target-machine <name of machine> --target-build <name of build>\n\n"
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
    printf "${help_frmt1}" "Spock available target builds:" "mpi-linux-x86_64:smp:gnu"
    printf "${help_frmt1}" "" "ofi-linux-x86_64:smp:gnu"
    printf "${help_frmt1}" "" "ofi-linux-x86_64:slurmpmi2:smp:gnu"
    printf "${help_frmt1}" "" "netlrts-linux-x86_64:smp:gnu"
    printf "${help_frmt1}" "" "multicore-linux-x86_64:gnu"
    printf "\n"
    printf "${help_frmt1}" "Available target machine: " "Summit"
    printf "${help_frmt1}" "Summit available target builds:" "multicore-linux-ppc64le:gnu"
    printf "\n"
}

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
    # This variable stores the charm++ target machine.
    # The target machine is the name of machine to build
    # charm++ on.
    #
    #-----------------------------------------------------
    declare -g ncp_target_machine="NOT_DEFINED"

    #-----------------------------------------------------
    # This variable stores the charm++ build target 
    # configuration.
    # 
    #-----------------------------------------------------
    declare -g ncp_target_build="NOT_DEFINED"

    #-----------------------------------------------------
    # Stores the the program options.
    # 
    #-----------------------------------------------------
    declare -g OPTS=""

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
    
    charmarch_error_message="The environmental variable CHARMARCH is not set."
    ${CHARMARCH:?"${charmarch_error_message}"}

    return
}

#-----------------------------------------------------
# Function:                                          -
#    Spock_build_ofi_linux_x86_64_gcc_smp_gfortran   -
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
function Spock_build_ofi_linux_x86_64_gcc_smp_gfortran() {
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
    # The pmi2 include and library options need          -
    # to be explicitly passed to the charm++ build       -
    # command options.                                   -
    #-----------------------------------------------------
    local pmi_include_dir="$(pkg-config --cflags-only-I cray-pmi)"
    # The below bash string manipulation removes the "-I" at the beginning of the string
    # for we only need the directory path.
    pmi_include_dir=${pmi_include_dir##-I} 

    local pmi_library_dir="$(pkg-config --libs-only-L cray-pmi)"
    # The below bash string manipulation removes the "-L" at the beginning of the string
    # for we only need the directory path.
    pmi_library_dir=${pmi_library_dir##-L} 

    #-----------------------------------------------------
    # The libfabric include and library options need 
    # to be explicitly passed to the charm++ build 
    # command options.
    #-----------------------------------------------------
    local libfabric_include_dir="$(pkg-config --cflags-only-I libfabric)"
    # The below bash string manipulation removes the "-I" at the beginning of the string
    # for we only need the directory path.
    libfabric_include_dir=${libfabric_include_dir##-I} 

    local libfabric_library_dir="$(pkg-config --libs-only-L libfabric)"
    # The below bash string manipulation removes the "-L" at the beginning of the string
    # for we only need the directory path.
    libfabric_library_dir=${libfabric_library_dir##-L} 

    #-----------------------------------------------------
    # Define  the options to the charm++ build command.
    #-----------------------------------------------------
    include_dir="--incdir ${pmi_include_dir} --incdir ${libfabric_include_dir}"
    library_dir="--libdir ${pmi_library_dir} --libdir ${libfabric_library_dir}"
    local -r options="gcc smp -j4 ${include_dir} ${library_dir}"

    #-----------------------------------------------------
    # Change to the charm++ source directory, and then
    # run the charm++ build command. 
    #-----------------------------------------------------
    change_dir "${CHARM_SOURCE_DIRECTORY}"

    #-----------------------------------------------------
    # Remove any prior builds of charm++                 -
    #                                                    -
    #-----------------------------------------------------
    if [ -d "${CHARMARCH}" ];then
        rm -rf "${CHARMARCH}"
    fi 

    echo "The charm++ build command: ./build ${target} ${charmarch} ${options}"

    ./buildold ${target} ${charmarch} ${options}
    if [ $? -ne 0 ];then
       local -r build_message="Error! The script ${SCRIPT_NAME} failed to build charm++."
       local -ir my_build_exit_status=${EXIT_STATUS["failed_build_command"]}
       echo "${build_message}"
       exit ${my_buildexit_status}
    fi

    change_dir "${SCRIPT_LAUNCH_DIR}"
    return
}

#-----------------------------------------------------
# Function:                                          -
#    Spock_build_ofi_linux_x86_64_slurmpmi2_gcc_smp_gfortran  -
#                                                    -
# Synopsis:                                          -
#   Builds charmm++ with the OFI transport layer.    -
#   This build is for the GNU programming            -
#   environment.                                     -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function Spock_build_ofi_linux_x86_64_slurmpmi2_gcc_smp_gfortran() {
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
    # The pmi2 include and library options need          -
    # to be explicitly passed to the charm++ build       -
    # command options.                                   -
    #-----------------------------------------------------
    local pmi_include_dir="$(pkg-config --cflags-only-I cray-pmi)"
    # The below bash string manipulation removes the "-I" at the beginning of the string
    # for we only need the directory path.
    pmi_include_dir=${pmi_include_dir##-I} 

    local pmi_library_dir="$(pkg-config --libs-only-L cray-pmi)"
    # The below bash string manipulation removes the "-L" at the beginning of the string
    # for we only need the directory path.
    pmi_library_dir=${pmi_library_dir##-L} 

    #-----------------------------------------------------
    # The libfabric include and library options need 
    # to be explicitly passed to the charm++ build 
    # command options.
    #-----------------------------------------------------
    local libfabric_include_dir="$(pkg-config --cflags-only-I libfabric)"
    # The below bash string manipulation removes the "-I" at the beginning of the string
    # for we only need the directory path.
    libfabric_include_dir=${libfabric_include_dir##-I} 

    local libfabric_library_dir="$(pkg-config --libs-only-L libfabric)"
    # The below bash string manipulation removes the "-L" at the beginning of the string
    # for we only need the directory path.
    libfabric_library_dir=${libfabric_library_dir##-L} 


    #-----------------------------------------------------
    # Define  the options to the charm++ build command.
    #-----------------------------------------------------
    include_dir="--incdir ${pmi_include_dir} --incdir ${libfabric_include_dir}"
    library_dir="--libdir ${pmi_library_dir} --libdir ${libfabric_library_dir}"
    local -r options="slurmpmi2 gcc smp -j4 ${include_dir} ${library_dir}"

    #-----------------------------------------------------
    # Change to the charm++ source directory, and then
    # run the charm++ build command. 
    #-----------------------------------------------------
    change_dir "${CHARM_SOURCE_DIRECTORY}"

    #-----------------------------------------------------
    # Remove any prior builds of charm++                 -
    #                                                    -
    #-----------------------------------------------------
    if [ -d "${CHARMARCH}" ];then
        rm -rf "${CHARMARCH}"
    fi 

    echo "The charm++ build command: ./build ${target} ${charmarch} ${options}"

    ./buildold ${target} ${charmarch} ${options}
    if [ $? -ne 0 ];then
       local -r build_message="Error! The script ${SCRIPT_NAME} failed to build charm++."
       local -ir my_build_exit_status=${EXIT_STATUS["failed_build_command"]}
       echo "${build_message}"
       exit ${my_buildexit_status}
    fi

    change_dir "${SCRIPT_LAUNCH_DIR}"
    return
}


#-----------------------------------------------------
# Function:                                          -
#    Spock_build_netlrts_linux_x86_64_gcc_smp_gfortran -
#                                                    -
# Synopsis:                                          -
#   Builds charmm++ with the netlrts transport       -
#   layer.Debug symbols are included.                -
#   This build is for the GNU programming            -
#   environment.                                     -
#                                                    -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function Spock_build_netlrts_linux_x86_64_gcc_smp_gfortran () {
    echo "Executing function Spock_build_netlrts_linux_x86_64_gcc_smp_gfortran"
    #-----------------------------------------------------
    # The target of the build.
    # 
    #-----------------------------------------------------
    local -r target='charm++'

    #-----------------------------------------------------
    # Define the charm++ arch. This variable selects 
    # the network transport layer to build. 
    #-----------------------------------------------------
    local -r charmarch='netlrts-linux-x86_64'

    #-----------------------------------------------------
    # Define  the options to the charm++ build command.
    #-----------------------------------------------------
    local -r options=" gcc smp -g -j4"

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

    change_dir "${SCRIPT_LAUNCH_DIR}"
    return
}



#-----------------------------------------------------
# Function:                                          -
#    Spock_build_multicore_linux_x86_64_gnu          -
#                                                    -
# Synopsis:                                          -
#   Builds charmm++ for single-node usage.           -
#   This build is for the GNU programming            -
#   environment.                                     -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function Spock_build_multicore_linux_x86_64_gnu () {
    echo "Executing function Spock_build_multicore_linux_x86_64_gnu"

    #-----------------------------------------------------
    # The target of the build.
    # 
    #-----------------------------------------------------
    local -r target='charm++'

    #-----------------------------------------------------
    # Define the charm++ arch. This variable selects 
    # the network transport layer to build. 
    #-----------------------------------------------------
    local -r charmarch='multicore-linux-x86_64'

    #-----------------------------------------------------
    # Define  the options to the charm++ build command.
    #-----------------------------------------------------
    local -r options="gcc -j4 --with-production"

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

    change_dir "${SCRIPT_LAUNCH_DIR}"
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
    OPTS=$(getopt --options ${short_options} --long ${long_options} --name "${SCRIPT_NAME}" -- "$@")
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
# Below are the primary function calls to execute    -
# the script.                                        -
#                                                    -
#-----------------------------------------------------

#-----------------------------------------------------
#                                                    -
# Start of main function of bash script.             -
#                                                    -
#-----------------------------------------------------
function main () {

    # Declare global variables that are used in this script.
    declare_global_variables

    # Check some prerequisites are satisfied.
    check_script_prerequisites

    # Validate the command line options and arguments.
    validate_command_line $@

    # Parses the command line options.
    parse_command_line ${OPTS}
    if [ $? != 0 ]; then
         error_exit 'The function parse_command_line failed ... exiting'
    fi
    
    case ${ncp_target_machine} in
        "Spock" )
            case ${ncp_target_build} in

                "ofi-linux-x86_64:smp:gnu" )
                    Spock_build_ofi_linux_x86_64_gcc_smp_gfortran;;

                "ofi-linux-x86_64:slurmpmi2:smp:gnu" )
                    Spock_build_ofi_linux_x86_64_slurmpmi2_gcc_smp_gfortran;;

                "netlrts-linux-x86_64:smp:gnu" )
                    Spock_build_netlrts_linux_x86_64_gcc_smp_gfortran;;

                "multicore-linux-x86_64:gnu" )
                    Spock_build_multicore_linux_x86_64_gnu;;

                *)
                    warn_unsupported_target "${ncp_target_build}" "${NCP_MACHINE_NAME}"
                    exit 1;;

            esac;;

        "Summit" )
            case ${ncp_target_build} in

                "multicore-linux-ppc64le:gnu" )
                    echo "Stud build for multicore-linux-ppc64le:gnu";;

                *)
                    warn_unsupported_target "${ncp_target_build}" "${NCP_MACHINE_NAME}"
                    exit 1;;

            esac;;

         * ) 
                echo "The machine '${NCP_MACHINE_NAME}' is not supported."
                usage
                exit 1;;
    esac

}

#-----------------------------------------------------
#                                                    -
# End of main function of bash script.               -
#                                                    -
#-----------------------------------------------------

main $@

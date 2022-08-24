#! /usr/bin/env bash

#cd ${NCP_TOP_LEVEL}/documentation
#make clean && make html
#if [[ $? != 0 ]]; then
#    echo "Failed to create documentation."
#    exit 1
#else
#    echo "Created documentation."
#fi

PROGNAME=$(basename ${0})

#-----------------------------------------------------
#                                                    -
# Program notes.                                     -
#                                                    -
# This program builds the documentation for          -
# namd-caar-reproducer.                              -
#                                                    -
#-----------------------------------------------------

#-----------------------------------------------------
# Function:                                          -
#    declare_global_variables                        -
#                                                    -
# Synopsis:                                          -
#   Prints the usage of this bash function.          -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function declare_global_variables {
    declare -g publish_dir
    declare -g doc_top_level
    
}

#-----------------------------------------------------
# Function:                                          -
#    error_exit                                      -
#                                                    -
# Synopsis:                                          -
#   An error handling function.                      -
#                                                    -
# Positional parameters:                             -
#   ${1} A string containing descriptive error       -
#        message                                     -
#                                                    -
#-----------------------------------------------------
function error_exit {
    echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    exit 1
}

#-----------------------------------------------------
# function usage() :                                 -
#                                                    -
# Synopsis:                                          -
#   Prints the usage of this bash script.            -
#                                                    -
#-----------------------------------------------------
function usage () {
    help_frmt1='%-72s %-72s\n'
    printf "Usage:\n"
    printf "\tbuild_documentation.sh [ -h | --help ] --publish-dir <PUBLISHDIR> --doc-top-level <DOCTOPLEVEL>\n\n"
    printf "${help_frmt1}" "option" "description"
    for ip in {1..145};do
        printf "%s" "-"
    done
    printf "\n"
    printf "${help_frmt1}" "-h | --help" "Prints the help message"
    printf "\n"
    printf "${help_frmt1}" "--publish-dir <PUBLISHDIR>"  "The directory PUBLISHDIR is where the sphinx-doc documentation will be installed."
    printf "\n"
    printf "${help_frmt1}" "--doc-top-level <DOCTOPLEVEL>"  "The directory DOCTOPLEVEL is where the top-level directory of the package"
    printf "${help_frmt1}" "" "docuementaion. This directory contains the file Makefile and the"
    printf "${help_frmt1}" "" "source sphinx directory."
    printf "\n"
}


#-----------------------------------------------------
# Process the arguments to this bash script.         -
#                                                    -
#-----------------------------------------------------
function parse_command_line {
    eval set -- $@
    while true;do
        case ${1} in
            -h | --help ) 
                usage
                shift
                exit 0;;

            --publish-dir )
                  publish_dir=${2}
                  shift 2;;

            --doc-top-level)
                doc_top_level=${2}
                shift 2;;

            -- ) 
                shift
                break;;

            * ) 
                echo "Internal parsing error!"
                usage
                exit 1;;
        esac
    done
}


# ----------------------------------------------------
# Function:
#    publish_documentation
#
# Synopsis:
#   Runs the sphinx-build commands to publish the 
#   package's documentation.
#
# Positional parameters:
#   ${1} The location of the documentation top level. 
#   ${2} The location to publish the documentation.
# ----------------------------------------------------
function publish_documentation {
    echo "Executing function publish_documentation"
 
    local -r my_doc_top_level=${1}
    local -r my_publish_dir=${2}  
    local -r my_start_dir=$(pwd)
    cd ${doc_top_level}
    PUBLISHDIR=${my_publish_dir} make clean && PUBLISHDIR=${my_publish_dir} make html 
    cd ${my_start_dir}


}

# ----------------------------------------------------
# 
# Start of main body of bash script.
# 
# ----------------------------------------------------
function main () {

    # We declare all global in this
    # function call. 
    declare_global_variables

    # We now parse the program command line options.
    long_options='help,publish-dir:,doc-top-level:'
    short_options=h
    OPTS=$(getopt --options ${short_options} --long ${long_options} --name "${PROGNAME}" -- "$@")
    parse_command_line ${OPTS}
    if [ $? != 0 ]; then
         error_exit "The function parse_command_line failed ... exiting"
    fi

    # We now publish the documentation.
    publish_documentation "${doc_top_level}" "${publish_dir}"
}
# ----------------------------------------------------
#
# End of main body of bash script.
#
# ----------------------------------------------------

main $@

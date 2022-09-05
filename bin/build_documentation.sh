#! /usr/bin/env bash
PROGNAME=$(basename ${0})

# ----------------------------------------------------
#
# Program notes.
#
# This program builds the documentation for namd-caar-reproducer.
#
# ----------------------------------------------------

# ----------------------------------------------------
# Function:
#    declare_global_variables
#
# Synopsis:
#   Declares global variables used in this script. Typically we declare the
#   global variables to store the command line argument values.
#
# Positional parameters:
#
# ----------------------------------------------------
function declare_global_variables {
    declare -g publish_mode
    declare -g doc_top_level
}

# ----------------------------------------------------
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
# ----------------------------------------------------
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
    frmtmodes='%-72s \t%-72s\n'
    printf "Usage:\n"
    printf "\tbuild_documentation.sh [ -h | --help ] --publish-mode <PUBLISHMODE> --doc-top-level <DOCTOPLEVEL>\n\n"
    printf "${help_frmt1}" "option" "description"
    for ip in {1..145};do
        printf "%s" "-"
    done
    printf "\n"
    printf "${help_frmt1}" "-h | --help" "Prints the help message"
    printf "\n"
    printf "${help_frmt1}" "--publish-mode <PUBLISHMODE>"  "The mode of publishing the documentation."
    printf "${help_frmt1}" ""  "The following modes are available:"
    printf "${frmtmodes}" ""  "standard : Publishes documentation to \${NCP_TOP_LEVEL}/documentation/build/html."
    printf "${frmtmodes}" ""  "gitlab-pages : Publishes documentation for gitlab-page in \${NCP_TOP_LEVEL}/public/html"
    printf "${frmtmodes}" ""  "github-pages : Publishes documentation for gitlab-page in \${NCP_TOP_LEVEL}/docs/"
    printf "\n"
    printf "${help_frmt1}" "--doc-top-level <DOCTOPLEVEL>"  "The directory DOCTOPLEVEL is where the top-level directory of the package"
    printf "${help_frmt1}" "" "documentation. This directory contains the files Makefile, make.bat and the"
    printf "${help_frmt1}" "" "sphinx directory 'source'. The standard location of <DOCTOPLEVEL> is "
    printf "${help_frmt1}" "" "\${NCP_TOP_LEVEL}/documentation/"
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

            --publish-mode )
                  publish_mode=${2}
                  shift 2;;

            --doc-top-level)
                doc_top_level=${2}
                doc_top_level=$(realpath ${doc_top_level})
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



#-----------------------------------------------------
# Function:                                          -
#   relocate_sphinx_html_docs                        -
#                                                    -
# Synopsis:                                          -
#   Relocates the sphinx html documentation to a     -
#   a new directory. If the new directory exists,    -
#   then it is removed, recreated, and then the      -
#   documentation is moved to the new directory.     -
#                                                    -
#                                                    -
# Positional parameters:                             -
#   $1 The source directory of the sphinx docs       -
#   $2 The destination directory of the sphinx docs  -
#                                                    -
#-----------------------------------------------------
function relocate_sphinx_html_docs {
    echo "Executing function relocate_sphinx_html_docs"
    local -r src_dir=$1
    local -r dest_dir=$2
    
    if [ -d "${dest_dir}" ]; then
        rm -rf  "${dest_dir}"
    fi
    mkdir --parents "${dest_dir}"
    mv --force "${src_dir}" "${dest_dir}"
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
#   ${2} The publish mode
# ----------------------------------------------------
function publish_documentation {
    echo "Executing function publish_documentation"
 
    local -r my_start_dir=$(pwd)
    local -r my_publish_mode=${2}  
    local -r my_doc_top_level=${1}
    local -r my_source_dir="${my_doc_top_level}/source"
    local -r my_publish_dir="${NCP_TOP_LEVEL}/documentation/build"

    cd "${doc_top_level}"

    SOURCEDIR="${my_source_dir}" PUBLISHDIR="${my_publish_dir}" make clean && SOURCEDIR="${my_source_dir}" PUBLISHDIR="${my_publish_dir}" make html 

    case ${my_publish_mode} in

        standard )
            echo "Publishing in standard mode"
            ;;

        gitlab-pages)
            echo "Publishing in gitlab-pages mode"
            local -r my_gitlab_publish_dir="${NCP_TOP_LEVEL}/public"
            relocate_sphinx_html_docs "${NCP_TOP_LEVEL}/documentation/build/html" "${my_gitlab_publish_dir}" 
            ;;

        github-pages)
            echo "Publishing in github-pages mode"
            local -r my_github_publish_dir="${NCP_TOP_LEVEL}/docs"
            relocate_sphinx_html_docs "${NCP_TOP_LEVEL}/documentation/build/html" "${my_github_publish_dir}" 
            ;;

        * ) 
            echo "Internal parsing error for publishing mode. The publishing mode, ${my_publish_mode}, is not implemented."
            usage
            exit 1;;
    esac

    cd "${my_start_dir}"


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
    long_options='help,publish-mode:,doc-top-level:'
    short_options=h
    OPTS=$(getopt --options ${short_options} --long ${long_options} --name "${PROGNAME}" -- "$@")
    parse_command_line ${OPTS}
    if [ $? != 0 ]; then
         error_exit "The function parse_command_line failed ... exiting"
    fi

    # We now publish the documentation.
    publish_documentation "${doc_top_level}" "${publish_mode}"
}
# ----------------------------------------------------
#
# End of main body of bash script.
#
# ----------------------------------------------------

main $@

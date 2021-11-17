#! /usr/bin/env bash

#-----------------------------------------------------
#                                                    -
# Program notes.                                     -
#                                                    -
#                                                    -
#                                                    -
#-----------------------------------------------------

# Define some global variables.
declare -gr PROGNAME=$(basename ${0})

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
    echo
    echo -e "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    echo
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
    local -r column_width=50
    let separator_line_with=2*column_width+1
    local -r help_frmt1="%-${column_width}s %-${column_width}s\n"
    printf "%s\n" "Usage:"
    printf "\t%s\n\n" "apoa1_benchmark.sh [ -h | --help ] --tag=<benchmark tag>"
    printf "${help_frmt1}" "option" "description"
    for ((ip=0; ip < ${separator_line_with}; ip++));do
        printf "%s" "-"
    done
    printf "\n"
    printf "${help_frmt1}" "-h | --help" "Prints the help message."
    printf "${help_frmt1}" "--tag" "A tag for uniquely identfying a benchmark run."
    printf "${help_frmt1}" "" "The tag should only consist of alphanumeric characters."
}

#-----------------------------------------------------
# Function:                                          -
#    declare_custom_variables                        -
#                                                    -
# Synopsis:                                          -
#   Prints the usage of this bash function.          -
#                                                    -
# Positional parameters:                             -
#                                                    -
#-----------------------------------------------------
function declare_global_variables {
    declare -gr NOT_DEFINED="NOT_DEFINED"
    declare -g TAG="NOT_DEFINED"
    declare -g OPTS=""

    # ----------------------------------------------------
    # Check that key environmental variables are set.
    # 
    # ----------------------------------------------------
    if [[ ! -v NCP_ACCOUNT_ID ]];then
        message="A FATAL ERROR HAS OCCURRED!\n"
        message+="\tThe environmental variable NCP_ACCOUNT_ID is not set.\n"
        message+="\tPlease read the README.md for this benchmark to correct."
        error_exit "${message}"
    fi

    if [[ ! -v APOA1_INPUT_FILES_PARENT_DIR ]];then
        message="A FATAL ERROR HAS OCCURRED!\n"
        message+="\tThe environmental variable APOA1_INPUT_FILES_PARENT_DIR is not set.\n"
        message+="\tPlease read the README.md for this benchmark to correct."
        error_exit "${message}"
    fi

    if [[ ! -v NCP_APOA1_NAMD3_BINARY ]];then
        message="A FATAL ERROR HAS OCCURRED!\n"
        message+="\tThe environmental variable NCP_APOA1_NAMD3_BINARY is not set.\n"
        message+="\tPlease read the README.md for this benchmark to correct."
        error_exit "${message}"
    fi

    if [[ ! -v NAMD3_BINARY_NAME ]];then
        message="A FATAL ERROR HAS OCCURRED!\n"
        message+="\tThe environmental variable NAMD3_BINARY_NAME is not set.\n"
        message+="\tPlease read the README.md for this benchmark to correct."
        error_exit "${message}"
    fi

    if [[ ! -v NCP_APOA1_RESULTS_DIR ]];then
        message="A FATAL ERROR HAS OCCURRED!\n"
        message+="\tThe environmental variable NCP_APOA1_RESULTS_DIR is not set.\n"
        message+="\tPlease read the README.md for this benchmark to correct."
        error_exit "${message}"
    fi

    if [[ ! -v NCP_APOA1_SCRATCH_DIR ]];then
        message="A FATAL ERROR HAS OCCURRED!\n"
        message+="\tThe environmental variable NCP_APOA1_SCRATCH_DIR is not set.\n"
        message+="\tPlease read the README.md for this benchmark to correct."
        error_exit "${message}"
    fi

    # ----------------------------------------------------
    # Set the critical variables/parameters needed to run
    # the benchmarks.
    # 
    # ----------------------------------------------------
    declare -g SCRATCH_DIR="${NCP_APOA1_SCRATCH_DIR}"
    declare -g RESULTS_DIR="${NCP_APOA1_RESULTS_DIR}"
    declare -gr NAMD_BINARY="${NCP_APOA1_NAMD3_BINARY}"
    declare -gr ACCOUNTID="${NCP_ACCOUNT_ID}"
    declare -gr SCRIPT_LAUNCH_DIR=$(pwd)
}

#-----------------------------------------------------
# Function:                                          -
#    parse_slurm_file                                -
#                                                    -
# Synopsis:                                          -
#   Parse the command slurm file.                    -
#   The slurm file is text processed with sed        -
#   and written to directory ${destdir}.             -
#                                                    -
# Positional parameters:                             -
#   ${1} The file to be parsed.                      -
#   ${2} The file to write the parsed file to.       -
#   ${3} The scratch directory where the simulations -
#        are run.                                    -
#   ${4} The directory where thr results are copied  -
#        to.                                         -
#                                                    -
#-----------------------------------------------------
function parse_slurm_file () {
    local -r my_infile=${1}
    local -r my_outfile=${2}
    local -r my_scratch=${3}
    local -r my_results_directory=${4}
    local -r my_apoa1_btag=${5}

    local -r pattern1='s/__ACCOUNTID__/'"${ACCOUNTID}"'/g'
    # The directory path may contain a '/' character so we use ':' as
    # the sed delimiter.
    local -r pattern2='s:__SCRATCHSPACE__:'"${my_scratch}/"':g'
    # The path to the NAMD binary may contain a '/' character so we use ':' as
    # the sed delimiter.
    local -r pattern32='s:__NAMD3BINARY__:'"${NCP_APOA1_NAMD3_BINARY}"':g'
    local -r pattern33='s:__NAMD3BINARYNAME__:'"${NAMD3_BINARY_NAME}"':g'
    # The directory path may contain a '/' character so we use ':' as
    # the sed delimiter.
    local -r pattern4='s:__NAMDRESULTSDIR__:'"${my_results_directory}"':g'
    # The pattern must contain only alphanumeric characters.
    local -r pattern5='s:__TAG__:'"${my_apoa1_btag}"':g'
    # The path to the parent directory of the input files.
    local -r pattern6='s:__APOA1_INPUT_FILES_PARENT_DIR__:'"${APOA1_INPUT_FILES_PARENT_DIR}"':g'
    # The name of the stdout and stderr files to write the output from the
    # NAMD binary.
    local -r pattern7='s:__STDOUT__:'"${NCP_STDOUT}"':g'
    local -r pattern8='s:__STDERR__:'"${NCP_STDERR}"':g'

    sed -e "${pattern1}" \
        -e "${pattern2}" \
        -e "${pattern32}" \
        -e "${pattern33}" \
        -e "${pattern4}" \
        -e "${pattern5}" \
        -e "${pattern6}" \
        -e "${pattern7}" \
        -e "${pattern8}" \
        < ${my_infile} > ${my_outfile}
}

#-------------------------------------------------------
# Function:                                            -
#    validate_command_line                             -
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
    # Validate and parse the command line options.
    local -r long_options_no_args="help,"
    local -r long_options_args="tag:,"
    local -r short_options_noargs="h,"
    local -r short_options_args=""
    local -r long_options="${long_options_args}${long_options_no_args}"
    local -r short_options="${short_options_args}${short_options_noargs}"

    OPTS=$(getopt --options ${short_options} --long ${long_options} --name "${PROGNAME}" -- "$@")

    if [ $? != 0 ]; then
         error_exit "The function get_opt failed ... exiting"
    fi
}


#-----------------------------------------------------
# Function:                                          -
#   parse_config_file                                -
#                                                    -
# Synopsis:                                          -
#   Parses the NAMD config input file for            -
#   NVE ensemble simulations.                        -
#                                                    -
# Positional parameters:                             -
#   ${1} The file to be parsed.                      -
#   ${2} The file to write the parsed file to.       -
#                                                    -
#-----------------------------------------------------
function parse_config_file {
    local -r my_infile=${1}
    local -r my_outfile=${2}
    local -r  outputTimings='250'
    local -r  outputEnergies='500'
    local -r  numsteps='28000'

    local -r pattern1='s/__outputTimings__/'"${outputTimings}"'/g'
    local -r pattern2='s/__outputEnergies__/'"${outputEnergies}"'/g'
    local -r pattern3='s/__numsteps__/'"${numsteps}"'/g'
    sed -e "${pattern1}" \
        -e "${pattern2}" \
        -e "${pattern3}" \
        < ${my_infile} > ${my_outfile}
}


#-----------------------------------------------------
# Function:                                          -
#   parse_command_line                               -
#                                                    -
# Synopsis:                                          -
#   Process the arguments to this bash script.       -
#                                                    -
#-----------------------------------------------------
function parse_command_line {
    eval set -- $@
    while true;do
        case ${1} in
            -h | --help) 
                usage
                shift
                exit 0;;

            --tag)
                TAG=${2}
                shift 2;;

            -- ) 
                break;;

            * ) 
                echo "Internal parsing error!"
                usage
                exit 1;;
        esac
    done

    # The --tag option is mandatory and its argument must be defined.
    if [[ ${TAG} == "NOT_DEFINED" ]]; then
        local error_message="The --tag option is mandatory.\nPlease read the help message: ${PROGNAME} --help"
        error_exit "${error_message}"
    fi

    # The ${TAG} variable can only contain alphanumeric characters. We use the
    # tag to create as part of a directory path in a sed command. Having only
    # alphanumeric characters simplifies these tasks.
    if [[  !  "${TAG}" =~ ^[[:alnum:]]+$  ]];then
        error_message="The --tag option value can only contain  letters, digits, hyphens and underscores."
        error_exit "${error_message}"
    fi

    return
}

#-----------------------------------------------------
# Function:                                          -
#    perform_benchmark                               -
#                                                    -
# Synopsis:                                          -
#   Performs the benchmark.                          -
#                                                    -
# Positional parameters:                             -
#   ${1} : The directory in which to run the         -
#          benchmark. The directory must not         -
#          exist.                                    -
#                                                    -
#   ${2} : The directory to which the results        -
#          of the benchmark are copied to. The       -
#          directory must not exist.                 -
#                                                    -
#   ${3} : The path to the namd binary.              -
#                                                    -
#   ${4} : The path to the template benchmark batch  -
#          file.                                     -
#                                                    -
#   ${5} : The specific tag that identifies the      -
#          the benchamrk template file.              -
#                                                    -
#-----------------------------------------------------
function perform_benchmark {

    local -r my_namd_binary=${3}
    local -r my_batch_template_file=${4}
    local -r my_apoa1_benchmarks_tag=${5}
    local -r my_scratch_directory=${1}/${TAG}/${my_apoa1_benchmarks_tag}
    local -r my_results_directory=${2}/${TAG}/${my_apoa1_benchmarks_tag}
    local -r config_infile=${6}

    # If the benchmark scratch directory exists then exit program with failure.
    if [ -d ${my_scratch_directory} ];then
        local -r error_message="Warning! The benchmark scratch directory '${my_scratch_directory}' exists.\n"
        error_exit "${error_message}"
    fi

    # If the results directory exists then exit program with failure.
    if [ -d ${my_results_directory} ];then
        local -r error_message="Warning! The results directory '${my_results_directory}' exists.\n"
        error_exit "${error_message}"
    fi

    # Create the benchmark scratch and results directory.
    mkdir -p ${my_scratch_directory}
    mkdir -p ${my_results_directory}

    # Parse the namd config file and copy to the benchmark scratch directory.
    local -r config_outfile="${my_scratch_directory}/apoa1.namd"
    parse_config_file "${config_infile}" "${config_outfile}"

    # Parse the slurm template file and copy to
    # the benchmark scratch directory.
    local -r infile="${my_batch_template_file}"
    local -r outfile="apoa1-${TAG}-${my_apoa1_benchmarks_tag}.slurm.sh"
    parse_slurm_file "${infile}" "${outfile}" "${my_scratch_directory}" "${my_results_directory}" "${my_apoa1_benchmarks_tag}"
    cp -f ${outfile} ${my_scratch_directory}/

    # Launch the batch script from the benchmark scratch directory.
    cd ${my_scratch_directory}
    sbatch ./${outfile}
    cd ${SCRIPT_LAUNCH_DIR}
    return
}

#-----------------------------------------------------
#                                                    -
# Start of main body of bash script.                 -
#                                                    -
#-----------------------------------------------------
function main () {
    # Declare global variables.
    declare_global_variables

    # Validate the command line options and arguments.
    validate_command_line $@

    parse_command_line ${OPTS}
    if [ $? != 0 ]; then
         error_exit "The function parse_command_line failed ... exiting"
    fi

    local -ra my_apoa1_benchmarks_tags=( '0' '1' '2' '3' '4' '5' '6' '7' '8' '9' )

    local -r batch_slurm_template_file="./etc/apoa1.slurm.template.sh"

    local -r config_template_infile="${APOA1_INPUT_FILES_PARENT_DIR}/apoa1.namd.nve.template"

    for apoa1_btag in "${my_apoa1_benchmarks_tags[@]}";do
        perform_benchmark ${SCRATCH_DIR} ${RESULTS_DIR} ${NAMD_BINARY} ${batch_slurm_template_file} ${apoa1_btag} ${config_template_infile}
    done
}

#-----------------------------------------------------
#                                                    -
# End of main body of bash script.                   -
#                                                    -
#-----------------------------------------------------

main $@

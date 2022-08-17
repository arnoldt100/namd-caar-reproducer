#! /usr/bin/env python3

"""Prints to stdout installation paths for the TCL sofware package.

This module is intended to be executed as script. Typical usage is 

    ncp_paths_tcl.py --machine-name *machinename* --software-name *softwarename* --software-version *softwareversion* --ncp-prefix *ncpprefix* --ncp-pe-key *ncppekey* --path *pathkey*

where

* *machinename* is the name of the machine on which to install the software.
* *softwarename* is the software name
* *softwareversion* is the sotware version
* *ncpprefix* is the top-level directory where all NAMD software dependencies are installed under
* *ncppekey* is the corresponding key for the runtime programming environment
* *pathkey* is the key corresponding to the path to printed to stdout.

For a list of the available path keys run the help option

    ncp_paths_tcl.py --help
"""

# System imports
import string
import argparse # Needed for parsing command line arguments.

# Local imports
from loggerutils.logger import create_logger_description
from loggerutils.logger import create_logger
import pathoption

def __create_path_description():
    frmt_header = "{0:20s} {1:50.50s}\n"
    frmt_items = frmt_header
    header1 =  frmt_header.format("Option Values", "Path Returned" )  
    header1_len = len(header1)
    log_option_desc = "The permitted options values and returned paths are the following:\n\n"
    log_option_desc += header1
    log_option_desc += "-"*header1_len  + "\n"
    log_option_desc += frmt_items.format("prefix", "The top-level installation directory for TCL.\n")  
    return log_option_desc

def __parse_arguments():

    import logging

    # Create a string of the description of the 
    # program
    program_description = "Returns installation paths for TCL software."

    # Create an argument parser.
    my_parser = argparse.ArgumentParser(
            description=program_description,
            formatter_class=argparse.RawTextHelpFormatter,
            add_help=True)

    # Add an optional argument for the logging level.
    my_parser.add_argument("--log-level",
                           type=int,
                           default=logging.WARNING,
                           help=create_logger_description() )

    # Adding mandatory argument group.
    mandatory_args_group = my_parser.add_argument_group(title="Mandatory Arguments")

    mandatory_args_group.add_argument("--machine-name",
        help="The name of the machine on which the sotware will be installed.",
        required=True,
        type=str,
        metavar='<machine name>')

    mandatory_args_group.add_argument("--software-name",
        help="The name of the software package.",
        required=True,
        type=str,
        metavar='<software name>')
    
    mandatory_args_group.add_argument("--software-version",
        help="The version of the sofware package.",
        required=True,
        type=str,
        metavar='<software version>')

    mandatory_args_group.add_argument("--ncp-prefix",
                           help="The top-level directory where all NAMD dependent software is installed under.",
                           required=True,
                           type=str,
                           metavar='<ncp prefix>')

    mandatory_args_group.add_argument("--ncp-pe-key",
                           help="The key for setting the programming environment.",
                           required=True,
                           type=str,
                           metavar='<ncp pe key>')
                           
    mandatory_args_group.add_argument("--path",
                                      help=__create_path_description(),
                                      required=True,
                                      type=str,
                                      choices=[ _PATH_OPTIONS['prefix'][0] ],
                                      metavar="<path key>")
    my_args = my_parser.parse_args()

    return my_args 

def __print_path(path_option_value,
                 ncp_prefix,
                 machine_name,
                 software_name,
                 software_version,
                 ncp_pe_key):
    import sys
    fp = _PATH_OPTIONS[path_option_value]
    tmp_path = fp[1](ncp_prefix,machine_name,software_name,software_version,ncp_pe_key)
    sys.stdout.write(tmp_path)

def __prefix_path(ncp_prefix,machine_name,software_name,software_version,ncp_pe_key):
    import os
    tmp_path = os.path.join(ncp_prefix,machine_name,software_name,software_version,ncp_pe_key)
    return tmp_path
    
## @var dict _PATH_OPTIONS
## @brief Stores the option  and a function reference
##
## @details Each installation path is associated with key, and for a given "key" : 
## ""key" : The key associated for the desired installation path.
## _PATH_OPTIONS["key"][0] : A --path option value. 
## _PATH_OPTIONS["key"][1] : A reference to a function that will print the corresponding  path installation.
_PATH_OPTIONS = {"prefix" : [ "prefix", __prefix_path] }

## @fn main ()
## @brief The main function.
def main():
    args = __parse_arguments()
    logger = create_logger(log_id='Default',
                           log_level=args.log_level)

    logger.info("Start of main program")

    __print_path(args.path,
                 args.ncp_prefix,
                 args.machine_name,
                 args.software_name,
                 args.software_version,
                 args.ncp_pe_key)

    logger.info("End of main program")

if __name__ == "__main__":
    main()

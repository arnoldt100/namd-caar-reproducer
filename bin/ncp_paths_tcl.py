#! /usr/bin/env python3

"""Prints to stdout installation paths for the TCL sofware package.

This module is intended to be executed as script. Typical usage is 

    ncp_paths_tcl.py --software-name XXX --software-version YYY --NCP_PREFIX NCP_PE_KEY --path AAA

where

* XXX is the software name
* YYY is the sotware version
* NCP_PE_KEY is the programming environment key.
* AAA is the key corresponding to the path to printed to stdout.

For a list of the available paths run the help option

    ncp_paths_tcl.py --help
"""

# System imports
import string
import argparse # Needed for parsing command line arguments.

# Local imports

## @fn _create_path_description( )
## @brief Returns a string whose contents are the --path option description.
## 
## @return A string
def _create_path_description():
    frmt_header = "{0:20s} {1:40.40s}\n"
    frmt_items = frmt_header
    header1 =  frmt_header.format("Option Values", "Path Returned" )  
    header1_len = len(header1)
    log_option_desc = "The installation path to be returned. The options values are the following:\n\n"
    log_option_desc += header1
    log_option_desc += "-"*header1_len  + "\n"
    log_option_desc += frmt_items.format("prefix", "The top-level installation directory for TCL.\n")  
    return log_option_desc

## @fn parse_arguments( )
## @brief Parses the command line arguments.
##
## @details Parses the command line arguments and
## returns A namespace.
##
## @return A namespace. The namespace contains attributes
##         that are the command line arguments.
def parse_arguments():

    # Create a string of the description of the 
    # program
    program_description = "Generates installation paths for TCL software."

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

    mandatory_args_group.add_argument("--software-name",
        help="The name of the software package.",
        required=True,
        type=str,
        metavar='XXX')
    
    mandatory_args_group.add_argument("--software-version",
        help="The version of the sofware package.",
        required=True,
        type=str,
        metavar='YYY')

    mandatory_args_group.add_argument("--NCP_PREFIX",
                           help="The top-level directory where all NAMD dependent software is installed under.",
                           required=True,
                           type=str,
                           metavar='NCP_PE_KEY')

    mandatory_args_group.add_argument("--NCP_PE_KEY",
                           help="The key for setting the programming environment.",
                           required=True,
                           type=str,
                           metavar='NCP_PE_KEY')
                           
    mandatory_args_group.add_argument("--path",
                                      help=_create_path_description(),
                                      required=True,
                                      type=str,
                                      choices=[ _PATH_OPTIONS['prefix'][0] ],
                                      metavar="AAA")
    my_args = my_parser.parse_args()

    return my_args 

## @fn _print_prefix_path ()
## @brief Prints the installation path to stdout.
##
## @param[in] path_option_value The option value for --path
## @param[in] ncp_pe_key The programming environmnet key
## @param[in] software_name The name of the software
## @param[in] software_version The software version
## @param[in] ncp_prefix The top-level installation directory under which the package will installed

def _print_path(path_option_value):
    import sys
    fp = _PATH_OPTIONS[path_option_value]
    tmp_path = fp[1]()
    sys.stdout.write(tmp_path)

def __prefix_path():
    return "Dummy prefix path"
    
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
    args = parse_arguments()
    logger = _create_logger(log_id='Default',
                           log_level=args.log_level)

    logger.info("Start of main program")

    _print_path(args.path)

    logger.info("End of main program")

if __name__ == "__main__":
    main()

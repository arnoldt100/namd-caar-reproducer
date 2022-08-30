#! /usr/bin/env python3

"""Prints to stdout installation paths for the charm++ sofware package.

This module is intended to be executed as script. Typical usage is 

    ncp_paths_charm.py --machine-name *machinename* --software-name *softwarename* --software-version *softwareversion* --charm-arch *charmarch* --ncp-prefix *ncpprefix* --ncp-pe-key *ncppekey* --path *pathkey*

where

* *machinename* is the name of the machine on which to install the software.
* *softwarename* is the software name
* *softwareversion* is the sotware version
* *charmarch* is the charm archictecture build.
* *ncpprefix* is the top-level directory where all NAMD software dependencies are installed under
* *ncppekey* is the corresponding key for the runtime programming environment
* *pathkey* is the key corresponding to the path to printed to stdout.

For a list of the available path keys run the help option

    ncp_paths_charm.py --help

Invoking this script will print, for a given *pathkey*, the fully qualified
installation path to stdout.
"""

# System imports
import string
import argparse # Needed for parsing command line arguments.
import os

# Local imports
from loggerutils.logger import create_logger_description
from loggerutils.logger import create_logger
import pathoption

def main():

    # Instantiate a Charm++ pathoption object.
    charm_pathoption = pathoption.create_pathoption()

    # Register all path functions with object charm_pathoption. Each
    # valid option value, <pathkey>, for the option --path <pathkey>
    # need the following:
    #   <pathkey>
    #   A function reference that when invoked will return the installation path for <pathkey>
    #   A description of <pathkey>
    
    pathkey = "prefix"
    function_reference = _path_prefix
    pathkey_description = "The top-level installation directory for Charm++."  
    pathoption.register_pathoption(charm_pathoption,pathkey,function_reference,pathkey_description)

    pathkey = "charmbasedir"
    function_reference = _path_prefix
    pathkey_description = "The CHARMBASEDIR for Charm++."  
    pathoption.register_pathoption(charm_pathoption,pathkey,function_reference,pathkey_description)

    pathkey = "bindir"
    function_reference = _path_bindir
    pathkey_description = "The Charm++ bin directory."  
    pathoption.register_pathoption(charm_pathoption,pathkey,function_reference,pathkey_description)

    pathkey = "libdir"
    function_reference = _path_libdir
    pathkey_description = "The Charm++ lib directory."  
    pathoption.register_pathoption(charm_pathoption,pathkey,function_reference,pathkey_description)

    pathkey = "incdir"
    function_reference = _path_incdir
    pathkey_description = "The Charm++ lib directory."  
    pathoption.register_pathoption(charm_pathoption,pathkey,function_reference,pathkey_description)

    # Parse the command line arugments of this script.
    args = _parse_arguments(charm_pathoption)

    # Instantiate a logging object.
    logger = create_logger(log_id='Default',
                           log_level=args.log_level)
    logger.info("Start of main program")

    # Print the installation path. The arguments to the function reference 
    # is collected in values. Note the aruguments in values must match the
    # parameters of the function reference.

    kvalues = { 'ncp_prefix' : args.ncp_prefix,
                'machine_name' : args.machine_name,
                'software_name' : args.software_name,
                'software_version' : args.software_version,
                'ncp_pe_key' : args.ncp_pe_key,
                'charmarch' : args.charmarch}

    pathoption.print_path(charm_pathoption,
                          args.path,
                          **kvalues)

    logger.info("End of main program")

def _parse_arguments(charm_pathoption):

    import logging

    # Create a string of the description of the 
    # program
    program_description = "Returns installation paths for Charm++ software."

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
                           
    mandatory_args_group.add_argument("--charmarch",
                           help="The Charm++ architecture.",
                           required=True,
                           type=str,
                           metavar='<ncp charm arch>')
                           
    mandatory_args_group.add_argument("--path",
                                      help=pathoption.create_path_description(charm_pathoption),
                                      required=True,
                                      type=str,
                                      choices=pathoption.get_pathoption_keys(charm_pathoption),
                                      metavar="<path key>")
    my_args = my_parser.parse_args()

    return my_args 


def _path_prefix(ncp_prefix,
                 machine_name,
                 software_name,
                 software_version,
                 ncp_pe_key,
                 charmarch):
    tmp_path = os.path.join(ncp_prefix,machine_name,software_name,software_version,ncp_pe_key)
    return tmp_path

class _get_charmbasedir:
    def __init__(self,func):
        self.func = func

    def __call__(self,*args,**kargs):
        path1 = self.func(*args,**kargs)
        path2 = _path_prefix(*args,**kargs)
        final_path = os.path.join(path2,path1)
        return final_path

@_get_charmbasedir
def _path_bindir(*args,**kwargs):
    return "bin"

@_get_charmbasedir
def _path_libdir(*args,**kargs):
    return "lib"

@_get_charmbasedir
def _path_incdir(*args,**kargs):
    return "include"

if __name__ == "__main__":
    main()

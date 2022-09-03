#! /usr/bin/env python3

"""Builds NAMD software package.

This module is intended to be executed as a scripy, Typical usage is

    build_namd.py --target-machine *machinename* --target-build *targetbuild*

where 

* *machinename* is the name of the machine on which to install the software.
* *targetbuild* is the NAMD build target.

For a list of available machines and build targets do

    build_namd.py --help
"""
# System imports
import string
import argparse # Needed for parsing command line arguments.

# Local imports
from loggerutils.logger import create_logger_description
from loggerutils.logger import create_logger
import namd_machine_registrations
import namd_machine_builds

def main():
    mr =  _register_machines_buildtargets()

    args = _parse_arguments()

    logger = create_logger(log_id='Default',
                           log_level=args.log_level)

    logger.info("Start of main program")

    logger.info("End of main program")

def _parse_arguments():

    import logging

    # Create a string of the description of the 
    # program
    program_description = "Your program description" 

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

    mandatory_args_group.add_argument("--target-build",
        help="The NAMD build target.",
        required=True,
        type=str,
        metavar='<target build>')

    my_args = my_parser.parse_args()

    return my_args 

def _register_machines_buildtargets():
    # Register Crusher
    reg_mach = namd_machine_registrations.NamdBuildRegister()

    namd_machine_registrations.register_new_machine(reg_mach,'Crusher')
    kargs_bt = {"machine_name" : 'Crusher','build_target' : 'Multicore'}
    builder1 = namd_machine_builds.get_builder(**kargs_bt)
    namd_machine_registrations.register_new_build(reg_mach,**kargs_bt,builder=builder1)
    namd_machine_registrations.build_software(reg_mach,**kargs_bt)


    return reg_mach

if __name__ == "__main__":
    main()

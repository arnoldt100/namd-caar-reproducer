"""Contains the builders for all machines

This module contains the callable builder classes for all mcnhines and the their targets.
All new machine builders should be added in this module. 


"""

# System imports
import string
import argparse # Needed for parsing command line arguments.
import logging  # Needed for logging events.

# Local imports
from loggerutils.logger import create_logger_description
from loggerutils.logger import create_logger
from namd_builders import GenericNAMDBuilder 

# Make a dictionary of all Crusher build_targets and the corresponding builder.
_crusher_builders = {"Multicore" : GenericNAMDBuilder }

# Make a dictionary of  builders for all machines.
_all_machine_builders = {"Crusher": _crusher_builders }

def get_builder(machine_name="",build_target=""):
    """Returns the a callable class that builds NAMD"""
    return GenericNAMDBuilder()

def main():
    args = _parse_arguments()

    logger = create_logger(log_id='Default',
                           log_level=args.log_level)

    logger.info("Start of main program")

    logger.info("End of main program")

def _parse_arguments():

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

    my_args = my_parser.parse_args()

    return my_args 

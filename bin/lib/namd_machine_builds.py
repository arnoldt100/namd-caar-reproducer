#! /usr/bin/env python3

"""Contaisn various functions for building NAMD"""

# System imports
import string
import argparse # Needed for parsing command line arguments.
import logging  # Needed for logging events.

# Local imports
from loggerutils.logger import create_logger_description
from loggerutils.logger import create_logger

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

if __name__ == "__main__":
    main()

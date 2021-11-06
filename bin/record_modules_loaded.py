#! /usr/bin/env python3
## @package record_modules_loaded
#  Records the loaded modules to an xml format.
#
# Records the loaded module to a file.

# System imports
import string
import argparse # Needed for parsing command line arguments.
import logging  # Needed for logging events.

# Local imports
import lmod_interface

## @fn _create_logger_description( )
## @brief Returns a string whose contents are the log level option help description.
## 
## @return A string
def _create_logger_description():
    frmt_header = "{0:10s} {1:40.40s} {2:5s}\n"
    frmt_items = frmt_header
    header1 =  frmt_header.format("Level", "Description", "Option Value" )  
    header1_len = len(header1)
    log_option_desc = "The logging level. The standard levels are the following:\n\n"
    log_option_desc += header1
    log_option_desc += "-"*header1_len  + "\n"
    log_option_desc += frmt_items.format("NOTSET", "All messages will be processed", "0" )  
    log_option_desc += frmt_items.format("", "processed", " \n" )  
    log_option_desc += frmt_items.format("DEBUG", "Detailed information, typically of ", "10" )  
    log_option_desc += frmt_items.format("", "interest only when diagnosing problems.", "\n" )  
    log_option_desc += frmt_items.format("INFO", "Confirmation that things", "20" )  
    log_option_desc += frmt_items.format("", "are working as expected.", " \n" )  
    log_option_desc += frmt_items.format("WARNING ", "An indication that something unexpected , ", "30" )  
    log_option_desc += frmt_items.format("", "happened or indicative of some problem", "" )  
    log_option_desc += frmt_items.format("", "in the near future.", "\n" )  
    log_option_desc += frmt_items.format("ERROR ", "Due to a more serious problem ", "40" )  
    log_option_desc += frmt_items.format("", "the software has not been able ", "" )  
    log_option_desc += frmt_items.format("", "to perform some function. ", "\n" )  
    log_option_desc += frmt_items.format("CRITICAL ", "A serious error, indicating ", "50" )  
    log_option_desc += frmt_items.format("", "that the program itself may be unable", "" )  
    log_option_desc += frmt_items.format("", "to continue running.", "\n" )  
    return log_option_desc

## @brief Creates and returns a logger object.
##
## @details Creates a logger object with name log_id and returns it.
## log level log_level.
##
## @param log_id A string
## @param log_level A logging level (e.g. logging.DEBUG, logging.INFO, etc.)
## @retval logger A logger object - see logging python documentation
def _create_logger(log_id, log_level):
    logger = logging.getLogger(log_id)
    logger.setLevel(log_level)

    # create console handler and set level to debug
    ch = logging.StreamHandler()
    ch.setLevel(log_level)

    # create formatter
    formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s')

    # add formatter to ch
    ch.setFormatter(formatter)

    # add ch to logger
    logger.addHandler(ch)

    return logger

## @fn _parse_arguments( )
## @brief Parses the command line arguments.
##
## @details Parses the command line arguments and
## returns a namespace.
##
## @return A namespace. The namespace contains attributes
##         that are the command line arguments.
def _parse_arguments():

    # Create a string of the description of the 
    # program
    program_description = "Records the loaded module files." 

    # Create an argument parser.
    my_parser = argparse.ArgumentParser(
            description=program_description,
            formatter_class=argparse.RawTextHelpFormatter,
            add_help=True)

    # Add an optional argument for the logging level.
    my_parser.add_argument("--log-level",
                           type=int,
                           default=logging.WARNING,
                           help=_create_logger_description() )

    # The name of the file to record the loaded modules.
    my_parser.add_argument("--outfile",
                           type=str,
                           required=True,
                           help="The file name to write the list of loaded module files." )

    my_args = my_parser.parse_args()

    return my_args 


## @fn capture_output_ml_command ( )
## @brief Writes the loaded module to a file.
##
def capture_output_ml_command():
    # Instatiate a Lua module interface.
    aLmod = lmod_interface.lmod("my_modules.txt",logging_level=logging.DEBUG)

    # Write loaded modules to file.
    aLmod.write_modules_loaded_to_file()

## @fn main ()
## @brief The main function.
def main():
    args = _parse_arguments()

    logger = _create_logger(log_id='record_modules_loaded_logger',
                           log_level=args.log_level)

    logger.info("Start of main program")
    
    capture_output_ml_command()

    logger.info("End of main program")

if __name__ == "__main__":
    main()

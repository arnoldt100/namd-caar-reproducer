#! /usr/bin/env python3
## @package lmod_interface
#  Provides functionalities to interact with Lua modulefiles.
#
#  Provides functionalities to interact with Lua modulefiles.

# System imports
import string
import argparse # Needed for parsing command line arguments.
import logging # Needed for logging events.

# Local imports

## @fn create_logger_description( )
## @brief Returns a string whose contents are the log level option help description.
## 
## @return A string
def create_logger_description():
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


## @fn _capture_stderr_stdout_module_list ( )
## @brief Returns a dictionary of standard error and out of lmod command "module list"
##
## return A dictionary of strings, d, where :
##        d["standard_out"] is the stdout of command "module list"
##        d["standard_err"] is the stderr of command "module list"
## 
## @details Returns the standard error and out of lmod command "module list". 
def _capture_stderr_stdout_module_list():
    import subprocess

    # For LUA modules the command 'module' is an alias, so we must use the
    # shell to call it. We capture the stdout and stderr. Stderr has the
    # information on the loaded modules.
    command="module list"
    my_command = subprocess.run(command,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    return {"standard_out" : my_command.stdout, "standard_err" : my_command.stderr}


## @fn _write_loaded_modules_in_xml_format ( )
##
## @brief Writes the list of loaded modules to a file in XML format.
##
## @param[in] filename The xml file name of the file to write to.
## @param[in] loaded_modules A string list of the load modules.
def _write_loaded_modules_in_xml_format(xml_file_name,loaded_modules):

    import xml.etree.ElementTree as ET # Needed for writing results as XML.

    my_xml_root = ET.Element("Modules Loaded")
    my_xml_root.text = loaded_modules[0]

    # Imstantiate an ElementTree 
    my_xml_doc = ET.ElementTree(my_xml_root)

    # Write as xml doc to file xml_file_name
    my_xml_doc.write(xml_file_name)
    with open (xml_file_name, "wb") as files :
        my_xml_doc.write(files)

    return

## @brief Abstracts the Lua modules functionality.
##
## @details Abstracts the Lua module file functionality.
class lmod():
    def __init__(self,filename,
                 logging_level=logging.NOTSET,
                 logging_id="lmod"):
        self._outputfile_name = filename 
        self._logger = _create_logger(logging_id,logging_level)

    ## @brief Writes the loaded Lua modules to a file.
    ##
    ## @details The loaded modules are written to file
    ##
    ## @params xml_file_name The name of the xml file to write the results to.
    def write_modules_loaded_to_file(self):

        # Capture the output of command "module list".
        module_list_output = _capture_stderr_stdout_module_list()

        # Now parse the stderr of command 'module list'. 
        loaded_modules = self._parse_lmod_stderr(module_list_output["standard_err"])

        # Now write the list of loaded modules to file.
        _write_loaded_modules_in_xml_format(self._outputfile_name,loaded_modules)
    
    ## @brief Returns a list of strings of the loaded modules.
    ##
    ## @details Returns a list of strings whose elements are the list
    ##          of loaded modules. 
    ##
    ## @param stderr The standard error of command "module list". sterr is of type byte string.
    ##
    ## @return A list of strings. The elements are the loaded modules.
    def _parse_lmod_stderr(self,stderr):
        import re

        # Step 0 - Convert stderr to  UTF-8.
        stderr0 = stderr.decode('UTF-8')

        # Step 1 - Remove all newlines form stderr0.
        stderr1 = stderr0.replace("\n","")

        # Step 2 - Remove the substring "Currently Loaded Modules:"
        repl2 = "Currently Loaded Modules:"
        stderr2 = stderr1.replace(repl2,"")

        # Step 3 - Parse string and write loaded module to a list.
        # The string variabe stderr2 has each loaded module in the form below:
        # ...  6) craype-network-ofi   17) rocm/4.3.0  ...
        pattern = "\s+\d+\)\s+(?P<ml>\S+)"
        regexpr = re.compile(pattern)
        loaded_modules = regexpr.findall(stderr2)

        # Text for debigging.
        debug_message = "Module list stderr after parsing stderr to list:\n"
        for tmp_str in loaded_modules:
            debug_message += tmp_str + "\n"
        self._logger.debug(debug_message)

        return loaded_modules

## @fn main ()
## @brief The main function.
def main():
    args = parse_arguments()

    logger = _create_logger(log_id='lmod_interface_logger',
                           log_level=args.log_level)

    logger.info("Start of main program")

    logger.info("End of main program")

if __name__ == "main":
    main()

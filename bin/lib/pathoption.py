"""Utility module for the option "--path" for ncp_paths_<software>.py scripts.

The function create_pathoption returns an PathOption object. 

The function  register_pathoption registers a new path option permmited value and the
corresponding function reference.

"""

import errors_pathoption

def create_pathoption ():
    """Returns a PathOption object"""
    return PathOption()

def register_pathoption(path_option,key,ref_to_function,description="No description"):
    try:
        path_option.add_option(key,ref_to_function,description)
    except errors_pathoption.ErrorDuplicatePathOptionKey as error:
        print("Key " + key + " already registered.")
    return

def get_pathoption_keys(path_option):
    return path_option.keys()

def get_pathoption_path(path_option,key,*args):
    import os
    tmp_path = path_option.path(key,*args)
    tmp_path = os.path.abspath(tmp_path)
    return tmp_path

def create_path_description(path_option):
    frmt_header = "{0:20s} {1:50.50s}\n"
    frmt_items = frmt_header
    header1 =  frmt_header.format("Option Values", "Path Returned" )  
    header1_len = len(header1)
    log_option_desc = "The permitted options values and returned paths are the following:\n\n"
    log_option_desc += header1
    log_option_desc += "-"*header1_len  + "\n"
    for key in get_pathoption_keys(path_option):
        description = _get_pathoption_description(path_option,key)
        log_option_desc += frmt_items.format(key,description + "\n")  
    return log_option_desc

def print_path(path_option,
               path_option_value,
               *args):
    import sys
    tmp_path = get_pathoption_path(path_option,path_option_value,*args)
    sys.stdout.write(tmp_path)

class PathOption:
    """A class that stores the option --path allowed option values and corresponding reference function.
    
    The option --path takes 1 argument

        --path arg1

    where arg1 is a flag to select which installation path to print to stdout.
    For this class, arg1 is a dictionary key that corresponds to a function
    reference.
    """
    def __init__(self):
        self._functionReference = {}
        self._description = {}

    def add_option (self, key, ref_to_function, description):
        if key in self._functionReference:
             raise errors_pathoption.ErrorDuplicatePathOptionKey
        self._functionReference[key] = ref_to_function
        self._description[key] = description
        return

    def keys(self):
        return list(self._functionReference)

    def description(self,key):
        return self._description[key]

    def path(self,key,*args):
        return self._functionReference[key](*args)

def _get_pathoption_description(path_option,key):
    return path_option.description(key)


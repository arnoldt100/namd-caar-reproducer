"""Utility module for the option "--path" for ncp_paths_<software>.py scripts.

The function create_pathoption returns an PathOption object. 

The function  register_pathoption registers a new path option permmited value and the
corresponding function reference.

"""

import errors_pathoption

def register_pathoption(pathoption,key,ref_to_function,description="No description"):
    try:
        pathoption.add_option(key,ref_to_function,description)
    except errors_pathoption.ErrorDuplicatePathOptionKey as error:
        print("Key " + key + " already registered.")
    return

def get_pathoption_keys(pathoption):
    return pathoption.keys()

def get_pathoption_path(pathoption,key,*args):
    return pathoption.path(key,*args)

def create_pathoption ():
    """Returns a PathOption object"""
    return PathOption()

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


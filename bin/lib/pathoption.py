"""Utility module for the option "--path" for ncp_paths_<software>.py scripts.

The function create_pathoption returns an PathOption object. 

The function  register_pathoption registers a new path option permmited value and the
corresponding function reference.

The function  unregister_pathoption registers removes a path option and the corresponding
function reference.
"""

def get_pathoption_path(pathoption,key):
    return

def register_pathoption(pathoption,key,ref_to_function):
    # Check if key is in self._pathOptionData. If so then raise a error.

    if key in self._pathOptionData:
        pass

    self._pathOptionData[key] = ref_to_function

    return

def unregister_pathoption(pathoption,key):
    return

def create_pathoption ():
    """Returns a PathOption object"""
    return PathOption

class PathOption:
    """A class that stores the option --path allowed option values and corresponding reference function.
    
    The option --path takes 1 argument

        --path arg1

    where arg1 is a flag to select which installation path to print to stdout.
    For this class, arg1 is a dictionary key that corresponds to a function
    reference.
    """
    def __init__(self):
        self._pathOptionData = {}

    def add_option (self, key, ref_to_function):
        self._pathOptionData[key] = ref_to_function
        return

    def get_path(self,key):
        return self._pathOptionData[key]


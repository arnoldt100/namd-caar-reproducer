#! /usr/bin/env python3
"""Convenience module for registering new machine builds.

The fuction register_new_machine registers a new machine.

The fuction register_new_build registers a new build.
"""
# System imports

# Local imports

def register_new_machine(reg_builder,machine_name=''):
    """Registers a new machine to build NAMD.

    Registers 'machine_name' for building NAMD. Registering the same 
    machine more than once hase no effect on reg_builder. 

    Args:
        reg_builder (NamdBuildRegister) : An instance of class NamdBuildRegister.
        machine_name (str) : The name of the machine being registered.

    Returns:
       A machine that has registered machine "machine_name".  
    """

    reg_builder.register_machine(machine_name)
    return  

def register_new_build(reg_builder,machine_name='',build_target='',builder=''):
    """Registers a new build target for machine 'machine_name'.
   
    Registers 'machine_name' for building NAMD target 'build_target'
    Registering the same machine and build target more than once hase no effect
    on reg_builder. 
    
    Args:
        reg_builder (NamdBuildRegister) : An instance of class NamdBuildRegister.
        machine_name (str) : The name of the machine being registered.
        build_target (str) : The name of the NAMD build target.
        builder (function referece) : A callable object that will build NAMD.
    
    Returns:
       A machine that has registered machine "machine_name".  
    """

    print( f"Registering build target: {machine_name}, {build_target}." )
    reg_builder.add_buildtarget(machine_name=machine_name,build_target=build_target,builder=builder)
    return reg_builder

def build_software(reg_builder,machine_name='',build_target=''):
    """ """
    reg_builder.build(machine_name=machine_name,build_target=build_target)
    return

class NamdBuildRegister():
    """Stores the machines and machine registrations for building NAMD.
    
    Attributes:
        _machine_names : A array that stores the NAMD machine names.
        _builder : An dict of callable objects. The dict is a nested dict
                   such that to access the builder for machine_name and 
                   build_target, one does self._builder[machine_name][build_target]
    """
    def __init__(self):
        self._machine_names = []
        self._builder = {}

    def register_machine(self,machine_name):
        """Adds a machine for registration

        If the machine already exists then nothing is done.

        Args:
            machine_name (str) : The machine name.
        """
        if not ( machine_name in self._machine_names ) :
            print( f"Registering {machine_name}." )
            self._machine_names += [machine_name]
            self._builder[machine_name] = {}

        return

    def unregister_machine(self,machine_name):
        """Removes machine machine_name
        
        If the machine already removed then nothing is done.
        
        Args:
            machine_name (str) : The machine name.
        """
        if machine_name in self._machine_names :
            self._machine_names.pop(machine_name)
            self._builder.pop(machine_name)

    def add_buildtarget(self,machine_name,builder,build_target):
        """Adds a new build target 

        The build target must not previously exist.
        
        Args:
            machine_name (str) : The name of the machine
            builder (callable object) : When innvoked, builds namd for the
                                        desired target.
            build_target (str) : The NAMD build target.

        """

        # First verify that the machine is registered.
        if not ( machine_name in self._machine_names ) :
            msg = ( f'Error! The nachine "{machine_name}" is not registered.' )
            raise ValueError(msg)

        # Verify that the build_target is not previously registered
        if build_target in self._builder[machine_name] :
            msg = ( f'Error! The build target "{build_target}" for "{machine_name}"'
                    f' is previously registered.' )
            raise ValueError(msg)

        self._builder[machine_name][build_target] = builder

        return

    def remove_buildtarget(self,machine_name,build_target):
        """Removes a build target of machine machine_name
        
        Args:
            machine_name (str) : The name of the machine
            build_target (str) : The NAMD build target.

        """

        if  machine_name in self._machine_names  :
            if build_target in self._builder[_machine_name] :
                self._builder[machine_name].pop(build_target,'')
        return

    def build(self,machine_name,build_target):
        """ """
        self._builder[machine_name][build_target](machine_name=machine_name,build_target=build_target)
        return

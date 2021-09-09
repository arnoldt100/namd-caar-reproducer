# Overview of Building and Running the Reproducer
This package is a reproducer for the NAMD/charm++ intermittent hanging behavior
found on **spock.olcf.ornl.gov**. 

# Setting Essential Environmental Variables

The first step is to set essential paths and environmental variables by
doing the following command<br>

**source ./runtime\_configuration/core\_runtime\_environment.sh**<br>

This will set the environmental variable **NCP_TOP_LEVEL**, modify your
**PATH** environmental variable, and make available Lmod modules to build/run
the appropriate NAMD binaries.<br>

To see the list of available modules for this reproducer, type <br>

**module avail Spock**

Load the 




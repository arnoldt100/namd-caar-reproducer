# Overview of Building and Running the Reproducer
This package is a reproducer for the NAMD/charm++ intermittent hanging behavior
found on **spock.olcf.ornl.gov**. One must download the prerequisite software
packages and NAMD, load some Lmod modulefiles, build all software, and finally
run the NAMD binary to reproduce the intermittent hanging behavior. 

# Setting Essential Environmental Variables

## Setting Core Package Environmental Variables.
The first step is to set essential paths and environmental variables by
doing the following command<br>

**source ./runtime\_configuration/core\_runtime\_environment.sh**<br>

Note this command must be executed in the top level of this package. This will
set the environmental variable **NCP_TOP_LEVEL**, modify your **PATH**
environmental variable, and make available Lmod modules to build/run the
appropriate NAMD binaries.<br>

## Setting Machine Package Environmental Variables.

The next step is load the module that corresponds to your specific machine. For
example, for the OLCF machine Spock load the module file
*Spock/Spock\_core\_runtime\_environment.lua*

**module load Spock/Spock\_core\_runtime\_environment**<br>

This will set the appropriate programming environment, the **MACHINE\_NAME** environmental
variable.<br>

## Downloading the Prerequisite Software Packages and NAMD.

The next step is to download the software TCL and charm++.<br>

### Downloading TCL

To download TCL run the command<br>

**download\_tcl.sh**<br>

This will download the tarball *tcl8.5.9-src.tar.gz* and unpack in directory
*${NCP_TOP_LEVEL}/sw/sources*.<br>

### Downloading charm++

To download charm++ run the command<br>

**download_charm.sh**<br>

This will clone charm++ to *${NCP_TOP_LEVEL}/sw/sources/charm*, and checkout
branch *v6.10.2*.<br>

### Downloading NAMD
To download NAMD source one must visit the URL
*https://www.ks.uiuc.edu/Research/namd/*, hoover over *software*, then hoover
over *NAMD*, and finally click on *Download*. A dialog will then ask for a
username and password. Please register and set your username and password.
Unpack the tarball in directory *${NCP_TOP_LEVEL}/sw/sources* and rename the
directory from *NAMD\_Git-2021-09-13\_Source* to *namd*.

## Building Prerequisite Software and NAMD

### Load Lmod modulefiles
To build the multinode(SMP version of NAMD) we load the Lmod module file  
*Spock/namd/namd-ofi-linux-x86\_64\_\_gnu\_\_cpu.lua*<br>

**module load Spock/namd/namd-ofi-linux-x86_64\_\_gnu\_\_cpu**<br>

This will load the correct fftw, charm++, and tcl module files.<br>

### Building TCL and charm++

At this point TCL and charm++ must be built. To build TCL run the command<br>

**build_tcl.sh**<br>

TCL will be installed in directory *${NCP_TOP_LEVEL}/sw/Spock/tcl/8.5.9/*.<br>

To build charm++, run the command<br> 

**build_charm.sh**<br>

This will build the ofi charm++ transport layer and install charm++ within
directory
*${NCP_TOP_LEVEL}/sw/sources/charm++/ofi-linux-x86_64-gfortran-smp-gcc*.<br>

### Building NAMD

Run the command<br> 

**build\_namd-uiuc.sh --target-machine Spock --target-build namd-ofi-linux-x86\_64\_\_gnu\_\_cpu**<br>

This will install the binary *namd2* in directory *${NCP_TOP_LEVEL}/sw/Spock/NAMD/ofi-linux-x86_64-gfortran-smp-gcc/cpu/*

# List of Critical Environmental Variables

**NCP_TOP_LEVEL** Stores the fully qualified path to the
top level of this package. This variable is set in file *core\_runtime\_environment.sh*.
<br>

**NAMD_TOP_LEVEL** Stores the fully qualified path to the top level
of the NAMD source. This variable is set in file *core\_runtime\_environment.sh*.
<br>

**MACHINE_NAME** Stores the name of the machine to build and run NAMD on. This variable
is set in the Lmod module file *&lt;MACHINE_NAME&gt;\_core\_runtime\_environment.lua*.

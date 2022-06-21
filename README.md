# Overview of Building and Running the Reproducer
This package is a testing framework for the NAMD/charm++ on OLCF machines. 
In general, one must download the
prerequisite software packages and NAMD, load some Lmod modulefiles, build all
software, and finally run the NAMD binary.

# Setting Essential Environmental Variables

## Setting Core Package Environmental Variables.
The first step is to set essential paths and environmental variables by
doing the following command<br>

**source ./runtime\_environment/core\_runtime\_environment.sh**<br>

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
*${NCP_TOP_LEVEL}/sw/sources*. One may have to run the script several
times to successfully download TCL.<br>

### Downloading charm++

To download charm++ run the command<br>

**download_charm.sh**<br>

This will clone charm++ to *${NCP_TOP_LEVEL}/sw/sources/charm*, and checkout
branch *v7.0.0-rc1*.<br>

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

**build_charm.sh --help**<br>

This will list the available builds for each machine. Then run the command

**build_charm.sh --target-machine ${MACHINE\_NAME} --target-build ${CHARM\_TARGET\_BUILD} **<br>

This will build the charm++ transport layer and install charm++ within
directory *${CHARMBASE}/${CHARMARCH}*.<br>

### Building NAMD

Run the command<br> 

**build\_namd-uiuc.sh --target-machine ${MACHINE\_NAME} --target-build ${NCP\_TARGET\_BUILD}**<br>

This will install the binary *namd2* in directory *${NAMD\_PREFIX}*

# List of Critical Environmental Variables

**NCP_TOP_LEVEL** Stores the fully qualified path to the
top level of this package. This variable is set in file *core\_runtime\_environment.sh*.
<br>

**NAMD_TOP_LEVEL** Stores the fully qualified path to the top level
of the NAMD source. This variable is set in file *core\_runtime\_environment.sh*.
<br>

**NAMD_AMD_TOP_LEVEL** Stores the fully qualified path to the top level
of the NAMD source form AMD. This variable is set in file *core\_runtime\_environment.sh*.
<br>

**MACHINE_NAME** Stores the name of the machine to build and run NAMD on. This variable
is set in the Lmod module file *&lt;MACHINE_NAME&gt;/&lt;MACHINE_NAME&gt;\_core\_runtime\_environment.lua*.

**NAMD_PREFIX** The directory containing the NAMD binary. This variable
is set in the Lmod module file *&lt;MACHINE_NAME&gt;/namd/namd-ofi-linux-x86_64.lua*.


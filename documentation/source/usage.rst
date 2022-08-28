.. _usage:

Usage
=====

Overview of Building and Running the Reproducer
-----------------------------------------------

This package provides a benchmark and testing framework for the NAMD on OLCF
machines.  In general, one must download the prerequisite software packages and
NAMD, set various environmental variables, load some Lmod modulefiles, build
all software and finally run the NAMD binary benchmarks.

Setting Essential Environmental Variables
-----------------------------------------

The following environmental variables must be set to run this package:

- **NCP\_TOP\_LEVEL** Defines the directory path to top level of this package.

- **NCP\_MACHINE\_NAME** Defines the machine to run the benchmarks/tests on.

- **NCP\_PE\_KEY** Defines the programming environment. This environmental variable
  is used as a key for the Lua table, i.e. an associative array, hash, dictionary, etc.,
  to set the values of the Lmod modulefiles to load. Examine the file 
  *${NCP\_TOP\_LEVEL}/runtime\_environment/Crusher/Crusher\_core\_runtime\_environment.lua*
  to see an example.

- **NCP\_SCRATCH** Defines the location where the NAMD benchmarks are run.

- **NCP\_PREFIX** Defines the top-level installation directory directory where all
  NAMD and its dependencies, e.g. tcl, namd, etc., are installed under.

- **NCP\_RESULTS** Defines the top-level directory where the benchmark results
  are stored under.

There are sample convenience scripts that can be used as guides to set the above 
environment. The scripts are located in the directory ::

    ${NCP_TOP_LEVEL}/etc/essential_environmental_variables.

Copy a script to the top-level, modify it to suite your needs and then source it.


Setting Core Package Environmental Variables
--------------------------------------------

The next step is to set core path environmental variables by
doing the following command ::

    source ${NCP_TOP_LEVEL}/runtime_environment/core_runtime_environment.sh

This command will modify your **PATH**, **PYTHONPATH**
environmental variables, and make available Lmod modules to build and run the
appropriate NAMD benchmarks.

Setting Machine Package Environmental Variables
-----------------------------------------------

The next step is load the module that corresponds to your specific machine.
We shall assume that we are targeting OLCF's Crusher development machine.  
We therefore load OLCF's machine modulefile
*Crusher/Crusher\_core\_runtime\_environment.lua* ::

    module load Crusher/Crusher_core_runtime_environment

This will set the appropriate programming environment based upon the
environmental variable **NCP\_PE\_KEY** and define the environmental variable
**MACHINE\_NAME**.

Important! All machine modulefiles name must have the format::

    ${NCP_MACHINE_NAME}_core_runtime_environment.lua

and be located at ::

   ${NCP_TOP_LEVEL}/runtime_environment/${NCP_MACHINE_NAME}/${NCP_MACHINE_NAME}_core_runtime_environment.lua


Downloading the Prerequisite Software Packages and NAMD
-------------------------------------------------------

The next step is to download the software TCL and Charm++

Downloading TCL
~~~~~~~~~~~~~~~

To download TCL run the command ::

    download_tcl.sh

This will download the tarball *tcl8.5.9-src.tar.gz* and unpack in directory
*${NCP_TOP_LEVEL}/sw/sources*. One may have to run the script several times to
successfully download TCL.

Downloading Charm++
~~~~~~~~~~~~~~~~~~~

To download charm++ run the command ::

    download_charm.sh

This will clone Charm++ to *${NCP_TOP_LEVEL}/sw/sources/charm* and checkout
branch *v7.0.0-rc1*.

Downloading NAMD
~~~~~~~~~~~~~~~~

To download NAMD source one must visit the URL ::

    https://www.ks.uiuc.edu/Research/namd/ 

and hoover over *software*, then hoover over *NAMD*, and finally click on
*Download*. A dialog may ask ask for a username and password. Is so, then
please register and set your username and password.  After downloading the
appropriate NAMD version, unpack the tarball in directory ::

    ${NCP_TOP_LEVEL}/sw/sources 

and rename the extracted directory *namd*. The directory
*${NCP_TOP_LEVEL}/sw/sources* will now contain directories

* namd
* tcl8.5.9
* charm

Building Prerequisite Software and NAMD
---------------------------------------

To build NAMD for a particular architecture and network layer, one must load
the appropriate modulefiles. For demonstration purpose we assume we are on
Crusher and target the default programming environment.

The environmental variable **NCP\_PE\_KEY** is important for it defines the
programming environment through the loading of modulefile ::

    Crusher/Crusher_core_runtime_environment.lua* 
    
For this example **NCP\_PE\_KEY** has the value of 'default'. The Crusher
'default' programming environment on Crusher targets an NAMD build for
multicore. If one echos the variables **NCP\_CHARM\_MODULE** and the
**NCP_NAMD_MODULE**, they will show which Charm++ and NAMD architectures are
being targeted.

Load Lmod modulefiles
~~~~~~~~~~~~~~~~~~~~~

For the default target on OLCF's Crusher we load the modulefile by the command ::

    module load ${NCP_NAMD_MODULE}

If one echos the variable **NCP_NAMD_MODULE** one will see it is set to ::

    Crusher/namd/default/multicore-linux-x86_64-gfortran-gcc

This will load the correct fftw, charm++, and tcl module files.<br>

Building TCL and charm++
~~~~~~~~~~~~~~~~~~~~~~~~

At this point TCL and charm++ must be built. To build TCL run the command ::

    build_tcl.sh**

TCL will be installed in directory *${NCP_TOP_LEVEL}/sw/Crusher/tcl/8.5.9/*.

To build charm++, run the command 

    build_charm.sh --help

This will list the available builds for each machine. Then run the command ::

    build_charm.sh --target-machine ${MACHINE_NAME} --target-build ${CHARM_TARGET_BUILD}

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


# Instructions on Running the Benchmark


## Prerequisites

Load the module for the specific programming environment. For this benchmark
the modulefile "Spock/namd/namd-ofi-linux-x86\_64\_\_gnu\_\_cpu" must be
loaded. Please read the top level README.md, ${NCP\_TOP\_LEVEL}/README.md, file
for details.

## Set Environmental Variables

Set the following environment variables.

**NCP_ACCOUNT_ID** - The pbs/slurm/etc account id. 

**NCP_APOA1_NAMD_BINARY** - The NAMD binary fully qualified path.

**NCP_APOA1_RESULTS_DIR** - The directory to copy the final results of the benchmark.

**NCP_APOA1_SCRATCH_DIR** - The scratch directory to run the apoa1 benhmark.

There a bash file ./etc/sample.env.sh that can be copied, modified, and sourced
to assist in setting these environmental variables.

If the above environmental variable are not set, then the script
apoa1\_benchark.sh will exit with a warning of unset environmental variables.

## Execute the Benchmark Script 

Launch a benchmark script. For example, the script apoa1\_benchmark.sh runs
apoa1 on a single node with 1 processor and 1 GPU. A list of benchmark scripts is detailed
below:

| Benchmark Script | Details |
| --- | --- |
| apoa1\_benchmark.sh | runs apoa1 on a single node with 1 processor and 1 GPU |

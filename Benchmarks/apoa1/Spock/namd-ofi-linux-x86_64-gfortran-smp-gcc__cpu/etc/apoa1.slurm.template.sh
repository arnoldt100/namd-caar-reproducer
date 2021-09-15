#!/bin/bash

#SBATCH --job-name=apoa1benchmark
#SBATCH --nodes=2
#SBATCH -A __ACCOUNTID__
#SBATCH --time=00:30:00

# ----------------------------------------------------
# Set the scratch dir.
# 
# ----------------------------------------------------
declare -r SCRATCH_DIR=__SCRATCHSPACE__

# ----------------------------------------------------
# Set the fully qualified path to the NAMD binary.
#
# ----------------------------------------------------
declare -r NAMD_BINARY=__NAMDBINARY__

#-----------------------------------------------------
# Set the fully qualified path to the results        -
# directory.                                         -
#                                                    -
#-----------------------------------------------------
declare -r NAMD_RESULTS_DIR=__NAMDRESULTSDIR__

#-----------------------------------------------------
# Set the fully qualified path the the input files   -
# parent directory.                                  -
#                                                    -
#-----------------------------------------------------
declare -r INPUT_FILES_PARENT_DIR=__APOA1_INPUT_FILES_PARENT_DIR__

#-----------------------------------------------------
# Set the number of physical nodes.                  -
# SLURM_JOB_NUM_NODES is the number of nodes         -
# requested:                                         -
#   SBATCH --nodes=2                                 -
#                                                    -
#-----------------------------------------------------
declare -ri number_physical_nodes=${SLURM_JOB_NUM_NODES}

#-----------------------------------------------------
# We now set the mapping of PEs and COMM.            -
#                                                    -
# For NUMA 0, we reserve hardware thread 0 for comm. -
# and 1-15 for PE.                                   -
#
# For NUMA 1, we reserve hardware thread 16 for comm.-
# and 17-31 for PE.                                  -
# 
# For NUMA 2, we reserve hardware thread 32 for comm.-
# and 33-47 for PE.                                  -
#                                                    -
# For NUMA 3, we reserve hardware thread 48 for comm.-
# and 49-63 for PE.                                  -
#                                                    -
#-----------------------------------------------------
declare -r pe_com_map="+commap 0,16,32,48 +pemap 1-15+16+32+48"


# #-----------------------------------------------------
# # compute the number of charmm++ logical domains     -
# # needed.                                            -
# #                                                    -
# #-----------------------------------------------------
# declare -i nm_charm_logical_nodes=$(calc_num_charm_logical_node number_worker_threads number_worker_threads_per_charm_logical_node)
# declare -ri nm_comm_threads=$((number_comm_threads_per_charm_logical_node*nm_charm_logical_nodes))
# declare -ri total_tasks=$((number_worker_threads+nm_comm_threads))
# declare -ri max_worker_threads_per_node=$((number_numa_domains_per_physical_node*number_charm_logical_nodes_per_numa_domain*number_worker_threads_per_charm_logical_node)) 
# declare -ri max_comm_threads_per_node=$((number_numa_domains_per_physical_node*number_charm_logical_nodes_per_numa_domain*number_comm_threads_per_charm_logical_node))
# declare -ri max_tasks_per_node=$((max_worker_threads_per_node+max_comm_threads_per_node))
# 
# 
# echo "nm_charm_logical_nodes=$nm_charm_logical_nodes"
# echo "number_worker_threads=${number_worker_threads}"
# echo "number_worker_threads_per_charm_logical_node=$number_worker_threads_per_charm_logical_node"
# echo "total_tasks=$total_tasks"
# echo "ntask_per_node=$max_tasks_per_node"
# echo "charmrun command line: charmrun +p ${number_worker_threads} ++ppn ${number_worker_threads_per_charm_logical_node} ++mpiexec ++remote-shell "srun -n ${total_tasks} --ntasks-per-node ${max_tasks_per_node}" ./namd2 ${pe_com_map} ./apoa1.namd"

# ----------------------------------------------------
# Copy the NAMD binary to the scratch directory.
#
# ----------------------------------------------------
cp ${NAMD_BINARY} ${SCRATCH_DIR}/

# ----------------------------------------------------
# Copy all input files to the scratch directory.     -
#                                                    -
# ----------------------------------------------------
input_files=( "apoa1.namd" 
              "apoa1.pdb"
              "apoa1.psf"
              "par_all22_popc.xplor"
              "par_all22_prot_lipid.xplor" ) 

for tmp_input_file in "${input_files[@]}";do
    cp -f "${INPUT_FILES_PARENT_DIR}/${tmp_input_file}" "${SCRATCH_DIR}"
done

#-----------------------------------------------------
# Now run namd with charmrun.                        -
#                                                    -
#-----------------------------------------------------
cd ${SCRATCH_DIR}/
# charmrun +p ${number_worker_threads} ++ppn ${number_worker_threads_per_charm_logical_node} ++mpiexec ++remote-shell "srun -n ${total_tasks} --ntasks-per-node ${max_tasks_per_node}" ./namd2 ${pe_com_map} ./apoa1.namd

#-----------------------------------------------------
# Copy all files back to the results directory.      -
#                                                    -
#-----------------------------------------------------
cp -rf ${SCRATCH_DIR}/* ${NAMD_RESULTS_DIR}/ 

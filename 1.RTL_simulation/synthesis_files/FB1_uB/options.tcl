###############################################
# User-modified options:
option set add_dut_hierarchy 1
option set distributed_compile 0
option set distributed_synthesis 0
option set haps_target_detail HAPS-100
option set no_constraint_check 0
option set prepare_readback 0
option set synthesis_strategy advanced
option set design_flow synthesis
# device options
# "technology" is no longer specified as an option. (See -technology argument to "database create")
#    option set technology HAPS-100
# haps target detail
option set -internal haps_target_detail HAPS-100
option set speed_grade -1-e
# suppress_remap saves runtime when this FPGA didn't change:
option set -internal suppress_remap 1

setenv LM_LICENSE_FILE 27020@ws26:2100@ws26

setenv PROTOCOMPILER /usr/cadtool/csr5306/synopsys/protocomp/R-2020.12-SP1-1
setenv VCS_HOME /usr/cadtool/csr5306/synopsys/vcs/Q-2020.03-SP2-10-T-20220405
setenv XILINX_VIVADO /usr/cadtool/csr5306/synopsys/xilinx_vivado/2021.1-ep9/tools/XILINX_VIVADO
    

set path = ($PROTOCOMPILER/bin $VCS_HOME/linux64/bin $XILINX_VIVADO/bin $path)

which protocompiler
which vcs
which vivado


###################################################################

# Created by write_sdc on Thu Jan  6 17:10:42 2022

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions slow -library slow
set_load -pin_load 0.005194 [get_ports {signature[16]}]
set_load -pin_load 0.005194 [get_ports {signature[15]}]
set_load -pin_load 0.005194 [get_ports {signature[14]}]
set_load -pin_load 0.005194 [get_ports {signature[13]}]
set_load -pin_load 0.005194 [get_ports {signature[12]}]
set_load -pin_load 0.005194 [get_ports {signature[11]}]
set_load -pin_load 0.005194 [get_ports {signature[10]}]
set_load -pin_load 0.005194 [get_ports {signature[9]}]
set_load -pin_load 0.005194 [get_ports {signature[8]}]
set_load -pin_load 0.005194 [get_ports {signature[7]}]
set_load -pin_load 0.005194 [get_ports {signature[6]}]
set_load -pin_load 0.005194 [get_ports {signature[5]}]
set_load -pin_load 0.005194 [get_ports {signature[4]}]
set_load -pin_load 0.005194 [get_ports {signature[3]}]
set_load -pin_load 0.005194 [get_ports {signature[2]}]
set_load -pin_load 0.005194 [get_ports {signature[1]}]
set_load -pin_load 0.005194 [get_ports {signature[0]}]
set_load -pin_load 0.005194 [get_ports finish]
create_clock [get_ports clk]  -period 1  -waveform {0 0.5}
set_drive 1  [get_ports clk]
set_drive 1  [get_ports rst]

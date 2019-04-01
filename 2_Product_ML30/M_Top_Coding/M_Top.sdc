## Generated SDC file "M_Top.out.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.1.0 Build 590 10/25/2017 SJ Standard Edition"

## DATE    "Wed Jul 11 10:20:43 2018"

##
## DEVICE  "10M40DAF256C8G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {CLK_40MHz_IN} -period 25.000 -waveform { 0.000 12.5 } [get_ports {CLK_40MHz_IN}]
create_clock -name {PrSl_Clk80M_s} -period 12.500 -waveform { 0.000 6.250 } 
#create_clock -name {F_LCLK_IN_P} -period 5.000 -waveform { 0.000 2.500 } 
#create_clock -name {F_LCLK_OUT_P} -period 5.000 -waveform { 0.000 2.500 } 

#derive_pll_clocks


#create_clock -name{U_M_Clock_0|U_M_ClkPll_0|altpll_component|auto_generated|pll1|inclk0} -period 25.000 -waveform {0.000 12.5} 
# [get_ports Pin_J15]  

#create_generated_clock -source {U_M_Clock_0|U_M_ClkPll_0|altpll_component|auto_generated|pll1|clk[0]} -name {M_ClkPll_clk[0]}

create_clock -name lclk0 -period 10.000 [get_ports {F_LCLK_OUT_P}]
create_clock -name lclk1 -period 10.000 [get_ports {F_LCLK_OUT_1P}]
#derive_pll_clocks


set_input_delay -clock { lclk0 }  -min 1 [get_ports {F_FRAME1_P F_FRAME2_P F_FRAME3_P F_FRAME4_P F_SD1_P F_SD2_P F_SD3_P F_SD4_P}]
set_input_delay -clock { lclk0 }  -max 5 [get_ports {F_FRAME1_P F_FRAME2_P F_FRAME3_P F_FRAME4_P F_SD1_P F_SD2_P F_SD3_P F_SD4_P}]
set_input_delay -clock { lclk1 }  -min 1 [get_ports {F_FRAME5_P F_FRAME6_P F_FRAME7_P F_FRAME8_P F_SD5_P F_SD6_P F_SD7_P F_SD8_P}]
set_input_delay -clock { lclk1 }  -max 5 [get_ports {F_FRAME5_P F_FRAME6_P F_FRAME7_P F_FRAME8_P F_SD5_P F_SD6_P F_SD7_P F_SD8_P}]


set_false_path -from [get_clocks {CLK_40MHz_IN}] -to [get_clocks {lclk0}]
set_false_path -from [get_clocks {CLK_40MHz_IN}] -to [get_clocks {lclk1}]
set_false_path -from [get_clocks {lclk0}] -to [get_clocks {CLK_40MHz_IN}]
set_false_path -from [get_clocks {lclk1}] -to [get_clocks {CLK_40MHz_IN}]
set_false_path -from [get_clocks {PrSl_Clk200M_s}] -to [get_clocks {lclk0}]
set_false_path -from [get_clocks {PrSl_Clk200M_s}] -to [get_clocks {lclk1}]


#**************************************************************
# Create Generated Clock
#**************************************************************
#creat_clock -period 25.000 [get_ports CpSl_Clk_i]

#create_generated_clock -name PrSl_Clk200M_s -source {U_M_Clock_0|U_M_ClkPll_0|altpll_component|auto_generated|pll1|inclk[0]} -multiply_by 5 -duty_cycle 50.00 [get_pins {U_M_Clock_0|U_M_ClkPll_0|altpll_component|auto_generated|pll1|clk[0]}]
#-name {U_M_Clock_0|U_M_ClkPll_0|altpll_component|auto_generated|pll1|clk[0]} {U_M_Clock_0|U_M_ClkPll_0|altpll_component|auto_generated|pll1|clk[0]}

#create_generated_clock -name PrSl_Clk80M_s -source {U_M_Clock_0|U_M_ClkPll_0|altpll_component|auto_generated|pll1|inclk[0]} -multiply_by 2 -duty_cycle 50.00 [get_pins {U_M_Clock_0|U_M_ClkPll_0|altpll_component|auto_generated|pll1|clk[1]}]


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
set_clock_uncertainty  -setup -rise_from altera_reserved_tck -rise_to altera_reserved_tck 0.150
set_clock_uncertainty  -hold -rise_from altera_reserved_tck -rise_to altera_reserved_tck 0.150

set_clock_uncertainty  -setup -rise_from altera_reserved_tck -fall_to altera_reserved_tck 0.150
set_clock_uncertainty  -hold -rise_from altera_reserved_tck -fall_to altera_reserved_tck 0.150

set_clock_uncertainty  -setup -fall_from altera_reserved_tck -fall_to altera_reserved_tck 0.150
set_clock_uncertainty  -hold -fall_from altera_reserved_tck -fall_to altera_reserved_tck 0.150


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

#set_false_path -from [get_keepers {altera_reserved_tdi}] -to [get_keepers {pzdyqx*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Disable Timing
#**************************************************************

#set_disable_timing -from * -to * [get_cells -hierarchical {QXXQ6833_0}]
#set_disable_timing -from * -to * [get_cells -hierarchical {JEQQ5299_0}]
#set_disable_timing -from * -to * [get_cells -hierarchical {JEQQ5299_1}]
#set_disable_timing -from * -to * [get_cells -hierarchical {JEQQ5299_2}]
#set_disable_timing -from * -to * [get_cells -hierarchical {JEQQ5299_3}]
#set_disable_timing -from * -to * [get_cells -hierarchical {JEQQ5299_4}]
#set_disable_timing -from * -to * [get_cells -hierarchical {JEQQ5299_5}]
#set_disable_timing -from * -to * [get_cells -hierarchical {JEQQ5299_6}]
#set_disable_timing -from * -to * [get_cells -hierarchical {JEQQ5299_7}]
#set_disable_timing -from * -to * [get_cells -hierarchical {BITP7563_0}]

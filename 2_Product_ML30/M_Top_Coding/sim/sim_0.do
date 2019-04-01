#---------------------------------------
#   Compile library
#---------------------------------------

# Create and map a work directory
vlib work
vmap work work


#---------------------------------------
#compile the "glbl.v" 
#---------------------------------------
#vlog -work work -novopt D:/My_tool/Xilinx/14.7/ISE_DS/ISE/verilog/src/glbl.v

#---------------------------------------
# Compile files in the work directory
#vcom 表示编译VHDL代码；
#vlog 表示编译Verilog代码
#user designed part 
#---------------------------------------
vcom -work work ../src/agc/*.vhd
vcom -work work ../src/Library/*.vhd 
vcom -work work ../src/M_Gps/*.vhd
vcom -work work ../src/Tdc/*.vhd
vcom -work work ../src/Top/*.vhd
vcom -work work ../src/W5300/*.vhd
vcom -work work ../src/*.vhd
vcom -work work ../ip/*.vhd


# Compile testbench source
vcom -work work ./tb/M_Sim.vhd

# Begin the test
# Simulation Xilinx
##vsim -t ps -novopt +notimingchecks -L xilinxcorelib_ver -L unisim_ver -L simprim work.M_Sim glbl

## Simulation Altera
vsim -t ps -novopt +notimingchecks -L altera_ver -L altera_mf_ver work.M_Sim


#look wave form
do wave.do

log -r /*
run 10 ms
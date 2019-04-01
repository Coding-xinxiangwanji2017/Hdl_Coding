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
#vcom ��ʾ����VHDL���룻
#vlog ��ʾ����Verilog����
#user designed part 
#---------------------------------------
vcom -work work ../src/I2C/*.vhd
vcom -work work ../src/APD/*.vhd
vcom -work work ../src/Clock/*.vhd
vcom -work work ../src/DA7547/*.vhd
vcom -work work ../src/Library/*.vhd
vcom -work work ../src/LTC2324/*.vhd
vcom -work work ../src/M_Gps/*.vhd
vcom -work work ../src/Pulse_Gen_Trig/*.vhd
vcom -work work ../src/TDC_GPX2/*.vhd
vcom -work work ../src/Top/*.vhd
vcom -work work ../src/W5300/*.vhd
vcom -work work ../src/*.vhd  

vcom -work work ../src/TDC/M_TestTdc*.vhd

vcom -work work ../ip/*.vhd
vcom -work work ../ip/New/*.vhd

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
run 3 ms
onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib system_opt

do {wave.do}

view wave
view structure
view signals

do {system.udo}

run -all

source {../../../../daq2_zcu102.srcs/sources_1/bd/system/ip/system_axi_ad9680_dma_0/bd/bd.tcl}


quit -force

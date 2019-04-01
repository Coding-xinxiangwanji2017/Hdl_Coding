transcript on
if ![file isdirectory vhdl_libs] {
	file mkdir vhdl_libs
}

vlib vhdl_libs/altera
vmap altera ./vhdl_libs/altera
vcom -93 -work altera {c:/intelfpga/17.1/quartus/eda/sim_lib/altera_syn_attributes.vhd}
vcom -93 -work altera {c:/intelfpga/17.1/quartus/eda/sim_lib/altera_standard_functions.vhd}
vcom -93 -work altera {c:/intelfpga/17.1/quartus/eda/sim_lib/alt_dspbuilder_package.vhd}
vcom -93 -work altera {c:/intelfpga/17.1/quartus/eda/sim_lib/altera_europa_support_lib.vhd}
vcom -93 -work altera {c:/intelfpga/17.1/quartus/eda/sim_lib/altera_primitives_components.vhd}
vcom -93 -work altera {c:/intelfpga/17.1/quartus/eda/sim_lib/altera_primitives.vhd}

vlib vhdl_libs/lpm
vmap lpm ./vhdl_libs/lpm
vcom -93 -work lpm {c:/intelfpga/17.1/quartus/eda/sim_lib/220pack.vhd}
vcom -93 -work lpm {c:/intelfpga/17.1/quartus/eda/sim_lib/220model.vhd}

vlib vhdl_libs/sgate
vmap sgate ./vhdl_libs/sgate
vcom -93 -work sgate {c:/intelfpga/17.1/quartus/eda/sim_lib/sgate_pack.vhd}
vcom -93 -work sgate {c:/intelfpga/17.1/quartus/eda/sim_lib/sgate.vhd}

vlib vhdl_libs/altera_mf
vmap altera_mf ./vhdl_libs/altera_mf
vcom -93 -work altera_mf {c:/intelfpga/17.1/quartus/eda/sim_lib/altera_mf_components.vhd}
vcom -93 -work altera_mf {c:/intelfpga/17.1/quartus/eda/sim_lib/altera_mf.vhd}

vlib vhdl_libs/altera_lnsim
vmap altera_lnsim ./vhdl_libs/altera_lnsim
vlog -sv -work altera_lnsim {c:/intelfpga/17.1/quartus/eda/sim_lib/mentor/altera_lnsim_for_vhdl.sv}
vcom -93 -work altera_lnsim {c:/intelfpga/17.1/quartus/eda/sim_lib/altera_lnsim_components.vhd}

vlib vhdl_libs/fiftyfivenm
vmap fiftyfivenm ./vhdl_libs/fiftyfivenm
vlog -vlog01compat -work fiftyfivenm {c:/intelfpga/17.1/quartus/eda/sim_lib/mentor/fiftyfivenm_atoms_ncrypt.v}
vcom -93 -work fiftyfivenm {c:/intelfpga/17.1/quartus/eda/sim_lib/fiftyfivenm_atoms.vhd}
vcom -93 -work fiftyfivenm {c:/intelfpga/17.1/quartus/eda/sim_lib/fiftyfivenm_components.vhd}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib on_chip_flash
vmap on_chip_flash on_chip_flash
vlog -vlog01compat -work on_chip_flash +incdir+E:/workspace20190313/M_Top_0320/ip/on_chip_flash/on_chip_flash/synthesis/submodules {E:/workspace20190313/M_Top_0320/ip/on_chip_flash/on_chip_flash/synthesis/submodules/altera_onchip_flash_util.v}
vlog -vlog01compat -work on_chip_flash +incdir+E:/workspace20190313/M_Top_0320/ip/on_chip_flash/on_chip_flash/synthesis/submodules {E:/workspace20190313/M_Top_0320/ip/on_chip_flash/on_chip_flash/synthesis/submodules/altera_onchip_flash.v}
vlog -vlog01compat -work on_chip_flash +incdir+E:/workspace20190313/M_Top_0320/ip/on_chip_flash/on_chip_flash/synthesis/submodules {E:/workspace20190313/M_Top_0320/ip/on_chip_flash/on_chip_flash/synthesis/submodules/altera_onchip_flash_avmm_data_controller.v}
vlog -vlog01compat -work on_chip_flash +incdir+E:/workspace20190313/M_Top_0320/ip/on_chip_flash/on_chip_flash/synthesis/submodules {E:/workspace20190313/M_Top_0320/ip/on_chip_flash/on_chip_flash/synthesis/submodules/altera_onchip_flash_avmm_csr_controller.v}
vlog -vlog01compat -work work +incdir+E:/workspace20190313/M_Top_0320/db {E:/workspace20190313/M_Top_0320/db/m_clkpll_altpll.v}
vlib M_NCO
vmap M_NCO M_NCO
vlog -vlog01compat -work M_NCO +incdir+e:/workspace20190313/m_top_0320/db/ip/m_nco {e:/workspace20190313/m_top_0320/db/ip/m_nco/m_nco.v}
vlog -vlog01compat -work M_NCO +incdir+e:/workspace20190313/m_top_0320/db/ip/m_nco/submodules {e:/workspace20190313/m_top_0320/db/ip/m_nco/submodules/m_nco_nco_ii_0.v}
vlog -sv -work work +incdir+E:/workspace20190313/M_Top_0320/sim/tb/sim_v {E:/workspace20190313/M_Top_0320/sim/tb/sim_v/ocf_model.sv}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/WalkError/vector_integer.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_DistConst.vhd}
vcom -93 -work on_chip_flash {E:/workspace20190313/M_Top_0320/ip/on_chip_flash/on_chip_flash/synthesis/on_chip_flash.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/W5300/ocf_ctrl.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/WalkError/M_WalkError.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_Tdc_s2p.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_Tdc_group_sub.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_Tdc_group.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_GrayColum.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC/M_TestTdc.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/APD/M_apd_slt.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_GrayMult.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_DistMult.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_MeanData.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_WaveData.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_CompWave.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_CompData.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_Data.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/I2C/M_I2C.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_SeqData.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_AgcDiv.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/Top/M_Top.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_RomAgc.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/W5300/M_W5300If.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/W5300/M_NetWr.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/DA7547/M_VolAgc.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_TdcSpi.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/APD/M_VolApd.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/W5300/v_filter_2.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/DA7547/da_controller_7547.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/counter_shdn.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/Pulse_Gen_Trig/M_TrigCtrl.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/Pulse_Gen_Trig/M_RomCtrl.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/Pulse_Gen_Trig/ctrlCycle_simple.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/TDC_GPX2/M_TdcGpx2.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/M_Gps/M_GpsTop.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/M_Gps/M_CtrlTime.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/LTC2324/adc_ltc2324_16_controller.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/Library/pine_basic.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/Clock/M_Colck.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/W5300/state_control_top.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/W5300/delay_nrst.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_CombDataFifo.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_Mult.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_DivClk.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_ClkPll.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_GrayDiv.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_MultRate.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_TdcParAdd.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_GrayColum_a.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_GrayColum_b.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_GrayColum_Add.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/async_fifo/async_fifo_64x32.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/sync_fifo_64x8/sync_fifo_64x8.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/sync_fifo_16x64/sync_fifo_16x64.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/New/M_Fifo.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_WalkErrorAdd.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_WalkErrorFifo.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/W5300/M_Net_ds_ctrl.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/sync_fifo_32x512/sync_fifo_32x512.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/dpram_apd_slt/dpram_apd_slt.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/dpram_mem/dpram_mem.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/dpram_apd_vol/dpram_apd_vol.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_GrayRam.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_MemFifo.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/M_PulseMultGray.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/ip/dpram_cap_apd_vol/dpram_cap_apd_vol.vhd}
vcom -93 -work work {E:/workspace20190313/M_Top_0320/src/W5300/M_W5300Ctrl.vhd}

vlog -sv -work work +incdir+E:/workspace20190313/M_Top_0320/sim/tb/sim_v {E:/workspace20190313/M_Top_0320/sim/tb/sim_v/ad_model.sv}
vlog -sv -work work +incdir+E:/workspace20190313/M_Top_0320/sim/tb/sim_v {E:/workspace20190313/M_Top_0320/sim/tb/sim_v/M_Sim_sv.sv}
vlog -vlog01compat -work work +incdir+E:/workspace20190313/M_Top_0320/sim/tb/sim_v {E:/workspace20190313/M_Top_0320/sim/tb/sim_v/M_TestTdc.v}
vlog -sv -work work +incdir+E:/workspace20190313/M_Top_0320/sim/tb/sim_v {E:/workspace20190313/M_Top_0320/sim/tb/sim_v/eth_5300_model.sv}
vlog -sv -work work +incdir+E:/workspace20190313/M_Top_0320/sim/tb/sim_v {E:/workspace20190313/M_Top_0320/sim/tb/sim_v/ocf_model.sv}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -L on_chip_flash -L M_NCO -voptargs="+acc"  M_Sim_sv

add wave *
view structure
view signals
run -all

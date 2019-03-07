
# daq2
 
#set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports port_fda_passthrough]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports spi1_clk]
set_property  SLEW FAST [get_ports spi1_clk]
set_property  DRIVE 16 [get_ports spi1_clk]
 #J3 PIN 6
  
#set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports port_fdb_passthrough]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports spi1_sdio]
set_property  SLEW FAST [get_ports spi1_sdio]
set_property  DRIVE 16 [get_ports spi1_sdio]
#J3 PIN 8
 
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports status1]
#set_property  SLEW FAST [get_ports status1]
#set_property  DRIVE 16 [get_ports status1]
#J3 PIN 10

#set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports port_clk_out200M]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports spi1_csn_0]
set_property  SLEW SLOW [get_ports spi1_csn_0]
set_property  DRIVE 8 [get_ports spi1_csn_0]
#J3 PIN 12

set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports clk_resetn]
set_property  SLEW SLOW [get_ports clk_resetn]
set_property  DRIVE 8 [get_ports clk_resetn]
#J3 PIN 14

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports port_sysref]
#J3 PIN 16
 
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports port_lmfc_clk]
#J3 PIN 18

set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports port_lmfc_edge]
 #J3 PIN 20

set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports port_start1]
  #J3 PIN 22
   
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports port_rx_out_clk]
#J3 PIN 24

set_property -dict {PACKAGE_PIN AL8 IOSTANDARD DIFF_SSTL12} [get_ports port_clk_in1_p]
set_property -dict {PACKAGE_PIN AL7 IOSTANDARD DIFF_SSTL12} [get_ports port_clk_in1_n]

set_property  SLEW FAST [get_ports port_start1]
set_property  DRIVE 16 [get_ports port_start1]
#set_property  SLEW FAST [get_ports port_clk_out200M]
#set_property  DRIVE 16 [get_ports port_clk_out200M]
set_property  SLEW FAST [get_ports port_lmfc_clk]
set_property  DRIVE 16 [get_ports port_lmfc_clk]
set_property  SLEW FAST [get_ports port_lmfc_edge]
set_property  DRIVE 16 [get_ports port_lmfc_edge]
set_property  SLEW FAST [get_ports port_rx_out_clk]
set_property  DRIVE 16 [get_ports port_rx_out_clk]

set_property -dict {PACKAGE_PIN AA2 IOSTANDARD LVDS} [get_ports rx_sync_p]
set_property -dict {PACKAGE_PIN AA1 IOSTANDARD LVDS} [get_ports rx_sync_n]
set_property IOSTANDARD LVDS [get_ports rx_sysref_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports rx_sysref_p]
set_property IOSTANDARD LVDS [get_ports rx_sysref_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports rx_sysref_n]
#set_property IOSTANDARD LVDS [get_ports tx_sync_p]
#set_property DIFF_TERM_ADV TERM_100 [get_ports tx_sync_p]
#set_property IOSTANDARD LVDS [get_ports tx_sync_n]
#set_property DIFF_TERM_ADV TERM_100 [get_ports tx_sync_n]
#set_property IOSTANDARD LVDS [get_ports tx_sysref_p]
#set_property DIFF_TERM_ADV TERM_100 [get_ports tx_sysref_p]
#set_property IOSTANDARD LVDS [get_ports tx_sysref_n]
#set_property DIFF_TERM_ADV TERM_100 [get_ports tx_sysref_n]

#set_property IOSTANDARD LVCMOS18 [get_ports spi_csn_clk]
#set_property IOSTANDARD LVCMOS18 [get_ports spi_csn_dac]
set_property -dict {PACKAGE_PIN AC2 IOSTANDARD LVCMOS18} [get_ports spi_csn_adc]
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS18} [get_ports spi_clk]
#set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS18} [get_ports spi_sdio]
#set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS18} [get_ports spi_dir]
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS18} [get_ports fmc_spi_mosi]
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS18} [get_ports fmc_spi_miso]

#set_property IOSTANDARD LVCMOS18 [get_ports clkd_sync]
#set_property IOSTANDARD LVCMOS18 [get_ports dac_reset]
#set_property IOSTANDARD LVCMOS18 [get_ports dac_txen]
set_property -dict {PACKAGE_PIN V1 IOSTANDARD LVCMOS18} [get_ports adc_pd]

#set_property IOSTANDARD LVCMOS18 [get_ports {clkd_status[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {clkd_status[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports dac_irq]
set_property -dict {PACKAGE_PIN Y2 IOSTANDARD LVCMOS18} [get_ports adc_fda]
set_property -dict {PACKAGE_PIN Y1 IOSTANDARD LVCMOS18} [get_ports adc_fdb]

#set_property IOSTANDARD LVDS [get_ports trig_p]
#set_property DIFF_TERM_ADV TERM_100 [get_ports trig_p]
#set_property IOSTANDARD LVDS [get_ports trig_n]
#set_property DIFF_TERM_ADV TERM_100 [get_ports trig_n]

set_property LOC GTHE4_COMMON_X1Y2 [get_cells -hierarchical -filter {NAME =~ *i_ibufds_rx_ref_clk}]
#set_property PACKAGE_PIN G8 [get_ports rx_ref_clk_p]

# clocks

#create_clock -period 2.000 -name tx_ref_clk [get_ports tx_ref_clk_p]
create_clock -period 2.000 -name rx_ref_clk [get_ports rx_ref_clk_p]
#create_clock -period 4.000 -name tx_div_clk [get_pins i_system_wrapper/system_i/util_daq2_xcvr/inst/i_xch_0/i_gthe4_channel/TXOUTCLK]
create_clock -period 4.000 -name rx_div_clk [get_pins i_system_wrapper/system_i/util_daq2_xcvr/inst/i_xch_0/i_gthe4_channel/RXOUTCLK]

# pin assignments below are for reference only and are ignored by the tool!

## set_property  -dict {PACKAGE_PIN  L8} [get_ports rx_ref_clk_p]                                              ; ## B20  FMC_HPC0_GBTCLK1_M2C_P
## set_property  -dict {PACKAGE_PIN  L7} [get_ports rx_ref_clk_n]                                              ; ## B21  FMC_HPC0_GBTCLK1_M2C_N
## set_property  -dict {PACKAGE_PIN  G8} [get_ports tx_ref_clk_p]                                              ; ## D04  FMC_HPC0_GBTCLK0_M2C_P
## set_property  -dict {PACKAGE_PIN  G7} [get_ports tx_ref_clk_n]                                              ; ## D05  FMC_HPC0_GBTCLK0_M2C_N

set_property -dict {PACKAGE_PIN K2} [get_ports {rx_data_p[0]}]
set_property -dict {PACKAGE_PIN K1} [get_ports {rx_data_n[0]}]
set_property -dict {PACKAGE_PIN F2} [get_ports {rx_data_p[1]}]
set_property -dict {PACKAGE_PIN F1} [get_ports {rx_data_n[1]}]
set_property -dict {PACKAGE_PIN H2} [get_ports {rx_data_p[2]}]
set_property -dict {PACKAGE_PIN H1} [get_ports {rx_data_n[2]}]
set_property -dict {PACKAGE_PIN J4} [get_ports {rx_data_p[3]}]
set_property -dict {PACKAGE_PIN J3} [get_ports {rx_data_n[3]}]

#set_property  -dict {PACKAGE_PIN  K6} [get_ports tx_data_p[0]] ; ## A30  FMC_HPC0_DP3_C2M_P (tx_data_p[0])
#set_property  -dict {PACKAGE_PIN  K5} [get_ports tx_data_n[0]] ; ## A31  FMC_HPC0_DP3_C2M_N (tx_data_n[0])
#set_property  -dict {PACKAGE_PIN  G4} [get_ports tx_data_p[1]] ; ## C02  FMC_HPC0_DP0_C2M_P (tx_data_p[3])
#set_property  -dict {PACKAGE_PIN  G3} [get_ports tx_data_n[1]] ; ## C03  FMC_HPC0_DP0_C2M_N (tx_data_n[3])
#set_property  -dict {PACKAGE_PIN  F6} [get_ports tx_data_p[2]] ; ## A26  FMC_HPC0_DP2_C2M_P (tx_data_p[1])
#set_property  -dict {PACKAGE_PIN  F5} [get_ports tx_data_n[2]] ; ## A27  FMC_HPC0_DP2_C2M_N (tx_data_n[1])
#set_property  -dict {PACKAGE_PIN  H6} [get_ports tx_data_p[3]] ; ## A22  FMC_HPC0_DP1_C2M_P (tx_data_p[2])
#set_property  -dict {PACKAGE_PIN  H5} [get_ports tx_data_n[3]] ; ## A23  FMC_HPC0_DP1_C2M_N (tx_data_n[2])

set_property LOC GTHE4_CHANNEL_X1Y8 [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_0/i_gthe4_channel}]
set_property LOC GTHE4_CHANNEL_X1Y11 [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_1/i_gthe4_channel}]
set_property LOC GTHE4_CHANNEL_X1Y10 [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_2/i_gthe4_channel}]
set_property LOC GTHE4_CHANNEL_X1Y9 [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_3/i_gthe4_channel}]

set_property -dict {PACKAGE_PIN AA7} [get_ports rx_sysref_p]
set_property -dict {PACKAGE_PIN AA6} [get_ports rx_sysref_n]
set_property -dict {PACKAGE_PIN G8} [get_ports rx_ref_clk_p]
set_property -dict {PACKAGE_PIN G7} [get_ports rx_ref_clk_n]






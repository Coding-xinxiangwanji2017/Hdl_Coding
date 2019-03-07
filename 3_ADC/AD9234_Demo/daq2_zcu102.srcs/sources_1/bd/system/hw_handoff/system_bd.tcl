
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# start_LD

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu9eg-ffvb1156-2-e
   set_property BOARD_PART xilinx.com:zcu102:part0:3.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: axi_ad9680_jesd
proc create_hier_cell_axi_ad9680_jesd { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_axi_ad9680_jesd() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy2
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy3
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  # Create pins
  create_bd_pin -dir I -type clk device_clk
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir O lmfc_clk_0
  create_bd_pin -dir O lmfc_edge_0
  create_bd_pin -dir O phy_en_char_align
  create_bd_pin -dir O -from 127 -to 0 rx_data_tdata
  create_bd_pin -dir O rx_data_tvalid
  create_bd_pin -dir O -from 3 -to 0 rx_eof
  create_bd_pin -dir O -from 3 -to 0 rx_sof
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O -from 0 -to 0 sync
  create_bd_pin -dir I sysref

  # Create instance: rx, and set properties
  set rx [ create_bd_cell -type ip -vlnv analog.com:user:jesd204_rx:1.0 rx ]
  set_property -dict [ list \
   CONFIG.NUM_LANES {4} \
   CONFIG.NUM_LINKS {1} \
 ] $rx

  # Create instance: rx_axi, and set properties
  set rx_axi [ create_bd_cell -type ip -vlnv analog.com:user:axi_jesd204_rx:1.0 rx_axi ]
  set_property -dict [ list \
   CONFIG.NUM_LANES {4} \
   CONFIG.NUM_LINKS {1} \
 ] $rx_axi

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /axi_ad9680_jesd/rx_axi/s_axi]

  # Create interface connections
  connect_bd_intf_net -intf_net rx_axi_rx_cfg [get_bd_intf_pins rx/rx_cfg] [get_bd_intf_pins rx_axi/rx_cfg]
  connect_bd_intf_net -intf_net rx_phy0_1 [get_bd_intf_pins rx_phy0] [get_bd_intf_pins rx/rx_phy0]
  connect_bd_intf_net -intf_net rx_phy1_1 [get_bd_intf_pins rx_phy1] [get_bd_intf_pins rx/rx_phy1]
  connect_bd_intf_net -intf_net rx_phy2_1 [get_bd_intf_pins rx_phy2] [get_bd_intf_pins rx/rx_phy2]
  connect_bd_intf_net -intf_net rx_phy3_1 [get_bd_intf_pins rx_phy3] [get_bd_intf_pins rx/rx_phy3]
  connect_bd_intf_net -intf_net rx_rx_event [get_bd_intf_pins rx/rx_event] [get_bd_intf_pins rx_axi/rx_event]
  connect_bd_intf_net -intf_net rx_rx_ilas_config [get_bd_intf_pins rx/rx_ilas_config] [get_bd_intf_pins rx_axi/rx_ilas_config]
  connect_bd_intf_net -intf_net rx_rx_status [get_bd_intf_pins rx/rx_status] [get_bd_intf_pins rx_axi/rx_status]
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins rx_axi/s_axi]

  # Create port connections
  connect_bd_net -net device_clk_1 [get_bd_pins device_clk] [get_bd_pins rx/clk] [get_bd_pins rx_axi/core_clk]
  connect_bd_net -net rx_axi_core_reset [get_bd_pins rx/reset] [get_bd_pins rx_axi/core_reset]
  connect_bd_net -net rx_axi_irq [get_bd_pins irq] [get_bd_pins rx_axi/irq]
  connect_bd_net -net rx_lmfc_clk [get_bd_pins lmfc_clk_0] [get_bd_pins rx/lmfc_clk]
  connect_bd_net -net rx_lmfc_edge [get_bd_pins lmfc_edge_0] [get_bd_pins rx/lmfc_edge]
  connect_bd_net -net rx_phy_en_char_align [get_bd_pins phy_en_char_align] [get_bd_pins rx/phy_en_char_align]
  connect_bd_net -net rx_rx_data [get_bd_pins rx_data_tdata] [get_bd_pins rx/rx_data]
  connect_bd_net -net rx_rx_eof [get_bd_pins rx_eof] [get_bd_pins rx/rx_eof]
  connect_bd_net -net rx_rx_sof [get_bd_pins rx_sof] [get_bd_pins rx/rx_sof]
  connect_bd_net -net rx_rx_valid [get_bd_pins rx_data_tvalid] [get_bd_pins rx/rx_valid]
  connect_bd_net -net rx_sync [get_bd_pins sync] [get_bd_pins rx/sync]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins rx_axi/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins rx_axi/s_axi_aresetn]
  connect_bd_net -net sysref_1 [get_bd_pins sysref] [get_bd_pins rx/sysref]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set adc_fda [ create_bd_port -dir I adc_fda ]
  set adc_fdb [ create_bd_port -dir I adc_fdb ]
  set clk_in1_0 [ create_bd_port -dir I -type clk clk_in1_0 ]
  set clk_out200M [ create_bd_port -dir O -type clk clk_out200M ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
 ] $clk_out200M
  set gpio_i [ create_bd_port -dir I -from 94 -to 0 gpio_i ]
  set gpio_o [ create_bd_port -dir O -from 94 -to 0 gpio_o ]
  set gpio_t [ create_bd_port -dir O -from 94 -to 0 gpio_t ]
  set lmfc_clk [ create_bd_port -dir O lmfc_clk ]
  set lmfc_edge [ create_bd_port -dir O lmfc_edge ]
  set ps_intr_00 [ create_bd_port -dir I -type intr ps_intr_00 ]
  set ps_intr_01 [ create_bd_port -dir I -type intr ps_intr_01 ]
  set ps_intr_02 [ create_bd_port -dir I -type intr ps_intr_02 ]
  set ps_intr_03 [ create_bd_port -dir I -type intr ps_intr_03 ]
  set ps_intr_04 [ create_bd_port -dir I -type intr ps_intr_04 ]
  set ps_intr_05 [ create_bd_port -dir I -type intr ps_intr_05 ]
  set ps_intr_06 [ create_bd_port -dir I -type intr ps_intr_06 ]
  set ps_intr_07 [ create_bd_port -dir I -type intr ps_intr_07 ]
  set ps_intr_08 [ create_bd_port -dir I -type intr ps_intr_08 ]
  set ps_intr_09 [ create_bd_port -dir I -type intr ps_intr_09 ]
  set ps_intr_14 [ create_bd_port -dir I -type intr ps_intr_14 ]
  set ps_intr_15 [ create_bd_port -dir I -type intr ps_intr_15 ]
  set rx_data_0_n [ create_bd_port -dir I rx_data_0_n ]
  set rx_data_0_p [ create_bd_port -dir I rx_data_0_p ]
  set rx_data_1_n [ create_bd_port -dir I rx_data_1_n ]
  set rx_data_1_p [ create_bd_port -dir I rx_data_1_p ]
  set rx_data_2_n [ create_bd_port -dir I rx_data_2_n ]
  set rx_data_2_p [ create_bd_port -dir I rx_data_2_p ]
  set rx_data_3_n [ create_bd_port -dir I rx_data_3_n ]
  set rx_data_3_p [ create_bd_port -dir I rx_data_3_p ]
  set rx_out_clk [ create_bd_port -dir O -type clk rx_out_clk ]
  set rx_ref_clk_0 [ create_bd_port -dir I rx_ref_clk_0 ]
  set rx_sync_0 [ create_bd_port -dir O -from 0 -to 0 rx_sync_0 ]
  set rx_sysref_0 [ create_bd_port -dir I rx_sysref_0 ]
  set spi0_csn [ create_bd_port -dir O -from 2 -to 0 spi0_csn ]
  set spi0_miso [ create_bd_port -dir I spi0_miso ]
  set spi0_mosi [ create_bd_port -dir O spi0_mosi ]
  set spi0_sclk [ create_bd_port -dir O spi0_sclk ]
  set spi1_csn [ create_bd_port -dir O -from 2 -to 0 spi1_csn ]
  set spi1_miso [ create_bd_port -dir I spi1_miso ]
  set spi1_mosi [ create_bd_port -dir O spi1_mosi ]
  set spi1_sclk [ create_bd_port -dir O spi1_sclk ]
  set start1 [ create_bd_port -dir O -type data start1 ]
  set tx_data_0_n [ create_bd_port -dir O tx_data_0_n ]
  set tx_data_0_p [ create_bd_port -dir O tx_data_0_p ]
  set tx_data_1_n [ create_bd_port -dir O tx_data_1_n ]
  set tx_data_1_p [ create_bd_port -dir O tx_data_1_p ]
  set tx_data_2_n [ create_bd_port -dir O tx_data_2_n ]
  set tx_data_2_p [ create_bd_port -dir O tx_data_2_p ]
  set tx_data_3_n [ create_bd_port -dir O tx_data_3_n ]
  set tx_data_3_p [ create_bd_port -dir O tx_data_3_p ]

  # Create instance: axi_ad9680_core, and set properties
  set axi_ad9680_core [ create_bd_cell -type ip -vlnv analog.com:user:axi_ad9680:1.0 axi_ad9680_core ]

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /axi_ad9680_core/s_axi]

  # Create instance: axi_ad9680_cpack, and set properties
  set axi_ad9680_cpack [ create_bd_cell -type ip -vlnv analog.com:user:util_cpack:1.0 axi_ad9680_cpack ]
  set_property -dict [ list \
   CONFIG.CHANNEL_DATA_WIDTH {64} \
   CONFIG.NUM_OF_CHANNELS {2} \
 ] $axi_ad9680_cpack

  # Create instance: axi_ad9680_dma, and set properties
  set axi_ad9680_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9680_dma ]
  set_property -dict [ list \
   CONFIG.AXI_SLICE_DEST {false} \
   CONFIG.AXI_SLICE_SRC {false} \
   CONFIG.CYCLIC {false} \
   CONFIG.DMA_2D_TRANSFER {false} \
   CONFIG.DMA_DATA_WIDTH_DEST {64} \
   CONFIG.DMA_DATA_WIDTH_SRC {64} \
   CONFIG.DMA_LENGTH_WIDTH {24} \
   CONFIG.DMA_TYPE_DEST {0} \
   CONFIG.DMA_TYPE_SRC {1} \
   CONFIG.ID {0} \
   CONFIG.SYNC_TRANSFER_START {false} \
 ] $axi_ad9680_dma

  # Create instance: axi_ad9680_fifo, and set properties
  set axi_ad9680_fifo [ create_bd_cell -type ip -vlnv analog.com:user:util_adcfifo:1.0 axi_ad9680_fifo ]
  set_property -dict [ list \
   CONFIG.ADC_DATA_WIDTH {128} \
   CONFIG.DMA_ADDRESS_WIDTH {16} \
   CONFIG.DMA_DATA_WIDTH {64} \
   CONFIG.DMA_READY_ENABLE {1} \
 ] $axi_ad9680_fifo

  # Create instance: axi_ad9680_jesd
  create_hier_cell_axi_ad9680_jesd [current_bd_instance .] axi_ad9680_jesd

  # Create instance: axi_ad9680_jesd_rstgen, and set properties
  set axi_ad9680_jesd_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_ad9680_jesd_rstgen ]

  # Create instance: axi_ad9680_xcvr, and set properties
  set axi_ad9680_xcvr [ create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_ad9680_xcvr ]
  set_property -dict [ list \
   CONFIG.NUM_OF_LANES {4} \
   CONFIG.OUT_CLK_SEL {"011"} \
   CONFIG.QPLL_ENABLE {0} \
   CONFIG.TX_OR_RX_N {0} \
   CONFIG.XCVR_TYPE {2} \
 ] $axi_ad9680_xcvr

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /axi_ad9680_xcvr/m_axi]

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /axi_ad9680_xcvr/s_axi]

  # Create instance: axi_cpu_interconnect, and set properties
  set axi_cpu_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {8} \
 ] $axi_cpu_interconnect

  # Create instance: axi_hp2_interconnect, and set properties
  set axi_hp2_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_hp2_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_hp2_interconnect

  # Create instance: axi_hp3_interconnect, and set properties
  set axi_hp3_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_hp3_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_hp3_interconnect

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {100.0} \
   CONFIG.CLKOUT1_JITTER {114.829} \
   CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
   CONFIG.CLKOUT2_JITTER {97.082} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {500} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {Custom} \
   CONFIG.CLK_OUT1_PORT {clk_out200M} \
   CONFIG.CLK_OUT2_PORT {clk_out500M} \
   CONFIG.ENABLE_CLOCK_MONITOR {false} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {5.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {2} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {false} \
 ] $clk_wiz_0

  # Create instance: format_9234_timestamp_0, and set properties
  set format_9234_timestamp_0 [ create_bd_cell -type ip -vlnv zvision:user:format_9234_timestamp:1.0 format_9234_timestamp_0 ]
  set_property -dict [ list \
   CONFIG.RECV64_CNT {250} \
   CONFIG.TRIGtoPSIRQ_DELAY {0} \
   CONFIG.TRIGtoRECV_DELAY {0} \
 ] $format_9234_timestamp_0

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU_CNT {2} \
   CONFIG.C_ADV_TRIGGER {true} \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_EN_STRG_QUAL {1} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {12} \
   CONFIG.C_PROBE0_MU_CNT {2} \
   CONFIG.C_PROBE0_WIDTH {1} \
   CONFIG.C_PROBE10_WIDTH {64} \
   CONFIG.C_PROBE11_WIDTH {64} \
   CONFIG.C_PROBE16_WIDTH {1} \
   CONFIG.C_PROBE17_WIDTH {1} \
   CONFIG.C_PROBE22_WIDTH {1} \
   CONFIG.C_PROBE2_WIDTH {64} \
   CONFIG.C_PROBE3_WIDTH {12} \
   CONFIG.C_PROBE4_WIDTH {12} \
 ] $ila_0

  # Create instance: spi0_csn_concat, and set properties
  set spi0_csn_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 spi0_csn_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $spi0_csn_concat

  # Create instance: spi1_csn_concat, and set properties
  set spi1_csn_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 spi1_csn_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $spi1_csn_concat

  # Create instance: start_LD_0, and set properties
  set block_name start_LD
  set block_cell_name start_LD_0
  if { [catch {set start_LD_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $start_LD_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.HIGH_PERIOD {0x00000007} \
   CONFIG.TOTAL_PERIOD {0x0003D090} \
 ] $start_LD_0

  # Create instance: sys_concat_intc_0, and set properties
  set sys_concat_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $sys_concat_intc_0

  # Create instance: sys_concat_intc_1, and set properties
  set sys_concat_intc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $sys_concat_intc_1

  # Create instance: sys_ps8, and set properties
  set sys_ps8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.1 sys_ps8 ]
  set_property -dict [ list \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_10_DIRECTION {inout} \
   CONFIG.PSU_MIO_11_DIRECTION {inout} \
   CONFIG.PSU_MIO_12_DIRECTION {out} \
   CONFIG.PSU_MIO_12_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_18_DIRECTION {in} \
   CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_18_SLEW {slow} \
   CONFIG.PSU_MIO_19_DIRECTION {out} \
   CONFIG.PSU_MIO_19_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_DIRECTION {out} \
   CONFIG.PSU_MIO_20_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_21_DIRECTION {in} \
   CONFIG.PSU_MIO_21_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_21_SLEW {slow} \
   CONFIG.PSU_MIO_22_DIRECTION {inout} \
   CONFIG.PSU_MIO_23_DIRECTION {inout} \
   CONFIG.PSU_MIO_24_DIRECTION {out} \
   CONFIG.PSU_MIO_24_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_25_DIRECTION {in} \
   CONFIG.PSU_MIO_25_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_25_SLEW {slow} \
   CONFIG.PSU_MIO_26_DIRECTION {inout} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_SLEW {slow} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_SLEW {slow} \
   CONFIG.PSU_MIO_31_DIRECTION {out} \
   CONFIG.PSU_MIO_31_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_32_DIRECTION {out} \
   CONFIG.PSU_MIO_32_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_33_DIRECTION {out} \
   CONFIG.PSU_MIO_33_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_34_DIRECTION {out} \
   CONFIG.PSU_MIO_34_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_35_DIRECTION {out} \
   CONFIG.PSU_MIO_35_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_36_DIRECTION {out} \
   CONFIG.PSU_MIO_36_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_37_DIRECTION {out} \
   CONFIG.PSU_MIO_37_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_42_DIRECTION {inout} \
   CONFIG.PSU_MIO_43_DIRECTION {inout} \
   CONFIG.PSU_MIO_44_DIRECTION {in} \
   CONFIG.PSU_MIO_44_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_44_SLEW {slow} \
   CONFIG.PSU_MIO_45_DIRECTION {in} \
   CONFIG.PSU_MIO_45_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_45_SLEW {slow} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_SLEW {slow} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_SLEW {slow} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_SLEW {slow} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_64_DIRECTION {out} \
   CONFIG.PSU_MIO_64_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_65_DIRECTION {out} \
   CONFIG.PSU_MIO_65_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_66_DIRECTION {out} \
   CONFIG.PSU_MIO_66_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_67_DIRECTION {out} \
   CONFIG.PSU_MIO_67_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_68_DIRECTION {out} \
   CONFIG.PSU_MIO_68_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_69_DIRECTION {out} \
   CONFIG.PSU_MIO_69_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_6_DIRECTION {out} \
   CONFIG.PSU_MIO_6_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_70_DIRECTION {in} \
   CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_70_SLEW {slow} \
   CONFIG.PSU_MIO_71_DIRECTION {in} \
   CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_71_SLEW {slow} \
   CONFIG.PSU_MIO_72_DIRECTION {in} \
   CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_72_SLEW {slow} \
   CONFIG.PSU_MIO_73_DIRECTION {in} \
   CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_73_SLEW {slow} \
   CONFIG.PSU_MIO_74_DIRECTION {in} \
   CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_74_SLEW {slow} \
   CONFIG.PSU_MIO_75_DIRECTION {in} \
   CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_75_SLEW {slow} \
   CONFIG.PSU_MIO_76_DIRECTION {out} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_7_DIRECTION {out} \
   CONFIG.PSU_MIO_7_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_8_DIRECTION {inout} \
   CONFIG.PSU_MIO_9_DIRECTION {inout} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#UART 1#UART 1#GPIO0 MIO#GPIO0 MIO#CAN 1#CAN 1#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#PCIE#PMU GPO 0#PMU GPO 1#PMU GPO 2#PMU GPO 3#PMU GPO 4#PMU GPO 5#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
   CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#txd#rxd#gpio0[22]#gpio0[23]#phy_tx#phy_rx#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#reset_n#gpo[0]#gpo[1]#gpo[2]#gpo[3]#gpo[4]#gpo[5]#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#gpio1[43]#sdio1_wp#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.560059} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__CAN1__PERIPHERAL__IO {MIO 24 .. 25} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.880} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.975} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.975} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.280} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.940} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.997} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {16} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.664} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.970} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.940} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {499.950} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__ACT_FREQMHZ {249.975} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {249.975} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.280} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.950} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.995} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.950} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.975} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.850} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.987} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.975} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.975} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.950} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.481} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {187.481} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {124.987} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.481} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.990} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.975} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.998} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {NA} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {15} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
   CONFIG.PSU__DDRC__CWL {14} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {8 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__EN_2ND_CLK {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
   CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {30.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {33} \
   CONFIG.PSU__DDRC__T_RC {47.06} \
   CONFIG.PSU__DDRC__T_RCD {15} \
   CONFIG.PSU__DDRC__T_RP {15} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Single Lower} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk3} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.989998} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {99.989998} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__FPGA_PL1_ENABLE {1} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO_WIDTH {95} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {95} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.989998} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {99.989998} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PCIE__BAR0_64BIT {0} \
   CONFIG.PSU__PCIE__BAR0_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR0_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR0_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR1_64BIT {0} \
   CONFIG.PSU__PCIE__BAR1_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR1_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR1_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR2_64BIT {0} \
   CONFIG.PSU__PCIE__BAR2_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR2_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR2_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR3_64BIT {0} \
   CONFIG.PSU__PCIE__BAR3_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR3_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR3_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR4_64BIT {0} \
   CONFIG.PSU__PCIE__BAR4_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR4_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR4_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR5_64BIT {0} \
   CONFIG.PSU__PCIE__BAR5_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR5_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR5_VAL {0x0} \
   CONFIG.PSU__PCIE__CLASS_CODE_BASE {0x06} \
   CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {0x0} \
   CONFIG.PSU__PCIE__CLASS_CODE_SUB {0x4} \
   CONFIG.PSU__PCIE__CLASS_CODE_VALUE {0x60400} \
   CONFIG.PSU__PCIE__CRS_SW_VISIBILITY {1} \
   CONFIG.PSU__PCIE__DEVICE_ID {0xD021} \
   CONFIG.PSU__PCIE__DEVICE_PORT_TYPE {Root Port} \
   CONFIG.PSU__PCIE__EROM_ENABLE {0} \
   CONFIG.PSU__PCIE__EROM_VAL {0x0} \
   CONFIG.PSU__PCIE__LANE0__ENABLE {1} \
   CONFIG.PSU__PCIE__LANE0__IO {GT Lane0} \
   CONFIG.PSU__PCIE__LANE1__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE2__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE3__ENABLE {0} \
   CONFIG.PSU__PCIE__LINK_SPEED {5.0 Gb/s} \
   CONFIG.PSU__PCIE__MAXIMUM_LINK_WIDTH {x1} \
   CONFIG.PSU__PCIE__MAX_PAYLOAD_SIZE {256 bytes} \
   CONFIG.PSU__PCIE__MSIX_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_CAPABILITY {0} \
   CONFIG.PSU__PCIE__MSIX_PBA_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_PBA_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_SIZE {0} \
   CONFIG.PSU__PCIE__MSI_64BIT_ADDR_CAPABLE {0} \
   CONFIG.PSU__PCIE__MSI_CAPABILITY {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {1} \
   CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_IO {MIO 31} \
   CONFIG.PSU__PCIE__REF_CLK_FREQ {100} \
   CONFIG.PSU__PCIE__REF_CLK_SEL {Ref Clk0} \
   CONFIG.PSU__PCIE__RESET__POLARITY {Active Low} \
   CONFIG.PSU__PCIE__REVISION_ID {0x0} \
   CONFIG.PSU__PCIE__SUBSYSTEM_ID {0x7} \
   CONFIG.PSU__PCIE__SUBSYSTEM_VENDOR_ID {0x10EE} \
   CONFIG.PSU__PCIE__VENDOR_ID {0x10EE} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PL_CLK1_BUF {TRUE} \
   CONFIG.PSU__PMU_COHERENCY {0} \
   CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
   CONFIG.PSU__PMU__GPI0__ENABLE {0} \
   CONFIG.PSU__PMU__GPI1__ENABLE {0} \
   CONFIG.PSU__PMU__GPI2__ENABLE {0} \
   CONFIG.PSU__PMU__GPI3__ENABLE {0} \
   CONFIG.PSU__PMU__GPI4__ENABLE {0} \
   CONFIG.PSU__PMU__GPI5__ENABLE {0} \
   CONFIG.PSU__PMU__GPO0__ENABLE {1} \
   CONFIG.PSU__PMU__GPO0__IO {MIO 32} \
   CONFIG.PSU__PMU__GPO1__ENABLE {1} \
   CONFIG.PSU__PMU__GPO1__IO {MIO 33} \
   CONFIG.PSU__PMU__GPO2__ENABLE {1} \
   CONFIG.PSU__PMU__GPO2__IO {MIO 34} \
   CONFIG.PSU__PMU__GPO3__ENABLE {1} \
   CONFIG.PSU__PMU__GPO3__IO {MIO 35} \
   CONFIG.PSU__PMU__GPO4__ENABLE {1} \
   CONFIG.PSU__PMU__GPO4__IO {MIO 36} \
   CONFIG.PSU__PMU__GPO5__ENABLE {1} \
   CONFIG.PSU__PMU__GPO5__IO {MIO 37} \
   CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
   CONFIG.PSU__PRESET_APPLIED {1} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;0|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;1|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;1|LPD;SPI0;FF040000;FF04FFFF;1|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|FPD;RCPU_GIC;F9000000;F900FFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;1|FPD;PCIE_LOW;E0000000;EFFFFFFF;1|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;1|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;1|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;1|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;1|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;1|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9000000;F907FFFF;1} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.330} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
   CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {1} \
   CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
   CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_WP__IO {MIO 44} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
   CONFIG.PSU__SPI0__GRP_SS0__ENABLE {1} \
   CONFIG.PSU__SPI0__GRP_SS0__IO {EMIO} \
   CONFIG.PSU__SPI0__GRP_SS1__ENABLE {1} \
   CONFIG.PSU__SPI0__GRP_SS1__IO {EMIO} \
   CONFIG.PSU__SPI0__GRP_SS2__ENABLE {1} \
   CONFIG.PSU__SPI0__GRP_SS2__IO {EMIO} \
   CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SPI0__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__SPI1__GRP_SS0__ENABLE {1} \
   CONFIG.PSU__SPI1__GRP_SS0__IO {EMIO} \
   CONFIG.PSU__SPI1__GRP_SS1__ENABLE {1} \
   CONFIG.PSU__SPI1__GRP_SS1__IO {EMIO} \
   CONFIG.PSU__SPI1__GRP_SS2__ENABLE {1} \
   CONFIG.PSU__SPI1__GRP_SS2__IO {EMIO} \
   CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SPI1__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
   CONFIG.PSU__UART1__BAUD_RATE {115200} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 20 .. 21} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
   CONFIG.PSU__USE__AUDIO {0} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__IRQ1 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {0} \
   CONFIG.PSU__USE__M_AXI_GP1 {0} \
   CONFIG.PSU__USE__M_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP3 {1} \
   CONFIG.PSU__USE__S_AXI_GP4 {1} \
   CONFIG.PSU__USE__S_AXI_GP5 {1} \
   CONFIG.PSU__USE__VIDEO {0} \
 ] $sys_ps8

  # Create instance: sys_ps8_emio_spi0_s_i_GND, and set properties
  set sys_ps8_emio_spi0_s_i_GND [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 sys_ps8_emio_spi0_s_i_GND ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $sys_ps8_emio_spi0_s_i_GND

  # Create instance: sys_ps8_emio_spi0_sclk_i_GND, and set properties
  set sys_ps8_emio_spi0_sclk_i_GND [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 sys_ps8_emio_spi0_sclk_i_GND ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $sys_ps8_emio_spi0_sclk_i_GND

  # Create instance: sys_ps8_emio_spi0_ss_i_n_VCC, and set properties
  set sys_ps8_emio_spi0_ss_i_n_VCC [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 sys_ps8_emio_spi0_ss_i_n_VCC ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {-1} \
   CONFIG.CONST_WIDTH {1} \
 ] $sys_ps8_emio_spi0_ss_i_n_VCC

  # Create instance: sys_ps8_emio_spi1_s_i_GND, and set properties
  set sys_ps8_emio_spi1_s_i_GND [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 sys_ps8_emio_spi1_s_i_GND ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $sys_ps8_emio_spi1_s_i_GND

  # Create instance: sys_ps8_emio_spi1_sclk_i_GND, and set properties
  set sys_ps8_emio_spi1_sclk_i_GND [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 sys_ps8_emio_spi1_sclk_i_GND ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $sys_ps8_emio_spi1_sclk_i_GND

  # Create instance: sys_ps8_emio_spi1_ss_i_n_VCC, and set properties
  set sys_ps8_emio_spi1_ss_i_n_VCC [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 sys_ps8_emio_spi1_ss_i_n_VCC ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {-1} \
   CONFIG.CONST_WIDTH {1} \
 ] $sys_ps8_emio_spi1_ss_i_n_VCC

  # Create instance: sys_ps8_emio_spi1_ss_i_n_VCC1, and set properties
  set sys_ps8_emio_spi1_ss_i_n_VCC1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 sys_ps8_emio_spi1_ss_i_n_VCC1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {-1} \
   CONFIG.CONST_WIDTH {1} \
 ] $sys_ps8_emio_spi1_ss_i_n_VCC1

  # Create instance: sys_rstgen, and set properties
  set sys_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen ]
  set_property -dict [ list \
   CONFIG.C_EXT_RST_WIDTH {1} \
 ] $sys_rstgen

  # Create instance: util_daq2_xcvr, and set properties
  set util_daq2_xcvr [ create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_daq2_xcvr ]
  set_property -dict [ list \
   CONFIG.QPLL_FBDIV {"0000101000"} \
   CONFIG.QPLL_REFCLK_DIV {1} \
   CONFIG.RX_NUM_OF_LANES {4} \
   CONFIG.TX_NUM_OF_LANES {4} \
   CONFIG.XCVR_TYPE {2} \
 ] $util_daq2_xcvr

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_ps8/M_AXI_HPM0_LPD]
  connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins axi_ad9680_xcvr/m_axi] [get_bd_intf_pins axi_hp3_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_4 [get_bd_intf_pins axi_ad9680_dma/m_dest_axi] [get_bd_intf_pins axi_hp2_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_ad9680_xcvr_up_ch_0 [get_bd_intf_pins axi_ad9680_xcvr/up_ch_0] [get_bd_intf_pins util_daq2_xcvr/up_rx_0]
  connect_bd_intf_net -intf_net axi_ad9680_xcvr_up_ch_1 [get_bd_intf_pins axi_ad9680_xcvr/up_ch_1] [get_bd_intf_pins util_daq2_xcvr/up_rx_1]
  connect_bd_intf_net -intf_net axi_ad9680_xcvr_up_ch_2 [get_bd_intf_pins axi_ad9680_xcvr/up_ch_2] [get_bd_intf_pins util_daq2_xcvr/up_rx_2]
  connect_bd_intf_net -intf_net axi_ad9680_xcvr_up_ch_3 [get_bd_intf_pins axi_ad9680_xcvr/up_ch_3] [get_bd_intf_pins util_daq2_xcvr/up_rx_3]
  connect_bd_intf_net -intf_net axi_ad9680_xcvr_up_es_0 [get_bd_intf_pins axi_ad9680_xcvr/up_es_0] [get_bd_intf_pins util_daq2_xcvr/up_es_0]
  connect_bd_intf_net -intf_net axi_ad9680_xcvr_up_es_1 [get_bd_intf_pins axi_ad9680_xcvr/up_es_1] [get_bd_intf_pins util_daq2_xcvr/up_es_1]
  connect_bd_intf_net -intf_net axi_ad9680_xcvr_up_es_2 [get_bd_intf_pins axi_ad9680_xcvr/up_es_2] [get_bd_intf_pins util_daq2_xcvr/up_es_2]
  connect_bd_intf_net -intf_net axi_ad9680_xcvr_up_es_3 [get_bd_intf_pins axi_ad9680_xcvr/up_es_3] [get_bd_intf_pins util_daq2_xcvr/up_es_3]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M04_AXI [get_bd_intf_pins axi_ad9680_xcvr/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M04_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M05_AXI [get_bd_intf_pins axi_ad9680_core/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M05_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M06_AXI [get_bd_intf_pins axi_ad9680_jesd/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M06_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M07_AXI [get_bd_intf_pins axi_ad9680_dma/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M07_AXI]
  connect_bd_intf_net -intf_net axi_hp2_interconnect_M00_AXI [get_bd_intf_pins axi_hp2_interconnect/M00_AXI] [get_bd_intf_pins sys_ps8/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net axi_hp3_interconnect_M00_AXI [get_bd_intf_pins axi_hp3_interconnect/M00_AXI] [get_bd_intf_pins sys_ps8/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net util_daq2_xcvr_rx_0 [get_bd_intf_pins axi_ad9680_jesd/rx_phy0] [get_bd_intf_pins util_daq2_xcvr/rx_0]
  connect_bd_intf_net -intf_net util_daq2_xcvr_rx_1 [get_bd_intf_pins axi_ad9680_jesd/rx_phy1] [get_bd_intf_pins util_daq2_xcvr/rx_1]
  connect_bd_intf_net -intf_net util_daq2_xcvr_rx_2 [get_bd_intf_pins axi_ad9680_jesd/rx_phy2] [get_bd_intf_pins util_daq2_xcvr/rx_2]
  connect_bd_intf_net -intf_net util_daq2_xcvr_rx_3 [get_bd_intf_pins axi_ad9680_jesd/rx_phy3] [get_bd_intf_pins util_daq2_xcvr/rx_3]

  # Create port connections
  connect_bd_net -net axi_ad9680_core_adc_data_0 [get_bd_pins axi_ad9680_core/adc_data_0] [get_bd_pins format_9234_timestamp_0/in_0] [get_bd_pins ila_0/probe10]
  connect_bd_net -net axi_ad9680_core_adc_data_1 [get_bd_pins axi_ad9680_core/adc_data_1] [get_bd_pins format_9234_timestamp_0/in_1] [get_bd_pins ila_0/probe11]
  connect_bd_net -net axi_ad9680_core_adc_enable_0 [get_bd_pins axi_ad9680_core/adc_enable_0] [get_bd_pins format_9234_timestamp_0/i_adc_enable_0]
  connect_bd_net -net axi_ad9680_core_adc_enable_1 [get_bd_pins axi_ad9680_core/adc_enable_1] [get_bd_pins format_9234_timestamp_0/i_adc_enable_1]
  connect_bd_net -net axi_ad9680_core_adc_valid_0 [get_bd_pins axi_ad9680_core/adc_valid_0] [get_bd_pins format_9234_timestamp_0/i_adc_valid_0]
  connect_bd_net -net axi_ad9680_core_adc_valid_1 [get_bd_pins axi_ad9680_core/adc_valid_1] [get_bd_pins format_9234_timestamp_0/i_adc_valid_1]
  connect_bd_net -net axi_ad9680_cpack_adc_data [get_bd_pins axi_ad9680_cpack/adc_data] [get_bd_pins axi_ad9680_fifo/adc_wdata]
  connect_bd_net -net axi_ad9680_cpack_adc_valid [get_bd_pins axi_ad9680_cpack/adc_valid] [get_bd_pins axi_ad9680_fifo/adc_wr]
  connect_bd_net -net axi_ad9680_dma_irq [get_bd_pins axi_ad9680_dma/irq] [get_bd_pins sys_concat_intc_1/In5]
  connect_bd_net -net axi_ad9680_dma_s_axis_ready [get_bd_pins axi_ad9680_dma/s_axis_ready] [get_bd_pins axi_ad9680_fifo/dma_wready]
  connect_bd_net -net axi_ad9680_dma_s_axis_xfer_req [get_bd_pins axi_ad9680_dma/s_axis_xfer_req] [get_bd_pins axi_ad9680_fifo/dma_xfer_req]
  connect_bd_net -net axi_ad9680_fifo_adc_wovf [get_bd_pins axi_ad9680_core/adc_dovf] [get_bd_pins axi_ad9680_fifo/adc_wovf]
  connect_bd_net -net axi_ad9680_fifo_dma_wdata [get_bd_pins axi_ad9680_dma/s_axis_data] [get_bd_pins axi_ad9680_fifo/dma_wdata]
  connect_bd_net -net axi_ad9680_fifo_dma_wr [get_bd_pins axi_ad9680_dma/s_axis_valid] [get_bd_pins axi_ad9680_fifo/dma_wr]
  connect_bd_net -net axi_ad9680_jesd_irq [get_bd_pins axi_ad9680_jesd/irq] [get_bd_pins sys_concat_intc_1/In3]
  connect_bd_net -net axi_ad9680_jesd_lmfc_clk_0 [get_bd_ports lmfc_clk] [get_bd_pins axi_ad9680_jesd/lmfc_clk_0]
  connect_bd_net -net axi_ad9680_jesd_lmfc_edge_0 [get_bd_ports lmfc_edge] [get_bd_pins axi_ad9680_jesd/lmfc_edge_0]
  connect_bd_net -net axi_ad9680_jesd_phy_en_char_align [get_bd_pins axi_ad9680_jesd/phy_en_char_align] [get_bd_pins util_daq2_xcvr/rx_calign_0] [get_bd_pins util_daq2_xcvr/rx_calign_1] [get_bd_pins util_daq2_xcvr/rx_calign_2] [get_bd_pins util_daq2_xcvr/rx_calign_3]
  connect_bd_net -net axi_ad9680_jesd_rstgen_peripheral_aresetn [get_bd_pins axi_ad9680_jesd_rstgen/peripheral_aresetn] [get_bd_pins format_9234_timestamp_0/rst_n]
  connect_bd_net -net axi_ad9680_jesd_rstgen_peripheral_reset [get_bd_pins axi_ad9680_cpack/adc_rst] [get_bd_pins axi_ad9680_fifo/adc_rst] [get_bd_pins axi_ad9680_jesd_rstgen/peripheral_reset]
  connect_bd_net -net axi_ad9680_jesd_rx_data_tdata [get_bd_pins axi_ad9680_core/rx_data] [get_bd_pins axi_ad9680_jesd/rx_data_tdata]
  connect_bd_net -net axi_ad9680_jesd_rx_sof [get_bd_pins axi_ad9680_core/rx_sof] [get_bd_pins axi_ad9680_jesd/rx_sof]
  connect_bd_net -net axi_ad9680_jesd_sync [get_bd_ports rx_sync_0] [get_bd_pins axi_ad9680_jesd/sync]
  connect_bd_net -net axi_ad9680_xcvr_up_pll_rst [get_bd_pins axi_ad9680_xcvr/up_pll_rst] [get_bd_pins util_daq2_xcvr/up_cpll_rst_0] [get_bd_pins util_daq2_xcvr/up_cpll_rst_1] [get_bd_pins util_daq2_xcvr/up_cpll_rst_2] [get_bd_pins util_daq2_xcvr/up_cpll_rst_3] [get_bd_pins util_daq2_xcvr/up_qpll_rst_0]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports clk_in1_0] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out200M [get_bd_ports clk_out200M] [get_bd_pins clk_wiz_0/clk_out200M]
  connect_bd_net -net format_9234_timestamp_0_o_adc_enable_0 [get_bd_pins axi_ad9680_cpack/adc_enable_0] [get_bd_pins format_9234_timestamp_0/o_adc_enable_0] [get_bd_pins ila_0/probe8]
  connect_bd_net -net format_9234_timestamp_0_o_adc_enable_1 [get_bd_pins axi_ad9680_cpack/adc_enable_1] [get_bd_pins format_9234_timestamp_0/o_adc_enable_1] [get_bd_pins ila_0/probe9]
  connect_bd_net -net format_9234_timestamp_0_o_adc_valid_0 [get_bd_pins axi_ad9680_cpack/adc_valid_0] [get_bd_pins format_9234_timestamp_0/o_adc_valid_0] [get_bd_pins ila_0/probe6]
  connect_bd_net -net format_9234_timestamp_0_o_adc_valid_1 [get_bd_pins axi_ad9680_cpack/adc_valid_1] [get_bd_pins format_9234_timestamp_0/o_adc_valid_1] [get_bd_pins ila_0/probe7]
  connect_bd_net -net format_9234_timestamp_0_o_ps_irq [get_bd_pins format_9234_timestamp_0/o_ps_irq] [get_bd_pins ila_0/probe5] [get_bd_pins sys_concat_intc_1/In2]
  connect_bd_net -net format_9234_timestamp_0_out_0 [get_bd_pins axi_ad9680_cpack/adc_data_0] [get_bd_pins format_9234_timestamp_0/out_0] [get_bd_pins ila_0/probe1]
  connect_bd_net -net format_9234_timestamp_0_out_1 [get_bd_pins axi_ad9680_cpack/adc_data_1] [get_bd_pins format_9234_timestamp_0/out_1] [get_bd_pins ila_0/probe2]
  connect_bd_net -net format_9234_timestamp_0_waveform_0 [get_bd_pins format_9234_timestamp_0/waveform_0] [get_bd_pins ila_0/probe3]
  connect_bd_net -net format_9234_timestamp_0_waveform_1 [get_bd_pins format_9234_timestamp_0/waveform_1] [get_bd_pins ila_0/probe4]
  connect_bd_net -net gpio_i_1 [get_bd_ports gpio_i] [get_bd_pins sys_ps8/emio_gpio_i]
  connect_bd_net -net ps_intr_00_1 [get_bd_ports ps_intr_00] [get_bd_pins sys_concat_intc_0/In0]
  connect_bd_net -net ps_intr_01_1 [get_bd_ports ps_intr_01] [get_bd_pins sys_concat_intc_0/In1]
  connect_bd_net -net ps_intr_02_1 [get_bd_ports ps_intr_02] [get_bd_pins sys_concat_intc_0/In2]
  connect_bd_net -net ps_intr_03_1 [get_bd_ports ps_intr_03] [get_bd_pins sys_concat_intc_0/In3]
  connect_bd_net -net ps_intr_04_1 [get_bd_ports ps_intr_04] [get_bd_pins sys_concat_intc_0/In4]
  connect_bd_net -net ps_intr_05_1 [get_bd_ports ps_intr_05] [get_bd_pins sys_concat_intc_0/In5]
  connect_bd_net -net ps_intr_06_1 [get_bd_ports ps_intr_06] [get_bd_pins sys_concat_intc_0/In6]
  connect_bd_net -net ps_intr_07_1 [get_bd_ports ps_intr_07] [get_bd_pins sys_concat_intc_0/In7]
  connect_bd_net -net ps_intr_08_1 [get_bd_ports ps_intr_08] [get_bd_pins sys_concat_intc_1/In0]
  connect_bd_net -net ps_intr_09_1 [get_bd_ports ps_intr_09] [get_bd_pins sys_concat_intc_1/In1]
  connect_bd_net -net ps_intr_14_1 [get_bd_ports ps_intr_14] [get_bd_pins sys_concat_intc_1/In6]
  connect_bd_net -net ps_intr_15_1 [get_bd_ports ps_intr_15] [get_bd_pins sys_concat_intc_1/In7]
  connect_bd_net -net rx_data_0_n_1 [get_bd_ports rx_data_0_n] [get_bd_pins util_daq2_xcvr/rx_0_n]
  connect_bd_net -net rx_data_0_p_1 [get_bd_ports rx_data_0_p] [get_bd_pins util_daq2_xcvr/rx_0_p]
  connect_bd_net -net rx_data_1_n_1 [get_bd_ports rx_data_1_n] [get_bd_pins util_daq2_xcvr/rx_1_n]
  connect_bd_net -net rx_data_1_p_1 [get_bd_ports rx_data_1_p] [get_bd_pins util_daq2_xcvr/rx_1_p]
  connect_bd_net -net rx_data_2_n_1 [get_bd_ports rx_data_2_n] [get_bd_pins util_daq2_xcvr/rx_2_n]
  connect_bd_net -net rx_data_2_p_1 [get_bd_ports rx_data_2_p] [get_bd_pins util_daq2_xcvr/rx_2_p]
  connect_bd_net -net rx_data_3_n_1 [get_bd_ports rx_data_3_n] [get_bd_pins util_daq2_xcvr/rx_3_n]
  connect_bd_net -net rx_data_3_p_1 [get_bd_ports rx_data_3_p] [get_bd_pins util_daq2_xcvr/rx_3_p]
  connect_bd_net -net rx_ref_clk_0_1 [get_bd_ports rx_ref_clk_0] [get_bd_pins util_daq2_xcvr/cpll_ref_clk_0] [get_bd_pins util_daq2_xcvr/cpll_ref_clk_1] [get_bd_pins util_daq2_xcvr/cpll_ref_clk_2] [get_bd_pins util_daq2_xcvr/cpll_ref_clk_3] [get_bd_pins util_daq2_xcvr/qpll_ref_clk_0]
  connect_bd_net -net spi0_csn_concat_dout [get_bd_ports spi0_csn] [get_bd_pins spi0_csn_concat/dout]
  connect_bd_net -net spi0_miso_1 [get_bd_ports spi0_miso] [get_bd_pins sys_ps8/emio_spi0_m_i]
  connect_bd_net -net spi1_csn_concat_dout [get_bd_ports spi1_csn] [get_bd_pins spi1_csn_concat/dout]
  connect_bd_net -net spi1_miso_1 [get_bd_ports spi1_miso] [get_bd_pins sys_ps8/emio_spi1_m_i]
  connect_bd_net -net start_LD_0_start1 [get_bd_ports start1] [get_bd_pins format_9234_timestamp_0/trig] [get_bd_pins ila_0/probe0] [get_bd_pins start_LD_0/start1]
  connect_bd_net -net sys_200m_clk [get_bd_pins sys_ps8/pl_clk1]
  connect_bd_net -net sys_concat_intc_0_dout [get_bd_pins sys_concat_intc_0/dout] [get_bd_pins sys_ps8/pl_ps_irq0]
  connect_bd_net -net sys_concat_intc_1_dout [get_bd_pins sys_concat_intc_1/dout] [get_bd_pins sys_ps8/pl_ps_irq1]
  connect_bd_net -net sys_cpu_clk [get_bd_pins axi_ad9680_core/s_axi_aclk] [get_bd_pins axi_ad9680_dma/m_dest_axi_aclk] [get_bd_pins axi_ad9680_dma/s_axi_aclk] [get_bd_pins axi_ad9680_dma/s_axis_aclk] [get_bd_pins axi_ad9680_fifo/dma_clk] [get_bd_pins axi_ad9680_jesd/s_axi_aclk] [get_bd_pins axi_ad9680_xcvr/s_axi_aclk] [get_bd_pins axi_cpu_interconnect/ACLK] [get_bd_pins axi_cpu_interconnect/M00_ACLK] [get_bd_pins axi_cpu_interconnect/M01_ACLK] [get_bd_pins axi_cpu_interconnect/M02_ACLK] [get_bd_pins axi_cpu_interconnect/M03_ACLK] [get_bd_pins axi_cpu_interconnect/M04_ACLK] [get_bd_pins axi_cpu_interconnect/M05_ACLK] [get_bd_pins axi_cpu_interconnect/M06_ACLK] [get_bd_pins axi_cpu_interconnect/M07_ACLK] [get_bd_pins axi_cpu_interconnect/S00_ACLK] [get_bd_pins axi_hp2_interconnect/ACLK] [get_bd_pins axi_hp2_interconnect/M00_ACLK] [get_bd_pins axi_hp2_interconnect/S00_ACLK] [get_bd_pins axi_hp3_interconnect/ACLK] [get_bd_pins axi_hp3_interconnect/M00_ACLK] [get_bd_pins axi_hp3_interconnect/S00_ACLK] [get_bd_pins sys_ps8/maxihpm0_lpd_aclk] [get_bd_pins sys_ps8/pl_clk0] [get_bd_pins sys_ps8/saxihp1_fpd_aclk] [get_bd_pins sys_ps8/saxihp2_fpd_aclk] [get_bd_pins sys_ps8/saxihp3_fpd_aclk] [get_bd_pins sys_rstgen/slowest_sync_clk] [get_bd_pins util_daq2_xcvr/up_clk]
  connect_bd_net -net sys_cpu_resetn [get_bd_pins axi_ad9680_core/s_axi_aresetn] [get_bd_pins axi_ad9680_dma/m_dest_axi_aresetn] [get_bd_pins axi_ad9680_dma/s_axi_aresetn] [get_bd_pins axi_ad9680_jesd/s_axi_aresetn] [get_bd_pins axi_ad9680_jesd_rstgen/ext_reset_in] [get_bd_pins axi_ad9680_xcvr/s_axi_aresetn] [get_bd_pins axi_cpu_interconnect/ARESETN] [get_bd_pins axi_cpu_interconnect/M00_ARESETN] [get_bd_pins axi_cpu_interconnect/M01_ARESETN] [get_bd_pins axi_cpu_interconnect/M02_ARESETN] [get_bd_pins axi_cpu_interconnect/M03_ARESETN] [get_bd_pins axi_cpu_interconnect/M04_ARESETN] [get_bd_pins axi_cpu_interconnect/M05_ARESETN] [get_bd_pins axi_cpu_interconnect/M06_ARESETN] [get_bd_pins axi_cpu_interconnect/M07_ARESETN] [get_bd_pins axi_cpu_interconnect/S00_ARESETN] [get_bd_pins axi_hp2_interconnect/ARESETN] [get_bd_pins axi_hp2_interconnect/M00_ARESETN] [get_bd_pins axi_hp2_interconnect/S00_ARESETN] [get_bd_pins axi_hp3_interconnect/ARESETN] [get_bd_pins axi_hp3_interconnect/M00_ARESETN] [get_bd_pins axi_hp3_interconnect/S00_ARESETN] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins sys_rstgen/peripheral_aresetn] [get_bd_pins util_daq2_xcvr/up_rstn]
  connect_bd_net -net sys_ps8_emio_gpio_o [get_bd_ports gpio_o] [get_bd_pins sys_ps8/emio_gpio_o]
  connect_bd_net -net sys_ps8_emio_gpio_t [get_bd_ports gpio_t] [get_bd_pins sys_ps8/emio_gpio_t]
  connect_bd_net -net sys_ps8_emio_spi0_m_o [get_bd_ports spi0_mosi] [get_bd_pins sys_ps8/emio_spi0_m_o]
  connect_bd_net -net sys_ps8_emio_spi0_s_i_GND_dout [get_bd_pins sys_ps8/emio_spi0_s_i] [get_bd_pins sys_ps8_emio_spi0_s_i_GND/dout]
  connect_bd_net -net sys_ps8_emio_spi0_sclk_i_GND_dout [get_bd_pins sys_ps8/emio_spi0_sclk_i] [get_bd_pins sys_ps8_emio_spi0_sclk_i_GND/dout]
  connect_bd_net -net sys_ps8_emio_spi0_sclk_o [get_bd_ports spi0_sclk] [get_bd_pins sys_ps8/emio_spi0_sclk_o]
  connect_bd_net -net sys_ps8_emio_spi0_ss1_o_n [get_bd_pins spi0_csn_concat/In1] [get_bd_pins sys_ps8/emio_spi0_ss1_o_n]
  connect_bd_net -net sys_ps8_emio_spi0_ss2_o_n [get_bd_pins spi0_csn_concat/In2] [get_bd_pins sys_ps8/emio_spi0_ss2_o_n]
  connect_bd_net -net sys_ps8_emio_spi0_ss_i_n_VCC_dout [get_bd_pins sys_ps8/emio_spi0_ss_i_n] [get_bd_pins sys_ps8_emio_spi0_ss_i_n_VCC/dout]
  connect_bd_net -net sys_ps8_emio_spi0_ss_o_n [get_bd_pins spi0_csn_concat/In0] [get_bd_pins sys_ps8/emio_spi0_ss_o_n]
  connect_bd_net -net sys_ps8_emio_spi1_m_o [get_bd_ports spi1_mosi] [get_bd_pins sys_ps8/emio_spi1_m_o]
  connect_bd_net -net sys_ps8_emio_spi1_s_i_GND_dout [get_bd_pins sys_ps8/emio_spi1_s_i] [get_bd_pins sys_ps8_emio_spi1_s_i_GND/dout]
  connect_bd_net -net sys_ps8_emio_spi1_sclk_i_GND_dout [get_bd_pins sys_ps8/emio_spi1_sclk_i] [get_bd_pins sys_ps8_emio_spi1_sclk_i_GND/dout]
  connect_bd_net -net sys_ps8_emio_spi1_sclk_o [get_bd_ports spi1_sclk] [get_bd_pins sys_ps8/emio_spi1_sclk_o]
  connect_bd_net -net sys_ps8_emio_spi1_ss1_o_n [get_bd_pins spi1_csn_concat/In1] [get_bd_pins sys_ps8/emio_spi1_ss1_o_n]
  connect_bd_net -net sys_ps8_emio_spi1_ss2_o_n [get_bd_pins spi1_csn_concat/In2] [get_bd_pins sys_ps8/emio_spi1_ss2_o_n]
  connect_bd_net -net sys_ps8_emio_spi1_ss_i_n_VCC1_dout [get_bd_pins start_LD_0/rst_n] [get_bd_pins sys_ps8_emio_spi1_ss_i_n_VCC1/dout]
  connect_bd_net -net sys_ps8_emio_spi1_ss_i_n_VCC_dout [get_bd_pins sys_ps8/emio_spi1_ss_i_n] [get_bd_pins sys_ps8_emio_spi1_ss_i_n_VCC/dout]
  connect_bd_net -net sys_ps8_emio_spi1_ss_o_n [get_bd_pins spi1_csn_concat/In0] [get_bd_pins sys_ps8/emio_spi1_ss_o_n]
  connect_bd_net -net sys_ps8_pl_resetn0 [get_bd_pins sys_ps8/pl_resetn0] [get_bd_pins sys_rstgen/ext_reset_in]
  connect_bd_net -net sysref_2 [get_bd_ports rx_sysref_0] [get_bd_pins axi_ad9680_jesd/sysref]
  connect_bd_net -net util_daq2_xcvr_rx_out_clk_0 [get_bd_ports rx_out_clk] [get_bd_pins axi_ad9680_core/rx_clk] [get_bd_pins axi_ad9680_cpack/adc_clk] [get_bd_pins axi_ad9680_fifo/adc_clk] [get_bd_pins axi_ad9680_jesd/device_clk] [get_bd_pins axi_ad9680_jesd_rstgen/slowest_sync_clk] [get_bd_pins format_9234_timestamp_0/clk] [get_bd_pins format_9234_timestamp_0/clk_2x] [get_bd_pins ila_0/clk] [get_bd_pins start_LD_0/clk] [get_bd_pins util_daq2_xcvr/rx_clk_0] [get_bd_pins util_daq2_xcvr/rx_clk_1] [get_bd_pins util_daq2_xcvr/rx_clk_2] [get_bd_pins util_daq2_xcvr/rx_clk_3] [get_bd_pins util_daq2_xcvr/rx_out_clk_0]
  connect_bd_net -net util_daq2_xcvr_tx_0_n [get_bd_ports tx_data_0_n] [get_bd_pins util_daq2_xcvr/tx_0_n]
  connect_bd_net -net util_daq2_xcvr_tx_0_p [get_bd_ports tx_data_0_p] [get_bd_pins util_daq2_xcvr/tx_0_p]
  connect_bd_net -net util_daq2_xcvr_tx_1_n [get_bd_ports tx_data_1_n] [get_bd_pins util_daq2_xcvr/tx_1_n]
  connect_bd_net -net util_daq2_xcvr_tx_1_p [get_bd_ports tx_data_1_p] [get_bd_pins util_daq2_xcvr/tx_1_p]
  connect_bd_net -net util_daq2_xcvr_tx_2_n [get_bd_ports tx_data_2_n] [get_bd_pins util_daq2_xcvr/tx_2_n]
  connect_bd_net -net util_daq2_xcvr_tx_2_p [get_bd_ports tx_data_2_p] [get_bd_pins util_daq2_xcvr/tx_2_p]
  connect_bd_net -net util_daq2_xcvr_tx_3_n [get_bd_ports tx_data_3_n] [get_bd_pins util_daq2_xcvr/tx_3_n]
  connect_bd_net -net util_daq2_xcvr_tx_3_p [get_bd_ports tx_data_3_p] [get_bd_pins util_daq2_xcvr/tx_3_p]
  connect_bd_net -net util_daq2_xcvr_tx_out_clk_0 [get_bd_pins util_daq2_xcvr/tx_clk_0] [get_bd_pins util_daq2_xcvr/tx_clk_1] [get_bd_pins util_daq2_xcvr/tx_clk_2] [get_bd_pins util_daq2_xcvr/tx_clk_3] [get_bd_pins util_daq2_xcvr/tx_out_clk_0]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_ad9680_dma/m_dest_axi] [get_bd_addr_segs sys_ps8/SAXIGP4/HP2_DDR_LOW] SEG_sys_ps8_HP2_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_ad9680_dma/m_dest_axi] [get_bd_addr_segs sys_ps8/SAXIGP4/HP2_LPS_OCM] SEG_sys_ps8_HP2_LPS_OCM
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_ad9680_dma/m_dest_axi] [get_bd_addr_segs sys_ps8/SAXIGP4/HP2_PCIE_LOW] SEG_sys_ps8_HP2_PCIE_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_ad9680_dma/m_dest_axi] [get_bd_addr_segs sys_ps8/SAXIGP4/HP2_QSPI] SEG_sys_ps8_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_ad9680_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_LOW] SEG_sys_ps8_HP3_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_ad9680_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_LPS_OCM] SEG_sys_ps8_HP3_LPS_OCM
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_ad9680_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_PCIE_LOW] SEG_sys_ps8_HP3_PCIE_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_ad9680_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_QSPI] SEG_sys_ps8_HP3_QSPI
  create_bd_addr_seg -range 0x00010000 -offset 0x84A10000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_ad9680_core/s_axi/axi_lite] SEG_data_axi_ad9680_core
  create_bd_addr_seg -range 0x00001000 -offset 0x9C400000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_ad9680_dma/s_axi/axi_lite] SEG_data_axi_ad9680_dma
  create_bd_addr_seg -range 0x00004000 -offset 0x84AA0000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_ad9680_jesd/rx_axi/s_axi/axi_lite] SEG_data_axi_ad9680_jesd
  create_bd_addr_seg -range 0x00010000 -offset 0x84A50000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_ad9680_xcvr/s_axi/axi_lite] SEG_data_axi_ad9680_xcvr


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



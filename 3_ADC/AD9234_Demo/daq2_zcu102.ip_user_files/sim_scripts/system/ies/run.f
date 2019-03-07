-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/axi_infrastructure_v1_1_0 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/smartconnect_v1_0 -sv \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/02c8/hdl/sc_util_v1_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/axi_protocol_checker_v2_0_1 -sv \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/3b24/hdl/axi_protocol_checker_v2_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/axi_vip_v1_1_1 -sv \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/a16a/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib ies_lib/zynq_ultra_ps_e_vip_v1_0_1 -sv \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/cfaa/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_sys_ps8_0/sim/system_sys_ps8_0_vip_wrapper.v" \
-endlib
-makelib ies_lib/lib_cdc_v1_0_2 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib ies_lib/proc_sys_reset_v5_0_12 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/f86a/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_sys_rstgen_0/sim/system_sys_rstgen_0.vhd" \
-endlib
-makelib ies_lib/xlconcat_v2_1_1 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/2f66/hdl/xlconcat_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_spi0_csn_concat_0/sim/system_spi0_csn_concat_0.v" \
-endlib
-makelib ies_lib/xlconstant_v1_1_3 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/0750/hdl/xlconstant_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_sys_ps8_emio_spi0_ss_i_n_VCC_0/sim/system_sys_ps8_emio_spi0_ss_i_n_VCC_0.v" \
  "../../../bd/system/ip/system_sys_ps8_emio_spi0_sclk_i_GND_0/sim/system_sys_ps8_emio_spi0_sclk_i_GND_0.v" \
  "../../../bd/system/ip/system_sys_ps8_emio_spi0_s_i_GND_0/sim/system_sys_ps8_emio_spi0_s_i_GND_0.v" \
  "../../../bd/system/ip/system_spi1_csn_concat_0/sim/system_spi1_csn_concat_0.v" \
  "../../../bd/system/ip/system_sys_ps8_emio_spi1_ss_i_n_VCC_0/sim/system_sys_ps8_emio_spi1_ss_i_n_VCC_0.v" \
  "../../../bd/system/ip/system_sys_ps8_emio_spi1_sclk_i_GND_0/sim/system_sys_ps8_emio_spi1_sclk_i_GND_0.v" \
  "../../../bd/system/ip/system_sys_ps8_emio_spi1_s_i_GND_0/sim/system_sys_ps8_emio_spi1_s_i_GND_0.v" \
  "../../../bd/system/ip/system_sys_concat_intc_0_0/sim/system_sys_concat_intc_0_0.v" \
  "../../../bd/system/ip/system_sys_concat_intc_1_0/sim/system_sys_concat_intc_1_0.v" \
  "../../../../daq2_zcu102.srcs/sources_1/bd/hdl/library/common/ad_axis_inf_rx.v" \
  "../../../../daq2_zcu102.srcs/sources_1/bd/hdl/library/common/ad_mem_asym.v" \
  "../../../bd/system/ipshared/b072/util_adcfifo.v" \
  "../../../bd/system/ip/system_axi_ad9680_fifo_0/sim/system_axi_ad9680_fifo_0.v" \
  "../../../bd/system/ipshared/8aa1/axi_adxcvr_es.v" \
  "../../../bd/system/ipshared/8aa1/axi_adxcvr_mdrp.v" \
  "../../../bd/system/ipshared/8aa1/axi_adxcvr_mstatus.v" \
  "../../../bd/system/ipshared/8aa1/axi_adxcvr_up.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/up_axi.v" \
  "../../../bd/system/ipshared/8aa1/axi_adxcvr.v" \
  "../../../bd/system/ip/system_axi_ad9680_xcvr_0/sim/system_axi_ad9680_xcvr_0.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/ad_datafmt.v" \
  "../../../bd/system/ipshared/419f/ad_ip_jesd204_tpl_adc_channel.v" \
  "../../../bd/system/ipshared/419f/ad_ip_jesd204_tpl_adc_core.v" \
  "../../../bd/system/ipshared/419f/ad_ip_jesd204_tpl_adc_deframer.v" \
  "../../../bd/system/ipshared/419f/ad_ip_jesd204_tpl_adc_pnmon.v" \
  "../../../bd/system/ipshared/419f/ad_ip_jesd204_tpl_adc_regmap.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/ad_pnmon.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/ad_rst.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/ad_xcvr_rx_if.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/up_adc_channel.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/up_adc_common.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/up_clock_mon.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/up_xfer_cntrl.v" \
  "../../../../daq2_zcu102.srcs/sources_1/hdl/library/common/up_xfer_status.v" \
  "../../../bd/system/ipshared/419f/ad_ip_jesd204_tpl_adc.v" \
  "../../../bd/system/ipshared/70d6/axi_ad9680.v" \
  "../../../bd/system/ip/system_axi_ad9680_core_0/sim/system_axi_ad9680_core_0.v" \
  "../../../bd/system/ipshared/2884/util_cpack_dsf.v" \
  "../../../bd/system/ipshared/2884/util_cpack_mux.v" \
  "../../../bd/system/ipshared/2884/util_cpack.v" \
  "../../../bd/system/ip/system_axi_ad9680_cpack_0/sim/system_axi_ad9680_cpack_0.v" \
  "../../../bd/system/ipshared/fb52/sync_bits.v" \
  "../../../bd/system/ipshared/fb52/sync_data.v" \
  "../../../bd/system/ipshared/fb52/sync_event.v" \
  "../../../bd/system/ipshared/fb52/sync_gray.v" \
  "../../../../daq2_zcu102.srcs/sources_1/bd/hdl/library/common/ad_mem.v" \
  "../../../bd/system/ipshared/0d03/address_gray_pipelined.v" \
  "../../../bd/system/ipshared/0d03/address_sync.v" \
  "../../../bd/system/ipshared/0d03/util_axis_fifo.v" \
-endlib
-makelib ies_lib/xil_defaultlib -sv \
  "../../../bd/system/ip/system_axi_ad9680_dma_0/sim/system_axi_ad9680_dma_0_pkg.sv" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ipshared/225a/2d_transfer.v" \
  "../../../bd/system/ipshared/225a/address_generator.v" \
  "../../../bd/system/ipshared/225a/axi_dmac_burst_memory.v" \
  "../../../bd/system/ipshared/225a/axi_dmac_regmap.v" \
  "../../../bd/system/ipshared/225a/axi_dmac_regmap_request.v" \
  "../../../bd/system/ipshared/225a/axi_dmac_reset_manager.v" \
  "../../../bd/system/ipshared/225a/axi_dmac_resize_dest.v" \
  "../../../bd/system/ipshared/225a/axi_dmac_resize_src.v" \
  "../../../bd/system/ipshared/225a/axi_dmac_transfer.v" \
  "../../../bd/system/ipshared/225a/axi_register_slice.v" \
  "../../../bd/system/ipshared/225a/data_mover.v" \
  "../../../bd/system/ipshared/225a/dest_axi_mm.v" \
  "../../../bd/system/ipshared/225a/dest_axi_stream.v" \
  "../../../bd/system/ipshared/225a/dest_fifo_inf.v" \
  "../../../bd/system/ipshared/225a/request_arb.v" \
  "../../../bd/system/ipshared/225a/request_generator.v" \
  "../../../bd/system/ipshared/225a/response_generator.v" \
  "../../../bd/system/ipshared/225a/response_handler.v" \
  "../../../bd/system/ipshared/225a/splitter.v" \
  "../../../bd/system/ipshared/225a/src_axi_mm.v" \
  "../../../bd/system/ipshared/225a/src_axi_stream.v" \
  "../../../bd/system/ipshared/225a/src_fifo_inf.v" \
  "../../../bd/system/ipshared/225a/axi_dmac.v" \
  "../../../bd/system/ip/system_axi_ad9680_dma_0/sim/system_axi_ad9680_dma_0.v" \
  "../../../bd/system/ipshared/bdee/util_adxcvr_xch.v" \
  "../../../bd/system/ipshared/bdee/util_adxcvr_xcm.v" \
  "../../../bd/system/ipshared/bdee/util_adxcvr.v" \
  "../../../bd/system/ip/system_util_daq2_xcvr_0/sim/system_util_daq2_xcvr_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_axi_ad9680_jesd_rstgen_0/sim/system_axi_ad9680_jesd_rstgen_0.vhd" \
-endlib
-makelib ies_lib/generic_baseblocks_v2_1_0 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_register_slice_v2_1_15 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/3ed1/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_1 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/5c35/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_1 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/5c35/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_1 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/5c35/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib ies_lib/axi_data_fifo_v2_1_14 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/9909/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_crossbar_v2_1_16 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/c631/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_xbar_0/sim/system_xbar_0.v" \
  "../../../bd/system/ipshared/a6ac/jesd204_up_common.v" \
  "../../../bd/system/ipshared/a6ac/jesd204_up_sysref.v" \
  "../../../bd/system/ipshared/4b85/jesd204_up_ilas_mem.v" \
  "../../../bd/system/ipshared/4b85/jesd204_up_rx.v" \
  "../../../bd/system/ipshared/4b85/jesd204_up_rx_lane.v" \
  "../../../bd/system/ipshared/4b85/axi_jesd204_rx.v" \
  "../../../bd/system/ip/system_rx_axi_0/sim/system_rx_axi_0.v" \
  "../../../bd/system/ipshared/c919/jesd204_eof_generator.v" \
  "../../../bd/system/ipshared/c919/jesd204_lmfc.v" \
  "../../../bd/system/ipshared/c919/jesd204_scrambler.v" \
  "../../../bd/system/ipshared/c919/pipeline_stage.v" \
  "../../../bd/system/ipshared/f9c3/align_mux.v" \
  "../../../bd/system/ipshared/f9c3/elastic_buffer.v" \
  "../../../bd/system/ipshared/f9c3/jesd204_ilas_monitor.v" \
  "../../../bd/system/ipshared/f9c3/jesd204_lane_latency_monitor.v" \
  "../../../bd/system/ipshared/f9c3/jesd204_rx_cgs.v" \
  "../../../bd/system/ipshared/f9c3/jesd204_rx_ctrl.v" \
  "../../../bd/system/ipshared/f9c3/jesd204_rx_lane.v" \
  "../../../bd/system/ipshared/f9c3/jesd204_rx.v" \
  "../../../bd/system/ip/system_rx_0/sim/system_rx_0.v" \
  "../../../bd/system/ip/system_ila_0_0/sim/system_ila_0_0.v" \
  "../../../bd/system/ip/system_start_LD_0_0/sim/system_start_LD_0_0.v" \
  "../../../bd/system/ip/system_clk_wiz_0_0/system_clk_wiz_0_0_clk_wiz.v" \
  "../../../bd/system/ip/system_clk_wiz_0_0/system_clk_wiz_0_0.v" \
  "../../../bd/system/sim/system.v" \
  "../../../bd/system/ipshared/9b3e/sources_1/new/format_9234.v" \
  "../../../bd/system/ip/system_format_9234_timestamp_0_0/sim/system_format_9234_timestamp_0_0.v" \
  "../../../bd/system/ip/system_sys_ps8_emio_spi1_ss_i_n_VCC_1/sim/system_sys_ps8_emio_spi1_ss_i_n_VCC_1.v" \
-endlib
-makelib ies_lib/axi_protocol_converter_v2_1_15 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/ff69/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_clock_converter_v2_1_14 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/445f/hdl/axi_clock_converter_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_1 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/67d8/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/axi_dwidth_converter_v2_1_15 \
  "../../../../daq2_zcu102.srcs/sources_1/bd/system/ipshared/1cdc/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_auto_us_1/sim/system_auto_us_1.v" \
  "../../../bd/system/ip/system_auto_pc_1/sim/system_auto_pc_1.v" \
  "../../../bd/system/ip/system_auto_us_0/sim/system_auto_us_0.v" \
  "../../../bd/system/ip/system_auto_pc_0/sim/system_auto_pc_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib


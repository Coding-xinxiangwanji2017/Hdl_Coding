//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Wed Sep 19 20:50:17 2018
//Host        : DESKTOP-9BSENP7 running 64-bit major release  (build 9200)
//Command     : generate_target system.bd
//Design      : system
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module axi_ad9680_jesd_imp_9H50XX
   (device_clk,
    irq,
    lmfc_clk_0,
    lmfc_edge_0,
    phy_en_char_align,
    rx_data_tdata,
    rx_data_tvalid,
    rx_eof,
    rx_phy0_rxcharisk,
    rx_phy0_rxdata,
    rx_phy0_rxdisperr,
    rx_phy0_rxnotintable,
    rx_phy1_rxcharisk,
    rx_phy1_rxdata,
    rx_phy1_rxdisperr,
    rx_phy1_rxnotintable,
    rx_phy2_rxcharisk,
    rx_phy2_rxdata,
    rx_phy2_rxdisperr,
    rx_phy2_rxnotintable,
    rx_phy3_rxcharisk,
    rx_phy3_rxdata,
    rx_phy3_rxdisperr,
    rx_phy3_rxnotintable,
    rx_sof,
    s_axi_aclk,
    s_axi_araddr,
    s_axi_aresetn,
    s_axi_arprot,
    s_axi_arready,
    s_axi_arvalid,
    s_axi_awaddr,
    s_axi_awprot,
    s_axi_awready,
    s_axi_awvalid,
    s_axi_bready,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_rdata,
    s_axi_rready,
    s_axi_rresp,
    s_axi_rvalid,
    s_axi_wdata,
    s_axi_wready,
    s_axi_wstrb,
    s_axi_wvalid,
    sync,
    sysref);
  input device_clk;
  output irq;
  output lmfc_clk_0;
  output lmfc_edge_0;
  output phy_en_char_align;
  output [127:0]rx_data_tdata;
  output rx_data_tvalid;
  output [3:0]rx_eof;
  input [3:0]rx_phy0_rxcharisk;
  input [31:0]rx_phy0_rxdata;
  input [3:0]rx_phy0_rxdisperr;
  input [3:0]rx_phy0_rxnotintable;
  input [3:0]rx_phy1_rxcharisk;
  input [31:0]rx_phy1_rxdata;
  input [3:0]rx_phy1_rxdisperr;
  input [3:0]rx_phy1_rxnotintable;
  input [3:0]rx_phy2_rxcharisk;
  input [31:0]rx_phy2_rxdata;
  input [3:0]rx_phy2_rxdisperr;
  input [3:0]rx_phy2_rxnotintable;
  input [3:0]rx_phy3_rxcharisk;
  input [31:0]rx_phy3_rxdata;
  input [3:0]rx_phy3_rxdisperr;
  input [3:0]rx_phy3_rxnotintable;
  output [3:0]rx_sof;
  input s_axi_aclk;
  input [39:0]s_axi_araddr;
  input s_axi_aresetn;
  input [2:0]s_axi_arprot;
  output [0:0]s_axi_arready;
  input [0:0]s_axi_arvalid;
  input [39:0]s_axi_awaddr;
  input [2:0]s_axi_awprot;
  output [0:0]s_axi_awready;
  input [0:0]s_axi_awvalid;
  input [0:0]s_axi_bready;
  output [1:0]s_axi_bresp;
  output [0:0]s_axi_bvalid;
  output [31:0]s_axi_rdata;
  input [0:0]s_axi_rready;
  output [1:0]s_axi_rresp;
  output [0:0]s_axi_rvalid;
  input [31:0]s_axi_wdata;
  output [0:0]s_axi_wready;
  input [3:0]s_axi_wstrb;
  input [0:0]s_axi_wvalid;
  output [0:0]sync;
  input sysref;

  wire device_clk_1;
  wire rx_axi_core_reset;
  wire rx_axi_irq;
  wire [7:0]rx_axi_rx_cfg_beats_per_multiframe;
  wire [7:0]rx_axi_rx_cfg_buffer_delay;
  wire rx_axi_rx_cfg_buffer_early_release;
  wire rx_axi_rx_cfg_disable_char_replacement;
  wire rx_axi_rx_cfg_disable_scrambler;
  wire [2:0]rx_axi_rx_cfg_err_statistics_mask;
  wire rx_axi_rx_cfg_err_statistics_reset;
  wire [3:0]rx_axi_rx_cfg_lanes_disable;
  wire [0:0]rx_axi_rx_cfg_links_disable;
  wire [7:0]rx_axi_rx_cfg_lmfc_offset;
  wire [7:0]rx_axi_rx_cfg_octets_per_frame;
  wire rx_axi_rx_cfg_sysref_disable;
  wire rx_axi_rx_cfg_sysref_oneshot;
  wire rx_lmfc_clk;
  wire rx_lmfc_edge;
  wire [3:0]rx_phy0_1_rxcharisk;
  wire [31:0]rx_phy0_1_rxdata;
  wire [3:0]rx_phy0_1_rxdisperr;
  wire [3:0]rx_phy0_1_rxnotintable;
  wire [3:0]rx_phy1_1_rxcharisk;
  wire [31:0]rx_phy1_1_rxdata;
  wire [3:0]rx_phy1_1_rxdisperr;
  wire [3:0]rx_phy1_1_rxnotintable;
  wire [3:0]rx_phy2_1_rxcharisk;
  wire [31:0]rx_phy2_1_rxdata;
  wire [3:0]rx_phy2_1_rxdisperr;
  wire [3:0]rx_phy2_1_rxnotintable;
  wire [3:0]rx_phy3_1_rxcharisk;
  wire [31:0]rx_phy3_1_rxdata;
  wire [3:0]rx_phy3_1_rxdisperr;
  wire [3:0]rx_phy3_1_rxnotintable;
  wire rx_phy_en_char_align;
  wire [127:0]rx_rx_data;
  wire [3:0]rx_rx_eof;
  wire rx_rx_event_sysref_alignment_error;
  wire rx_rx_event_sysref_edge;
  wire [7:0]rx_rx_ilas_config_addr;
  wire [127:0]rx_rx_ilas_config_data;
  wire [3:0]rx_rx_ilas_config_valid;
  wire [3:0]rx_rx_sof;
  wire [1:0]rx_rx_status_ctrl_state;
  wire [127:0]rx_rx_status_err_statistics_cnt;
  wire [7:0]rx_rx_status_lane_cgs_state;
  wire [3:0]rx_rx_status_lane_ifs_ready;
  wire [55:0]rx_rx_status_lane_latency;
  wire rx_rx_valid;
  wire [0:0]rx_sync;
  wire [39:0]s_axi_1_ARADDR;
  wire [2:0]s_axi_1_ARPROT;
  wire s_axi_1_ARREADY;
  wire [0:0]s_axi_1_ARVALID;
  wire [39:0]s_axi_1_AWADDR;
  wire [2:0]s_axi_1_AWPROT;
  wire s_axi_1_AWREADY;
  wire [0:0]s_axi_1_AWVALID;
  wire [0:0]s_axi_1_BREADY;
  wire [1:0]s_axi_1_BRESP;
  wire s_axi_1_BVALID;
  wire [31:0]s_axi_1_RDATA;
  wire [0:0]s_axi_1_RREADY;
  wire [1:0]s_axi_1_RRESP;
  wire s_axi_1_RVALID;
  wire [31:0]s_axi_1_WDATA;
  wire s_axi_1_WREADY;
  wire [3:0]s_axi_1_WSTRB;
  wire [0:0]s_axi_1_WVALID;
  wire s_axi_aclk_1;
  wire s_axi_aresetn_1;
  wire sysref_1;

  assign device_clk_1 = device_clk;
  assign irq = rx_axi_irq;
  assign lmfc_clk_0 = rx_lmfc_clk;
  assign lmfc_edge_0 = rx_lmfc_edge;
  assign phy_en_char_align = rx_phy_en_char_align;
  assign rx_data_tdata[127:0] = rx_rx_data;
  assign rx_data_tvalid = rx_rx_valid;
  assign rx_eof[3:0] = rx_rx_eof;
  assign rx_phy0_1_rxcharisk = rx_phy0_rxcharisk[3:0];
  assign rx_phy0_1_rxdata = rx_phy0_rxdata[31:0];
  assign rx_phy0_1_rxdisperr = rx_phy0_rxdisperr[3:0];
  assign rx_phy0_1_rxnotintable = rx_phy0_rxnotintable[3:0];
  assign rx_phy1_1_rxcharisk = rx_phy1_rxcharisk[3:0];
  assign rx_phy1_1_rxdata = rx_phy1_rxdata[31:0];
  assign rx_phy1_1_rxdisperr = rx_phy1_rxdisperr[3:0];
  assign rx_phy1_1_rxnotintable = rx_phy1_rxnotintable[3:0];
  assign rx_phy2_1_rxcharisk = rx_phy2_rxcharisk[3:0];
  assign rx_phy2_1_rxdata = rx_phy2_rxdata[31:0];
  assign rx_phy2_1_rxdisperr = rx_phy2_rxdisperr[3:0];
  assign rx_phy2_1_rxnotintable = rx_phy2_rxnotintable[3:0];
  assign rx_phy3_1_rxcharisk = rx_phy3_rxcharisk[3:0];
  assign rx_phy3_1_rxdata = rx_phy3_rxdata[31:0];
  assign rx_phy3_1_rxdisperr = rx_phy3_rxdisperr[3:0];
  assign rx_phy3_1_rxnotintable = rx_phy3_rxnotintable[3:0];
  assign rx_sof[3:0] = rx_rx_sof;
  assign s_axi_1_ARADDR = s_axi_araddr[39:0];
  assign s_axi_1_ARPROT = s_axi_arprot[2:0];
  assign s_axi_1_ARVALID = s_axi_arvalid[0];
  assign s_axi_1_AWADDR = s_axi_awaddr[39:0];
  assign s_axi_1_AWPROT = s_axi_awprot[2:0];
  assign s_axi_1_AWVALID = s_axi_awvalid[0];
  assign s_axi_1_BREADY = s_axi_bready[0];
  assign s_axi_1_RREADY = s_axi_rready[0];
  assign s_axi_1_WDATA = s_axi_wdata[31:0];
  assign s_axi_1_WSTRB = s_axi_wstrb[3:0];
  assign s_axi_1_WVALID = s_axi_wvalid[0];
  assign s_axi_aclk_1 = s_axi_aclk;
  assign s_axi_aresetn_1 = s_axi_aresetn;
  assign s_axi_arready[0] = s_axi_1_ARREADY;
  assign s_axi_awready[0] = s_axi_1_AWREADY;
  assign s_axi_bresp[1:0] = s_axi_1_BRESP;
  assign s_axi_bvalid[0] = s_axi_1_BVALID;
  assign s_axi_rdata[31:0] = s_axi_1_RDATA;
  assign s_axi_rresp[1:0] = s_axi_1_RRESP;
  assign s_axi_rvalid[0] = s_axi_1_RVALID;
  assign s_axi_wready[0] = s_axi_1_WREADY;
  assign sync[0] = rx_sync;
  assign sysref_1 = sysref;
  system_rx_0 rx
       (.cfg_beats_per_multiframe(rx_axi_rx_cfg_beats_per_multiframe),
        .cfg_buffer_delay(rx_axi_rx_cfg_buffer_delay),
        .cfg_buffer_early_release(rx_axi_rx_cfg_buffer_early_release),
        .cfg_disable_char_replacement(rx_axi_rx_cfg_disable_char_replacement),
        .cfg_disable_scrambler(rx_axi_rx_cfg_disable_scrambler),
        .cfg_lanes_disable(rx_axi_rx_cfg_lanes_disable),
        .cfg_links_disable(rx_axi_rx_cfg_links_disable),
        .cfg_lmfc_offset(rx_axi_rx_cfg_lmfc_offset),
        .cfg_octets_per_frame(rx_axi_rx_cfg_octets_per_frame),
        .cfg_sysref_disable(rx_axi_rx_cfg_sysref_disable),
        .cfg_sysref_oneshot(rx_axi_rx_cfg_sysref_oneshot),
        .clk(device_clk_1),
        .ctrl_err_statistics_mask(rx_axi_rx_cfg_err_statistics_mask),
        .ctrl_err_statistics_reset(rx_axi_rx_cfg_err_statistics_reset),
        .event_sysref_alignment_error(rx_rx_event_sysref_alignment_error),
        .event_sysref_edge(rx_rx_event_sysref_edge),
        .ilas_config_addr(rx_rx_ilas_config_addr),
        .ilas_config_data(rx_rx_ilas_config_data),
        .ilas_config_valid(rx_rx_ilas_config_valid),
        .lmfc_clk(rx_lmfc_clk),
        .lmfc_edge(rx_lmfc_edge),
        .phy_charisk({rx_phy3_1_rxcharisk,rx_phy2_1_rxcharisk,rx_phy1_1_rxcharisk,rx_phy0_1_rxcharisk}),
        .phy_data({rx_phy3_1_rxdata,rx_phy2_1_rxdata,rx_phy1_1_rxdata,rx_phy0_1_rxdata}),
        .phy_disperr({rx_phy3_1_rxdisperr,rx_phy2_1_rxdisperr,rx_phy1_1_rxdisperr,rx_phy0_1_rxdisperr}),
        .phy_en_char_align(rx_phy_en_char_align),
        .phy_notintable({rx_phy3_1_rxnotintable,rx_phy2_1_rxnotintable,rx_phy1_1_rxnotintable,rx_phy0_1_rxnotintable}),
        .reset(rx_axi_core_reset),
        .rx_data(rx_rx_data),
        .rx_eof(rx_rx_eof),
        .rx_sof(rx_rx_sof),
        .rx_valid(rx_rx_valid),
        .status_ctrl_state(rx_rx_status_ctrl_state),
        .status_err_statistics_cnt(rx_rx_status_err_statistics_cnt),
        .status_lane_cgs_state(rx_rx_status_lane_cgs_state),
        .status_lane_ifs_ready(rx_rx_status_lane_ifs_ready),
        .status_lane_latency(rx_rx_status_lane_latency),
        .sync(rx_sync),
        .sysref(sysref_1));
  system_rx_axi_0 rx_axi
       (.core_cfg_beats_per_multiframe(rx_axi_rx_cfg_beats_per_multiframe),
        .core_cfg_buffer_delay(rx_axi_rx_cfg_buffer_delay),
        .core_cfg_buffer_early_release(rx_axi_rx_cfg_buffer_early_release),
        .core_cfg_disable_char_replacement(rx_axi_rx_cfg_disable_char_replacement),
        .core_cfg_disable_scrambler(rx_axi_rx_cfg_disable_scrambler),
        .core_cfg_lanes_disable(rx_axi_rx_cfg_lanes_disable),
        .core_cfg_links_disable(rx_axi_rx_cfg_links_disable),
        .core_cfg_lmfc_offset(rx_axi_rx_cfg_lmfc_offset),
        .core_cfg_octets_per_frame(rx_axi_rx_cfg_octets_per_frame),
        .core_cfg_sysref_disable(rx_axi_rx_cfg_sysref_disable),
        .core_cfg_sysref_oneshot(rx_axi_rx_cfg_sysref_oneshot),
        .core_clk(device_clk_1),
        .core_ctrl_err_statistics_mask(rx_axi_rx_cfg_err_statistics_mask),
        .core_ctrl_err_statistics_reset(rx_axi_rx_cfg_err_statistics_reset),
        .core_event_sysref_alignment_error(rx_rx_event_sysref_alignment_error),
        .core_event_sysref_edge(rx_rx_event_sysref_edge),
        .core_ilas_config_addr(rx_rx_ilas_config_addr),
        .core_ilas_config_data(rx_rx_ilas_config_data),
        .core_ilas_config_valid(rx_rx_ilas_config_valid),
        .core_reset(rx_axi_core_reset),
        .core_reset_ext(1'b0),
        .core_status_ctrl_state(rx_rx_status_ctrl_state),
        .core_status_err_statistics_cnt(rx_rx_status_err_statistics_cnt),
        .core_status_lane_cgs_state(rx_rx_status_lane_cgs_state),
        .core_status_lane_ifs_ready(rx_rx_status_lane_ifs_ready),
        .core_status_lane_latency(rx_rx_status_lane_latency),
        .irq(rx_axi_irq),
        .s_axi_aclk(s_axi_aclk_1),
        .s_axi_araddr(s_axi_1_ARADDR[13:0]),
        .s_axi_aresetn(s_axi_aresetn_1),
        .s_axi_arprot(s_axi_1_ARPROT),
        .s_axi_arready(s_axi_1_ARREADY),
        .s_axi_arvalid(s_axi_1_ARVALID),
        .s_axi_awaddr(s_axi_1_AWADDR[13:0]),
        .s_axi_awprot(s_axi_1_AWPROT),
        .s_axi_awready(s_axi_1_AWREADY),
        .s_axi_awvalid(s_axi_1_AWVALID),
        .s_axi_bready(s_axi_1_BREADY),
        .s_axi_bresp(s_axi_1_BRESP),
        .s_axi_bvalid(s_axi_1_BVALID),
        .s_axi_rdata(s_axi_1_RDATA),
        .s_axi_rready(s_axi_1_RREADY),
        .s_axi_rresp(s_axi_1_RRESP),
        .s_axi_rvalid(s_axi_1_RVALID),
        .s_axi_wdata(s_axi_1_WDATA),
        .s_axi_wready(s_axi_1_WREADY),
        .s_axi_wstrb(s_axi_1_WSTRB),
        .s_axi_wvalid(s_axi_1_WVALID));
endmodule

module m00_couplers_imp_I5GH1N
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output M_AXI_araddr;
  output M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output M_AXI_awaddr;
  output M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input M_AXI_bresp;
  input M_AXI_bvalid;
  input M_AXI_rdata;
  output M_AXI_rready;
  input M_AXI_rresp;
  input M_AXI_rvalid;
  output M_AXI_wdata;
  input M_AXI_wready;
  output M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input S_AXI_araddr;
  input S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input S_AXI_awaddr;
  input S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output S_AXI_bresp;
  output S_AXI_bvalid;
  output S_AXI_rdata;
  input S_AXI_rready;
  output S_AXI_rresp;
  output S_AXI_rvalid;
  input S_AXI_wdata;
  output S_AXI_wready;
  input S_AXI_wstrb;
  input S_AXI_wvalid;

  wire m00_couplers_to_m00_couplers_ARADDR;
  wire m00_couplers_to_m00_couplers_ARPROT;
  wire m00_couplers_to_m00_couplers_ARREADY;
  wire m00_couplers_to_m00_couplers_ARVALID;
  wire m00_couplers_to_m00_couplers_AWADDR;
  wire m00_couplers_to_m00_couplers_AWPROT;
  wire m00_couplers_to_m00_couplers_AWREADY;
  wire m00_couplers_to_m00_couplers_AWVALID;
  wire m00_couplers_to_m00_couplers_BREADY;
  wire m00_couplers_to_m00_couplers_BRESP;
  wire m00_couplers_to_m00_couplers_BVALID;
  wire m00_couplers_to_m00_couplers_RDATA;
  wire m00_couplers_to_m00_couplers_RREADY;
  wire m00_couplers_to_m00_couplers_RRESP;
  wire m00_couplers_to_m00_couplers_RVALID;
  wire m00_couplers_to_m00_couplers_WDATA;
  wire m00_couplers_to_m00_couplers_WREADY;
  wire m00_couplers_to_m00_couplers_WSTRB;
  wire m00_couplers_to_m00_couplers_WVALID;

  assign M_AXI_araddr = m00_couplers_to_m00_couplers_ARADDR;
  assign M_AXI_arprot = m00_couplers_to_m00_couplers_ARPROT;
  assign M_AXI_arvalid = m00_couplers_to_m00_couplers_ARVALID;
  assign M_AXI_awaddr = m00_couplers_to_m00_couplers_AWADDR;
  assign M_AXI_awprot = m00_couplers_to_m00_couplers_AWPROT;
  assign M_AXI_awvalid = m00_couplers_to_m00_couplers_AWVALID;
  assign M_AXI_bready = m00_couplers_to_m00_couplers_BREADY;
  assign M_AXI_rready = m00_couplers_to_m00_couplers_RREADY;
  assign M_AXI_wdata = m00_couplers_to_m00_couplers_WDATA;
  assign M_AXI_wstrb = m00_couplers_to_m00_couplers_WSTRB;
  assign M_AXI_wvalid = m00_couplers_to_m00_couplers_WVALID;
  assign S_AXI_arready = m00_couplers_to_m00_couplers_ARREADY;
  assign S_AXI_awready = m00_couplers_to_m00_couplers_AWREADY;
  assign S_AXI_bresp = m00_couplers_to_m00_couplers_BRESP;
  assign S_AXI_bvalid = m00_couplers_to_m00_couplers_BVALID;
  assign S_AXI_rdata = m00_couplers_to_m00_couplers_RDATA;
  assign S_AXI_rresp = m00_couplers_to_m00_couplers_RRESP;
  assign S_AXI_rvalid = m00_couplers_to_m00_couplers_RVALID;
  assign S_AXI_wready = m00_couplers_to_m00_couplers_WREADY;
  assign m00_couplers_to_m00_couplers_ARADDR = S_AXI_araddr;
  assign m00_couplers_to_m00_couplers_ARPROT = S_AXI_arprot;
  assign m00_couplers_to_m00_couplers_ARREADY = M_AXI_arready;
  assign m00_couplers_to_m00_couplers_ARVALID = S_AXI_arvalid;
  assign m00_couplers_to_m00_couplers_AWADDR = S_AXI_awaddr;
  assign m00_couplers_to_m00_couplers_AWPROT = S_AXI_awprot;
  assign m00_couplers_to_m00_couplers_AWREADY = M_AXI_awready;
  assign m00_couplers_to_m00_couplers_AWVALID = S_AXI_awvalid;
  assign m00_couplers_to_m00_couplers_BREADY = S_AXI_bready;
  assign m00_couplers_to_m00_couplers_BRESP = M_AXI_bresp;
  assign m00_couplers_to_m00_couplers_BVALID = M_AXI_bvalid;
  assign m00_couplers_to_m00_couplers_RDATA = M_AXI_rdata;
  assign m00_couplers_to_m00_couplers_RREADY = S_AXI_rready;
  assign m00_couplers_to_m00_couplers_RRESP = M_AXI_rresp;
  assign m00_couplers_to_m00_couplers_RVALID = M_AXI_rvalid;
  assign m00_couplers_to_m00_couplers_WDATA = S_AXI_wdata;
  assign m00_couplers_to_m00_couplers_WREADY = M_AXI_wready;
  assign m00_couplers_to_m00_couplers_WSTRB = S_AXI_wstrb;
  assign m00_couplers_to_m00_couplers_WVALID = S_AXI_wvalid;
endmodule

module m01_couplers_imp_1UBGIXM
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output M_AXI_araddr;
  output M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output M_AXI_awaddr;
  output M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input M_AXI_bresp;
  input M_AXI_bvalid;
  input M_AXI_rdata;
  output M_AXI_rready;
  input M_AXI_rresp;
  input M_AXI_rvalid;
  output M_AXI_wdata;
  input M_AXI_wready;
  output M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input S_AXI_araddr;
  input S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input S_AXI_awaddr;
  input S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output S_AXI_bresp;
  output S_AXI_bvalid;
  output S_AXI_rdata;
  input S_AXI_rready;
  output S_AXI_rresp;
  output S_AXI_rvalid;
  input S_AXI_wdata;
  output S_AXI_wready;
  input S_AXI_wstrb;
  input S_AXI_wvalid;

  wire m01_couplers_to_m01_couplers_ARADDR;
  wire m01_couplers_to_m01_couplers_ARPROT;
  wire m01_couplers_to_m01_couplers_ARREADY;
  wire m01_couplers_to_m01_couplers_ARVALID;
  wire m01_couplers_to_m01_couplers_AWADDR;
  wire m01_couplers_to_m01_couplers_AWPROT;
  wire m01_couplers_to_m01_couplers_AWREADY;
  wire m01_couplers_to_m01_couplers_AWVALID;
  wire m01_couplers_to_m01_couplers_BREADY;
  wire m01_couplers_to_m01_couplers_BRESP;
  wire m01_couplers_to_m01_couplers_BVALID;
  wire m01_couplers_to_m01_couplers_RDATA;
  wire m01_couplers_to_m01_couplers_RREADY;
  wire m01_couplers_to_m01_couplers_RRESP;
  wire m01_couplers_to_m01_couplers_RVALID;
  wire m01_couplers_to_m01_couplers_WDATA;
  wire m01_couplers_to_m01_couplers_WREADY;
  wire m01_couplers_to_m01_couplers_WSTRB;
  wire m01_couplers_to_m01_couplers_WVALID;

  assign M_AXI_araddr = m01_couplers_to_m01_couplers_ARADDR;
  assign M_AXI_arprot = m01_couplers_to_m01_couplers_ARPROT;
  assign M_AXI_arvalid = m01_couplers_to_m01_couplers_ARVALID;
  assign M_AXI_awaddr = m01_couplers_to_m01_couplers_AWADDR;
  assign M_AXI_awprot = m01_couplers_to_m01_couplers_AWPROT;
  assign M_AXI_awvalid = m01_couplers_to_m01_couplers_AWVALID;
  assign M_AXI_bready = m01_couplers_to_m01_couplers_BREADY;
  assign M_AXI_rready = m01_couplers_to_m01_couplers_RREADY;
  assign M_AXI_wdata = m01_couplers_to_m01_couplers_WDATA;
  assign M_AXI_wstrb = m01_couplers_to_m01_couplers_WSTRB;
  assign M_AXI_wvalid = m01_couplers_to_m01_couplers_WVALID;
  assign S_AXI_arready = m01_couplers_to_m01_couplers_ARREADY;
  assign S_AXI_awready = m01_couplers_to_m01_couplers_AWREADY;
  assign S_AXI_bresp = m01_couplers_to_m01_couplers_BRESP;
  assign S_AXI_bvalid = m01_couplers_to_m01_couplers_BVALID;
  assign S_AXI_rdata = m01_couplers_to_m01_couplers_RDATA;
  assign S_AXI_rresp = m01_couplers_to_m01_couplers_RRESP;
  assign S_AXI_rvalid = m01_couplers_to_m01_couplers_RVALID;
  assign S_AXI_wready = m01_couplers_to_m01_couplers_WREADY;
  assign m01_couplers_to_m01_couplers_ARADDR = S_AXI_araddr;
  assign m01_couplers_to_m01_couplers_ARPROT = S_AXI_arprot;
  assign m01_couplers_to_m01_couplers_ARREADY = M_AXI_arready;
  assign m01_couplers_to_m01_couplers_ARVALID = S_AXI_arvalid;
  assign m01_couplers_to_m01_couplers_AWADDR = S_AXI_awaddr;
  assign m01_couplers_to_m01_couplers_AWPROT = S_AXI_awprot;
  assign m01_couplers_to_m01_couplers_AWREADY = M_AXI_awready;
  assign m01_couplers_to_m01_couplers_AWVALID = S_AXI_awvalid;
  assign m01_couplers_to_m01_couplers_BREADY = S_AXI_bready;
  assign m01_couplers_to_m01_couplers_BRESP = M_AXI_bresp;
  assign m01_couplers_to_m01_couplers_BVALID = M_AXI_bvalid;
  assign m01_couplers_to_m01_couplers_RDATA = M_AXI_rdata;
  assign m01_couplers_to_m01_couplers_RREADY = S_AXI_rready;
  assign m01_couplers_to_m01_couplers_RRESP = M_AXI_rresp;
  assign m01_couplers_to_m01_couplers_RVALID = M_AXI_rvalid;
  assign m01_couplers_to_m01_couplers_WDATA = S_AXI_wdata;
  assign m01_couplers_to_m01_couplers_WREADY = M_AXI_wready;
  assign m01_couplers_to_m01_couplers_WSTRB = S_AXI_wstrb;
  assign m01_couplers_to_m01_couplers_WVALID = S_AXI_wvalid;
endmodule

module m02_couplers_imp_1J5P44O
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output M_AXI_araddr;
  output M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output M_AXI_awaddr;
  output M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input M_AXI_bresp;
  input M_AXI_bvalid;
  input M_AXI_rdata;
  output M_AXI_rready;
  input M_AXI_rresp;
  input M_AXI_rvalid;
  output M_AXI_wdata;
  input M_AXI_wready;
  output M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input S_AXI_araddr;
  input S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input S_AXI_awaddr;
  input S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output S_AXI_bresp;
  output S_AXI_bvalid;
  output S_AXI_rdata;
  input S_AXI_rready;
  output S_AXI_rresp;
  output S_AXI_rvalid;
  input S_AXI_wdata;
  output S_AXI_wready;
  input S_AXI_wstrb;
  input S_AXI_wvalid;

  wire m02_couplers_to_m02_couplers_ARADDR;
  wire m02_couplers_to_m02_couplers_ARPROT;
  wire m02_couplers_to_m02_couplers_ARREADY;
  wire m02_couplers_to_m02_couplers_ARVALID;
  wire m02_couplers_to_m02_couplers_AWADDR;
  wire m02_couplers_to_m02_couplers_AWPROT;
  wire m02_couplers_to_m02_couplers_AWREADY;
  wire m02_couplers_to_m02_couplers_AWVALID;
  wire m02_couplers_to_m02_couplers_BREADY;
  wire m02_couplers_to_m02_couplers_BRESP;
  wire m02_couplers_to_m02_couplers_BVALID;
  wire m02_couplers_to_m02_couplers_RDATA;
  wire m02_couplers_to_m02_couplers_RREADY;
  wire m02_couplers_to_m02_couplers_RRESP;
  wire m02_couplers_to_m02_couplers_RVALID;
  wire m02_couplers_to_m02_couplers_WDATA;
  wire m02_couplers_to_m02_couplers_WREADY;
  wire m02_couplers_to_m02_couplers_WSTRB;
  wire m02_couplers_to_m02_couplers_WVALID;

  assign M_AXI_araddr = m02_couplers_to_m02_couplers_ARADDR;
  assign M_AXI_arprot = m02_couplers_to_m02_couplers_ARPROT;
  assign M_AXI_arvalid = m02_couplers_to_m02_couplers_ARVALID;
  assign M_AXI_awaddr = m02_couplers_to_m02_couplers_AWADDR;
  assign M_AXI_awprot = m02_couplers_to_m02_couplers_AWPROT;
  assign M_AXI_awvalid = m02_couplers_to_m02_couplers_AWVALID;
  assign M_AXI_bready = m02_couplers_to_m02_couplers_BREADY;
  assign M_AXI_rready = m02_couplers_to_m02_couplers_RREADY;
  assign M_AXI_wdata = m02_couplers_to_m02_couplers_WDATA;
  assign M_AXI_wstrb = m02_couplers_to_m02_couplers_WSTRB;
  assign M_AXI_wvalid = m02_couplers_to_m02_couplers_WVALID;
  assign S_AXI_arready = m02_couplers_to_m02_couplers_ARREADY;
  assign S_AXI_awready = m02_couplers_to_m02_couplers_AWREADY;
  assign S_AXI_bresp = m02_couplers_to_m02_couplers_BRESP;
  assign S_AXI_bvalid = m02_couplers_to_m02_couplers_BVALID;
  assign S_AXI_rdata = m02_couplers_to_m02_couplers_RDATA;
  assign S_AXI_rresp = m02_couplers_to_m02_couplers_RRESP;
  assign S_AXI_rvalid = m02_couplers_to_m02_couplers_RVALID;
  assign S_AXI_wready = m02_couplers_to_m02_couplers_WREADY;
  assign m02_couplers_to_m02_couplers_ARADDR = S_AXI_araddr;
  assign m02_couplers_to_m02_couplers_ARPROT = S_AXI_arprot;
  assign m02_couplers_to_m02_couplers_ARREADY = M_AXI_arready;
  assign m02_couplers_to_m02_couplers_ARVALID = S_AXI_arvalid;
  assign m02_couplers_to_m02_couplers_AWADDR = S_AXI_awaddr;
  assign m02_couplers_to_m02_couplers_AWPROT = S_AXI_awprot;
  assign m02_couplers_to_m02_couplers_AWREADY = M_AXI_awready;
  assign m02_couplers_to_m02_couplers_AWVALID = S_AXI_awvalid;
  assign m02_couplers_to_m02_couplers_BREADY = S_AXI_bready;
  assign m02_couplers_to_m02_couplers_BRESP = M_AXI_bresp;
  assign m02_couplers_to_m02_couplers_BVALID = M_AXI_bvalid;
  assign m02_couplers_to_m02_couplers_RDATA = M_AXI_rdata;
  assign m02_couplers_to_m02_couplers_RREADY = S_AXI_rready;
  assign m02_couplers_to_m02_couplers_RRESP = M_AXI_rresp;
  assign m02_couplers_to_m02_couplers_RVALID = M_AXI_rvalid;
  assign m02_couplers_to_m02_couplers_WDATA = S_AXI_wdata;
  assign m02_couplers_to_m02_couplers_WREADY = M_AXI_wready;
  assign m02_couplers_to_m02_couplers_WSTRB = S_AXI_wstrb;
  assign m02_couplers_to_m02_couplers_WVALID = S_AXI_wvalid;
endmodule

module m03_couplers_imp_T17W6X
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output M_AXI_araddr;
  output M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output M_AXI_awaddr;
  output M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input M_AXI_bresp;
  input M_AXI_bvalid;
  input M_AXI_rdata;
  output M_AXI_rready;
  input M_AXI_rresp;
  input M_AXI_rvalid;
  output M_AXI_wdata;
  input M_AXI_wready;
  output M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input S_AXI_araddr;
  input S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input S_AXI_awaddr;
  input S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output S_AXI_bresp;
  output S_AXI_bvalid;
  output S_AXI_rdata;
  input S_AXI_rready;
  output S_AXI_rresp;
  output S_AXI_rvalid;
  input S_AXI_wdata;
  output S_AXI_wready;
  input S_AXI_wstrb;
  input S_AXI_wvalid;

  wire m03_couplers_to_m03_couplers_ARADDR;
  wire m03_couplers_to_m03_couplers_ARPROT;
  wire m03_couplers_to_m03_couplers_ARREADY;
  wire m03_couplers_to_m03_couplers_ARVALID;
  wire m03_couplers_to_m03_couplers_AWADDR;
  wire m03_couplers_to_m03_couplers_AWPROT;
  wire m03_couplers_to_m03_couplers_AWREADY;
  wire m03_couplers_to_m03_couplers_AWVALID;
  wire m03_couplers_to_m03_couplers_BREADY;
  wire m03_couplers_to_m03_couplers_BRESP;
  wire m03_couplers_to_m03_couplers_BVALID;
  wire m03_couplers_to_m03_couplers_RDATA;
  wire m03_couplers_to_m03_couplers_RREADY;
  wire m03_couplers_to_m03_couplers_RRESP;
  wire m03_couplers_to_m03_couplers_RVALID;
  wire m03_couplers_to_m03_couplers_WDATA;
  wire m03_couplers_to_m03_couplers_WREADY;
  wire m03_couplers_to_m03_couplers_WSTRB;
  wire m03_couplers_to_m03_couplers_WVALID;

  assign M_AXI_araddr = m03_couplers_to_m03_couplers_ARADDR;
  assign M_AXI_arprot = m03_couplers_to_m03_couplers_ARPROT;
  assign M_AXI_arvalid = m03_couplers_to_m03_couplers_ARVALID;
  assign M_AXI_awaddr = m03_couplers_to_m03_couplers_AWADDR;
  assign M_AXI_awprot = m03_couplers_to_m03_couplers_AWPROT;
  assign M_AXI_awvalid = m03_couplers_to_m03_couplers_AWVALID;
  assign M_AXI_bready = m03_couplers_to_m03_couplers_BREADY;
  assign M_AXI_rready = m03_couplers_to_m03_couplers_RREADY;
  assign M_AXI_wdata = m03_couplers_to_m03_couplers_WDATA;
  assign M_AXI_wstrb = m03_couplers_to_m03_couplers_WSTRB;
  assign M_AXI_wvalid = m03_couplers_to_m03_couplers_WVALID;
  assign S_AXI_arready = m03_couplers_to_m03_couplers_ARREADY;
  assign S_AXI_awready = m03_couplers_to_m03_couplers_AWREADY;
  assign S_AXI_bresp = m03_couplers_to_m03_couplers_BRESP;
  assign S_AXI_bvalid = m03_couplers_to_m03_couplers_BVALID;
  assign S_AXI_rdata = m03_couplers_to_m03_couplers_RDATA;
  assign S_AXI_rresp = m03_couplers_to_m03_couplers_RRESP;
  assign S_AXI_rvalid = m03_couplers_to_m03_couplers_RVALID;
  assign S_AXI_wready = m03_couplers_to_m03_couplers_WREADY;
  assign m03_couplers_to_m03_couplers_ARADDR = S_AXI_araddr;
  assign m03_couplers_to_m03_couplers_ARPROT = S_AXI_arprot;
  assign m03_couplers_to_m03_couplers_ARREADY = M_AXI_arready;
  assign m03_couplers_to_m03_couplers_ARVALID = S_AXI_arvalid;
  assign m03_couplers_to_m03_couplers_AWADDR = S_AXI_awaddr;
  assign m03_couplers_to_m03_couplers_AWPROT = S_AXI_awprot;
  assign m03_couplers_to_m03_couplers_AWREADY = M_AXI_awready;
  assign m03_couplers_to_m03_couplers_AWVALID = S_AXI_awvalid;
  assign m03_couplers_to_m03_couplers_BREADY = S_AXI_bready;
  assign m03_couplers_to_m03_couplers_BRESP = M_AXI_bresp;
  assign m03_couplers_to_m03_couplers_BVALID = M_AXI_bvalid;
  assign m03_couplers_to_m03_couplers_RDATA = M_AXI_rdata;
  assign m03_couplers_to_m03_couplers_RREADY = S_AXI_rready;
  assign m03_couplers_to_m03_couplers_RRESP = M_AXI_rresp;
  assign m03_couplers_to_m03_couplers_RVALID = M_AXI_rvalid;
  assign m03_couplers_to_m03_couplers_WDATA = S_AXI_wdata;
  assign m03_couplers_to_m03_couplers_WREADY = M_AXI_wready;
  assign m03_couplers_to_m03_couplers_WSTRB = S_AXI_wstrb;
  assign m03_couplers_to_m03_couplers_WVALID = S_AXI_wvalid;
endmodule

module m04_couplers_imp_15FU5SC
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input [0:0]M_AXI_arready;
  output [0:0]M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input [0:0]M_AXI_awready;
  output [0:0]M_AXI_awvalid;
  output [0:0]M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output [0:0]M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input [0:0]M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input [0:0]M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output [0:0]S_AXI_arready;
  input [0:0]S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output [0:0]S_AXI_awready;
  input [0:0]S_AXI_awvalid;
  input [0:0]S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input [0:0]S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output [0:0]S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output [0:0]S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wvalid;

  wire [39:0]m04_couplers_to_m04_couplers_ARADDR;
  wire [2:0]m04_couplers_to_m04_couplers_ARPROT;
  wire [0:0]m04_couplers_to_m04_couplers_ARREADY;
  wire [0:0]m04_couplers_to_m04_couplers_ARVALID;
  wire [39:0]m04_couplers_to_m04_couplers_AWADDR;
  wire [2:0]m04_couplers_to_m04_couplers_AWPROT;
  wire [0:0]m04_couplers_to_m04_couplers_AWREADY;
  wire [0:0]m04_couplers_to_m04_couplers_AWVALID;
  wire [0:0]m04_couplers_to_m04_couplers_BREADY;
  wire [1:0]m04_couplers_to_m04_couplers_BRESP;
  wire [0:0]m04_couplers_to_m04_couplers_BVALID;
  wire [31:0]m04_couplers_to_m04_couplers_RDATA;
  wire [0:0]m04_couplers_to_m04_couplers_RREADY;
  wire [1:0]m04_couplers_to_m04_couplers_RRESP;
  wire [0:0]m04_couplers_to_m04_couplers_RVALID;
  wire [31:0]m04_couplers_to_m04_couplers_WDATA;
  wire [0:0]m04_couplers_to_m04_couplers_WREADY;
  wire [3:0]m04_couplers_to_m04_couplers_WSTRB;
  wire [0:0]m04_couplers_to_m04_couplers_WVALID;

  assign M_AXI_araddr[39:0] = m04_couplers_to_m04_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = m04_couplers_to_m04_couplers_ARPROT;
  assign M_AXI_arvalid[0] = m04_couplers_to_m04_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = m04_couplers_to_m04_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = m04_couplers_to_m04_couplers_AWPROT;
  assign M_AXI_awvalid[0] = m04_couplers_to_m04_couplers_AWVALID;
  assign M_AXI_bready[0] = m04_couplers_to_m04_couplers_BREADY;
  assign M_AXI_rready[0] = m04_couplers_to_m04_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m04_couplers_to_m04_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m04_couplers_to_m04_couplers_WSTRB;
  assign M_AXI_wvalid[0] = m04_couplers_to_m04_couplers_WVALID;
  assign S_AXI_arready[0] = m04_couplers_to_m04_couplers_ARREADY;
  assign S_AXI_awready[0] = m04_couplers_to_m04_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = m04_couplers_to_m04_couplers_BRESP;
  assign S_AXI_bvalid[0] = m04_couplers_to_m04_couplers_BVALID;
  assign S_AXI_rdata[31:0] = m04_couplers_to_m04_couplers_RDATA;
  assign S_AXI_rresp[1:0] = m04_couplers_to_m04_couplers_RRESP;
  assign S_AXI_rvalid[0] = m04_couplers_to_m04_couplers_RVALID;
  assign S_AXI_wready[0] = m04_couplers_to_m04_couplers_WREADY;
  assign m04_couplers_to_m04_couplers_ARADDR = S_AXI_araddr[39:0];
  assign m04_couplers_to_m04_couplers_ARPROT = S_AXI_arprot[2:0];
  assign m04_couplers_to_m04_couplers_ARREADY = M_AXI_arready[0];
  assign m04_couplers_to_m04_couplers_ARVALID = S_AXI_arvalid[0];
  assign m04_couplers_to_m04_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign m04_couplers_to_m04_couplers_AWPROT = S_AXI_awprot[2:0];
  assign m04_couplers_to_m04_couplers_AWREADY = M_AXI_awready[0];
  assign m04_couplers_to_m04_couplers_AWVALID = S_AXI_awvalid[0];
  assign m04_couplers_to_m04_couplers_BREADY = S_AXI_bready[0];
  assign m04_couplers_to_m04_couplers_BRESP = M_AXI_bresp[1:0];
  assign m04_couplers_to_m04_couplers_BVALID = M_AXI_bvalid[0];
  assign m04_couplers_to_m04_couplers_RDATA = M_AXI_rdata[31:0];
  assign m04_couplers_to_m04_couplers_RREADY = S_AXI_rready[0];
  assign m04_couplers_to_m04_couplers_RRESP = M_AXI_rresp[1:0];
  assign m04_couplers_to_m04_couplers_RVALID = M_AXI_rvalid[0];
  assign m04_couplers_to_m04_couplers_WDATA = S_AXI_wdata[31:0];
  assign m04_couplers_to_m04_couplers_WREADY = M_AXI_wready[0];
  assign m04_couplers_to_m04_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign m04_couplers_to_m04_couplers_WVALID = S_AXI_wvalid[0];
endmodule

module m05_couplers_imp_GFBASD
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input [0:0]M_AXI_arready;
  output [0:0]M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input [0:0]M_AXI_awready;
  output [0:0]M_AXI_awvalid;
  output [0:0]M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output [0:0]M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input [0:0]M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input [0:0]M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output [0:0]S_AXI_arready;
  input [0:0]S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output [0:0]S_AXI_awready;
  input [0:0]S_AXI_awvalid;
  input [0:0]S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input [0:0]S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output [0:0]S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output [0:0]S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wvalid;

  wire [39:0]m05_couplers_to_m05_couplers_ARADDR;
  wire [2:0]m05_couplers_to_m05_couplers_ARPROT;
  wire [0:0]m05_couplers_to_m05_couplers_ARREADY;
  wire [0:0]m05_couplers_to_m05_couplers_ARVALID;
  wire [39:0]m05_couplers_to_m05_couplers_AWADDR;
  wire [2:0]m05_couplers_to_m05_couplers_AWPROT;
  wire [0:0]m05_couplers_to_m05_couplers_AWREADY;
  wire [0:0]m05_couplers_to_m05_couplers_AWVALID;
  wire [0:0]m05_couplers_to_m05_couplers_BREADY;
  wire [1:0]m05_couplers_to_m05_couplers_BRESP;
  wire [0:0]m05_couplers_to_m05_couplers_BVALID;
  wire [31:0]m05_couplers_to_m05_couplers_RDATA;
  wire [0:0]m05_couplers_to_m05_couplers_RREADY;
  wire [1:0]m05_couplers_to_m05_couplers_RRESP;
  wire [0:0]m05_couplers_to_m05_couplers_RVALID;
  wire [31:0]m05_couplers_to_m05_couplers_WDATA;
  wire [0:0]m05_couplers_to_m05_couplers_WREADY;
  wire [3:0]m05_couplers_to_m05_couplers_WSTRB;
  wire [0:0]m05_couplers_to_m05_couplers_WVALID;

  assign M_AXI_araddr[39:0] = m05_couplers_to_m05_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = m05_couplers_to_m05_couplers_ARPROT;
  assign M_AXI_arvalid[0] = m05_couplers_to_m05_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = m05_couplers_to_m05_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = m05_couplers_to_m05_couplers_AWPROT;
  assign M_AXI_awvalid[0] = m05_couplers_to_m05_couplers_AWVALID;
  assign M_AXI_bready[0] = m05_couplers_to_m05_couplers_BREADY;
  assign M_AXI_rready[0] = m05_couplers_to_m05_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m05_couplers_to_m05_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m05_couplers_to_m05_couplers_WSTRB;
  assign M_AXI_wvalid[0] = m05_couplers_to_m05_couplers_WVALID;
  assign S_AXI_arready[0] = m05_couplers_to_m05_couplers_ARREADY;
  assign S_AXI_awready[0] = m05_couplers_to_m05_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = m05_couplers_to_m05_couplers_BRESP;
  assign S_AXI_bvalid[0] = m05_couplers_to_m05_couplers_BVALID;
  assign S_AXI_rdata[31:0] = m05_couplers_to_m05_couplers_RDATA;
  assign S_AXI_rresp[1:0] = m05_couplers_to_m05_couplers_RRESP;
  assign S_AXI_rvalid[0] = m05_couplers_to_m05_couplers_RVALID;
  assign S_AXI_wready[0] = m05_couplers_to_m05_couplers_WREADY;
  assign m05_couplers_to_m05_couplers_ARADDR = S_AXI_araddr[39:0];
  assign m05_couplers_to_m05_couplers_ARPROT = S_AXI_arprot[2:0];
  assign m05_couplers_to_m05_couplers_ARREADY = M_AXI_arready[0];
  assign m05_couplers_to_m05_couplers_ARVALID = S_AXI_arvalid[0];
  assign m05_couplers_to_m05_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign m05_couplers_to_m05_couplers_AWPROT = S_AXI_awprot[2:0];
  assign m05_couplers_to_m05_couplers_AWREADY = M_AXI_awready[0];
  assign m05_couplers_to_m05_couplers_AWVALID = S_AXI_awvalid[0];
  assign m05_couplers_to_m05_couplers_BREADY = S_AXI_bready[0];
  assign m05_couplers_to_m05_couplers_BRESP = M_AXI_bresp[1:0];
  assign m05_couplers_to_m05_couplers_BVALID = M_AXI_bvalid[0];
  assign m05_couplers_to_m05_couplers_RDATA = M_AXI_rdata[31:0];
  assign m05_couplers_to_m05_couplers_RREADY = S_AXI_rready[0];
  assign m05_couplers_to_m05_couplers_RRESP = M_AXI_rresp[1:0];
  assign m05_couplers_to_m05_couplers_RVALID = M_AXI_rvalid[0];
  assign m05_couplers_to_m05_couplers_WDATA = S_AXI_wdata[31:0];
  assign m05_couplers_to_m05_couplers_WREADY = M_AXI_wready[0];
  assign m05_couplers_to_m05_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign m05_couplers_to_m05_couplers_WVALID = S_AXI_wvalid[0];
endmodule

module m06_couplers_imp_59JXRJ
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input [0:0]M_AXI_arready;
  output [0:0]M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input [0:0]M_AXI_awready;
  output [0:0]M_AXI_awvalid;
  output [0:0]M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output [0:0]M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input [0:0]M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input [0:0]M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output [0:0]S_AXI_arready;
  input [0:0]S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output [0:0]S_AXI_awready;
  input [0:0]S_AXI_awvalid;
  input [0:0]S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input [0:0]S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output [0:0]S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output [0:0]S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wvalid;

  wire [39:0]m06_couplers_to_m06_couplers_ARADDR;
  wire [2:0]m06_couplers_to_m06_couplers_ARPROT;
  wire [0:0]m06_couplers_to_m06_couplers_ARREADY;
  wire [0:0]m06_couplers_to_m06_couplers_ARVALID;
  wire [39:0]m06_couplers_to_m06_couplers_AWADDR;
  wire [2:0]m06_couplers_to_m06_couplers_AWPROT;
  wire [0:0]m06_couplers_to_m06_couplers_AWREADY;
  wire [0:0]m06_couplers_to_m06_couplers_AWVALID;
  wire [0:0]m06_couplers_to_m06_couplers_BREADY;
  wire [1:0]m06_couplers_to_m06_couplers_BRESP;
  wire [0:0]m06_couplers_to_m06_couplers_BVALID;
  wire [31:0]m06_couplers_to_m06_couplers_RDATA;
  wire [0:0]m06_couplers_to_m06_couplers_RREADY;
  wire [1:0]m06_couplers_to_m06_couplers_RRESP;
  wire [0:0]m06_couplers_to_m06_couplers_RVALID;
  wire [31:0]m06_couplers_to_m06_couplers_WDATA;
  wire [0:0]m06_couplers_to_m06_couplers_WREADY;
  wire [3:0]m06_couplers_to_m06_couplers_WSTRB;
  wire [0:0]m06_couplers_to_m06_couplers_WVALID;

  assign M_AXI_araddr[39:0] = m06_couplers_to_m06_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = m06_couplers_to_m06_couplers_ARPROT;
  assign M_AXI_arvalid[0] = m06_couplers_to_m06_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = m06_couplers_to_m06_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = m06_couplers_to_m06_couplers_AWPROT;
  assign M_AXI_awvalid[0] = m06_couplers_to_m06_couplers_AWVALID;
  assign M_AXI_bready[0] = m06_couplers_to_m06_couplers_BREADY;
  assign M_AXI_rready[0] = m06_couplers_to_m06_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m06_couplers_to_m06_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m06_couplers_to_m06_couplers_WSTRB;
  assign M_AXI_wvalid[0] = m06_couplers_to_m06_couplers_WVALID;
  assign S_AXI_arready[0] = m06_couplers_to_m06_couplers_ARREADY;
  assign S_AXI_awready[0] = m06_couplers_to_m06_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = m06_couplers_to_m06_couplers_BRESP;
  assign S_AXI_bvalid[0] = m06_couplers_to_m06_couplers_BVALID;
  assign S_AXI_rdata[31:0] = m06_couplers_to_m06_couplers_RDATA;
  assign S_AXI_rresp[1:0] = m06_couplers_to_m06_couplers_RRESP;
  assign S_AXI_rvalid[0] = m06_couplers_to_m06_couplers_RVALID;
  assign S_AXI_wready[0] = m06_couplers_to_m06_couplers_WREADY;
  assign m06_couplers_to_m06_couplers_ARADDR = S_AXI_araddr[39:0];
  assign m06_couplers_to_m06_couplers_ARPROT = S_AXI_arprot[2:0];
  assign m06_couplers_to_m06_couplers_ARREADY = M_AXI_arready[0];
  assign m06_couplers_to_m06_couplers_ARVALID = S_AXI_arvalid[0];
  assign m06_couplers_to_m06_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign m06_couplers_to_m06_couplers_AWPROT = S_AXI_awprot[2:0];
  assign m06_couplers_to_m06_couplers_AWREADY = M_AXI_awready[0];
  assign m06_couplers_to_m06_couplers_AWVALID = S_AXI_awvalid[0];
  assign m06_couplers_to_m06_couplers_BREADY = S_AXI_bready[0];
  assign m06_couplers_to_m06_couplers_BRESP = M_AXI_bresp[1:0];
  assign m06_couplers_to_m06_couplers_BVALID = M_AXI_bvalid[0];
  assign m06_couplers_to_m06_couplers_RDATA = M_AXI_rdata[31:0];
  assign m06_couplers_to_m06_couplers_RREADY = S_AXI_rready[0];
  assign m06_couplers_to_m06_couplers_RRESP = M_AXI_rresp[1:0];
  assign m06_couplers_to_m06_couplers_RVALID = M_AXI_rvalid[0];
  assign m06_couplers_to_m06_couplers_WDATA = S_AXI_wdata[31:0];
  assign m06_couplers_to_m06_couplers_WREADY = M_AXI_wready[0];
  assign m06_couplers_to_m06_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign m06_couplers_to_m06_couplers_WVALID = S_AXI_wvalid[0];
endmodule

module m07_couplers_imp_1GBLMBI
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input [0:0]M_AXI_arready;
  output [0:0]M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input [0:0]M_AXI_awready;
  output [0:0]M_AXI_awvalid;
  output [0:0]M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output [0:0]M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input [0:0]M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input [0:0]M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output [0:0]S_AXI_arready;
  input [0:0]S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output [0:0]S_AXI_awready;
  input [0:0]S_AXI_awvalid;
  input [0:0]S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input [0:0]S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output [0:0]S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output [0:0]S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wvalid;

  wire [39:0]m07_couplers_to_m07_couplers_ARADDR;
  wire [2:0]m07_couplers_to_m07_couplers_ARPROT;
  wire [0:0]m07_couplers_to_m07_couplers_ARREADY;
  wire [0:0]m07_couplers_to_m07_couplers_ARVALID;
  wire [39:0]m07_couplers_to_m07_couplers_AWADDR;
  wire [2:0]m07_couplers_to_m07_couplers_AWPROT;
  wire [0:0]m07_couplers_to_m07_couplers_AWREADY;
  wire [0:0]m07_couplers_to_m07_couplers_AWVALID;
  wire [0:0]m07_couplers_to_m07_couplers_BREADY;
  wire [1:0]m07_couplers_to_m07_couplers_BRESP;
  wire [0:0]m07_couplers_to_m07_couplers_BVALID;
  wire [31:0]m07_couplers_to_m07_couplers_RDATA;
  wire [0:0]m07_couplers_to_m07_couplers_RREADY;
  wire [1:0]m07_couplers_to_m07_couplers_RRESP;
  wire [0:0]m07_couplers_to_m07_couplers_RVALID;
  wire [31:0]m07_couplers_to_m07_couplers_WDATA;
  wire [0:0]m07_couplers_to_m07_couplers_WREADY;
  wire [3:0]m07_couplers_to_m07_couplers_WSTRB;
  wire [0:0]m07_couplers_to_m07_couplers_WVALID;

  assign M_AXI_araddr[39:0] = m07_couplers_to_m07_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = m07_couplers_to_m07_couplers_ARPROT;
  assign M_AXI_arvalid[0] = m07_couplers_to_m07_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = m07_couplers_to_m07_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = m07_couplers_to_m07_couplers_AWPROT;
  assign M_AXI_awvalid[0] = m07_couplers_to_m07_couplers_AWVALID;
  assign M_AXI_bready[0] = m07_couplers_to_m07_couplers_BREADY;
  assign M_AXI_rready[0] = m07_couplers_to_m07_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m07_couplers_to_m07_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m07_couplers_to_m07_couplers_WSTRB;
  assign M_AXI_wvalid[0] = m07_couplers_to_m07_couplers_WVALID;
  assign S_AXI_arready[0] = m07_couplers_to_m07_couplers_ARREADY;
  assign S_AXI_awready[0] = m07_couplers_to_m07_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = m07_couplers_to_m07_couplers_BRESP;
  assign S_AXI_bvalid[0] = m07_couplers_to_m07_couplers_BVALID;
  assign S_AXI_rdata[31:0] = m07_couplers_to_m07_couplers_RDATA;
  assign S_AXI_rresp[1:0] = m07_couplers_to_m07_couplers_RRESP;
  assign S_AXI_rvalid[0] = m07_couplers_to_m07_couplers_RVALID;
  assign S_AXI_wready[0] = m07_couplers_to_m07_couplers_WREADY;
  assign m07_couplers_to_m07_couplers_ARADDR = S_AXI_araddr[39:0];
  assign m07_couplers_to_m07_couplers_ARPROT = S_AXI_arprot[2:0];
  assign m07_couplers_to_m07_couplers_ARREADY = M_AXI_arready[0];
  assign m07_couplers_to_m07_couplers_ARVALID = S_AXI_arvalid[0];
  assign m07_couplers_to_m07_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign m07_couplers_to_m07_couplers_AWPROT = S_AXI_awprot[2:0];
  assign m07_couplers_to_m07_couplers_AWREADY = M_AXI_awready[0];
  assign m07_couplers_to_m07_couplers_AWVALID = S_AXI_awvalid[0];
  assign m07_couplers_to_m07_couplers_BREADY = S_AXI_bready[0];
  assign m07_couplers_to_m07_couplers_BRESP = M_AXI_bresp[1:0];
  assign m07_couplers_to_m07_couplers_BVALID = M_AXI_bvalid[0];
  assign m07_couplers_to_m07_couplers_RDATA = M_AXI_rdata[31:0];
  assign m07_couplers_to_m07_couplers_RREADY = S_AXI_rready[0];
  assign m07_couplers_to_m07_couplers_RRESP = M_AXI_rresp[1:0];
  assign m07_couplers_to_m07_couplers_RVALID = M_AXI_rvalid[0];
  assign m07_couplers_to_m07_couplers_WDATA = S_AXI_wdata[31:0];
  assign m07_couplers_to_m07_couplers_WREADY = M_AXI_wready[0];
  assign m07_couplers_to_m07_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign m07_couplers_to_m07_couplers_WVALID = S_AXI_wvalid[0];
endmodule

module s00_couplers_imp_MCTRXI
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [7:0]M_AXI_arlen;
  output [0:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [7:0]M_AXI_awlen;
  output [0:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [127:0]M_AXI_rdata;
  input M_AXI_rlast;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [127:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [15:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [31:0]auto_pc_to_auto_us_ARADDR;
  wire [1:0]auto_pc_to_auto_us_ARBURST;
  wire [3:0]auto_pc_to_auto_us_ARCACHE;
  wire [7:0]auto_pc_to_auto_us_ARLEN;
  wire [0:0]auto_pc_to_auto_us_ARLOCK;
  wire [2:0]auto_pc_to_auto_us_ARPROT;
  wire [3:0]auto_pc_to_auto_us_ARQOS;
  wire auto_pc_to_auto_us_ARREADY;
  wire [3:0]auto_pc_to_auto_us_ARREGION;
  wire [2:0]auto_pc_to_auto_us_ARSIZE;
  wire auto_pc_to_auto_us_ARVALID;
  wire [31:0]auto_pc_to_auto_us_AWADDR;
  wire [1:0]auto_pc_to_auto_us_AWBURST;
  wire [3:0]auto_pc_to_auto_us_AWCACHE;
  wire [7:0]auto_pc_to_auto_us_AWLEN;
  wire [0:0]auto_pc_to_auto_us_AWLOCK;
  wire [2:0]auto_pc_to_auto_us_AWPROT;
  wire [3:0]auto_pc_to_auto_us_AWQOS;
  wire auto_pc_to_auto_us_AWREADY;
  wire [3:0]auto_pc_to_auto_us_AWREGION;
  wire [2:0]auto_pc_to_auto_us_AWSIZE;
  wire auto_pc_to_auto_us_AWVALID;
  wire auto_pc_to_auto_us_BREADY;
  wire [1:0]auto_pc_to_auto_us_BRESP;
  wire auto_pc_to_auto_us_BVALID;
  wire [31:0]auto_pc_to_auto_us_RDATA;
  wire auto_pc_to_auto_us_RLAST;
  wire auto_pc_to_auto_us_RREADY;
  wire [1:0]auto_pc_to_auto_us_RRESP;
  wire auto_pc_to_auto_us_RVALID;
  wire [31:0]auto_pc_to_auto_us_WDATA;
  wire auto_pc_to_auto_us_WLAST;
  wire auto_pc_to_auto_us_WREADY;
  wire [3:0]auto_pc_to_auto_us_WSTRB;
  wire auto_pc_to_auto_us_WVALID;
  wire [31:0]auto_us_to_s00_couplers_ARADDR;
  wire [1:0]auto_us_to_s00_couplers_ARBURST;
  wire [3:0]auto_us_to_s00_couplers_ARCACHE;
  wire [7:0]auto_us_to_s00_couplers_ARLEN;
  wire [0:0]auto_us_to_s00_couplers_ARLOCK;
  wire [2:0]auto_us_to_s00_couplers_ARPROT;
  wire [3:0]auto_us_to_s00_couplers_ARQOS;
  wire auto_us_to_s00_couplers_ARREADY;
  wire [2:0]auto_us_to_s00_couplers_ARSIZE;
  wire auto_us_to_s00_couplers_ARVALID;
  wire [31:0]auto_us_to_s00_couplers_AWADDR;
  wire [1:0]auto_us_to_s00_couplers_AWBURST;
  wire [3:0]auto_us_to_s00_couplers_AWCACHE;
  wire [7:0]auto_us_to_s00_couplers_AWLEN;
  wire [0:0]auto_us_to_s00_couplers_AWLOCK;
  wire [2:0]auto_us_to_s00_couplers_AWPROT;
  wire [3:0]auto_us_to_s00_couplers_AWQOS;
  wire auto_us_to_s00_couplers_AWREADY;
  wire [2:0]auto_us_to_s00_couplers_AWSIZE;
  wire auto_us_to_s00_couplers_AWVALID;
  wire auto_us_to_s00_couplers_BREADY;
  wire [1:0]auto_us_to_s00_couplers_BRESP;
  wire auto_us_to_s00_couplers_BVALID;
  wire [127:0]auto_us_to_s00_couplers_RDATA;
  wire auto_us_to_s00_couplers_RLAST;
  wire auto_us_to_s00_couplers_RREADY;
  wire [1:0]auto_us_to_s00_couplers_RRESP;
  wire auto_us_to_s00_couplers_RVALID;
  wire [127:0]auto_us_to_s00_couplers_WDATA;
  wire auto_us_to_s00_couplers_WLAST;
  wire auto_us_to_s00_couplers_WREADY;
  wire [15:0]auto_us_to_s00_couplers_WSTRB;
  wire auto_us_to_s00_couplers_WVALID;
  wire [31:0]s00_couplers_to_auto_pc_ARADDR;
  wire [2:0]s00_couplers_to_auto_pc_ARPROT;
  wire s00_couplers_to_auto_pc_ARREADY;
  wire s00_couplers_to_auto_pc_ARVALID;
  wire [31:0]s00_couplers_to_auto_pc_AWADDR;
  wire [2:0]s00_couplers_to_auto_pc_AWPROT;
  wire s00_couplers_to_auto_pc_AWREADY;
  wire s00_couplers_to_auto_pc_AWVALID;
  wire s00_couplers_to_auto_pc_BREADY;
  wire [1:0]s00_couplers_to_auto_pc_BRESP;
  wire s00_couplers_to_auto_pc_BVALID;
  wire [31:0]s00_couplers_to_auto_pc_RDATA;
  wire s00_couplers_to_auto_pc_RREADY;
  wire [1:0]s00_couplers_to_auto_pc_RRESP;
  wire s00_couplers_to_auto_pc_RVALID;
  wire [31:0]s00_couplers_to_auto_pc_WDATA;
  wire s00_couplers_to_auto_pc_WREADY;
  wire [3:0]s00_couplers_to_auto_pc_WSTRB;
  wire s00_couplers_to_auto_pc_WVALID;

  assign M_AXI_araddr[31:0] = auto_us_to_s00_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = auto_us_to_s00_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = auto_us_to_s00_couplers_ARCACHE;
  assign M_AXI_arlen[7:0] = auto_us_to_s00_couplers_ARLEN;
  assign M_AXI_arlock[0] = auto_us_to_s00_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = auto_us_to_s00_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = auto_us_to_s00_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = auto_us_to_s00_couplers_ARSIZE;
  assign M_AXI_arvalid = auto_us_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[31:0] = auto_us_to_s00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = auto_us_to_s00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = auto_us_to_s00_couplers_AWCACHE;
  assign M_AXI_awlen[7:0] = auto_us_to_s00_couplers_AWLEN;
  assign M_AXI_awlock[0] = auto_us_to_s00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = auto_us_to_s00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = auto_us_to_s00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = auto_us_to_s00_couplers_AWSIZE;
  assign M_AXI_awvalid = auto_us_to_s00_couplers_AWVALID;
  assign M_AXI_bready = auto_us_to_s00_couplers_BREADY;
  assign M_AXI_rready = auto_us_to_s00_couplers_RREADY;
  assign M_AXI_wdata[127:0] = auto_us_to_s00_couplers_WDATA;
  assign M_AXI_wlast = auto_us_to_s00_couplers_WLAST;
  assign M_AXI_wstrb[15:0] = auto_us_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = auto_us_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = s00_couplers_to_auto_pc_ARREADY;
  assign S_AXI_awready = s00_couplers_to_auto_pc_AWREADY;
  assign S_AXI_bresp[1:0] = s00_couplers_to_auto_pc_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_auto_pc_BVALID;
  assign S_AXI_rdata[31:0] = s00_couplers_to_auto_pc_RDATA;
  assign S_AXI_rresp[1:0] = s00_couplers_to_auto_pc_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_auto_pc_RVALID;
  assign S_AXI_wready = s00_couplers_to_auto_pc_WREADY;
  assign auto_us_to_s00_couplers_ARREADY = M_AXI_arready;
  assign auto_us_to_s00_couplers_AWREADY = M_AXI_awready;
  assign auto_us_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_us_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign auto_us_to_s00_couplers_RDATA = M_AXI_rdata[127:0];
  assign auto_us_to_s00_couplers_RLAST = M_AXI_rlast;
  assign auto_us_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_us_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign auto_us_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_auto_pc_ARADDR = S_AXI_araddr[31:0];
  assign s00_couplers_to_auto_pc_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_auto_pc_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_auto_pc_AWADDR = S_AXI_awaddr[31:0];
  assign s00_couplers_to_auto_pc_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_auto_pc_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_auto_pc_BREADY = S_AXI_bready;
  assign s00_couplers_to_auto_pc_RREADY = S_AXI_rready;
  assign s00_couplers_to_auto_pc_WDATA = S_AXI_wdata[31:0];
  assign s00_couplers_to_auto_pc_WSTRB = S_AXI_wstrb[3:0];
  assign s00_couplers_to_auto_pc_WVALID = S_AXI_wvalid;
  system_auto_pc_1 auto_pc
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(auto_pc_to_auto_us_ARADDR),
        .m_axi_arburst(auto_pc_to_auto_us_ARBURST),
        .m_axi_arcache(auto_pc_to_auto_us_ARCACHE),
        .m_axi_arlen(auto_pc_to_auto_us_ARLEN),
        .m_axi_arlock(auto_pc_to_auto_us_ARLOCK),
        .m_axi_arprot(auto_pc_to_auto_us_ARPROT),
        .m_axi_arqos(auto_pc_to_auto_us_ARQOS),
        .m_axi_arready(auto_pc_to_auto_us_ARREADY),
        .m_axi_arregion(auto_pc_to_auto_us_ARREGION),
        .m_axi_arsize(auto_pc_to_auto_us_ARSIZE),
        .m_axi_arvalid(auto_pc_to_auto_us_ARVALID),
        .m_axi_awaddr(auto_pc_to_auto_us_AWADDR),
        .m_axi_awburst(auto_pc_to_auto_us_AWBURST),
        .m_axi_awcache(auto_pc_to_auto_us_AWCACHE),
        .m_axi_awlen(auto_pc_to_auto_us_AWLEN),
        .m_axi_awlock(auto_pc_to_auto_us_AWLOCK),
        .m_axi_awprot(auto_pc_to_auto_us_AWPROT),
        .m_axi_awqos(auto_pc_to_auto_us_AWQOS),
        .m_axi_awready(auto_pc_to_auto_us_AWREADY),
        .m_axi_awregion(auto_pc_to_auto_us_AWREGION),
        .m_axi_awsize(auto_pc_to_auto_us_AWSIZE),
        .m_axi_awvalid(auto_pc_to_auto_us_AWVALID),
        .m_axi_bready(auto_pc_to_auto_us_BREADY),
        .m_axi_bresp(auto_pc_to_auto_us_BRESP),
        .m_axi_bvalid(auto_pc_to_auto_us_BVALID),
        .m_axi_rdata(auto_pc_to_auto_us_RDATA),
        .m_axi_rlast(auto_pc_to_auto_us_RLAST),
        .m_axi_rready(auto_pc_to_auto_us_RREADY),
        .m_axi_rresp(auto_pc_to_auto_us_RRESP),
        .m_axi_rvalid(auto_pc_to_auto_us_RVALID),
        .m_axi_wdata(auto_pc_to_auto_us_WDATA),
        .m_axi_wlast(auto_pc_to_auto_us_WLAST),
        .m_axi_wready(auto_pc_to_auto_us_WREADY),
        .m_axi_wstrb(auto_pc_to_auto_us_WSTRB),
        .m_axi_wvalid(auto_pc_to_auto_us_WVALID),
        .s_axi_araddr(s00_couplers_to_auto_pc_ARADDR),
        .s_axi_arprot(s00_couplers_to_auto_pc_ARPROT),
        .s_axi_arready(s00_couplers_to_auto_pc_ARREADY),
        .s_axi_arvalid(s00_couplers_to_auto_pc_ARVALID),
        .s_axi_awaddr(s00_couplers_to_auto_pc_AWADDR),
        .s_axi_awprot(s00_couplers_to_auto_pc_AWPROT),
        .s_axi_awready(s00_couplers_to_auto_pc_AWREADY),
        .s_axi_awvalid(s00_couplers_to_auto_pc_AWVALID),
        .s_axi_bready(s00_couplers_to_auto_pc_BREADY),
        .s_axi_bresp(s00_couplers_to_auto_pc_BRESP),
        .s_axi_bvalid(s00_couplers_to_auto_pc_BVALID),
        .s_axi_rdata(s00_couplers_to_auto_pc_RDATA),
        .s_axi_rready(s00_couplers_to_auto_pc_RREADY),
        .s_axi_rresp(s00_couplers_to_auto_pc_RRESP),
        .s_axi_rvalid(s00_couplers_to_auto_pc_RVALID),
        .s_axi_wdata(s00_couplers_to_auto_pc_WDATA),
        .s_axi_wready(s00_couplers_to_auto_pc_WREADY),
        .s_axi_wstrb(s00_couplers_to_auto_pc_WSTRB),
        .s_axi_wvalid(s00_couplers_to_auto_pc_WVALID));
  system_auto_us_0 auto_us
       (.m_axi_araddr(auto_us_to_s00_couplers_ARADDR),
        .m_axi_arburst(auto_us_to_s00_couplers_ARBURST),
        .m_axi_arcache(auto_us_to_s00_couplers_ARCACHE),
        .m_axi_arlen(auto_us_to_s00_couplers_ARLEN),
        .m_axi_arlock(auto_us_to_s00_couplers_ARLOCK),
        .m_axi_arprot(auto_us_to_s00_couplers_ARPROT),
        .m_axi_arqos(auto_us_to_s00_couplers_ARQOS),
        .m_axi_arready(auto_us_to_s00_couplers_ARREADY),
        .m_axi_arsize(auto_us_to_s00_couplers_ARSIZE),
        .m_axi_arvalid(auto_us_to_s00_couplers_ARVALID),
        .m_axi_awaddr(auto_us_to_s00_couplers_AWADDR),
        .m_axi_awburst(auto_us_to_s00_couplers_AWBURST),
        .m_axi_awcache(auto_us_to_s00_couplers_AWCACHE),
        .m_axi_awlen(auto_us_to_s00_couplers_AWLEN),
        .m_axi_awlock(auto_us_to_s00_couplers_AWLOCK),
        .m_axi_awprot(auto_us_to_s00_couplers_AWPROT),
        .m_axi_awqos(auto_us_to_s00_couplers_AWQOS),
        .m_axi_awready(auto_us_to_s00_couplers_AWREADY),
        .m_axi_awsize(auto_us_to_s00_couplers_AWSIZE),
        .m_axi_awvalid(auto_us_to_s00_couplers_AWVALID),
        .m_axi_bready(auto_us_to_s00_couplers_BREADY),
        .m_axi_bresp(auto_us_to_s00_couplers_BRESP),
        .m_axi_bvalid(auto_us_to_s00_couplers_BVALID),
        .m_axi_rdata(auto_us_to_s00_couplers_RDATA),
        .m_axi_rlast(auto_us_to_s00_couplers_RLAST),
        .m_axi_rready(auto_us_to_s00_couplers_RREADY),
        .m_axi_rresp(auto_us_to_s00_couplers_RRESP),
        .m_axi_rvalid(auto_us_to_s00_couplers_RVALID),
        .m_axi_wdata(auto_us_to_s00_couplers_WDATA),
        .m_axi_wlast(auto_us_to_s00_couplers_WLAST),
        .m_axi_wready(auto_us_to_s00_couplers_WREADY),
        .m_axi_wstrb(auto_us_to_s00_couplers_WSTRB),
        .m_axi_wvalid(auto_us_to_s00_couplers_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(auto_pc_to_auto_us_ARADDR),
        .s_axi_arburst(auto_pc_to_auto_us_ARBURST),
        .s_axi_arcache(auto_pc_to_auto_us_ARCACHE),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arlen(auto_pc_to_auto_us_ARLEN),
        .s_axi_arlock(auto_pc_to_auto_us_ARLOCK),
        .s_axi_arprot(auto_pc_to_auto_us_ARPROT),
        .s_axi_arqos(auto_pc_to_auto_us_ARQOS),
        .s_axi_arready(auto_pc_to_auto_us_ARREADY),
        .s_axi_arregion(auto_pc_to_auto_us_ARREGION),
        .s_axi_arsize(auto_pc_to_auto_us_ARSIZE),
        .s_axi_arvalid(auto_pc_to_auto_us_ARVALID),
        .s_axi_awaddr(auto_pc_to_auto_us_AWADDR),
        .s_axi_awburst(auto_pc_to_auto_us_AWBURST),
        .s_axi_awcache(auto_pc_to_auto_us_AWCACHE),
        .s_axi_awlen(auto_pc_to_auto_us_AWLEN),
        .s_axi_awlock(auto_pc_to_auto_us_AWLOCK),
        .s_axi_awprot(auto_pc_to_auto_us_AWPROT),
        .s_axi_awqos(auto_pc_to_auto_us_AWQOS),
        .s_axi_awready(auto_pc_to_auto_us_AWREADY),
        .s_axi_awregion(auto_pc_to_auto_us_AWREGION),
        .s_axi_awsize(auto_pc_to_auto_us_AWSIZE),
        .s_axi_awvalid(auto_pc_to_auto_us_AWVALID),
        .s_axi_bready(auto_pc_to_auto_us_BREADY),
        .s_axi_bresp(auto_pc_to_auto_us_BRESP),
        .s_axi_bvalid(auto_pc_to_auto_us_BVALID),
        .s_axi_rdata(auto_pc_to_auto_us_RDATA),
        .s_axi_rlast(auto_pc_to_auto_us_RLAST),
        .s_axi_rready(auto_pc_to_auto_us_RREADY),
        .s_axi_rresp(auto_pc_to_auto_us_RRESP),
        .s_axi_rvalid(auto_pc_to_auto_us_RVALID),
        .s_axi_wdata(auto_pc_to_auto_us_WDATA),
        .s_axi_wlast(auto_pc_to_auto_us_WLAST),
        .s_axi_wready(auto_pc_to_auto_us_WREADY),
        .s_axi_wstrb(auto_pc_to_auto_us_WSTRB),
        .s_axi_wvalid(auto_pc_to_auto_us_WVALID));
endmodule

module s00_couplers_imp_SELTG5
   (M_ACLK,
    M_ARESETN,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awlen,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [7:0]M_AXI_awlen;
  output [0:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  output [127:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [15:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [7:0]S_AXI_awlen;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  input [63:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [7:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [31:0]auto_us_to_s00_couplers_AWADDR;
  wire [1:0]auto_us_to_s00_couplers_AWBURST;
  wire [3:0]auto_us_to_s00_couplers_AWCACHE;
  wire [7:0]auto_us_to_s00_couplers_AWLEN;
  wire [0:0]auto_us_to_s00_couplers_AWLOCK;
  wire [2:0]auto_us_to_s00_couplers_AWPROT;
  wire [3:0]auto_us_to_s00_couplers_AWQOS;
  wire auto_us_to_s00_couplers_AWREADY;
  wire [2:0]auto_us_to_s00_couplers_AWSIZE;
  wire auto_us_to_s00_couplers_AWVALID;
  wire auto_us_to_s00_couplers_BREADY;
  wire [1:0]auto_us_to_s00_couplers_BRESP;
  wire auto_us_to_s00_couplers_BVALID;
  wire [127:0]auto_us_to_s00_couplers_WDATA;
  wire auto_us_to_s00_couplers_WLAST;
  wire auto_us_to_s00_couplers_WREADY;
  wire [15:0]auto_us_to_s00_couplers_WSTRB;
  wire auto_us_to_s00_couplers_WVALID;
  wire [31:0]s00_couplers_to_auto_us_AWADDR;
  wire [1:0]s00_couplers_to_auto_us_AWBURST;
  wire [3:0]s00_couplers_to_auto_us_AWCACHE;
  wire [7:0]s00_couplers_to_auto_us_AWLEN;
  wire [2:0]s00_couplers_to_auto_us_AWPROT;
  wire s00_couplers_to_auto_us_AWREADY;
  wire [2:0]s00_couplers_to_auto_us_AWSIZE;
  wire s00_couplers_to_auto_us_AWVALID;
  wire s00_couplers_to_auto_us_BREADY;
  wire [1:0]s00_couplers_to_auto_us_BRESP;
  wire s00_couplers_to_auto_us_BVALID;
  wire [63:0]s00_couplers_to_auto_us_WDATA;
  wire s00_couplers_to_auto_us_WLAST;
  wire s00_couplers_to_auto_us_WREADY;
  wire [7:0]s00_couplers_to_auto_us_WSTRB;
  wire s00_couplers_to_auto_us_WVALID;

  assign M_AXI_awaddr[31:0] = auto_us_to_s00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = auto_us_to_s00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = auto_us_to_s00_couplers_AWCACHE;
  assign M_AXI_awlen[7:0] = auto_us_to_s00_couplers_AWLEN;
  assign M_AXI_awlock[0] = auto_us_to_s00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = auto_us_to_s00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = auto_us_to_s00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = auto_us_to_s00_couplers_AWSIZE;
  assign M_AXI_awvalid = auto_us_to_s00_couplers_AWVALID;
  assign M_AXI_bready = auto_us_to_s00_couplers_BREADY;
  assign M_AXI_wdata[127:0] = auto_us_to_s00_couplers_WDATA;
  assign M_AXI_wlast = auto_us_to_s00_couplers_WLAST;
  assign M_AXI_wstrb[15:0] = auto_us_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = auto_us_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_awready = s00_couplers_to_auto_us_AWREADY;
  assign S_AXI_bresp[1:0] = s00_couplers_to_auto_us_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_auto_us_BVALID;
  assign S_AXI_wready = s00_couplers_to_auto_us_WREADY;
  assign auto_us_to_s00_couplers_AWREADY = M_AXI_awready;
  assign auto_us_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_us_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign auto_us_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_auto_us_AWADDR = S_AXI_awaddr[31:0];
  assign s00_couplers_to_auto_us_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_auto_us_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_auto_us_AWLEN = S_AXI_awlen[7:0];
  assign s00_couplers_to_auto_us_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_auto_us_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_auto_us_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_auto_us_BREADY = S_AXI_bready;
  assign s00_couplers_to_auto_us_WDATA = S_AXI_wdata[63:0];
  assign s00_couplers_to_auto_us_WLAST = S_AXI_wlast;
  assign s00_couplers_to_auto_us_WSTRB = S_AXI_wstrb[7:0];
  assign s00_couplers_to_auto_us_WVALID = S_AXI_wvalid;
  system_auto_us_1 auto_us
       (.m_axi_awaddr(auto_us_to_s00_couplers_AWADDR),
        .m_axi_awburst(auto_us_to_s00_couplers_AWBURST),
        .m_axi_awcache(auto_us_to_s00_couplers_AWCACHE),
        .m_axi_awlen(auto_us_to_s00_couplers_AWLEN),
        .m_axi_awlock(auto_us_to_s00_couplers_AWLOCK),
        .m_axi_awprot(auto_us_to_s00_couplers_AWPROT),
        .m_axi_awqos(auto_us_to_s00_couplers_AWQOS),
        .m_axi_awready(auto_us_to_s00_couplers_AWREADY),
        .m_axi_awsize(auto_us_to_s00_couplers_AWSIZE),
        .m_axi_awvalid(auto_us_to_s00_couplers_AWVALID),
        .m_axi_bready(auto_us_to_s00_couplers_BREADY),
        .m_axi_bresp(auto_us_to_s00_couplers_BRESP),
        .m_axi_bvalid(auto_us_to_s00_couplers_BVALID),
        .m_axi_wdata(auto_us_to_s00_couplers_WDATA),
        .m_axi_wlast(auto_us_to_s00_couplers_WLAST),
        .m_axi_wready(auto_us_to_s00_couplers_WREADY),
        .m_axi_wstrb(auto_us_to_s00_couplers_WSTRB),
        .m_axi_wvalid(auto_us_to_s00_couplers_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_awaddr(s00_couplers_to_auto_us_AWADDR),
        .s_axi_awburst(s00_couplers_to_auto_us_AWBURST),
        .s_axi_awcache(s00_couplers_to_auto_us_AWCACHE),
        .s_axi_awlen(s00_couplers_to_auto_us_AWLEN),
        .s_axi_awlock(1'b0),
        .s_axi_awprot(s00_couplers_to_auto_us_AWPROT),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(s00_couplers_to_auto_us_AWREADY),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize(s00_couplers_to_auto_us_AWSIZE),
        .s_axi_awvalid(s00_couplers_to_auto_us_AWVALID),
        .s_axi_bready(s00_couplers_to_auto_us_BREADY),
        .s_axi_bresp(s00_couplers_to_auto_us_BRESP),
        .s_axi_bvalid(s00_couplers_to_auto_us_BVALID),
        .s_axi_wdata(s00_couplers_to_auto_us_WDATA),
        .s_axi_wlast(s00_couplers_to_auto_us_WLAST),
        .s_axi_wready(s00_couplers_to_auto_us_WREADY),
        .s_axi_wstrb(s00_couplers_to_auto_us_WSTRB),
        .s_axi_wvalid(s00_couplers_to_auto_us_WVALID));
endmodule

module s00_couplers_imp_WZLZH6
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arid,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rid,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [15:0]S_AXI_arid;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [15:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  output [15:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  output [15:0]S_AXI_rid;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [39:0]auto_pc_to_s00_couplers_ARADDR;
  wire [2:0]auto_pc_to_s00_couplers_ARPROT;
  wire auto_pc_to_s00_couplers_ARREADY;
  wire auto_pc_to_s00_couplers_ARVALID;
  wire [39:0]auto_pc_to_s00_couplers_AWADDR;
  wire [2:0]auto_pc_to_s00_couplers_AWPROT;
  wire auto_pc_to_s00_couplers_AWREADY;
  wire auto_pc_to_s00_couplers_AWVALID;
  wire auto_pc_to_s00_couplers_BREADY;
  wire [1:0]auto_pc_to_s00_couplers_BRESP;
  wire auto_pc_to_s00_couplers_BVALID;
  wire [31:0]auto_pc_to_s00_couplers_RDATA;
  wire auto_pc_to_s00_couplers_RREADY;
  wire [1:0]auto_pc_to_s00_couplers_RRESP;
  wire auto_pc_to_s00_couplers_RVALID;
  wire [31:0]auto_pc_to_s00_couplers_WDATA;
  wire auto_pc_to_s00_couplers_WREADY;
  wire [3:0]auto_pc_to_s00_couplers_WSTRB;
  wire auto_pc_to_s00_couplers_WVALID;
  wire [39:0]s00_couplers_to_auto_pc_ARADDR;
  wire [1:0]s00_couplers_to_auto_pc_ARBURST;
  wire [3:0]s00_couplers_to_auto_pc_ARCACHE;
  wire [15:0]s00_couplers_to_auto_pc_ARID;
  wire [7:0]s00_couplers_to_auto_pc_ARLEN;
  wire [0:0]s00_couplers_to_auto_pc_ARLOCK;
  wire [2:0]s00_couplers_to_auto_pc_ARPROT;
  wire [3:0]s00_couplers_to_auto_pc_ARQOS;
  wire s00_couplers_to_auto_pc_ARREADY;
  wire [2:0]s00_couplers_to_auto_pc_ARSIZE;
  wire s00_couplers_to_auto_pc_ARVALID;
  wire [39:0]s00_couplers_to_auto_pc_AWADDR;
  wire [1:0]s00_couplers_to_auto_pc_AWBURST;
  wire [3:0]s00_couplers_to_auto_pc_AWCACHE;
  wire [15:0]s00_couplers_to_auto_pc_AWID;
  wire [7:0]s00_couplers_to_auto_pc_AWLEN;
  wire [0:0]s00_couplers_to_auto_pc_AWLOCK;
  wire [2:0]s00_couplers_to_auto_pc_AWPROT;
  wire [3:0]s00_couplers_to_auto_pc_AWQOS;
  wire s00_couplers_to_auto_pc_AWREADY;
  wire [2:0]s00_couplers_to_auto_pc_AWSIZE;
  wire s00_couplers_to_auto_pc_AWVALID;
  wire [15:0]s00_couplers_to_auto_pc_BID;
  wire s00_couplers_to_auto_pc_BREADY;
  wire [1:0]s00_couplers_to_auto_pc_BRESP;
  wire s00_couplers_to_auto_pc_BVALID;
  wire [31:0]s00_couplers_to_auto_pc_RDATA;
  wire [15:0]s00_couplers_to_auto_pc_RID;
  wire s00_couplers_to_auto_pc_RLAST;
  wire s00_couplers_to_auto_pc_RREADY;
  wire [1:0]s00_couplers_to_auto_pc_RRESP;
  wire s00_couplers_to_auto_pc_RVALID;
  wire [31:0]s00_couplers_to_auto_pc_WDATA;
  wire s00_couplers_to_auto_pc_WLAST;
  wire s00_couplers_to_auto_pc_WREADY;
  wire [3:0]s00_couplers_to_auto_pc_WSTRB;
  wire s00_couplers_to_auto_pc_WVALID;

  assign M_AXI_araddr[39:0] = auto_pc_to_s00_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = auto_pc_to_s00_couplers_ARPROT;
  assign M_AXI_arvalid = auto_pc_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = auto_pc_to_s00_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = auto_pc_to_s00_couplers_AWPROT;
  assign M_AXI_awvalid = auto_pc_to_s00_couplers_AWVALID;
  assign M_AXI_bready = auto_pc_to_s00_couplers_BREADY;
  assign M_AXI_rready = auto_pc_to_s00_couplers_RREADY;
  assign M_AXI_wdata[31:0] = auto_pc_to_s00_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = auto_pc_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = auto_pc_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = s00_couplers_to_auto_pc_ARREADY;
  assign S_AXI_awready = s00_couplers_to_auto_pc_AWREADY;
  assign S_AXI_bid[15:0] = s00_couplers_to_auto_pc_BID;
  assign S_AXI_bresp[1:0] = s00_couplers_to_auto_pc_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_auto_pc_BVALID;
  assign S_AXI_rdata[31:0] = s00_couplers_to_auto_pc_RDATA;
  assign S_AXI_rid[15:0] = s00_couplers_to_auto_pc_RID;
  assign S_AXI_rlast = s00_couplers_to_auto_pc_RLAST;
  assign S_AXI_rresp[1:0] = s00_couplers_to_auto_pc_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_auto_pc_RVALID;
  assign S_AXI_wready = s00_couplers_to_auto_pc_WREADY;
  assign auto_pc_to_s00_couplers_ARREADY = M_AXI_arready;
  assign auto_pc_to_s00_couplers_AWREADY = M_AXI_awready;
  assign auto_pc_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_pc_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign auto_pc_to_s00_couplers_RDATA = M_AXI_rdata[31:0];
  assign auto_pc_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_pc_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign auto_pc_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_auto_pc_ARADDR = S_AXI_araddr[39:0];
  assign s00_couplers_to_auto_pc_ARBURST = S_AXI_arburst[1:0];
  assign s00_couplers_to_auto_pc_ARCACHE = S_AXI_arcache[3:0];
  assign s00_couplers_to_auto_pc_ARID = S_AXI_arid[15:0];
  assign s00_couplers_to_auto_pc_ARLEN = S_AXI_arlen[7:0];
  assign s00_couplers_to_auto_pc_ARLOCK = S_AXI_arlock[0];
  assign s00_couplers_to_auto_pc_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_auto_pc_ARQOS = S_AXI_arqos[3:0];
  assign s00_couplers_to_auto_pc_ARSIZE = S_AXI_arsize[2:0];
  assign s00_couplers_to_auto_pc_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_auto_pc_AWADDR = S_AXI_awaddr[39:0];
  assign s00_couplers_to_auto_pc_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_auto_pc_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_auto_pc_AWID = S_AXI_awid[15:0];
  assign s00_couplers_to_auto_pc_AWLEN = S_AXI_awlen[7:0];
  assign s00_couplers_to_auto_pc_AWLOCK = S_AXI_awlock[0];
  assign s00_couplers_to_auto_pc_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_auto_pc_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_auto_pc_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_auto_pc_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_auto_pc_BREADY = S_AXI_bready;
  assign s00_couplers_to_auto_pc_RREADY = S_AXI_rready;
  assign s00_couplers_to_auto_pc_WDATA = S_AXI_wdata[31:0];
  assign s00_couplers_to_auto_pc_WLAST = S_AXI_wlast;
  assign s00_couplers_to_auto_pc_WSTRB = S_AXI_wstrb[3:0];
  assign s00_couplers_to_auto_pc_WVALID = S_AXI_wvalid;
  system_auto_pc_0 auto_pc
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(auto_pc_to_s00_couplers_ARADDR),
        .m_axi_arprot(auto_pc_to_s00_couplers_ARPROT),
        .m_axi_arready(auto_pc_to_s00_couplers_ARREADY),
        .m_axi_arvalid(auto_pc_to_s00_couplers_ARVALID),
        .m_axi_awaddr(auto_pc_to_s00_couplers_AWADDR),
        .m_axi_awprot(auto_pc_to_s00_couplers_AWPROT),
        .m_axi_awready(auto_pc_to_s00_couplers_AWREADY),
        .m_axi_awvalid(auto_pc_to_s00_couplers_AWVALID),
        .m_axi_bready(auto_pc_to_s00_couplers_BREADY),
        .m_axi_bresp(auto_pc_to_s00_couplers_BRESP),
        .m_axi_bvalid(auto_pc_to_s00_couplers_BVALID),
        .m_axi_rdata(auto_pc_to_s00_couplers_RDATA),
        .m_axi_rready(auto_pc_to_s00_couplers_RREADY),
        .m_axi_rresp(auto_pc_to_s00_couplers_RRESP),
        .m_axi_rvalid(auto_pc_to_s00_couplers_RVALID),
        .m_axi_wdata(auto_pc_to_s00_couplers_WDATA),
        .m_axi_wready(auto_pc_to_s00_couplers_WREADY),
        .m_axi_wstrb(auto_pc_to_s00_couplers_WSTRB),
        .m_axi_wvalid(auto_pc_to_s00_couplers_WVALID),
        .s_axi_araddr(s00_couplers_to_auto_pc_ARADDR),
        .s_axi_arburst(s00_couplers_to_auto_pc_ARBURST),
        .s_axi_arcache(s00_couplers_to_auto_pc_ARCACHE),
        .s_axi_arid(s00_couplers_to_auto_pc_ARID),
        .s_axi_arlen(s00_couplers_to_auto_pc_ARLEN),
        .s_axi_arlock(s00_couplers_to_auto_pc_ARLOCK),
        .s_axi_arprot(s00_couplers_to_auto_pc_ARPROT),
        .s_axi_arqos(s00_couplers_to_auto_pc_ARQOS),
        .s_axi_arready(s00_couplers_to_auto_pc_ARREADY),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize(s00_couplers_to_auto_pc_ARSIZE),
        .s_axi_arvalid(s00_couplers_to_auto_pc_ARVALID),
        .s_axi_awaddr(s00_couplers_to_auto_pc_AWADDR),
        .s_axi_awburst(s00_couplers_to_auto_pc_AWBURST),
        .s_axi_awcache(s00_couplers_to_auto_pc_AWCACHE),
        .s_axi_awid(s00_couplers_to_auto_pc_AWID),
        .s_axi_awlen(s00_couplers_to_auto_pc_AWLEN),
        .s_axi_awlock(s00_couplers_to_auto_pc_AWLOCK),
        .s_axi_awprot(s00_couplers_to_auto_pc_AWPROT),
        .s_axi_awqos(s00_couplers_to_auto_pc_AWQOS),
        .s_axi_awready(s00_couplers_to_auto_pc_AWREADY),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize(s00_couplers_to_auto_pc_AWSIZE),
        .s_axi_awvalid(s00_couplers_to_auto_pc_AWVALID),
        .s_axi_bid(s00_couplers_to_auto_pc_BID),
        .s_axi_bready(s00_couplers_to_auto_pc_BREADY),
        .s_axi_bresp(s00_couplers_to_auto_pc_BRESP),
        .s_axi_bvalid(s00_couplers_to_auto_pc_BVALID),
        .s_axi_rdata(s00_couplers_to_auto_pc_RDATA),
        .s_axi_rid(s00_couplers_to_auto_pc_RID),
        .s_axi_rlast(s00_couplers_to_auto_pc_RLAST),
        .s_axi_rready(s00_couplers_to_auto_pc_RREADY),
        .s_axi_rresp(s00_couplers_to_auto_pc_RRESP),
        .s_axi_rvalid(s00_couplers_to_auto_pc_RVALID),
        .s_axi_wdata(s00_couplers_to_auto_pc_WDATA),
        .s_axi_wlast(s00_couplers_to_auto_pc_WLAST),
        .s_axi_wready(s00_couplers_to_auto_pc_WREADY),
        .s_axi_wstrb(s00_couplers_to_auto_pc_WSTRB),
        .s_axi_wvalid(s00_couplers_to_auto_pc_WVALID));
endmodule

(* CORE_GENERATION_INFO = "system,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=system,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=46,numReposBlks=31,numNonXlnxBlks=9,numHierBlks=15,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,da_axi4_cnt=1,synth_mode=Global}" *) (* HW_HANDOFF = "system.hwdef" *) 
module system
   (adc_fda,
    adc_fdb,
    clk_in1_0,
    clk_out200M,
    gpio_i,
    gpio_o,
    gpio_t,
    lmfc_clk,
    lmfc_edge,
    ps_intr_00,
    ps_intr_01,
    ps_intr_02,
    ps_intr_03,
    ps_intr_04,
    ps_intr_05,
    ps_intr_06,
    ps_intr_07,
    ps_intr_08,
    ps_intr_09,
    ps_intr_14,
    ps_intr_15,
    rx_data_0_n,
    rx_data_0_p,
    rx_data_1_n,
    rx_data_1_p,
    rx_data_2_n,
    rx_data_2_p,
    rx_data_3_n,
    rx_data_3_p,
    rx_out_clk,
    rx_ref_clk_0,
    rx_sync_0,
    rx_sysref_0,
    spi0_csn,
    spi0_miso,
    spi0_mosi,
    spi0_sclk,
    spi1_csn,
    spi1_miso,
    spi1_mosi,
    spi1_sclk,
    start1,
    tx_data_0_n,
    tx_data_0_p,
    tx_data_1_n,
    tx_data_1_p,
    tx_data_2_n,
    tx_data_2_p,
    tx_data_3_n,
    tx_data_3_p);
  input adc_fda;
  input adc_fdb;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_IN1_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_IN1_0, CLK_DOMAIN system_clk_in1_0, FREQ_HZ 100000000, PHASE 0.000" *) input clk_in1_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_OUT200M CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_OUT200M, CLK_DOMAIN /clk_wiz_0_clk_out1, FREQ_HZ 200000000, PHASE 0.0" *) output clk_out200M;
  input [94:0]gpio_i;
  output [94:0]gpio_o;
  output [94:0]gpio_t;
  output lmfc_clk;
  output lmfc_edge;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_00 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_00, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_00;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_01 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_01, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_01;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_02 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_02, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_02;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_03 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_03, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_03;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_04 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_04, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_04;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_05 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_05, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_05;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_06 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_06, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_06;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_07 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_07, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_07;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_08 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_08, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_08;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_09 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_09, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_09;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_14 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_14, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_14;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PS_INTR_15 INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PS_INTR_15, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) input ps_intr_15;
  input rx_data_0_n;
  input rx_data_0_p;
  input rx_data_1_n;
  input rx_data_1_p;
  input rx_data_2_n;
  input rx_data_2_p;
  input rx_data_3_n;
  input rx_data_3_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.RX_OUT_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.RX_OUT_CLK, CLK_DOMAIN system_util_daq2_xcvr_0_rx_out_clk_0, FREQ_HZ 100000000, PHASE 0.000" *) output rx_out_clk;
  input rx_ref_clk_0;
  output [0:0]rx_sync_0;
  input rx_sysref_0;
  output [2:0]spi0_csn;
  input spi0_miso;
  output spi0_mosi;
  output spi0_sclk;
  output [2:0]spi1_csn;
  input spi1_miso;
  output spi1_mosi;
  output spi1_sclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.START1 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.START1, LAYERED_METADATA undef" *) output start1;
  output tx_data_0_n;
  output tx_data_0_p;
  output tx_data_1_n;
  output tx_data_1_p;
  output tx_data_2_n;
  output tx_data_2_p;
  output tx_data_3_n;
  output tx_data_3_p;

  wire [39:0]S00_AXI_1_ARADDR;
  wire [1:0]S00_AXI_1_ARBURST;
  wire [3:0]S00_AXI_1_ARCACHE;
  wire [15:0]S00_AXI_1_ARID;
  wire [7:0]S00_AXI_1_ARLEN;
  wire S00_AXI_1_ARLOCK;
  wire [2:0]S00_AXI_1_ARPROT;
  wire [3:0]S00_AXI_1_ARQOS;
  wire S00_AXI_1_ARREADY;
  wire [2:0]S00_AXI_1_ARSIZE;
  wire S00_AXI_1_ARVALID;
  wire [39:0]S00_AXI_1_AWADDR;
  wire [1:0]S00_AXI_1_AWBURST;
  wire [3:0]S00_AXI_1_AWCACHE;
  wire [15:0]S00_AXI_1_AWID;
  wire [7:0]S00_AXI_1_AWLEN;
  wire S00_AXI_1_AWLOCK;
  wire [2:0]S00_AXI_1_AWPROT;
  wire [3:0]S00_AXI_1_AWQOS;
  wire S00_AXI_1_AWREADY;
  wire [2:0]S00_AXI_1_AWSIZE;
  wire S00_AXI_1_AWVALID;
  wire [15:0]S00_AXI_1_BID;
  wire S00_AXI_1_BREADY;
  wire [1:0]S00_AXI_1_BRESP;
  wire S00_AXI_1_BVALID;
  wire [31:0]S00_AXI_1_RDATA;
  wire [15:0]S00_AXI_1_RID;
  wire S00_AXI_1_RLAST;
  wire S00_AXI_1_RREADY;
  wire [1:0]S00_AXI_1_RRESP;
  wire S00_AXI_1_RVALID;
  wire [31:0]S00_AXI_1_WDATA;
  wire S00_AXI_1_WLAST;
  wire S00_AXI_1_WREADY;
  wire [3:0]S00_AXI_1_WSTRB;
  wire S00_AXI_1_WVALID;
  wire [31:0]S00_AXI_2_ARADDR;
  wire [2:0]S00_AXI_2_ARPROT;
  wire S00_AXI_2_ARREADY;
  wire S00_AXI_2_ARVALID;
  wire [31:0]S00_AXI_2_AWADDR;
  wire [2:0]S00_AXI_2_AWPROT;
  wire S00_AXI_2_AWREADY;
  wire S00_AXI_2_AWVALID;
  wire S00_AXI_2_BREADY;
  wire [1:0]S00_AXI_2_BRESP;
  wire S00_AXI_2_BVALID;
  wire [31:0]S00_AXI_2_RDATA;
  wire S00_AXI_2_RREADY;
  wire [1:0]S00_AXI_2_RRESP;
  wire S00_AXI_2_RVALID;
  wire [31:0]S00_AXI_2_WDATA;
  wire S00_AXI_2_WREADY;
  wire [3:0]S00_AXI_2_WSTRB;
  wire S00_AXI_2_WVALID;
  wire [31:0]S00_AXI_4_AWADDR;
  wire [1:0]S00_AXI_4_AWBURST;
  wire [3:0]S00_AXI_4_AWCACHE;
  wire [7:0]S00_AXI_4_AWLEN;
  wire [2:0]S00_AXI_4_AWPROT;
  wire S00_AXI_4_AWREADY;
  wire [2:0]S00_AXI_4_AWSIZE;
  wire S00_AXI_4_AWVALID;
  wire S00_AXI_4_BREADY;
  wire [1:0]S00_AXI_4_BRESP;
  wire S00_AXI_4_BVALID;
  wire [63:0]S00_AXI_4_WDATA;
  wire S00_AXI_4_WLAST;
  wire S00_AXI_4_WREADY;
  wire [7:0]S00_AXI_4_WSTRB;
  wire S00_AXI_4_WVALID;
  wire adc_fda_1;
  wire adc_fdb_1;
  wire [63:0]axi_ad9680_core_adc_data_0;
  wire [63:0]axi_ad9680_core_adc_data_1;
  wire axi_ad9680_core_adc_enable_0;
  wire axi_ad9680_core_adc_enable_1;
  wire axi_ad9680_core_adc_valid_0;
  wire axi_ad9680_core_adc_valid_1;
  wire [127:0]axi_ad9680_cpack_adc_data;
  wire axi_ad9680_cpack_adc_valid;
  wire axi_ad9680_dma_irq;
  wire axi_ad9680_dma_s_axis_ready;
  wire axi_ad9680_dma_s_axis_xfer_req;
  wire axi_ad9680_fifo_adc_wovf;
  wire [63:0]axi_ad9680_fifo_dma_wdata;
  wire axi_ad9680_fifo_dma_wr;
  wire axi_ad9680_jesd_irq;
  wire axi_ad9680_jesd_lmfc_clk_0;
  wire axi_ad9680_jesd_lmfc_edge_0;
  wire axi_ad9680_jesd_phy_en_char_align;
  wire [0:0]axi_ad9680_jesd_rstgen_peripheral_aresetn;
  wire [0:0]axi_ad9680_jesd_rstgen_peripheral_reset;
  wire [127:0]axi_ad9680_jesd_rx_data_tdata;
  wire axi_ad9680_jesd_rx_data_tvalid;
  wire [3:0]axi_ad9680_jesd_rx_sof;
  wire [0:0]axi_ad9680_jesd_sync;
  wire [11:0]axi_ad9680_xcvr_up_ch_0_addr;
  wire axi_ad9680_xcvr_up_ch_0_enb;
  wire axi_ad9680_xcvr_up_ch_0_lpm_dfe_n;
  wire [2:0]axi_ad9680_xcvr_up_ch_0_out_clk_sel;
  wire axi_ad9680_xcvr_up_ch_0_pll_locked;
  wire [2:0]axi_ad9680_xcvr_up_ch_0_rate;
  wire [15:0]axi_ad9680_xcvr_up_ch_0_rdata;
  wire axi_ad9680_xcvr_up_ch_0_ready;
  wire axi_ad9680_xcvr_up_ch_0_rst;
  wire axi_ad9680_xcvr_up_ch_0_rst_done;
  wire [1:0]axi_ad9680_xcvr_up_ch_0_sys_clk_sel;
  wire axi_ad9680_xcvr_up_ch_0_user_ready;
  wire [15:0]axi_ad9680_xcvr_up_ch_0_wdata;
  wire axi_ad9680_xcvr_up_ch_0_wr;
  wire [11:0]axi_ad9680_xcvr_up_ch_1_addr;
  wire axi_ad9680_xcvr_up_ch_1_enb;
  wire axi_ad9680_xcvr_up_ch_1_lpm_dfe_n;
  wire [2:0]axi_ad9680_xcvr_up_ch_1_out_clk_sel;
  wire axi_ad9680_xcvr_up_ch_1_pll_locked;
  wire [2:0]axi_ad9680_xcvr_up_ch_1_rate;
  wire [15:0]axi_ad9680_xcvr_up_ch_1_rdata;
  wire axi_ad9680_xcvr_up_ch_1_ready;
  wire axi_ad9680_xcvr_up_ch_1_rst;
  wire axi_ad9680_xcvr_up_ch_1_rst_done;
  wire [1:0]axi_ad9680_xcvr_up_ch_1_sys_clk_sel;
  wire axi_ad9680_xcvr_up_ch_1_user_ready;
  wire [15:0]axi_ad9680_xcvr_up_ch_1_wdata;
  wire axi_ad9680_xcvr_up_ch_1_wr;
  wire [11:0]axi_ad9680_xcvr_up_ch_2_addr;
  wire axi_ad9680_xcvr_up_ch_2_enb;
  wire axi_ad9680_xcvr_up_ch_2_lpm_dfe_n;
  wire [2:0]axi_ad9680_xcvr_up_ch_2_out_clk_sel;
  wire axi_ad9680_xcvr_up_ch_2_pll_locked;
  wire [2:0]axi_ad9680_xcvr_up_ch_2_rate;
  wire [15:0]axi_ad9680_xcvr_up_ch_2_rdata;
  wire axi_ad9680_xcvr_up_ch_2_ready;
  wire axi_ad9680_xcvr_up_ch_2_rst;
  wire axi_ad9680_xcvr_up_ch_2_rst_done;
  wire [1:0]axi_ad9680_xcvr_up_ch_2_sys_clk_sel;
  wire axi_ad9680_xcvr_up_ch_2_user_ready;
  wire [15:0]axi_ad9680_xcvr_up_ch_2_wdata;
  wire axi_ad9680_xcvr_up_ch_2_wr;
  wire [11:0]axi_ad9680_xcvr_up_ch_3_addr;
  wire axi_ad9680_xcvr_up_ch_3_enb;
  wire axi_ad9680_xcvr_up_ch_3_lpm_dfe_n;
  wire [2:0]axi_ad9680_xcvr_up_ch_3_out_clk_sel;
  wire axi_ad9680_xcvr_up_ch_3_pll_locked;
  wire [2:0]axi_ad9680_xcvr_up_ch_3_rate;
  wire [15:0]axi_ad9680_xcvr_up_ch_3_rdata;
  wire axi_ad9680_xcvr_up_ch_3_ready;
  wire axi_ad9680_xcvr_up_ch_3_rst;
  wire axi_ad9680_xcvr_up_ch_3_rst_done;
  wire [1:0]axi_ad9680_xcvr_up_ch_3_sys_clk_sel;
  wire axi_ad9680_xcvr_up_ch_3_user_ready;
  wire [15:0]axi_ad9680_xcvr_up_ch_3_wdata;
  wire axi_ad9680_xcvr_up_ch_3_wr;
  wire [11:0]axi_ad9680_xcvr_up_es_0_addr;
  wire axi_ad9680_xcvr_up_es_0_enb;
  wire [15:0]axi_ad9680_xcvr_up_es_0_rdata;
  wire axi_ad9680_xcvr_up_es_0_ready;
  wire [15:0]axi_ad9680_xcvr_up_es_0_wdata;
  wire axi_ad9680_xcvr_up_es_0_wr;
  wire [11:0]axi_ad9680_xcvr_up_es_1_addr;
  wire axi_ad9680_xcvr_up_es_1_enb;
  wire [15:0]axi_ad9680_xcvr_up_es_1_rdata;
  wire axi_ad9680_xcvr_up_es_1_ready;
  wire [15:0]axi_ad9680_xcvr_up_es_1_wdata;
  wire axi_ad9680_xcvr_up_es_1_wr;
  wire [11:0]axi_ad9680_xcvr_up_es_2_addr;
  wire axi_ad9680_xcvr_up_es_2_enb;
  wire [15:0]axi_ad9680_xcvr_up_es_2_rdata;
  wire axi_ad9680_xcvr_up_es_2_ready;
  wire [15:0]axi_ad9680_xcvr_up_es_2_wdata;
  wire axi_ad9680_xcvr_up_es_2_wr;
  wire [11:0]axi_ad9680_xcvr_up_es_3_addr;
  wire axi_ad9680_xcvr_up_es_3_enb;
  wire [15:0]axi_ad9680_xcvr_up_es_3_rdata;
  wire axi_ad9680_xcvr_up_es_3_ready;
  wire [15:0]axi_ad9680_xcvr_up_es_3_wdata;
  wire axi_ad9680_xcvr_up_es_3_wr;
  wire axi_ad9680_xcvr_up_pll_rst;
  wire [39:0]axi_cpu_interconnect_M04_AXI_ARADDR;
  wire [2:0]axi_cpu_interconnect_M04_AXI_ARPROT;
  wire axi_cpu_interconnect_M04_AXI_ARREADY;
  wire [0:0]axi_cpu_interconnect_M04_AXI_ARVALID;
  wire [39:0]axi_cpu_interconnect_M04_AXI_AWADDR;
  wire [2:0]axi_cpu_interconnect_M04_AXI_AWPROT;
  wire axi_cpu_interconnect_M04_AXI_AWREADY;
  wire [0:0]axi_cpu_interconnect_M04_AXI_AWVALID;
  wire [0:0]axi_cpu_interconnect_M04_AXI_BREADY;
  wire [1:0]axi_cpu_interconnect_M04_AXI_BRESP;
  wire axi_cpu_interconnect_M04_AXI_BVALID;
  wire [31:0]axi_cpu_interconnect_M04_AXI_RDATA;
  wire [0:0]axi_cpu_interconnect_M04_AXI_RREADY;
  wire [1:0]axi_cpu_interconnect_M04_AXI_RRESP;
  wire axi_cpu_interconnect_M04_AXI_RVALID;
  wire [31:0]axi_cpu_interconnect_M04_AXI_WDATA;
  wire axi_cpu_interconnect_M04_AXI_WREADY;
  wire [3:0]axi_cpu_interconnect_M04_AXI_WSTRB;
  wire [0:0]axi_cpu_interconnect_M04_AXI_WVALID;
  wire [39:0]axi_cpu_interconnect_M05_AXI_ARADDR;
  wire [2:0]axi_cpu_interconnect_M05_AXI_ARPROT;
  wire axi_cpu_interconnect_M05_AXI_ARREADY;
  wire [0:0]axi_cpu_interconnect_M05_AXI_ARVALID;
  wire [39:0]axi_cpu_interconnect_M05_AXI_AWADDR;
  wire [2:0]axi_cpu_interconnect_M05_AXI_AWPROT;
  wire axi_cpu_interconnect_M05_AXI_AWREADY;
  wire [0:0]axi_cpu_interconnect_M05_AXI_AWVALID;
  wire [0:0]axi_cpu_interconnect_M05_AXI_BREADY;
  wire [1:0]axi_cpu_interconnect_M05_AXI_BRESP;
  wire axi_cpu_interconnect_M05_AXI_BVALID;
  wire [31:0]axi_cpu_interconnect_M05_AXI_RDATA;
  wire [0:0]axi_cpu_interconnect_M05_AXI_RREADY;
  wire [1:0]axi_cpu_interconnect_M05_AXI_RRESP;
  wire axi_cpu_interconnect_M05_AXI_RVALID;
  wire [31:0]axi_cpu_interconnect_M05_AXI_WDATA;
  wire axi_cpu_interconnect_M05_AXI_WREADY;
  wire [3:0]axi_cpu_interconnect_M05_AXI_WSTRB;
  wire [0:0]axi_cpu_interconnect_M05_AXI_WVALID;
  wire [39:0]axi_cpu_interconnect_M06_AXI_ARADDR;
  wire [2:0]axi_cpu_interconnect_M06_AXI_ARPROT;
  wire [0:0]axi_cpu_interconnect_M06_AXI_ARREADY;
  wire [0:0]axi_cpu_interconnect_M06_AXI_ARVALID;
  wire [39:0]axi_cpu_interconnect_M06_AXI_AWADDR;
  wire [2:0]axi_cpu_interconnect_M06_AXI_AWPROT;
  wire [0:0]axi_cpu_interconnect_M06_AXI_AWREADY;
  wire [0:0]axi_cpu_interconnect_M06_AXI_AWVALID;
  wire [0:0]axi_cpu_interconnect_M06_AXI_BREADY;
  wire [1:0]axi_cpu_interconnect_M06_AXI_BRESP;
  wire [0:0]axi_cpu_interconnect_M06_AXI_BVALID;
  wire [31:0]axi_cpu_interconnect_M06_AXI_RDATA;
  wire [0:0]axi_cpu_interconnect_M06_AXI_RREADY;
  wire [1:0]axi_cpu_interconnect_M06_AXI_RRESP;
  wire [0:0]axi_cpu_interconnect_M06_AXI_RVALID;
  wire [31:0]axi_cpu_interconnect_M06_AXI_WDATA;
  wire [0:0]axi_cpu_interconnect_M06_AXI_WREADY;
  wire [3:0]axi_cpu_interconnect_M06_AXI_WSTRB;
  wire [0:0]axi_cpu_interconnect_M06_AXI_WVALID;
  wire [39:0]axi_cpu_interconnect_M07_AXI_ARADDR;
  wire [2:0]axi_cpu_interconnect_M07_AXI_ARPROT;
  wire axi_cpu_interconnect_M07_AXI_ARREADY;
  wire [0:0]axi_cpu_interconnect_M07_AXI_ARVALID;
  wire [39:0]axi_cpu_interconnect_M07_AXI_AWADDR;
  wire [2:0]axi_cpu_interconnect_M07_AXI_AWPROT;
  wire axi_cpu_interconnect_M07_AXI_AWREADY;
  wire [0:0]axi_cpu_interconnect_M07_AXI_AWVALID;
  wire [0:0]axi_cpu_interconnect_M07_AXI_BREADY;
  wire [1:0]axi_cpu_interconnect_M07_AXI_BRESP;
  wire axi_cpu_interconnect_M07_AXI_BVALID;
  wire [31:0]axi_cpu_interconnect_M07_AXI_RDATA;
  wire [0:0]axi_cpu_interconnect_M07_AXI_RREADY;
  wire [1:0]axi_cpu_interconnect_M07_AXI_RRESP;
  wire axi_cpu_interconnect_M07_AXI_RVALID;
  wire [31:0]axi_cpu_interconnect_M07_AXI_WDATA;
  wire axi_cpu_interconnect_M07_AXI_WREADY;
  wire [3:0]axi_cpu_interconnect_M07_AXI_WSTRB;
  wire [0:0]axi_cpu_interconnect_M07_AXI_WVALID;
  wire [31:0]axi_hp2_interconnect_M00_AXI_AWADDR;
  wire [1:0]axi_hp2_interconnect_M00_AXI_AWBURST;
  wire [3:0]axi_hp2_interconnect_M00_AXI_AWCACHE;
  wire [7:0]axi_hp2_interconnect_M00_AXI_AWLEN;
  wire [0:0]axi_hp2_interconnect_M00_AXI_AWLOCK;
  wire [2:0]axi_hp2_interconnect_M00_AXI_AWPROT;
  wire [3:0]axi_hp2_interconnect_M00_AXI_AWQOS;
  wire axi_hp2_interconnect_M00_AXI_AWREADY;
  wire [2:0]axi_hp2_interconnect_M00_AXI_AWSIZE;
  wire axi_hp2_interconnect_M00_AXI_AWVALID;
  wire axi_hp2_interconnect_M00_AXI_BREADY;
  wire [1:0]axi_hp2_interconnect_M00_AXI_BRESP;
  wire axi_hp2_interconnect_M00_AXI_BVALID;
  wire [127:0]axi_hp2_interconnect_M00_AXI_WDATA;
  wire axi_hp2_interconnect_M00_AXI_WLAST;
  wire axi_hp2_interconnect_M00_AXI_WREADY;
  wire [15:0]axi_hp2_interconnect_M00_AXI_WSTRB;
  wire axi_hp2_interconnect_M00_AXI_WVALID;
  wire [31:0]axi_hp3_interconnect_M00_AXI_ARADDR;
  wire [1:0]axi_hp3_interconnect_M00_AXI_ARBURST;
  wire [3:0]axi_hp3_interconnect_M00_AXI_ARCACHE;
  wire [7:0]axi_hp3_interconnect_M00_AXI_ARLEN;
  wire [0:0]axi_hp3_interconnect_M00_AXI_ARLOCK;
  wire [2:0]axi_hp3_interconnect_M00_AXI_ARPROT;
  wire [3:0]axi_hp3_interconnect_M00_AXI_ARQOS;
  wire axi_hp3_interconnect_M00_AXI_ARREADY;
  wire [2:0]axi_hp3_interconnect_M00_AXI_ARSIZE;
  wire axi_hp3_interconnect_M00_AXI_ARVALID;
  wire [31:0]axi_hp3_interconnect_M00_AXI_AWADDR;
  wire [1:0]axi_hp3_interconnect_M00_AXI_AWBURST;
  wire [3:0]axi_hp3_interconnect_M00_AXI_AWCACHE;
  wire [7:0]axi_hp3_interconnect_M00_AXI_AWLEN;
  wire [0:0]axi_hp3_interconnect_M00_AXI_AWLOCK;
  wire [2:0]axi_hp3_interconnect_M00_AXI_AWPROT;
  wire [3:0]axi_hp3_interconnect_M00_AXI_AWQOS;
  wire axi_hp3_interconnect_M00_AXI_AWREADY;
  wire [2:0]axi_hp3_interconnect_M00_AXI_AWSIZE;
  wire axi_hp3_interconnect_M00_AXI_AWVALID;
  wire axi_hp3_interconnect_M00_AXI_BREADY;
  wire [1:0]axi_hp3_interconnect_M00_AXI_BRESP;
  wire axi_hp3_interconnect_M00_AXI_BVALID;
  wire [127:0]axi_hp3_interconnect_M00_AXI_RDATA;
  wire axi_hp3_interconnect_M00_AXI_RLAST;
  wire axi_hp3_interconnect_M00_AXI_RREADY;
  wire [1:0]axi_hp3_interconnect_M00_AXI_RRESP;
  wire axi_hp3_interconnect_M00_AXI_RVALID;
  wire [127:0]axi_hp3_interconnect_M00_AXI_WDATA;
  wire axi_hp3_interconnect_M00_AXI_WLAST;
  wire axi_hp3_interconnect_M00_AXI_WREADY;
  wire [15:0]axi_hp3_interconnect_M00_AXI_WSTRB;
  wire axi_hp3_interconnect_M00_AXI_WVALID;
  wire clk_in1_0_1;
  wire clk_wiz_0_clk_out200M;
  wire format_9234_timestamp_0_o_adc_enable_0;
  wire format_9234_timestamp_0_o_adc_enable_1;
  wire format_9234_timestamp_0_o_adc_valid_0;
  wire format_9234_timestamp_0_o_adc_valid_1;
  wire format_9234_timestamp_0_o_ps_irq;
  wire [63:0]format_9234_timestamp_0_out_0;
  wire [63:0]format_9234_timestamp_0_out_1;
  wire [11:0]format_9234_timestamp_0_waveform_0;
  wire [11:0]format_9234_timestamp_0_waveform_1;
  wire [94:0]gpio_i_1;
  wire ps_intr_00_1;
  wire ps_intr_01_1;
  wire ps_intr_02_1;
  wire ps_intr_03_1;
  wire ps_intr_04_1;
  wire ps_intr_05_1;
  wire ps_intr_06_1;
  wire ps_intr_07_1;
  wire ps_intr_08_1;
  wire ps_intr_09_1;
  wire ps_intr_14_1;
  wire ps_intr_15_1;
  wire rx_data_0_n_1;
  wire rx_data_0_p_1;
  wire rx_data_1_n_1;
  wire rx_data_1_p_1;
  wire rx_data_2_n_1;
  wire rx_data_2_p_1;
  wire rx_data_3_n_1;
  wire rx_data_3_p_1;
  wire rx_ref_clk_0_1;
  wire [2:0]spi0_csn_concat_dout;
  wire spi0_miso_1;
  wire [2:0]spi1_csn_concat_dout;
  wire spi1_miso_1;
  wire start_LD_0_start1;
  wire sys_200m_clk;
  wire [7:0]sys_concat_intc_0_dout;
  wire [7:0]sys_concat_intc_1_dout;
  wire sys_cpu_clk;
  wire [0:0]sys_cpu_resetn;
  wire [94:0]sys_ps8_emio_gpio_o;
  wire [94:0]sys_ps8_emio_gpio_t;
  wire sys_ps8_emio_spi0_m_o;
  wire [0:0]sys_ps8_emio_spi0_s_i_GND_dout;
  wire [0:0]sys_ps8_emio_spi0_sclk_i_GND_dout;
  wire sys_ps8_emio_spi0_sclk_o;
  wire sys_ps8_emio_spi0_ss1_o_n;
  wire sys_ps8_emio_spi0_ss2_o_n;
  wire [0:0]sys_ps8_emio_spi0_ss_i_n_VCC_dout;
  wire sys_ps8_emio_spi0_ss_o_n;
  wire sys_ps8_emio_spi1_m_o;
  wire [0:0]sys_ps8_emio_spi1_s_i_GND_dout;
  wire [0:0]sys_ps8_emio_spi1_sclk_i_GND_dout;
  wire sys_ps8_emio_spi1_sclk_o;
  wire sys_ps8_emio_spi1_ss1_o_n;
  wire sys_ps8_emio_spi1_ss2_o_n;
  wire [0:0]sys_ps8_emio_spi1_ss_i_n_VCC1_dout;
  wire [0:0]sys_ps8_emio_spi1_ss_i_n_VCC_dout;
  wire sys_ps8_emio_spi1_ss_o_n;
  wire sys_ps8_pl_resetn0;
  wire sysref_2;
  wire [3:0]util_daq2_xcvr_rx_0_rxcharisk;
  wire [31:0]util_daq2_xcvr_rx_0_rxdata;
  wire [3:0]util_daq2_xcvr_rx_0_rxdisperr;
  wire [3:0]util_daq2_xcvr_rx_0_rxnotintable;
  wire [3:0]util_daq2_xcvr_rx_1_rxcharisk;
  wire [31:0]util_daq2_xcvr_rx_1_rxdata;
  wire [3:0]util_daq2_xcvr_rx_1_rxdisperr;
  wire [3:0]util_daq2_xcvr_rx_1_rxnotintable;
  wire [3:0]util_daq2_xcvr_rx_2_rxcharisk;
  wire [31:0]util_daq2_xcvr_rx_2_rxdata;
  wire [3:0]util_daq2_xcvr_rx_2_rxdisperr;
  wire [3:0]util_daq2_xcvr_rx_2_rxnotintable;
  wire [3:0]util_daq2_xcvr_rx_3_rxcharisk;
  wire [31:0]util_daq2_xcvr_rx_3_rxdata;
  wire [3:0]util_daq2_xcvr_rx_3_rxdisperr;
  wire [3:0]util_daq2_xcvr_rx_3_rxnotintable;
  wire util_daq2_xcvr_rx_out_clk_0;
  wire util_daq2_xcvr_tx_0_n;
  wire util_daq2_xcvr_tx_0_p;
  wire util_daq2_xcvr_tx_1_n;
  wire util_daq2_xcvr_tx_1_p;
  wire util_daq2_xcvr_tx_2_n;
  wire util_daq2_xcvr_tx_2_p;
  wire util_daq2_xcvr_tx_3_n;
  wire util_daq2_xcvr_tx_3_p;
  wire util_daq2_xcvr_tx_out_clk_0;

  assign adc_fda_1 = adc_fda;
  assign adc_fdb_1 = adc_fdb;
  assign clk_in1_0_1 = clk_in1_0;
  assign clk_out200M = clk_wiz_0_clk_out200M;
  assign gpio_i_1 = gpio_i[94:0];
  assign gpio_o[94:0] = sys_ps8_emio_gpio_o;
  assign gpio_t[94:0] = sys_ps8_emio_gpio_t;
  assign lmfc_clk = axi_ad9680_jesd_lmfc_clk_0;
  assign lmfc_edge = axi_ad9680_jesd_lmfc_edge_0;
  assign ps_intr_00_1 = ps_intr_00;
  assign ps_intr_01_1 = ps_intr_01;
  assign ps_intr_02_1 = ps_intr_02;
  assign ps_intr_03_1 = ps_intr_03;
  assign ps_intr_04_1 = ps_intr_04;
  assign ps_intr_05_1 = ps_intr_05;
  assign ps_intr_06_1 = ps_intr_06;
  assign ps_intr_07_1 = ps_intr_07;
  assign ps_intr_08_1 = ps_intr_08;
  assign ps_intr_09_1 = ps_intr_09;
  assign ps_intr_14_1 = ps_intr_14;
  assign ps_intr_15_1 = ps_intr_15;
  assign rx_data_0_n_1 = rx_data_0_n;
  assign rx_data_0_p_1 = rx_data_0_p;
  assign rx_data_1_n_1 = rx_data_1_n;
  assign rx_data_1_p_1 = rx_data_1_p;
  assign rx_data_2_n_1 = rx_data_2_n;
  assign rx_data_2_p_1 = rx_data_2_p;
  assign rx_data_3_n_1 = rx_data_3_n;
  assign rx_data_3_p_1 = rx_data_3_p;
  assign rx_out_clk = util_daq2_xcvr_rx_out_clk_0;
  assign rx_ref_clk_0_1 = rx_ref_clk_0;
  assign rx_sync_0[0] = axi_ad9680_jesd_sync;
  assign spi0_csn[2:0] = spi0_csn_concat_dout;
  assign spi0_miso_1 = spi0_miso;
  assign spi0_mosi = sys_ps8_emio_spi0_m_o;
  assign spi0_sclk = sys_ps8_emio_spi0_sclk_o;
  assign spi1_csn[2:0] = spi1_csn_concat_dout;
  assign spi1_miso_1 = spi1_miso;
  assign spi1_mosi = sys_ps8_emio_spi1_m_o;
  assign spi1_sclk = sys_ps8_emio_spi1_sclk_o;
  assign start1 = start_LD_0_start1;
  assign sysref_2 = rx_sysref_0;
  assign tx_data_0_n = util_daq2_xcvr_tx_0_n;
  assign tx_data_0_p = util_daq2_xcvr_tx_0_p;
  assign tx_data_1_n = util_daq2_xcvr_tx_1_n;
  assign tx_data_1_p = util_daq2_xcvr_tx_1_p;
  assign tx_data_2_n = util_daq2_xcvr_tx_2_n;
  assign tx_data_2_p = util_daq2_xcvr_tx_2_p;
  assign tx_data_3_n = util_daq2_xcvr_tx_3_n;
  assign tx_data_3_p = util_daq2_xcvr_tx_3_p;
  system_axi_ad9680_core_0 axi_ad9680_core
       (.adc_data_0(axi_ad9680_core_adc_data_0),
        .adc_data_1(axi_ad9680_core_adc_data_1),
        .adc_dovf(axi_ad9680_fifo_adc_wovf),
        .adc_enable_0(axi_ad9680_core_adc_enable_0),
        .adc_enable_1(axi_ad9680_core_adc_enable_1),
        .adc_valid_0(axi_ad9680_core_adc_valid_0),
        .adc_valid_1(axi_ad9680_core_adc_valid_1),
        .rx_clk(util_daq2_xcvr_rx_out_clk_0),
        .rx_data(axi_ad9680_jesd_rx_data_tdata),
        .rx_sof(axi_ad9680_jesd_rx_sof),
        .rx_valid(1'b0),
        .s_axi_aclk(sys_cpu_clk),
        .s_axi_araddr(axi_cpu_interconnect_M05_AXI_ARADDR[15:0]),
        .s_axi_aresetn(sys_cpu_resetn),
        .s_axi_arprot(axi_cpu_interconnect_M05_AXI_ARPROT),
        .s_axi_arready(axi_cpu_interconnect_M05_AXI_ARREADY),
        .s_axi_arvalid(axi_cpu_interconnect_M05_AXI_ARVALID),
        .s_axi_awaddr(axi_cpu_interconnect_M05_AXI_AWADDR[15:0]),
        .s_axi_awprot(axi_cpu_interconnect_M05_AXI_AWPROT),
        .s_axi_awready(axi_cpu_interconnect_M05_AXI_AWREADY),
        .s_axi_awvalid(axi_cpu_interconnect_M05_AXI_AWVALID),
        .s_axi_bready(axi_cpu_interconnect_M05_AXI_BREADY),
        .s_axi_bresp(axi_cpu_interconnect_M05_AXI_BRESP),
        .s_axi_bvalid(axi_cpu_interconnect_M05_AXI_BVALID),
        .s_axi_rdata(axi_cpu_interconnect_M05_AXI_RDATA),
        .s_axi_rready(axi_cpu_interconnect_M05_AXI_RREADY),
        .s_axi_rresp(axi_cpu_interconnect_M05_AXI_RRESP),
        .s_axi_rvalid(axi_cpu_interconnect_M05_AXI_RVALID),
        .s_axi_wdata(axi_cpu_interconnect_M05_AXI_WDATA),
        .s_axi_wready(axi_cpu_interconnect_M05_AXI_WREADY),
        .s_axi_wstrb(axi_cpu_interconnect_M05_AXI_WSTRB),
        .s_axi_wvalid(axi_cpu_interconnect_M05_AXI_WVALID));
  system_axi_ad9680_cpack_0 axi_ad9680_cpack
       (.adc_clk(util_daq2_xcvr_rx_out_clk_0),
        .adc_data(axi_ad9680_cpack_adc_data),
        .adc_data_0(format_9234_timestamp_0_out_0),
        .adc_data_1(format_9234_timestamp_0_out_1),
        .adc_enable_0(format_9234_timestamp_0_o_adc_enable_0),
        .adc_enable_1(format_9234_timestamp_0_o_adc_enable_1),
        .adc_rst(axi_ad9680_jesd_rstgen_peripheral_reset),
        .adc_valid(axi_ad9680_cpack_adc_valid),
        .adc_valid_0(format_9234_timestamp_0_o_adc_valid_0),
        .adc_valid_1(format_9234_timestamp_0_o_adc_valid_1));
  system_axi_ad9680_dma_0 axi_ad9680_dma
       (.irq(axi_ad9680_dma_irq),
        .m_dest_axi_aclk(sys_cpu_clk),
        .m_dest_axi_aresetn(sys_cpu_resetn),
        .m_dest_axi_awaddr(S00_AXI_4_AWADDR),
        .m_dest_axi_awburst(S00_AXI_4_AWBURST),
        .m_dest_axi_awcache(S00_AXI_4_AWCACHE),
        .m_dest_axi_awlen(S00_AXI_4_AWLEN),
        .m_dest_axi_awprot(S00_AXI_4_AWPROT),
        .m_dest_axi_awready(S00_AXI_4_AWREADY),
        .m_dest_axi_awsize(S00_AXI_4_AWSIZE),
        .m_dest_axi_awvalid(S00_AXI_4_AWVALID),
        .m_dest_axi_bready(S00_AXI_4_BREADY),
        .m_dest_axi_bresp(S00_AXI_4_BRESP),
        .m_dest_axi_bvalid(S00_AXI_4_BVALID),
        .m_dest_axi_wdata(S00_AXI_4_WDATA),
        .m_dest_axi_wlast(S00_AXI_4_WLAST),
        .m_dest_axi_wready(S00_AXI_4_WREADY),
        .m_dest_axi_wstrb(S00_AXI_4_WSTRB),
        .m_dest_axi_wvalid(S00_AXI_4_WVALID),
        .s_axi_aclk(sys_cpu_clk),
        .s_axi_araddr(axi_cpu_interconnect_M07_AXI_ARADDR[11:0]),
        .s_axi_aresetn(sys_cpu_resetn),
        .s_axi_arprot(axi_cpu_interconnect_M07_AXI_ARPROT),
        .s_axi_arready(axi_cpu_interconnect_M07_AXI_ARREADY),
        .s_axi_arvalid(axi_cpu_interconnect_M07_AXI_ARVALID),
        .s_axi_awaddr(axi_cpu_interconnect_M07_AXI_AWADDR[11:0]),
        .s_axi_awprot(axi_cpu_interconnect_M07_AXI_AWPROT),
        .s_axi_awready(axi_cpu_interconnect_M07_AXI_AWREADY),
        .s_axi_awvalid(axi_cpu_interconnect_M07_AXI_AWVALID),
        .s_axi_bready(axi_cpu_interconnect_M07_AXI_BREADY),
        .s_axi_bresp(axi_cpu_interconnect_M07_AXI_BRESP),
        .s_axi_bvalid(axi_cpu_interconnect_M07_AXI_BVALID),
        .s_axi_rdata(axi_cpu_interconnect_M07_AXI_RDATA),
        .s_axi_rready(axi_cpu_interconnect_M07_AXI_RREADY),
        .s_axi_rresp(axi_cpu_interconnect_M07_AXI_RRESP),
        .s_axi_rvalid(axi_cpu_interconnect_M07_AXI_RVALID),
        .s_axi_wdata(axi_cpu_interconnect_M07_AXI_WDATA),
        .s_axi_wready(axi_cpu_interconnect_M07_AXI_WREADY),
        .s_axi_wstrb(axi_cpu_interconnect_M07_AXI_WSTRB),
        .s_axi_wvalid(axi_cpu_interconnect_M07_AXI_WVALID),
        .s_axis_aclk(sys_cpu_clk),
        .s_axis_data(axi_ad9680_fifo_dma_wdata),
        .s_axis_last(1'b0),
        .s_axis_ready(axi_ad9680_dma_s_axis_ready),
        .s_axis_user(1'b0),
        .s_axis_valid(axi_ad9680_fifo_dma_wr),
        .s_axis_xfer_req(axi_ad9680_dma_s_axis_xfer_req));
  system_axi_ad9680_fifo_0 axi_ad9680_fifo
       (.adc_clk(util_daq2_xcvr_rx_out_clk_0),
        .adc_rst(axi_ad9680_jesd_rstgen_peripheral_reset),
        .adc_wdata(axi_ad9680_cpack_adc_data),
        .adc_wovf(axi_ad9680_fifo_adc_wovf),
        .adc_wr(axi_ad9680_cpack_adc_valid),
        .dma_clk(sys_cpu_clk),
        .dma_wdata(axi_ad9680_fifo_dma_wdata),
        .dma_wr(axi_ad9680_fifo_dma_wr),
        .dma_wready(axi_ad9680_dma_s_axis_ready),
        .dma_xfer_req(axi_ad9680_dma_s_axis_xfer_req));
  axi_ad9680_jesd_imp_9H50XX axi_ad9680_jesd
       (.device_clk(util_daq2_xcvr_rx_out_clk_0),
        .irq(axi_ad9680_jesd_irq),
        .lmfc_clk_0(axi_ad9680_jesd_lmfc_clk_0),
        .lmfc_edge_0(axi_ad9680_jesd_lmfc_edge_0),
        .phy_en_char_align(axi_ad9680_jesd_phy_en_char_align),
        .rx_data_tdata(axi_ad9680_jesd_rx_data_tdata),
        .rx_data_tvalid(axi_ad9680_jesd_rx_data_tvalid),
        .rx_phy0_rxcharisk(util_daq2_xcvr_rx_0_rxcharisk),
        .rx_phy0_rxdata(util_daq2_xcvr_rx_0_rxdata),
        .rx_phy0_rxdisperr(util_daq2_xcvr_rx_0_rxdisperr),
        .rx_phy0_rxnotintable(util_daq2_xcvr_rx_0_rxnotintable),
        .rx_phy1_rxcharisk(util_daq2_xcvr_rx_1_rxcharisk),
        .rx_phy1_rxdata(util_daq2_xcvr_rx_1_rxdata),
        .rx_phy1_rxdisperr(util_daq2_xcvr_rx_1_rxdisperr),
        .rx_phy1_rxnotintable(util_daq2_xcvr_rx_1_rxnotintable),
        .rx_phy2_rxcharisk(util_daq2_xcvr_rx_2_rxcharisk),
        .rx_phy2_rxdata(util_daq2_xcvr_rx_2_rxdata),
        .rx_phy2_rxdisperr(util_daq2_xcvr_rx_2_rxdisperr),
        .rx_phy2_rxnotintable(util_daq2_xcvr_rx_2_rxnotintable),
        .rx_phy3_rxcharisk(util_daq2_xcvr_rx_3_rxcharisk),
        .rx_phy3_rxdata(util_daq2_xcvr_rx_3_rxdata),
        .rx_phy3_rxdisperr(util_daq2_xcvr_rx_3_rxdisperr),
        .rx_phy3_rxnotintable(util_daq2_xcvr_rx_3_rxnotintable),
        .rx_sof(axi_ad9680_jesd_rx_sof),
        .s_axi_aclk(sys_cpu_clk),
        .s_axi_araddr(axi_cpu_interconnect_M06_AXI_ARADDR),
        .s_axi_aresetn(sys_cpu_resetn),
        .s_axi_arprot(axi_cpu_interconnect_M06_AXI_ARPROT),
        .s_axi_arready(axi_cpu_interconnect_M06_AXI_ARREADY),
        .s_axi_arvalid(axi_cpu_interconnect_M06_AXI_ARVALID),
        .s_axi_awaddr(axi_cpu_interconnect_M06_AXI_AWADDR),
        .s_axi_awprot(axi_cpu_interconnect_M06_AXI_AWPROT),
        .s_axi_awready(axi_cpu_interconnect_M06_AXI_AWREADY),
        .s_axi_awvalid(axi_cpu_interconnect_M06_AXI_AWVALID),
        .s_axi_bready(axi_cpu_interconnect_M06_AXI_BREADY),
        .s_axi_bresp(axi_cpu_interconnect_M06_AXI_BRESP),
        .s_axi_bvalid(axi_cpu_interconnect_M06_AXI_BVALID),
        .s_axi_rdata(axi_cpu_interconnect_M06_AXI_RDATA),
        .s_axi_rready(axi_cpu_interconnect_M06_AXI_RREADY),
        .s_axi_rresp(axi_cpu_interconnect_M06_AXI_RRESP),
        .s_axi_rvalid(axi_cpu_interconnect_M06_AXI_RVALID),
        .s_axi_wdata(axi_cpu_interconnect_M06_AXI_WDATA),
        .s_axi_wready(axi_cpu_interconnect_M06_AXI_WREADY),
        .s_axi_wstrb(axi_cpu_interconnect_M06_AXI_WSTRB),
        .s_axi_wvalid(axi_cpu_interconnect_M06_AXI_WVALID),
        .sync(axi_ad9680_jesd_sync),
        .sysref(sysref_2));
  system_axi_ad9680_jesd_rstgen_0 axi_ad9680_jesd_rstgen
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(sys_cpu_resetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(axi_ad9680_jesd_rstgen_peripheral_aresetn),
        .peripheral_reset(axi_ad9680_jesd_rstgen_peripheral_reset),
        .slowest_sync_clk(util_daq2_xcvr_rx_out_clk_0));
  system_axi_ad9680_xcvr_0 axi_ad9680_xcvr
       (.m_axi_araddr(S00_AXI_2_ARADDR),
        .m_axi_arprot(S00_AXI_2_ARPROT),
        .m_axi_arready(S00_AXI_2_ARREADY),
        .m_axi_arvalid(S00_AXI_2_ARVALID),
        .m_axi_awaddr(S00_AXI_2_AWADDR),
        .m_axi_awprot(S00_AXI_2_AWPROT),
        .m_axi_awready(S00_AXI_2_AWREADY),
        .m_axi_awvalid(S00_AXI_2_AWVALID),
        .m_axi_bready(S00_AXI_2_BREADY),
        .m_axi_bresp(S00_AXI_2_BRESP),
        .m_axi_bvalid(S00_AXI_2_BVALID),
        .m_axi_rdata(S00_AXI_2_RDATA),
        .m_axi_rready(S00_AXI_2_RREADY),
        .m_axi_rresp(S00_AXI_2_RRESP),
        .m_axi_rvalid(S00_AXI_2_RVALID),
        .m_axi_wdata(S00_AXI_2_WDATA),
        .m_axi_wready(S00_AXI_2_WREADY),
        .m_axi_wstrb(S00_AXI_2_WSTRB),
        .m_axi_wvalid(S00_AXI_2_WVALID),
        .s_axi_aclk(sys_cpu_clk),
        .s_axi_araddr(axi_cpu_interconnect_M04_AXI_ARADDR[15:0]),
        .s_axi_aresetn(sys_cpu_resetn),
        .s_axi_arprot(axi_cpu_interconnect_M04_AXI_ARPROT),
        .s_axi_arready(axi_cpu_interconnect_M04_AXI_ARREADY),
        .s_axi_arvalid(axi_cpu_interconnect_M04_AXI_ARVALID),
        .s_axi_awaddr(axi_cpu_interconnect_M04_AXI_AWADDR[15:0]),
        .s_axi_awprot(axi_cpu_interconnect_M04_AXI_AWPROT),
        .s_axi_awready(axi_cpu_interconnect_M04_AXI_AWREADY),
        .s_axi_awvalid(axi_cpu_interconnect_M04_AXI_AWVALID),
        .s_axi_bready(axi_cpu_interconnect_M04_AXI_BREADY),
        .s_axi_bresp(axi_cpu_interconnect_M04_AXI_BRESP),
        .s_axi_bvalid(axi_cpu_interconnect_M04_AXI_BVALID),
        .s_axi_rdata(axi_cpu_interconnect_M04_AXI_RDATA),
        .s_axi_rready(axi_cpu_interconnect_M04_AXI_RREADY),
        .s_axi_rresp(axi_cpu_interconnect_M04_AXI_RRESP),
        .s_axi_rvalid(axi_cpu_interconnect_M04_AXI_RVALID),
        .s_axi_wdata(axi_cpu_interconnect_M04_AXI_WDATA),
        .s_axi_wready(axi_cpu_interconnect_M04_AXI_WREADY),
        .s_axi_wstrb(axi_cpu_interconnect_M04_AXI_WSTRB),
        .s_axi_wvalid(axi_cpu_interconnect_M04_AXI_WVALID),
        .up_ch_addr_0(axi_ad9680_xcvr_up_ch_0_addr),
        .up_ch_addr_1(axi_ad9680_xcvr_up_ch_1_addr),
        .up_ch_addr_2(axi_ad9680_xcvr_up_ch_2_addr),
        .up_ch_addr_3(axi_ad9680_xcvr_up_ch_3_addr),
        .up_ch_enb_0(axi_ad9680_xcvr_up_ch_0_enb),
        .up_ch_enb_1(axi_ad9680_xcvr_up_ch_1_enb),
        .up_ch_enb_2(axi_ad9680_xcvr_up_ch_2_enb),
        .up_ch_enb_3(axi_ad9680_xcvr_up_ch_3_enb),
        .up_ch_lpm_dfe_n_0(axi_ad9680_xcvr_up_ch_0_lpm_dfe_n),
        .up_ch_lpm_dfe_n_1(axi_ad9680_xcvr_up_ch_1_lpm_dfe_n),
        .up_ch_lpm_dfe_n_2(axi_ad9680_xcvr_up_ch_2_lpm_dfe_n),
        .up_ch_lpm_dfe_n_3(axi_ad9680_xcvr_up_ch_3_lpm_dfe_n),
        .up_ch_out_clk_sel_0(axi_ad9680_xcvr_up_ch_0_out_clk_sel),
        .up_ch_out_clk_sel_1(axi_ad9680_xcvr_up_ch_1_out_clk_sel),
        .up_ch_out_clk_sel_2(axi_ad9680_xcvr_up_ch_2_out_clk_sel),
        .up_ch_out_clk_sel_3(axi_ad9680_xcvr_up_ch_3_out_clk_sel),
        .up_ch_pll_locked_0(axi_ad9680_xcvr_up_ch_0_pll_locked),
        .up_ch_pll_locked_1(axi_ad9680_xcvr_up_ch_1_pll_locked),
        .up_ch_pll_locked_2(axi_ad9680_xcvr_up_ch_2_pll_locked),
        .up_ch_pll_locked_3(axi_ad9680_xcvr_up_ch_3_pll_locked),
        .up_ch_rate_0(axi_ad9680_xcvr_up_ch_0_rate),
        .up_ch_rate_1(axi_ad9680_xcvr_up_ch_1_rate),
        .up_ch_rate_2(axi_ad9680_xcvr_up_ch_2_rate),
        .up_ch_rate_3(axi_ad9680_xcvr_up_ch_3_rate),
        .up_ch_rdata_0(axi_ad9680_xcvr_up_ch_0_rdata),
        .up_ch_rdata_1(axi_ad9680_xcvr_up_ch_1_rdata),
        .up_ch_rdata_2(axi_ad9680_xcvr_up_ch_2_rdata),
        .up_ch_rdata_3(axi_ad9680_xcvr_up_ch_3_rdata),
        .up_ch_ready_0(axi_ad9680_xcvr_up_ch_0_ready),
        .up_ch_ready_1(axi_ad9680_xcvr_up_ch_1_ready),
        .up_ch_ready_2(axi_ad9680_xcvr_up_ch_2_ready),
        .up_ch_ready_3(axi_ad9680_xcvr_up_ch_3_ready),
        .up_ch_rst_0(axi_ad9680_xcvr_up_ch_0_rst),
        .up_ch_rst_1(axi_ad9680_xcvr_up_ch_1_rst),
        .up_ch_rst_2(axi_ad9680_xcvr_up_ch_2_rst),
        .up_ch_rst_3(axi_ad9680_xcvr_up_ch_3_rst),
        .up_ch_rst_done_0(axi_ad9680_xcvr_up_ch_0_rst_done),
        .up_ch_rst_done_1(axi_ad9680_xcvr_up_ch_1_rst_done),
        .up_ch_rst_done_2(axi_ad9680_xcvr_up_ch_2_rst_done),
        .up_ch_rst_done_3(axi_ad9680_xcvr_up_ch_3_rst_done),
        .up_ch_sys_clk_sel_0(axi_ad9680_xcvr_up_ch_0_sys_clk_sel),
        .up_ch_sys_clk_sel_1(axi_ad9680_xcvr_up_ch_1_sys_clk_sel),
        .up_ch_sys_clk_sel_2(axi_ad9680_xcvr_up_ch_2_sys_clk_sel),
        .up_ch_sys_clk_sel_3(axi_ad9680_xcvr_up_ch_3_sys_clk_sel),
        .up_ch_user_ready_0(axi_ad9680_xcvr_up_ch_0_user_ready),
        .up_ch_user_ready_1(axi_ad9680_xcvr_up_ch_1_user_ready),
        .up_ch_user_ready_2(axi_ad9680_xcvr_up_ch_2_user_ready),
        .up_ch_user_ready_3(axi_ad9680_xcvr_up_ch_3_user_ready),
        .up_ch_wdata_0(axi_ad9680_xcvr_up_ch_0_wdata),
        .up_ch_wdata_1(axi_ad9680_xcvr_up_ch_1_wdata),
        .up_ch_wdata_2(axi_ad9680_xcvr_up_ch_2_wdata),
        .up_ch_wdata_3(axi_ad9680_xcvr_up_ch_3_wdata),
        .up_ch_wr_0(axi_ad9680_xcvr_up_ch_0_wr),
        .up_ch_wr_1(axi_ad9680_xcvr_up_ch_1_wr),
        .up_ch_wr_2(axi_ad9680_xcvr_up_ch_2_wr),
        .up_ch_wr_3(axi_ad9680_xcvr_up_ch_3_wr),
        .up_es_addr_0(axi_ad9680_xcvr_up_es_0_addr),
        .up_es_addr_1(axi_ad9680_xcvr_up_es_1_addr),
        .up_es_addr_2(axi_ad9680_xcvr_up_es_2_addr),
        .up_es_addr_3(axi_ad9680_xcvr_up_es_3_addr),
        .up_es_enb_0(axi_ad9680_xcvr_up_es_0_enb),
        .up_es_enb_1(axi_ad9680_xcvr_up_es_1_enb),
        .up_es_enb_2(axi_ad9680_xcvr_up_es_2_enb),
        .up_es_enb_3(axi_ad9680_xcvr_up_es_3_enb),
        .up_es_rdata_0(axi_ad9680_xcvr_up_es_0_rdata),
        .up_es_rdata_1(axi_ad9680_xcvr_up_es_1_rdata),
        .up_es_rdata_2(axi_ad9680_xcvr_up_es_2_rdata),
        .up_es_rdata_3(axi_ad9680_xcvr_up_es_3_rdata),
        .up_es_ready_0(axi_ad9680_xcvr_up_es_0_ready),
        .up_es_ready_1(axi_ad9680_xcvr_up_es_1_ready),
        .up_es_ready_2(axi_ad9680_xcvr_up_es_2_ready),
        .up_es_ready_3(axi_ad9680_xcvr_up_es_3_ready),
        .up_es_wdata_0(axi_ad9680_xcvr_up_es_0_wdata),
        .up_es_wdata_1(axi_ad9680_xcvr_up_es_1_wdata),
        .up_es_wdata_2(axi_ad9680_xcvr_up_es_2_wdata),
        .up_es_wdata_3(axi_ad9680_xcvr_up_es_3_wdata),
        .up_es_wr_0(axi_ad9680_xcvr_up_es_0_wr),
        .up_es_wr_1(axi_ad9680_xcvr_up_es_1_wr),
        .up_es_wr_2(axi_ad9680_xcvr_up_es_2_wr),
        .up_es_wr_3(axi_ad9680_xcvr_up_es_3_wr),
        .up_pll_rst(axi_ad9680_xcvr_up_pll_rst));
  system_axi_cpu_interconnect_0 axi_cpu_interconnect
       (.ACLK(sys_cpu_clk),
        .ARESETN(sys_cpu_resetn),
        .M00_ACLK(sys_cpu_clk),
        .M00_ARESETN(sys_cpu_resetn),
        .M00_AXI_arready(1'b0),
        .M00_AXI_awready(1'b0),
        .M00_AXI_bresp(1'b0),
        .M00_AXI_bvalid(1'b0),
        .M00_AXI_rdata(1'b0),
        .M00_AXI_rresp(1'b0),
        .M00_AXI_rvalid(1'b0),
        .M00_AXI_wready(1'b0),
        .M01_ACLK(sys_cpu_clk),
        .M01_ARESETN(sys_cpu_resetn),
        .M01_AXI_arready(1'b0),
        .M01_AXI_awready(1'b0),
        .M01_AXI_bresp(1'b0),
        .M01_AXI_bvalid(1'b0),
        .M01_AXI_rdata(1'b0),
        .M01_AXI_rresp(1'b0),
        .M01_AXI_rvalid(1'b0),
        .M01_AXI_wready(1'b0),
        .M02_ACLK(sys_cpu_clk),
        .M02_ARESETN(sys_cpu_resetn),
        .M02_AXI_arready(1'b0),
        .M02_AXI_awready(1'b0),
        .M02_AXI_bresp(1'b0),
        .M02_AXI_bvalid(1'b0),
        .M02_AXI_rdata(1'b0),
        .M02_AXI_rresp(1'b0),
        .M02_AXI_rvalid(1'b0),
        .M02_AXI_wready(1'b0),
        .M03_ACLK(sys_cpu_clk),
        .M03_ARESETN(sys_cpu_resetn),
        .M03_AXI_arready(1'b0),
        .M03_AXI_awready(1'b0),
        .M03_AXI_bresp(1'b0),
        .M03_AXI_bvalid(1'b0),
        .M03_AXI_rdata(1'b0),
        .M03_AXI_rresp(1'b0),
        .M03_AXI_rvalid(1'b0),
        .M03_AXI_wready(1'b0),
        .M04_ACLK(sys_cpu_clk),
        .M04_ARESETN(sys_cpu_resetn),
        .M04_AXI_araddr(axi_cpu_interconnect_M04_AXI_ARADDR),
        .M04_AXI_arprot(axi_cpu_interconnect_M04_AXI_ARPROT),
        .M04_AXI_arready(axi_cpu_interconnect_M04_AXI_ARREADY),
        .M04_AXI_arvalid(axi_cpu_interconnect_M04_AXI_ARVALID),
        .M04_AXI_awaddr(axi_cpu_interconnect_M04_AXI_AWADDR),
        .M04_AXI_awprot(axi_cpu_interconnect_M04_AXI_AWPROT),
        .M04_AXI_awready(axi_cpu_interconnect_M04_AXI_AWREADY),
        .M04_AXI_awvalid(axi_cpu_interconnect_M04_AXI_AWVALID),
        .M04_AXI_bready(axi_cpu_interconnect_M04_AXI_BREADY),
        .M04_AXI_bresp(axi_cpu_interconnect_M04_AXI_BRESP),
        .M04_AXI_bvalid(axi_cpu_interconnect_M04_AXI_BVALID),
        .M04_AXI_rdata(axi_cpu_interconnect_M04_AXI_RDATA),
        .M04_AXI_rready(axi_cpu_interconnect_M04_AXI_RREADY),
        .M04_AXI_rresp(axi_cpu_interconnect_M04_AXI_RRESP),
        .M04_AXI_rvalid(axi_cpu_interconnect_M04_AXI_RVALID),
        .M04_AXI_wdata(axi_cpu_interconnect_M04_AXI_WDATA),
        .M04_AXI_wready(axi_cpu_interconnect_M04_AXI_WREADY),
        .M04_AXI_wstrb(axi_cpu_interconnect_M04_AXI_WSTRB),
        .M04_AXI_wvalid(axi_cpu_interconnect_M04_AXI_WVALID),
        .M05_ACLK(sys_cpu_clk),
        .M05_ARESETN(sys_cpu_resetn),
        .M05_AXI_araddr(axi_cpu_interconnect_M05_AXI_ARADDR),
        .M05_AXI_arprot(axi_cpu_interconnect_M05_AXI_ARPROT),
        .M05_AXI_arready(axi_cpu_interconnect_M05_AXI_ARREADY),
        .M05_AXI_arvalid(axi_cpu_interconnect_M05_AXI_ARVALID),
        .M05_AXI_awaddr(axi_cpu_interconnect_M05_AXI_AWADDR),
        .M05_AXI_awprot(axi_cpu_interconnect_M05_AXI_AWPROT),
        .M05_AXI_awready(axi_cpu_interconnect_M05_AXI_AWREADY),
        .M05_AXI_awvalid(axi_cpu_interconnect_M05_AXI_AWVALID),
        .M05_AXI_bready(axi_cpu_interconnect_M05_AXI_BREADY),
        .M05_AXI_bresp(axi_cpu_interconnect_M05_AXI_BRESP),
        .M05_AXI_bvalid(axi_cpu_interconnect_M05_AXI_BVALID),
        .M05_AXI_rdata(axi_cpu_interconnect_M05_AXI_RDATA),
        .M05_AXI_rready(axi_cpu_interconnect_M05_AXI_RREADY),
        .M05_AXI_rresp(axi_cpu_interconnect_M05_AXI_RRESP),
        .M05_AXI_rvalid(axi_cpu_interconnect_M05_AXI_RVALID),
        .M05_AXI_wdata(axi_cpu_interconnect_M05_AXI_WDATA),
        .M05_AXI_wready(axi_cpu_interconnect_M05_AXI_WREADY),
        .M05_AXI_wstrb(axi_cpu_interconnect_M05_AXI_WSTRB),
        .M05_AXI_wvalid(axi_cpu_interconnect_M05_AXI_WVALID),
        .M06_ACLK(sys_cpu_clk),
        .M06_ARESETN(sys_cpu_resetn),
        .M06_AXI_araddr(axi_cpu_interconnect_M06_AXI_ARADDR),
        .M06_AXI_arprot(axi_cpu_interconnect_M06_AXI_ARPROT),
        .M06_AXI_arready(axi_cpu_interconnect_M06_AXI_ARREADY),
        .M06_AXI_arvalid(axi_cpu_interconnect_M06_AXI_ARVALID),
        .M06_AXI_awaddr(axi_cpu_interconnect_M06_AXI_AWADDR),
        .M06_AXI_awprot(axi_cpu_interconnect_M06_AXI_AWPROT),
        .M06_AXI_awready(axi_cpu_interconnect_M06_AXI_AWREADY),
        .M06_AXI_awvalid(axi_cpu_interconnect_M06_AXI_AWVALID),
        .M06_AXI_bready(axi_cpu_interconnect_M06_AXI_BREADY),
        .M06_AXI_bresp(axi_cpu_interconnect_M06_AXI_BRESP),
        .M06_AXI_bvalid(axi_cpu_interconnect_M06_AXI_BVALID),
        .M06_AXI_rdata(axi_cpu_interconnect_M06_AXI_RDATA),
        .M06_AXI_rready(axi_cpu_interconnect_M06_AXI_RREADY),
        .M06_AXI_rresp(axi_cpu_interconnect_M06_AXI_RRESP),
        .M06_AXI_rvalid(axi_cpu_interconnect_M06_AXI_RVALID),
        .M06_AXI_wdata(axi_cpu_interconnect_M06_AXI_WDATA),
        .M06_AXI_wready(axi_cpu_interconnect_M06_AXI_WREADY),
        .M06_AXI_wstrb(axi_cpu_interconnect_M06_AXI_WSTRB),
        .M06_AXI_wvalid(axi_cpu_interconnect_M06_AXI_WVALID),
        .M07_ACLK(sys_cpu_clk),
        .M07_ARESETN(sys_cpu_resetn),
        .M07_AXI_araddr(axi_cpu_interconnect_M07_AXI_ARADDR),
        .M07_AXI_arprot(axi_cpu_interconnect_M07_AXI_ARPROT),
        .M07_AXI_arready(axi_cpu_interconnect_M07_AXI_ARREADY),
        .M07_AXI_arvalid(axi_cpu_interconnect_M07_AXI_ARVALID),
        .M07_AXI_awaddr(axi_cpu_interconnect_M07_AXI_AWADDR),
        .M07_AXI_awprot(axi_cpu_interconnect_M07_AXI_AWPROT),
        .M07_AXI_awready(axi_cpu_interconnect_M07_AXI_AWREADY),
        .M07_AXI_awvalid(axi_cpu_interconnect_M07_AXI_AWVALID),
        .M07_AXI_bready(axi_cpu_interconnect_M07_AXI_BREADY),
        .M07_AXI_bresp(axi_cpu_interconnect_M07_AXI_BRESP),
        .M07_AXI_bvalid(axi_cpu_interconnect_M07_AXI_BVALID),
        .M07_AXI_rdata(axi_cpu_interconnect_M07_AXI_RDATA),
        .M07_AXI_rready(axi_cpu_interconnect_M07_AXI_RREADY),
        .M07_AXI_rresp(axi_cpu_interconnect_M07_AXI_RRESP),
        .M07_AXI_rvalid(axi_cpu_interconnect_M07_AXI_RVALID),
        .M07_AXI_wdata(axi_cpu_interconnect_M07_AXI_WDATA),
        .M07_AXI_wready(axi_cpu_interconnect_M07_AXI_WREADY),
        .M07_AXI_wstrb(axi_cpu_interconnect_M07_AXI_WSTRB),
        .M07_AXI_wvalid(axi_cpu_interconnect_M07_AXI_WVALID),
        .S00_ACLK(sys_cpu_clk),
        .S00_ARESETN(sys_cpu_resetn),
        .S00_AXI_araddr(S00_AXI_1_ARADDR),
        .S00_AXI_arburst(S00_AXI_1_ARBURST),
        .S00_AXI_arcache(S00_AXI_1_ARCACHE),
        .S00_AXI_arid(S00_AXI_1_ARID),
        .S00_AXI_arlen(S00_AXI_1_ARLEN),
        .S00_AXI_arlock(S00_AXI_1_ARLOCK),
        .S00_AXI_arprot(S00_AXI_1_ARPROT),
        .S00_AXI_arqos(S00_AXI_1_ARQOS),
        .S00_AXI_arready(S00_AXI_1_ARREADY),
        .S00_AXI_arsize(S00_AXI_1_ARSIZE),
        .S00_AXI_arvalid(S00_AXI_1_ARVALID),
        .S00_AXI_awaddr(S00_AXI_1_AWADDR),
        .S00_AXI_awburst(S00_AXI_1_AWBURST),
        .S00_AXI_awcache(S00_AXI_1_AWCACHE),
        .S00_AXI_awid(S00_AXI_1_AWID),
        .S00_AXI_awlen(S00_AXI_1_AWLEN),
        .S00_AXI_awlock(S00_AXI_1_AWLOCK),
        .S00_AXI_awprot(S00_AXI_1_AWPROT),
        .S00_AXI_awqos(S00_AXI_1_AWQOS),
        .S00_AXI_awready(S00_AXI_1_AWREADY),
        .S00_AXI_awsize(S00_AXI_1_AWSIZE),
        .S00_AXI_awvalid(S00_AXI_1_AWVALID),
        .S00_AXI_bid(S00_AXI_1_BID),
        .S00_AXI_bready(S00_AXI_1_BREADY),
        .S00_AXI_bresp(S00_AXI_1_BRESP),
        .S00_AXI_bvalid(S00_AXI_1_BVALID),
        .S00_AXI_rdata(S00_AXI_1_RDATA),
        .S00_AXI_rid(S00_AXI_1_RID),
        .S00_AXI_rlast(S00_AXI_1_RLAST),
        .S00_AXI_rready(S00_AXI_1_RREADY),
        .S00_AXI_rresp(S00_AXI_1_RRESP),
        .S00_AXI_rvalid(S00_AXI_1_RVALID),
        .S00_AXI_wdata(S00_AXI_1_WDATA),
        .S00_AXI_wlast(S00_AXI_1_WLAST),
        .S00_AXI_wready(S00_AXI_1_WREADY),
        .S00_AXI_wstrb(S00_AXI_1_WSTRB),
        .S00_AXI_wvalid(S00_AXI_1_WVALID));
  system_axi_hp2_interconnect_0 axi_hp2_interconnect
       (.ACLK(sys_cpu_clk),
        .ARESETN(sys_cpu_resetn),
        .M00_ACLK(sys_cpu_clk),
        .M00_ARESETN(sys_cpu_resetn),
        .M00_AXI_awaddr(axi_hp2_interconnect_M00_AXI_AWADDR),
        .M00_AXI_awburst(axi_hp2_interconnect_M00_AXI_AWBURST),
        .M00_AXI_awcache(axi_hp2_interconnect_M00_AXI_AWCACHE),
        .M00_AXI_awlen(axi_hp2_interconnect_M00_AXI_AWLEN),
        .M00_AXI_awlock(axi_hp2_interconnect_M00_AXI_AWLOCK),
        .M00_AXI_awprot(axi_hp2_interconnect_M00_AXI_AWPROT),
        .M00_AXI_awqos(axi_hp2_interconnect_M00_AXI_AWQOS),
        .M00_AXI_awready(axi_hp2_interconnect_M00_AXI_AWREADY),
        .M00_AXI_awsize(axi_hp2_interconnect_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(axi_hp2_interconnect_M00_AXI_AWVALID),
        .M00_AXI_bready(axi_hp2_interconnect_M00_AXI_BREADY),
        .M00_AXI_bresp(axi_hp2_interconnect_M00_AXI_BRESP),
        .M00_AXI_bvalid(axi_hp2_interconnect_M00_AXI_BVALID),
        .M00_AXI_wdata(axi_hp2_interconnect_M00_AXI_WDATA),
        .M00_AXI_wlast(axi_hp2_interconnect_M00_AXI_WLAST),
        .M00_AXI_wready(axi_hp2_interconnect_M00_AXI_WREADY),
        .M00_AXI_wstrb(axi_hp2_interconnect_M00_AXI_WSTRB),
        .M00_AXI_wvalid(axi_hp2_interconnect_M00_AXI_WVALID),
        .S00_ACLK(sys_cpu_clk),
        .S00_ARESETN(sys_cpu_resetn),
        .S00_AXI_awaddr(S00_AXI_4_AWADDR),
        .S00_AXI_awburst(S00_AXI_4_AWBURST),
        .S00_AXI_awcache(S00_AXI_4_AWCACHE),
        .S00_AXI_awlen(S00_AXI_4_AWLEN),
        .S00_AXI_awprot(S00_AXI_4_AWPROT),
        .S00_AXI_awready(S00_AXI_4_AWREADY),
        .S00_AXI_awsize(S00_AXI_4_AWSIZE),
        .S00_AXI_awvalid(S00_AXI_4_AWVALID),
        .S00_AXI_bready(S00_AXI_4_BREADY),
        .S00_AXI_bresp(S00_AXI_4_BRESP),
        .S00_AXI_bvalid(S00_AXI_4_BVALID),
        .S00_AXI_wdata(S00_AXI_4_WDATA),
        .S00_AXI_wlast(S00_AXI_4_WLAST),
        .S00_AXI_wready(S00_AXI_4_WREADY),
        .S00_AXI_wstrb(S00_AXI_4_WSTRB),
        .S00_AXI_wvalid(S00_AXI_4_WVALID));
  system_axi_hp3_interconnect_0 axi_hp3_interconnect
       (.ACLK(sys_cpu_clk),
        .ARESETN(sys_cpu_resetn),
        .M00_ACLK(sys_cpu_clk),
        .M00_ARESETN(sys_cpu_resetn),
        .M00_AXI_araddr(axi_hp3_interconnect_M00_AXI_ARADDR),
        .M00_AXI_arburst(axi_hp3_interconnect_M00_AXI_ARBURST),
        .M00_AXI_arcache(axi_hp3_interconnect_M00_AXI_ARCACHE),
        .M00_AXI_arlen(axi_hp3_interconnect_M00_AXI_ARLEN),
        .M00_AXI_arlock(axi_hp3_interconnect_M00_AXI_ARLOCK),
        .M00_AXI_arprot(axi_hp3_interconnect_M00_AXI_ARPROT),
        .M00_AXI_arqos(axi_hp3_interconnect_M00_AXI_ARQOS),
        .M00_AXI_arready(axi_hp3_interconnect_M00_AXI_ARREADY),
        .M00_AXI_arsize(axi_hp3_interconnect_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(axi_hp3_interconnect_M00_AXI_ARVALID),
        .M00_AXI_awaddr(axi_hp3_interconnect_M00_AXI_AWADDR),
        .M00_AXI_awburst(axi_hp3_interconnect_M00_AXI_AWBURST),
        .M00_AXI_awcache(axi_hp3_interconnect_M00_AXI_AWCACHE),
        .M00_AXI_awlen(axi_hp3_interconnect_M00_AXI_AWLEN),
        .M00_AXI_awlock(axi_hp3_interconnect_M00_AXI_AWLOCK),
        .M00_AXI_awprot(axi_hp3_interconnect_M00_AXI_AWPROT),
        .M00_AXI_awqos(axi_hp3_interconnect_M00_AXI_AWQOS),
        .M00_AXI_awready(axi_hp3_interconnect_M00_AXI_AWREADY),
        .M00_AXI_awsize(axi_hp3_interconnect_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(axi_hp3_interconnect_M00_AXI_AWVALID),
        .M00_AXI_bready(axi_hp3_interconnect_M00_AXI_BREADY),
        .M00_AXI_bresp(axi_hp3_interconnect_M00_AXI_BRESP),
        .M00_AXI_bvalid(axi_hp3_interconnect_M00_AXI_BVALID),
        .M00_AXI_rdata(axi_hp3_interconnect_M00_AXI_RDATA),
        .M00_AXI_rlast(axi_hp3_interconnect_M00_AXI_RLAST),
        .M00_AXI_rready(axi_hp3_interconnect_M00_AXI_RREADY),
        .M00_AXI_rresp(axi_hp3_interconnect_M00_AXI_RRESP),
        .M00_AXI_rvalid(axi_hp3_interconnect_M00_AXI_RVALID),
        .M00_AXI_wdata(axi_hp3_interconnect_M00_AXI_WDATA),
        .M00_AXI_wlast(axi_hp3_interconnect_M00_AXI_WLAST),
        .M00_AXI_wready(axi_hp3_interconnect_M00_AXI_WREADY),
        .M00_AXI_wstrb(axi_hp3_interconnect_M00_AXI_WSTRB),
        .M00_AXI_wvalid(axi_hp3_interconnect_M00_AXI_WVALID),
        .S00_ACLK(sys_cpu_clk),
        .S00_ARESETN(sys_cpu_resetn),
        .S00_AXI_araddr(S00_AXI_2_ARADDR),
        .S00_AXI_arprot(S00_AXI_2_ARPROT),
        .S00_AXI_arready(S00_AXI_2_ARREADY),
        .S00_AXI_arvalid(S00_AXI_2_ARVALID),
        .S00_AXI_awaddr(S00_AXI_2_AWADDR),
        .S00_AXI_awprot(S00_AXI_2_AWPROT),
        .S00_AXI_awready(S00_AXI_2_AWREADY),
        .S00_AXI_awvalid(S00_AXI_2_AWVALID),
        .S00_AXI_bready(S00_AXI_2_BREADY),
        .S00_AXI_bresp(S00_AXI_2_BRESP),
        .S00_AXI_bvalid(S00_AXI_2_BVALID),
        .S00_AXI_rdata(S00_AXI_2_RDATA),
        .S00_AXI_rready(S00_AXI_2_RREADY),
        .S00_AXI_rresp(S00_AXI_2_RRESP),
        .S00_AXI_rvalid(S00_AXI_2_RVALID),
        .S00_AXI_wdata(S00_AXI_2_WDATA),
        .S00_AXI_wready(S00_AXI_2_WREADY),
        .S00_AXI_wstrb(S00_AXI_2_WSTRB),
        .S00_AXI_wvalid(S00_AXI_2_WVALID));
  system_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_in1_0_1),
        .clk_out200M(clk_wiz_0_clk_out200M),
        .resetn(sys_cpu_resetn));
  system_format_9234_timestamp_0_0 format_9234_timestamp_0
       (.clk(util_daq2_xcvr_rx_out_clk_0),
        .clk_2x(util_daq2_xcvr_rx_out_clk_0),
        .i_adc_enable_0(axi_ad9680_core_adc_enable_0),
        .i_adc_enable_1(axi_ad9680_core_adc_enable_1),
        .i_adc_valid_0(axi_ad9680_core_adc_valid_0),
        .i_adc_valid_1(axi_ad9680_core_adc_valid_1),
        .in_0(axi_ad9680_core_adc_data_0),
        .in_1(axi_ad9680_core_adc_data_1),
        .o_adc_enable_0(format_9234_timestamp_0_o_adc_enable_0),
        .o_adc_enable_1(format_9234_timestamp_0_o_adc_enable_1),
        .o_adc_valid_0(format_9234_timestamp_0_o_adc_valid_0),
        .o_adc_valid_1(format_9234_timestamp_0_o_adc_valid_1),
        .o_ps_irq(format_9234_timestamp_0_o_ps_irq),
        .out_0(format_9234_timestamp_0_out_0),
        .out_1(format_9234_timestamp_0_out_1),
        .rst_n(axi_ad9680_jesd_rstgen_peripheral_aresetn),
        .trig(start_LD_0_start1),
        .waveform_0(format_9234_timestamp_0_waveform_0),
        .waveform_1(format_9234_timestamp_0_waveform_1));
  system_ila_0_0 ila_0
       (.clk(util_daq2_xcvr_rx_out_clk_0),
        .probe0(start_LD_0_start1),
        .probe1(format_9234_timestamp_0_out_0),
        .probe10(axi_ad9680_core_adc_data_0),
        .probe11(axi_ad9680_core_adc_data_1),
        .probe12(axi_ad9680_core_adc_valid_1),
        .probe13(axi_ad9680_core_adc_enable_1),
        .probe14(axi_ad9680_core_adc_valid_0),
        .probe15(axi_ad9680_core_adc_enable_0),
        .probe16({adc_fdb_1,adc_fdb_1,adc_fdb_1,adc_fdb_1,adc_fdb_1,adc_fdb_1,adc_fdb_1,adc_fdb_1}),
        .probe17(axi_ad9680_jesd_rx_data_tdata),
        .probe18(sysref_2),
        .probe19(axi_ad9680_jesd_sync),
        .probe2(format_9234_timestamp_0_out_1),
        .probe20(adc_fda_1),
        .probe21(axi_ad9680_jesd_rx_data_tvalid),
        .probe22(axi_ad9680_jesd_rx_sof),
        .probe3(format_9234_timestamp_0_waveform_0),
        .probe4(format_9234_timestamp_0_waveform_1),
        .probe5(format_9234_timestamp_0_o_ps_irq),
        .probe6(format_9234_timestamp_0_o_adc_valid_0),
        .probe7(format_9234_timestamp_0_o_adc_valid_1),
        .probe8(format_9234_timestamp_0_o_adc_enable_0),
        .probe9(format_9234_timestamp_0_o_adc_enable_1));
  system_spi0_csn_concat_0 spi0_csn_concat
       (.In0(sys_ps8_emio_spi0_ss_o_n),
        .In1(sys_ps8_emio_spi0_ss1_o_n),
        .In2(sys_ps8_emio_spi0_ss2_o_n),
        .dout(spi0_csn_concat_dout));
  system_spi1_csn_concat_0 spi1_csn_concat
       (.In0(sys_ps8_emio_spi1_ss_o_n),
        .In1(sys_ps8_emio_spi1_ss1_o_n),
        .In2(sys_ps8_emio_spi1_ss2_o_n),
        .dout(spi1_csn_concat_dout));
  system_start_LD_0_0 start_LD_0
       (.clk(util_daq2_xcvr_rx_out_clk_0),
        .rst_n(sys_ps8_emio_spi1_ss_i_n_VCC1_dout),
        .start1(start_LD_0_start1));
  system_sys_concat_intc_0_0 sys_concat_intc_0
       (.In0(ps_intr_00_1),
        .In1(ps_intr_01_1),
        .In2(ps_intr_02_1),
        .In3(ps_intr_03_1),
        .In4(ps_intr_04_1),
        .In5(ps_intr_05_1),
        .In6(ps_intr_06_1),
        .In7(ps_intr_07_1),
        .dout(sys_concat_intc_0_dout));
  system_sys_concat_intc_1_0 sys_concat_intc_1
       (.In0(ps_intr_08_1),
        .In1(ps_intr_09_1),
        .In2(format_9234_timestamp_0_o_ps_irq),
        .In3(axi_ad9680_jesd_irq),
        .In4(1'b0),
        .In5(axi_ad9680_dma_irq),
        .In6(ps_intr_14_1),
        .In7(ps_intr_15_1),
        .dout(sys_concat_intc_1_dout));
  system_sys_ps8_0 sys_ps8
       (.emio_gpio_i(gpio_i_1),
        .emio_gpio_o(sys_ps8_emio_gpio_o),
        .emio_gpio_t(sys_ps8_emio_gpio_t),
        .emio_spi0_m_i(spi0_miso_1),
        .emio_spi0_m_o(sys_ps8_emio_spi0_m_o),
        .emio_spi0_s_i(sys_ps8_emio_spi0_s_i_GND_dout),
        .emio_spi0_sclk_i(sys_ps8_emio_spi0_sclk_i_GND_dout),
        .emio_spi0_sclk_o(sys_ps8_emio_spi0_sclk_o),
        .emio_spi0_ss1_o_n(sys_ps8_emio_spi0_ss1_o_n),
        .emio_spi0_ss2_o_n(sys_ps8_emio_spi0_ss2_o_n),
        .emio_spi0_ss_i_n(sys_ps8_emio_spi0_ss_i_n_VCC_dout),
        .emio_spi0_ss_o_n(sys_ps8_emio_spi0_ss_o_n),
        .emio_spi1_m_i(spi1_miso_1),
        .emio_spi1_m_o(sys_ps8_emio_spi1_m_o),
        .emio_spi1_s_i(sys_ps8_emio_spi1_s_i_GND_dout),
        .emio_spi1_sclk_i(sys_ps8_emio_spi1_sclk_i_GND_dout),
        .emio_spi1_sclk_o(sys_ps8_emio_spi1_sclk_o),
        .emio_spi1_ss1_o_n(sys_ps8_emio_spi1_ss1_o_n),
        .emio_spi1_ss2_o_n(sys_ps8_emio_spi1_ss2_o_n),
        .emio_spi1_ss_i_n(sys_ps8_emio_spi1_ss_i_n_VCC_dout),
        .emio_spi1_ss_o_n(sys_ps8_emio_spi1_ss_o_n),
        .maxigp2_araddr(S00_AXI_1_ARADDR),
        .maxigp2_arburst(S00_AXI_1_ARBURST),
        .maxigp2_arcache(S00_AXI_1_ARCACHE),
        .maxigp2_arid(S00_AXI_1_ARID),
        .maxigp2_arlen(S00_AXI_1_ARLEN),
        .maxigp2_arlock(S00_AXI_1_ARLOCK),
        .maxigp2_arprot(S00_AXI_1_ARPROT),
        .maxigp2_arqos(S00_AXI_1_ARQOS),
        .maxigp2_arready(S00_AXI_1_ARREADY),
        .maxigp2_arsize(S00_AXI_1_ARSIZE),
        .maxigp2_arvalid(S00_AXI_1_ARVALID),
        .maxigp2_awaddr(S00_AXI_1_AWADDR),
        .maxigp2_awburst(S00_AXI_1_AWBURST),
        .maxigp2_awcache(S00_AXI_1_AWCACHE),
        .maxigp2_awid(S00_AXI_1_AWID),
        .maxigp2_awlen(S00_AXI_1_AWLEN),
        .maxigp2_awlock(S00_AXI_1_AWLOCK),
        .maxigp2_awprot(S00_AXI_1_AWPROT),
        .maxigp2_awqos(S00_AXI_1_AWQOS),
        .maxigp2_awready(S00_AXI_1_AWREADY),
        .maxigp2_awsize(S00_AXI_1_AWSIZE),
        .maxigp2_awvalid(S00_AXI_1_AWVALID),
        .maxigp2_bid(S00_AXI_1_BID),
        .maxigp2_bready(S00_AXI_1_BREADY),
        .maxigp2_bresp(S00_AXI_1_BRESP),
        .maxigp2_bvalid(S00_AXI_1_BVALID),
        .maxigp2_rdata(S00_AXI_1_RDATA),
        .maxigp2_rid(S00_AXI_1_RID),
        .maxigp2_rlast(S00_AXI_1_RLAST),
        .maxigp2_rready(S00_AXI_1_RREADY),
        .maxigp2_rresp(S00_AXI_1_RRESP),
        .maxigp2_rvalid(S00_AXI_1_RVALID),
        .maxigp2_wdata(S00_AXI_1_WDATA),
        .maxigp2_wlast(S00_AXI_1_WLAST),
        .maxigp2_wready(S00_AXI_1_WREADY),
        .maxigp2_wstrb(S00_AXI_1_WSTRB),
        .maxigp2_wvalid(S00_AXI_1_WVALID),
        .maxihpm0_lpd_aclk(sys_cpu_clk),
        .pl_clk0(sys_cpu_clk),
        .pl_clk1(sys_200m_clk),
        .pl_ps_irq0(sys_concat_intc_0_dout),
        .pl_ps_irq1(sys_concat_intc_1_dout),
        .pl_resetn0(sys_ps8_pl_resetn0),
        .saxigp3_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_arburst({1'b0,1'b1}),
        .saxigp3_arcache({1'b0,1'b0,1'b1,1'b1}),
        .saxigp3_arid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_arlock(1'b0),
        .saxigp3_arprot({1'b0,1'b0,1'b0}),
        .saxigp3_arqos({1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_arsize({1'b1,1'b0,1'b0}),
        .saxigp3_aruser(1'b0),
        .saxigp3_arvalid(1'b0),
        .saxigp3_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_awburst({1'b0,1'b1}),
        .saxigp3_awcache({1'b0,1'b0,1'b1,1'b1}),
        .saxigp3_awid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_awlock(1'b0),
        .saxigp3_awprot({1'b0,1'b0,1'b0}),
        .saxigp3_awqos({1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_awsize({1'b1,1'b0,1'b0}),
        .saxigp3_awuser(1'b0),
        .saxigp3_awvalid(1'b0),
        .saxigp3_bready(1'b0),
        .saxigp3_rready(1'b0),
        .saxigp3_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_wlast(1'b0),
        .saxigp3_wstrb({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .saxigp3_wvalid(1'b0),
        .saxigp4_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_arburst({1'b0,1'b1}),
        .saxigp4_arcache({1'b0,1'b0,1'b1,1'b1}),
        .saxigp4_arid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_arlock(1'b0),
        .saxigp4_arprot({1'b0,1'b0,1'b0}),
        .saxigp4_arqos({1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_arsize({1'b1,1'b0,1'b0}),
        .saxigp4_aruser(1'b0),
        .saxigp4_arvalid(1'b0),
        .saxigp4_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_hp2_interconnect_M00_AXI_AWADDR}),
        .saxigp4_awburst(axi_hp2_interconnect_M00_AXI_AWBURST),
        .saxigp4_awcache(axi_hp2_interconnect_M00_AXI_AWCACHE),
        .saxigp4_awid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_awlen(axi_hp2_interconnect_M00_AXI_AWLEN),
        .saxigp4_awlock(axi_hp2_interconnect_M00_AXI_AWLOCK),
        .saxigp4_awprot(axi_hp2_interconnect_M00_AXI_AWPROT),
        .saxigp4_awqos(axi_hp2_interconnect_M00_AXI_AWQOS),
        .saxigp4_awready(axi_hp2_interconnect_M00_AXI_AWREADY),
        .saxigp4_awsize(axi_hp2_interconnect_M00_AXI_AWSIZE),
        .saxigp4_awuser(1'b0),
        .saxigp4_awvalid(axi_hp2_interconnect_M00_AXI_AWVALID),
        .saxigp4_bready(axi_hp2_interconnect_M00_AXI_BREADY),
        .saxigp4_bresp(axi_hp2_interconnect_M00_AXI_BRESP),
        .saxigp4_bvalid(axi_hp2_interconnect_M00_AXI_BVALID),
        .saxigp4_rready(1'b0),
        .saxigp4_wdata(axi_hp2_interconnect_M00_AXI_WDATA),
        .saxigp4_wlast(axi_hp2_interconnect_M00_AXI_WLAST),
        .saxigp4_wready(axi_hp2_interconnect_M00_AXI_WREADY),
        .saxigp4_wstrb(axi_hp2_interconnect_M00_AXI_WSTRB),
        .saxigp4_wvalid(axi_hp2_interconnect_M00_AXI_WVALID),
        .saxigp5_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_hp3_interconnect_M00_AXI_ARADDR}),
        .saxigp5_arburst(axi_hp3_interconnect_M00_AXI_ARBURST),
        .saxigp5_arcache(axi_hp3_interconnect_M00_AXI_ARCACHE),
        .saxigp5_arid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp5_arlen(axi_hp3_interconnect_M00_AXI_ARLEN),
        .saxigp5_arlock(axi_hp3_interconnect_M00_AXI_ARLOCK),
        .saxigp5_arprot(axi_hp3_interconnect_M00_AXI_ARPROT),
        .saxigp5_arqos(axi_hp3_interconnect_M00_AXI_ARQOS),
        .saxigp5_arready(axi_hp3_interconnect_M00_AXI_ARREADY),
        .saxigp5_arsize(axi_hp3_interconnect_M00_AXI_ARSIZE),
        .saxigp5_aruser(1'b0),
        .saxigp5_arvalid(axi_hp3_interconnect_M00_AXI_ARVALID),
        .saxigp5_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_hp3_interconnect_M00_AXI_AWADDR}),
        .saxigp5_awburst(axi_hp3_interconnect_M00_AXI_AWBURST),
        .saxigp5_awcache(axi_hp3_interconnect_M00_AXI_AWCACHE),
        .saxigp5_awid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp5_awlen(axi_hp3_interconnect_M00_AXI_AWLEN),
        .saxigp5_awlock(axi_hp3_interconnect_M00_AXI_AWLOCK),
        .saxigp5_awprot(axi_hp3_interconnect_M00_AXI_AWPROT),
        .saxigp5_awqos(axi_hp3_interconnect_M00_AXI_AWQOS),
        .saxigp5_awready(axi_hp3_interconnect_M00_AXI_AWREADY),
        .saxigp5_awsize(axi_hp3_interconnect_M00_AXI_AWSIZE),
        .saxigp5_awuser(1'b0),
        .saxigp5_awvalid(axi_hp3_interconnect_M00_AXI_AWVALID),
        .saxigp5_bready(axi_hp3_interconnect_M00_AXI_BREADY),
        .saxigp5_bresp(axi_hp3_interconnect_M00_AXI_BRESP),
        .saxigp5_bvalid(axi_hp3_interconnect_M00_AXI_BVALID),
        .saxigp5_rdata(axi_hp3_interconnect_M00_AXI_RDATA),
        .saxigp5_rlast(axi_hp3_interconnect_M00_AXI_RLAST),
        .saxigp5_rready(axi_hp3_interconnect_M00_AXI_RREADY),
        .saxigp5_rresp(axi_hp3_interconnect_M00_AXI_RRESP),
        .saxigp5_rvalid(axi_hp3_interconnect_M00_AXI_RVALID),
        .saxigp5_wdata(axi_hp3_interconnect_M00_AXI_WDATA),
        .saxigp5_wlast(axi_hp3_interconnect_M00_AXI_WLAST),
        .saxigp5_wready(axi_hp3_interconnect_M00_AXI_WREADY),
        .saxigp5_wstrb(axi_hp3_interconnect_M00_AXI_WSTRB),
        .saxigp5_wvalid(axi_hp3_interconnect_M00_AXI_WVALID),
        .saxihp1_fpd_aclk(sys_cpu_clk),
        .saxihp2_fpd_aclk(sys_cpu_clk),
        .saxihp3_fpd_aclk(sys_cpu_clk));
  system_sys_ps8_emio_spi0_s_i_GND_0 sys_ps8_emio_spi0_s_i_GND
       (.dout(sys_ps8_emio_spi0_s_i_GND_dout));
  system_sys_ps8_emio_spi0_sclk_i_GND_0 sys_ps8_emio_spi0_sclk_i_GND
       (.dout(sys_ps8_emio_spi0_sclk_i_GND_dout));
  system_sys_ps8_emio_spi0_ss_i_n_VCC_0 sys_ps8_emio_spi0_ss_i_n_VCC
       (.dout(sys_ps8_emio_spi0_ss_i_n_VCC_dout));
  system_sys_ps8_emio_spi1_s_i_GND_0 sys_ps8_emio_spi1_s_i_GND
       (.dout(sys_ps8_emio_spi1_s_i_GND_dout));
  system_sys_ps8_emio_spi1_sclk_i_GND_0 sys_ps8_emio_spi1_sclk_i_GND
       (.dout(sys_ps8_emio_spi1_sclk_i_GND_dout));
  system_sys_ps8_emio_spi1_ss_i_n_VCC_0 sys_ps8_emio_spi1_ss_i_n_VCC
       (.dout(sys_ps8_emio_spi1_ss_i_n_VCC_dout));
  system_sys_ps8_emio_spi1_ss_i_n_VCC_1 sys_ps8_emio_spi1_ss_i_n_VCC1
       (.dout(sys_ps8_emio_spi1_ss_i_n_VCC1_dout));
  system_sys_rstgen_0 sys_rstgen
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(sys_ps8_pl_resetn0),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(sys_cpu_resetn),
        .slowest_sync_clk(sys_cpu_clk));
  system_util_daq2_xcvr_0 util_daq2_xcvr
       (.cpll_ref_clk_0(rx_ref_clk_0_1),
        .cpll_ref_clk_1(rx_ref_clk_0_1),
        .cpll_ref_clk_2(rx_ref_clk_0_1),
        .cpll_ref_clk_3(rx_ref_clk_0_1),
        .qpll_ref_clk_0(rx_ref_clk_0_1),
        .rx_0_n(rx_data_0_n_1),
        .rx_0_p(rx_data_0_p_1),
        .rx_1_n(rx_data_1_n_1),
        .rx_1_p(rx_data_1_p_1),
        .rx_2_n(rx_data_2_n_1),
        .rx_2_p(rx_data_2_p_1),
        .rx_3_n(rx_data_3_n_1),
        .rx_3_p(rx_data_3_p_1),
        .rx_calign_0(axi_ad9680_jesd_phy_en_char_align),
        .rx_calign_1(axi_ad9680_jesd_phy_en_char_align),
        .rx_calign_2(axi_ad9680_jesd_phy_en_char_align),
        .rx_calign_3(axi_ad9680_jesd_phy_en_char_align),
        .rx_charisk_0(util_daq2_xcvr_rx_0_rxcharisk),
        .rx_charisk_1(util_daq2_xcvr_rx_1_rxcharisk),
        .rx_charisk_2(util_daq2_xcvr_rx_2_rxcharisk),
        .rx_charisk_3(util_daq2_xcvr_rx_3_rxcharisk),
        .rx_clk_0(util_daq2_xcvr_rx_out_clk_0),
        .rx_clk_1(util_daq2_xcvr_rx_out_clk_0),
        .rx_clk_2(util_daq2_xcvr_rx_out_clk_0),
        .rx_clk_3(util_daq2_xcvr_rx_out_clk_0),
        .rx_data_0(util_daq2_xcvr_rx_0_rxdata),
        .rx_data_1(util_daq2_xcvr_rx_1_rxdata),
        .rx_data_2(util_daq2_xcvr_rx_2_rxdata),
        .rx_data_3(util_daq2_xcvr_rx_3_rxdata),
        .rx_disperr_0(util_daq2_xcvr_rx_0_rxdisperr),
        .rx_disperr_1(util_daq2_xcvr_rx_1_rxdisperr),
        .rx_disperr_2(util_daq2_xcvr_rx_2_rxdisperr),
        .rx_disperr_3(util_daq2_xcvr_rx_3_rxdisperr),
        .rx_notintable_0(util_daq2_xcvr_rx_0_rxnotintable),
        .rx_notintable_1(util_daq2_xcvr_rx_1_rxnotintable),
        .rx_notintable_2(util_daq2_xcvr_rx_2_rxnotintable),
        .rx_notintable_3(util_daq2_xcvr_rx_3_rxnotintable),
        .rx_out_clk_0(util_daq2_xcvr_rx_out_clk_0),
        .tx_0_n(util_daq2_xcvr_tx_0_n),
        .tx_0_p(util_daq2_xcvr_tx_0_p),
        .tx_1_n(util_daq2_xcvr_tx_1_n),
        .tx_1_p(util_daq2_xcvr_tx_1_p),
        .tx_2_n(util_daq2_xcvr_tx_2_n),
        .tx_2_p(util_daq2_xcvr_tx_2_p),
        .tx_3_n(util_daq2_xcvr_tx_3_n),
        .tx_3_p(util_daq2_xcvr_tx_3_p),
        .tx_charisk_0({1'b0,1'b0,1'b0,1'b0}),
        .tx_charisk_1({1'b0,1'b0,1'b0,1'b0}),
        .tx_charisk_2({1'b0,1'b0,1'b0,1'b0}),
        .tx_charisk_3({1'b0,1'b0,1'b0,1'b0}),
        .tx_clk_0(util_daq2_xcvr_tx_out_clk_0),
        .tx_clk_1(util_daq2_xcvr_tx_out_clk_0),
        .tx_clk_2(util_daq2_xcvr_tx_out_clk_0),
        .tx_clk_3(util_daq2_xcvr_tx_out_clk_0),
        .tx_data_0({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .tx_data_1({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .tx_data_2({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .tx_data_3({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .tx_out_clk_0(util_daq2_xcvr_tx_out_clk_0),
        .up_clk(sys_cpu_clk),
        .up_cm_addr_0({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_cm_enb_0(1'b0),
        .up_cm_wdata_0({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_cm_wr_0(1'b0),
        .up_cpll_rst_0(axi_ad9680_xcvr_up_pll_rst),
        .up_cpll_rst_1(axi_ad9680_xcvr_up_pll_rst),
        .up_cpll_rst_2(axi_ad9680_xcvr_up_pll_rst),
        .up_cpll_rst_3(axi_ad9680_xcvr_up_pll_rst),
        .up_es_addr_0(axi_ad9680_xcvr_up_es_0_addr),
        .up_es_addr_1(axi_ad9680_xcvr_up_es_1_addr),
        .up_es_addr_2(axi_ad9680_xcvr_up_es_2_addr),
        .up_es_addr_3(axi_ad9680_xcvr_up_es_3_addr),
        .up_es_enb_0(axi_ad9680_xcvr_up_es_0_enb),
        .up_es_enb_1(axi_ad9680_xcvr_up_es_1_enb),
        .up_es_enb_2(axi_ad9680_xcvr_up_es_2_enb),
        .up_es_enb_3(axi_ad9680_xcvr_up_es_3_enb),
        .up_es_rdata_0(axi_ad9680_xcvr_up_es_0_rdata),
        .up_es_rdata_1(axi_ad9680_xcvr_up_es_1_rdata),
        .up_es_rdata_2(axi_ad9680_xcvr_up_es_2_rdata),
        .up_es_rdata_3(axi_ad9680_xcvr_up_es_3_rdata),
        .up_es_ready_0(axi_ad9680_xcvr_up_es_0_ready),
        .up_es_ready_1(axi_ad9680_xcvr_up_es_1_ready),
        .up_es_ready_2(axi_ad9680_xcvr_up_es_2_ready),
        .up_es_ready_3(axi_ad9680_xcvr_up_es_3_ready),
        .up_es_wdata_0(axi_ad9680_xcvr_up_es_0_wdata),
        .up_es_wdata_1(axi_ad9680_xcvr_up_es_1_wdata),
        .up_es_wdata_2(axi_ad9680_xcvr_up_es_2_wdata),
        .up_es_wdata_3(axi_ad9680_xcvr_up_es_3_wdata),
        .up_es_wr_0(axi_ad9680_xcvr_up_es_0_wr),
        .up_es_wr_1(axi_ad9680_xcvr_up_es_1_wr),
        .up_es_wr_2(axi_ad9680_xcvr_up_es_2_wr),
        .up_es_wr_3(axi_ad9680_xcvr_up_es_3_wr),
        .up_qpll_rst_0(axi_ad9680_xcvr_up_pll_rst),
        .up_rstn(sys_cpu_resetn),
        .up_rx_addr_0(axi_ad9680_xcvr_up_ch_0_addr),
        .up_rx_addr_1(axi_ad9680_xcvr_up_ch_1_addr),
        .up_rx_addr_2(axi_ad9680_xcvr_up_ch_2_addr),
        .up_rx_addr_3(axi_ad9680_xcvr_up_ch_3_addr),
        .up_rx_enb_0(axi_ad9680_xcvr_up_ch_0_enb),
        .up_rx_enb_1(axi_ad9680_xcvr_up_ch_1_enb),
        .up_rx_enb_2(axi_ad9680_xcvr_up_ch_2_enb),
        .up_rx_enb_3(axi_ad9680_xcvr_up_ch_3_enb),
        .up_rx_lpm_dfe_n_0(axi_ad9680_xcvr_up_ch_0_lpm_dfe_n),
        .up_rx_lpm_dfe_n_1(axi_ad9680_xcvr_up_ch_1_lpm_dfe_n),
        .up_rx_lpm_dfe_n_2(axi_ad9680_xcvr_up_ch_2_lpm_dfe_n),
        .up_rx_lpm_dfe_n_3(axi_ad9680_xcvr_up_ch_3_lpm_dfe_n),
        .up_rx_out_clk_sel_0(axi_ad9680_xcvr_up_ch_0_out_clk_sel),
        .up_rx_out_clk_sel_1(axi_ad9680_xcvr_up_ch_1_out_clk_sel),
        .up_rx_out_clk_sel_2(axi_ad9680_xcvr_up_ch_2_out_clk_sel),
        .up_rx_out_clk_sel_3(axi_ad9680_xcvr_up_ch_3_out_clk_sel),
        .up_rx_pll_locked_0(axi_ad9680_xcvr_up_ch_0_pll_locked),
        .up_rx_pll_locked_1(axi_ad9680_xcvr_up_ch_1_pll_locked),
        .up_rx_pll_locked_2(axi_ad9680_xcvr_up_ch_2_pll_locked),
        .up_rx_pll_locked_3(axi_ad9680_xcvr_up_ch_3_pll_locked),
        .up_rx_rate_0(axi_ad9680_xcvr_up_ch_0_rate),
        .up_rx_rate_1(axi_ad9680_xcvr_up_ch_1_rate),
        .up_rx_rate_2(axi_ad9680_xcvr_up_ch_2_rate),
        .up_rx_rate_3(axi_ad9680_xcvr_up_ch_3_rate),
        .up_rx_rdata_0(axi_ad9680_xcvr_up_ch_0_rdata),
        .up_rx_rdata_1(axi_ad9680_xcvr_up_ch_1_rdata),
        .up_rx_rdata_2(axi_ad9680_xcvr_up_ch_2_rdata),
        .up_rx_rdata_3(axi_ad9680_xcvr_up_ch_3_rdata),
        .up_rx_ready_0(axi_ad9680_xcvr_up_ch_0_ready),
        .up_rx_ready_1(axi_ad9680_xcvr_up_ch_1_ready),
        .up_rx_ready_2(axi_ad9680_xcvr_up_ch_2_ready),
        .up_rx_ready_3(axi_ad9680_xcvr_up_ch_3_ready),
        .up_rx_rst_0(axi_ad9680_xcvr_up_ch_0_rst),
        .up_rx_rst_1(axi_ad9680_xcvr_up_ch_1_rst),
        .up_rx_rst_2(axi_ad9680_xcvr_up_ch_2_rst),
        .up_rx_rst_3(axi_ad9680_xcvr_up_ch_3_rst),
        .up_rx_rst_done_0(axi_ad9680_xcvr_up_ch_0_rst_done),
        .up_rx_rst_done_1(axi_ad9680_xcvr_up_ch_1_rst_done),
        .up_rx_rst_done_2(axi_ad9680_xcvr_up_ch_2_rst_done),
        .up_rx_rst_done_3(axi_ad9680_xcvr_up_ch_3_rst_done),
        .up_rx_sys_clk_sel_0(axi_ad9680_xcvr_up_ch_0_sys_clk_sel),
        .up_rx_sys_clk_sel_1(axi_ad9680_xcvr_up_ch_1_sys_clk_sel),
        .up_rx_sys_clk_sel_2(axi_ad9680_xcvr_up_ch_2_sys_clk_sel),
        .up_rx_sys_clk_sel_3(axi_ad9680_xcvr_up_ch_3_sys_clk_sel),
        .up_rx_user_ready_0(axi_ad9680_xcvr_up_ch_0_user_ready),
        .up_rx_user_ready_1(axi_ad9680_xcvr_up_ch_1_user_ready),
        .up_rx_user_ready_2(axi_ad9680_xcvr_up_ch_2_user_ready),
        .up_rx_user_ready_3(axi_ad9680_xcvr_up_ch_3_user_ready),
        .up_rx_wdata_0(axi_ad9680_xcvr_up_ch_0_wdata),
        .up_rx_wdata_1(axi_ad9680_xcvr_up_ch_1_wdata),
        .up_rx_wdata_2(axi_ad9680_xcvr_up_ch_2_wdata),
        .up_rx_wdata_3(axi_ad9680_xcvr_up_ch_3_wdata),
        .up_rx_wr_0(axi_ad9680_xcvr_up_ch_0_wr),
        .up_rx_wr_1(axi_ad9680_xcvr_up_ch_1_wr),
        .up_rx_wr_2(axi_ad9680_xcvr_up_ch_2_wr),
        .up_rx_wr_3(axi_ad9680_xcvr_up_ch_3_wr),
        .up_tx_addr_0({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_tx_addr_1({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_tx_addr_2({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_tx_addr_3({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_tx_enb_0(1'b0),
        .up_tx_enb_1(1'b0),
        .up_tx_enb_2(1'b0),
        .up_tx_enb_3(1'b0),
        .up_tx_lpm_dfe_n_0(1'b0),
        .up_tx_lpm_dfe_n_1(1'b0),
        .up_tx_lpm_dfe_n_2(1'b0),
        .up_tx_lpm_dfe_n_3(1'b0),
        .up_tx_out_clk_sel_0({1'b0,1'b0,1'b0}),
        .up_tx_out_clk_sel_1({1'b0,1'b0,1'b0}),
        .up_tx_out_clk_sel_2({1'b0,1'b0,1'b0}),
        .up_tx_out_clk_sel_3({1'b0,1'b0,1'b0}),
        .up_tx_rate_0({1'b0,1'b0,1'b0}),
        .up_tx_rate_1({1'b0,1'b0,1'b0}),
        .up_tx_rate_2({1'b0,1'b0,1'b0}),
        .up_tx_rate_3({1'b0,1'b0,1'b0}),
        .up_tx_rst_0(1'b0),
        .up_tx_rst_1(1'b0),
        .up_tx_rst_2(1'b0),
        .up_tx_rst_3(1'b0),
        .up_tx_sys_clk_sel_0({1'b0,1'b0}),
        .up_tx_sys_clk_sel_1({1'b0,1'b0}),
        .up_tx_sys_clk_sel_2({1'b0,1'b0}),
        .up_tx_sys_clk_sel_3({1'b0,1'b0}),
        .up_tx_user_ready_0(1'b0),
        .up_tx_user_ready_1(1'b0),
        .up_tx_user_ready_2(1'b0),
        .up_tx_user_ready_3(1'b0),
        .up_tx_wdata_0({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_tx_wdata_1({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_tx_wdata_2({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_tx_wdata_3({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .up_tx_wr_0(1'b0),
        .up_tx_wr_1(1'b0),
        .up_tx_wr_2(1'b0),
        .up_tx_wr_3(1'b0));
endmodule

module system_axi_cpu_interconnect_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arprot,
    M00_AXI_arready,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awprot,
    M00_AXI_awready,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    M01_ACLK,
    M01_ARESETN,
    M01_AXI_araddr,
    M01_AXI_arprot,
    M01_AXI_arready,
    M01_AXI_arvalid,
    M01_AXI_awaddr,
    M01_AXI_awprot,
    M01_AXI_awready,
    M01_AXI_awvalid,
    M01_AXI_bready,
    M01_AXI_bresp,
    M01_AXI_bvalid,
    M01_AXI_rdata,
    M01_AXI_rready,
    M01_AXI_rresp,
    M01_AXI_rvalid,
    M01_AXI_wdata,
    M01_AXI_wready,
    M01_AXI_wstrb,
    M01_AXI_wvalid,
    M02_ACLK,
    M02_ARESETN,
    M02_AXI_araddr,
    M02_AXI_arprot,
    M02_AXI_arready,
    M02_AXI_arvalid,
    M02_AXI_awaddr,
    M02_AXI_awprot,
    M02_AXI_awready,
    M02_AXI_awvalid,
    M02_AXI_bready,
    M02_AXI_bresp,
    M02_AXI_bvalid,
    M02_AXI_rdata,
    M02_AXI_rready,
    M02_AXI_rresp,
    M02_AXI_rvalid,
    M02_AXI_wdata,
    M02_AXI_wready,
    M02_AXI_wstrb,
    M02_AXI_wvalid,
    M03_ACLK,
    M03_ARESETN,
    M03_AXI_araddr,
    M03_AXI_arprot,
    M03_AXI_arready,
    M03_AXI_arvalid,
    M03_AXI_awaddr,
    M03_AXI_awprot,
    M03_AXI_awready,
    M03_AXI_awvalid,
    M03_AXI_bready,
    M03_AXI_bresp,
    M03_AXI_bvalid,
    M03_AXI_rdata,
    M03_AXI_rready,
    M03_AXI_rresp,
    M03_AXI_rvalid,
    M03_AXI_wdata,
    M03_AXI_wready,
    M03_AXI_wstrb,
    M03_AXI_wvalid,
    M04_ACLK,
    M04_ARESETN,
    M04_AXI_araddr,
    M04_AXI_arprot,
    M04_AXI_arready,
    M04_AXI_arvalid,
    M04_AXI_awaddr,
    M04_AXI_awprot,
    M04_AXI_awready,
    M04_AXI_awvalid,
    M04_AXI_bready,
    M04_AXI_bresp,
    M04_AXI_bvalid,
    M04_AXI_rdata,
    M04_AXI_rready,
    M04_AXI_rresp,
    M04_AXI_rvalid,
    M04_AXI_wdata,
    M04_AXI_wready,
    M04_AXI_wstrb,
    M04_AXI_wvalid,
    M05_ACLK,
    M05_ARESETN,
    M05_AXI_araddr,
    M05_AXI_arprot,
    M05_AXI_arready,
    M05_AXI_arvalid,
    M05_AXI_awaddr,
    M05_AXI_awprot,
    M05_AXI_awready,
    M05_AXI_awvalid,
    M05_AXI_bready,
    M05_AXI_bresp,
    M05_AXI_bvalid,
    M05_AXI_rdata,
    M05_AXI_rready,
    M05_AXI_rresp,
    M05_AXI_rvalid,
    M05_AXI_wdata,
    M05_AXI_wready,
    M05_AXI_wstrb,
    M05_AXI_wvalid,
    M06_ACLK,
    M06_ARESETN,
    M06_AXI_araddr,
    M06_AXI_arprot,
    M06_AXI_arready,
    M06_AXI_arvalid,
    M06_AXI_awaddr,
    M06_AXI_awprot,
    M06_AXI_awready,
    M06_AXI_awvalid,
    M06_AXI_bready,
    M06_AXI_bresp,
    M06_AXI_bvalid,
    M06_AXI_rdata,
    M06_AXI_rready,
    M06_AXI_rresp,
    M06_AXI_rvalid,
    M06_AXI_wdata,
    M06_AXI_wready,
    M06_AXI_wstrb,
    M06_AXI_wvalid,
    M07_ACLK,
    M07_ARESETN,
    M07_AXI_araddr,
    M07_AXI_arprot,
    M07_AXI_arready,
    M07_AXI_arvalid,
    M07_AXI_awaddr,
    M07_AXI_awprot,
    M07_AXI_awready,
    M07_AXI_awvalid,
    M07_AXI_bready,
    M07_AXI_bresp,
    M07_AXI_bvalid,
    M07_AXI_rdata,
    M07_AXI_rready,
    M07_AXI_rresp,
    M07_AXI_rvalid,
    M07_AXI_wdata,
    M07_AXI_wready,
    M07_AXI_wstrb,
    M07_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arid,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arsize,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awid,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awvalid,
    S00_AXI_bid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rid,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output M00_AXI_araddr;
  output M00_AXI_arprot;
  input M00_AXI_arready;
  output M00_AXI_arvalid;
  output M00_AXI_awaddr;
  output M00_AXI_awprot;
  input M00_AXI_awready;
  output M00_AXI_awvalid;
  output M00_AXI_bready;
  input M00_AXI_bresp;
  input M00_AXI_bvalid;
  input M00_AXI_rdata;
  output M00_AXI_rready;
  input M00_AXI_rresp;
  input M00_AXI_rvalid;
  output M00_AXI_wdata;
  input M00_AXI_wready;
  output M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input M01_ACLK;
  input M01_ARESETN;
  output M01_AXI_araddr;
  output M01_AXI_arprot;
  input M01_AXI_arready;
  output M01_AXI_arvalid;
  output M01_AXI_awaddr;
  output M01_AXI_awprot;
  input M01_AXI_awready;
  output M01_AXI_awvalid;
  output M01_AXI_bready;
  input M01_AXI_bresp;
  input M01_AXI_bvalid;
  input M01_AXI_rdata;
  output M01_AXI_rready;
  input M01_AXI_rresp;
  input M01_AXI_rvalid;
  output M01_AXI_wdata;
  input M01_AXI_wready;
  output M01_AXI_wstrb;
  output M01_AXI_wvalid;
  input M02_ACLK;
  input M02_ARESETN;
  output M02_AXI_araddr;
  output M02_AXI_arprot;
  input M02_AXI_arready;
  output M02_AXI_arvalid;
  output M02_AXI_awaddr;
  output M02_AXI_awprot;
  input M02_AXI_awready;
  output M02_AXI_awvalid;
  output M02_AXI_bready;
  input M02_AXI_bresp;
  input M02_AXI_bvalid;
  input M02_AXI_rdata;
  output M02_AXI_rready;
  input M02_AXI_rresp;
  input M02_AXI_rvalid;
  output M02_AXI_wdata;
  input M02_AXI_wready;
  output M02_AXI_wstrb;
  output M02_AXI_wvalid;
  input M03_ACLK;
  input M03_ARESETN;
  output M03_AXI_araddr;
  output M03_AXI_arprot;
  input M03_AXI_arready;
  output M03_AXI_arvalid;
  output M03_AXI_awaddr;
  output M03_AXI_awprot;
  input M03_AXI_awready;
  output M03_AXI_awvalid;
  output M03_AXI_bready;
  input M03_AXI_bresp;
  input M03_AXI_bvalid;
  input M03_AXI_rdata;
  output M03_AXI_rready;
  input M03_AXI_rresp;
  input M03_AXI_rvalid;
  output M03_AXI_wdata;
  input M03_AXI_wready;
  output M03_AXI_wstrb;
  output M03_AXI_wvalid;
  input M04_ACLK;
  input M04_ARESETN;
  output [39:0]M04_AXI_araddr;
  output [2:0]M04_AXI_arprot;
  input [0:0]M04_AXI_arready;
  output [0:0]M04_AXI_arvalid;
  output [39:0]M04_AXI_awaddr;
  output [2:0]M04_AXI_awprot;
  input [0:0]M04_AXI_awready;
  output [0:0]M04_AXI_awvalid;
  output [0:0]M04_AXI_bready;
  input [1:0]M04_AXI_bresp;
  input [0:0]M04_AXI_bvalid;
  input [31:0]M04_AXI_rdata;
  output [0:0]M04_AXI_rready;
  input [1:0]M04_AXI_rresp;
  input [0:0]M04_AXI_rvalid;
  output [31:0]M04_AXI_wdata;
  input [0:0]M04_AXI_wready;
  output [3:0]M04_AXI_wstrb;
  output [0:0]M04_AXI_wvalid;
  input M05_ACLK;
  input M05_ARESETN;
  output [39:0]M05_AXI_araddr;
  output [2:0]M05_AXI_arprot;
  input [0:0]M05_AXI_arready;
  output [0:0]M05_AXI_arvalid;
  output [39:0]M05_AXI_awaddr;
  output [2:0]M05_AXI_awprot;
  input [0:0]M05_AXI_awready;
  output [0:0]M05_AXI_awvalid;
  output [0:0]M05_AXI_bready;
  input [1:0]M05_AXI_bresp;
  input [0:0]M05_AXI_bvalid;
  input [31:0]M05_AXI_rdata;
  output [0:0]M05_AXI_rready;
  input [1:0]M05_AXI_rresp;
  input [0:0]M05_AXI_rvalid;
  output [31:0]M05_AXI_wdata;
  input [0:0]M05_AXI_wready;
  output [3:0]M05_AXI_wstrb;
  output [0:0]M05_AXI_wvalid;
  input M06_ACLK;
  input M06_ARESETN;
  output [39:0]M06_AXI_araddr;
  output [2:0]M06_AXI_arprot;
  input [0:0]M06_AXI_arready;
  output [0:0]M06_AXI_arvalid;
  output [39:0]M06_AXI_awaddr;
  output [2:0]M06_AXI_awprot;
  input [0:0]M06_AXI_awready;
  output [0:0]M06_AXI_awvalid;
  output [0:0]M06_AXI_bready;
  input [1:0]M06_AXI_bresp;
  input [0:0]M06_AXI_bvalid;
  input [31:0]M06_AXI_rdata;
  output [0:0]M06_AXI_rready;
  input [1:0]M06_AXI_rresp;
  input [0:0]M06_AXI_rvalid;
  output [31:0]M06_AXI_wdata;
  input [0:0]M06_AXI_wready;
  output [3:0]M06_AXI_wstrb;
  output [0:0]M06_AXI_wvalid;
  input M07_ACLK;
  input M07_ARESETN;
  output [39:0]M07_AXI_araddr;
  output [2:0]M07_AXI_arprot;
  input [0:0]M07_AXI_arready;
  output [0:0]M07_AXI_arvalid;
  output [39:0]M07_AXI_awaddr;
  output [2:0]M07_AXI_awprot;
  input [0:0]M07_AXI_awready;
  output [0:0]M07_AXI_awvalid;
  output [0:0]M07_AXI_bready;
  input [1:0]M07_AXI_bresp;
  input [0:0]M07_AXI_bvalid;
  input [31:0]M07_AXI_rdata;
  output [0:0]M07_AXI_rready;
  input [1:0]M07_AXI_rresp;
  input [0:0]M07_AXI_rvalid;
  output [31:0]M07_AXI_wdata;
  input [0:0]M07_AXI_wready;
  output [3:0]M07_AXI_wstrb;
  output [0:0]M07_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [39:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [15:0]S00_AXI_arid;
  input [7:0]S00_AXI_arlen;
  input [0:0]S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [2:0]S00_AXI_arsize;
  input S00_AXI_arvalid;
  input [39:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [15:0]S00_AXI_awid;
  input [7:0]S00_AXI_awlen;
  input [0:0]S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input S00_AXI_awvalid;
  output [15:0]S00_AXI_bid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  output [15:0]S00_AXI_rid;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;

  wire axi_cpu_interconnect_ACLK_net;
  wire axi_cpu_interconnect_ARESETN_net;
  wire [39:0]axi_cpu_interconnect_to_s00_couplers_ARADDR;
  wire [1:0]axi_cpu_interconnect_to_s00_couplers_ARBURST;
  wire [3:0]axi_cpu_interconnect_to_s00_couplers_ARCACHE;
  wire [15:0]axi_cpu_interconnect_to_s00_couplers_ARID;
  wire [7:0]axi_cpu_interconnect_to_s00_couplers_ARLEN;
  wire [0:0]axi_cpu_interconnect_to_s00_couplers_ARLOCK;
  wire [2:0]axi_cpu_interconnect_to_s00_couplers_ARPROT;
  wire [3:0]axi_cpu_interconnect_to_s00_couplers_ARQOS;
  wire axi_cpu_interconnect_to_s00_couplers_ARREADY;
  wire [2:0]axi_cpu_interconnect_to_s00_couplers_ARSIZE;
  wire axi_cpu_interconnect_to_s00_couplers_ARVALID;
  wire [39:0]axi_cpu_interconnect_to_s00_couplers_AWADDR;
  wire [1:0]axi_cpu_interconnect_to_s00_couplers_AWBURST;
  wire [3:0]axi_cpu_interconnect_to_s00_couplers_AWCACHE;
  wire [15:0]axi_cpu_interconnect_to_s00_couplers_AWID;
  wire [7:0]axi_cpu_interconnect_to_s00_couplers_AWLEN;
  wire [0:0]axi_cpu_interconnect_to_s00_couplers_AWLOCK;
  wire [2:0]axi_cpu_interconnect_to_s00_couplers_AWPROT;
  wire [3:0]axi_cpu_interconnect_to_s00_couplers_AWQOS;
  wire axi_cpu_interconnect_to_s00_couplers_AWREADY;
  wire [2:0]axi_cpu_interconnect_to_s00_couplers_AWSIZE;
  wire axi_cpu_interconnect_to_s00_couplers_AWVALID;
  wire [15:0]axi_cpu_interconnect_to_s00_couplers_BID;
  wire axi_cpu_interconnect_to_s00_couplers_BREADY;
  wire [1:0]axi_cpu_interconnect_to_s00_couplers_BRESP;
  wire axi_cpu_interconnect_to_s00_couplers_BVALID;
  wire [31:0]axi_cpu_interconnect_to_s00_couplers_RDATA;
  wire [15:0]axi_cpu_interconnect_to_s00_couplers_RID;
  wire axi_cpu_interconnect_to_s00_couplers_RLAST;
  wire axi_cpu_interconnect_to_s00_couplers_RREADY;
  wire [1:0]axi_cpu_interconnect_to_s00_couplers_RRESP;
  wire axi_cpu_interconnect_to_s00_couplers_RVALID;
  wire [31:0]axi_cpu_interconnect_to_s00_couplers_WDATA;
  wire axi_cpu_interconnect_to_s00_couplers_WLAST;
  wire axi_cpu_interconnect_to_s00_couplers_WREADY;
  wire [3:0]axi_cpu_interconnect_to_s00_couplers_WSTRB;
  wire axi_cpu_interconnect_to_s00_couplers_WVALID;
  wire m00_couplers_to_axi_cpu_interconnect_ARADDR;
  wire m00_couplers_to_axi_cpu_interconnect_ARPROT;
  wire m00_couplers_to_axi_cpu_interconnect_ARREADY;
  wire m00_couplers_to_axi_cpu_interconnect_ARVALID;
  wire m00_couplers_to_axi_cpu_interconnect_AWADDR;
  wire m00_couplers_to_axi_cpu_interconnect_AWPROT;
  wire m00_couplers_to_axi_cpu_interconnect_AWREADY;
  wire m00_couplers_to_axi_cpu_interconnect_AWVALID;
  wire m00_couplers_to_axi_cpu_interconnect_BREADY;
  wire m00_couplers_to_axi_cpu_interconnect_BRESP;
  wire m00_couplers_to_axi_cpu_interconnect_BVALID;
  wire m00_couplers_to_axi_cpu_interconnect_RDATA;
  wire m00_couplers_to_axi_cpu_interconnect_RREADY;
  wire m00_couplers_to_axi_cpu_interconnect_RRESP;
  wire m00_couplers_to_axi_cpu_interconnect_RVALID;
  wire m00_couplers_to_axi_cpu_interconnect_WDATA;
  wire m00_couplers_to_axi_cpu_interconnect_WREADY;
  wire m00_couplers_to_axi_cpu_interconnect_WSTRB;
  wire m00_couplers_to_axi_cpu_interconnect_WVALID;
  wire m01_couplers_to_axi_cpu_interconnect_ARADDR;
  wire m01_couplers_to_axi_cpu_interconnect_ARPROT;
  wire m01_couplers_to_axi_cpu_interconnect_ARREADY;
  wire m01_couplers_to_axi_cpu_interconnect_ARVALID;
  wire m01_couplers_to_axi_cpu_interconnect_AWADDR;
  wire m01_couplers_to_axi_cpu_interconnect_AWPROT;
  wire m01_couplers_to_axi_cpu_interconnect_AWREADY;
  wire m01_couplers_to_axi_cpu_interconnect_AWVALID;
  wire m01_couplers_to_axi_cpu_interconnect_BREADY;
  wire m01_couplers_to_axi_cpu_interconnect_BRESP;
  wire m01_couplers_to_axi_cpu_interconnect_BVALID;
  wire m01_couplers_to_axi_cpu_interconnect_RDATA;
  wire m01_couplers_to_axi_cpu_interconnect_RREADY;
  wire m01_couplers_to_axi_cpu_interconnect_RRESP;
  wire m01_couplers_to_axi_cpu_interconnect_RVALID;
  wire m01_couplers_to_axi_cpu_interconnect_WDATA;
  wire m01_couplers_to_axi_cpu_interconnect_WREADY;
  wire m01_couplers_to_axi_cpu_interconnect_WSTRB;
  wire m01_couplers_to_axi_cpu_interconnect_WVALID;
  wire m02_couplers_to_axi_cpu_interconnect_ARADDR;
  wire m02_couplers_to_axi_cpu_interconnect_ARPROT;
  wire m02_couplers_to_axi_cpu_interconnect_ARREADY;
  wire m02_couplers_to_axi_cpu_interconnect_ARVALID;
  wire m02_couplers_to_axi_cpu_interconnect_AWADDR;
  wire m02_couplers_to_axi_cpu_interconnect_AWPROT;
  wire m02_couplers_to_axi_cpu_interconnect_AWREADY;
  wire m02_couplers_to_axi_cpu_interconnect_AWVALID;
  wire m02_couplers_to_axi_cpu_interconnect_BREADY;
  wire m02_couplers_to_axi_cpu_interconnect_BRESP;
  wire m02_couplers_to_axi_cpu_interconnect_BVALID;
  wire m02_couplers_to_axi_cpu_interconnect_RDATA;
  wire m02_couplers_to_axi_cpu_interconnect_RREADY;
  wire m02_couplers_to_axi_cpu_interconnect_RRESP;
  wire m02_couplers_to_axi_cpu_interconnect_RVALID;
  wire m02_couplers_to_axi_cpu_interconnect_WDATA;
  wire m02_couplers_to_axi_cpu_interconnect_WREADY;
  wire m02_couplers_to_axi_cpu_interconnect_WSTRB;
  wire m02_couplers_to_axi_cpu_interconnect_WVALID;
  wire m03_couplers_to_axi_cpu_interconnect_ARADDR;
  wire m03_couplers_to_axi_cpu_interconnect_ARPROT;
  wire m03_couplers_to_axi_cpu_interconnect_ARREADY;
  wire m03_couplers_to_axi_cpu_interconnect_ARVALID;
  wire m03_couplers_to_axi_cpu_interconnect_AWADDR;
  wire m03_couplers_to_axi_cpu_interconnect_AWPROT;
  wire m03_couplers_to_axi_cpu_interconnect_AWREADY;
  wire m03_couplers_to_axi_cpu_interconnect_AWVALID;
  wire m03_couplers_to_axi_cpu_interconnect_BREADY;
  wire m03_couplers_to_axi_cpu_interconnect_BRESP;
  wire m03_couplers_to_axi_cpu_interconnect_BVALID;
  wire m03_couplers_to_axi_cpu_interconnect_RDATA;
  wire m03_couplers_to_axi_cpu_interconnect_RREADY;
  wire m03_couplers_to_axi_cpu_interconnect_RRESP;
  wire m03_couplers_to_axi_cpu_interconnect_RVALID;
  wire m03_couplers_to_axi_cpu_interconnect_WDATA;
  wire m03_couplers_to_axi_cpu_interconnect_WREADY;
  wire m03_couplers_to_axi_cpu_interconnect_WSTRB;
  wire m03_couplers_to_axi_cpu_interconnect_WVALID;
  wire [39:0]m04_couplers_to_axi_cpu_interconnect_ARADDR;
  wire [2:0]m04_couplers_to_axi_cpu_interconnect_ARPROT;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_ARREADY;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_ARVALID;
  wire [39:0]m04_couplers_to_axi_cpu_interconnect_AWADDR;
  wire [2:0]m04_couplers_to_axi_cpu_interconnect_AWPROT;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_AWREADY;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_AWVALID;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_BREADY;
  wire [1:0]m04_couplers_to_axi_cpu_interconnect_BRESP;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_BVALID;
  wire [31:0]m04_couplers_to_axi_cpu_interconnect_RDATA;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_RREADY;
  wire [1:0]m04_couplers_to_axi_cpu_interconnect_RRESP;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_RVALID;
  wire [31:0]m04_couplers_to_axi_cpu_interconnect_WDATA;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_WREADY;
  wire [3:0]m04_couplers_to_axi_cpu_interconnect_WSTRB;
  wire [0:0]m04_couplers_to_axi_cpu_interconnect_WVALID;
  wire [39:0]m05_couplers_to_axi_cpu_interconnect_ARADDR;
  wire [2:0]m05_couplers_to_axi_cpu_interconnect_ARPROT;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_ARREADY;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_ARVALID;
  wire [39:0]m05_couplers_to_axi_cpu_interconnect_AWADDR;
  wire [2:0]m05_couplers_to_axi_cpu_interconnect_AWPROT;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_AWREADY;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_AWVALID;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_BREADY;
  wire [1:0]m05_couplers_to_axi_cpu_interconnect_BRESP;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_BVALID;
  wire [31:0]m05_couplers_to_axi_cpu_interconnect_RDATA;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_RREADY;
  wire [1:0]m05_couplers_to_axi_cpu_interconnect_RRESP;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_RVALID;
  wire [31:0]m05_couplers_to_axi_cpu_interconnect_WDATA;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_WREADY;
  wire [3:0]m05_couplers_to_axi_cpu_interconnect_WSTRB;
  wire [0:0]m05_couplers_to_axi_cpu_interconnect_WVALID;
  wire [39:0]m06_couplers_to_axi_cpu_interconnect_ARADDR;
  wire [2:0]m06_couplers_to_axi_cpu_interconnect_ARPROT;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_ARREADY;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_ARVALID;
  wire [39:0]m06_couplers_to_axi_cpu_interconnect_AWADDR;
  wire [2:0]m06_couplers_to_axi_cpu_interconnect_AWPROT;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_AWREADY;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_AWVALID;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_BREADY;
  wire [1:0]m06_couplers_to_axi_cpu_interconnect_BRESP;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_BVALID;
  wire [31:0]m06_couplers_to_axi_cpu_interconnect_RDATA;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_RREADY;
  wire [1:0]m06_couplers_to_axi_cpu_interconnect_RRESP;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_RVALID;
  wire [31:0]m06_couplers_to_axi_cpu_interconnect_WDATA;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_WREADY;
  wire [3:0]m06_couplers_to_axi_cpu_interconnect_WSTRB;
  wire [0:0]m06_couplers_to_axi_cpu_interconnect_WVALID;
  wire [39:0]m07_couplers_to_axi_cpu_interconnect_ARADDR;
  wire [2:0]m07_couplers_to_axi_cpu_interconnect_ARPROT;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_ARREADY;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_ARVALID;
  wire [39:0]m07_couplers_to_axi_cpu_interconnect_AWADDR;
  wire [2:0]m07_couplers_to_axi_cpu_interconnect_AWPROT;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_AWREADY;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_AWVALID;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_BREADY;
  wire [1:0]m07_couplers_to_axi_cpu_interconnect_BRESP;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_BVALID;
  wire [31:0]m07_couplers_to_axi_cpu_interconnect_RDATA;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_RREADY;
  wire [1:0]m07_couplers_to_axi_cpu_interconnect_RRESP;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_RVALID;
  wire [31:0]m07_couplers_to_axi_cpu_interconnect_WDATA;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_WREADY;
  wire [3:0]m07_couplers_to_axi_cpu_interconnect_WSTRB;
  wire [0:0]m07_couplers_to_axi_cpu_interconnect_WVALID;
  wire [39:0]s00_couplers_to_xbar_ARADDR;
  wire [2:0]s00_couplers_to_xbar_ARPROT;
  wire [0:0]s00_couplers_to_xbar_ARREADY;
  wire s00_couplers_to_xbar_ARVALID;
  wire [39:0]s00_couplers_to_xbar_AWADDR;
  wire [2:0]s00_couplers_to_xbar_AWPROT;
  wire [0:0]s00_couplers_to_xbar_AWREADY;
  wire s00_couplers_to_xbar_AWVALID;
  wire s00_couplers_to_xbar_BREADY;
  wire [1:0]s00_couplers_to_xbar_BRESP;
  wire [0:0]s00_couplers_to_xbar_BVALID;
  wire [31:0]s00_couplers_to_xbar_RDATA;
  wire s00_couplers_to_xbar_RREADY;
  wire [1:0]s00_couplers_to_xbar_RRESP;
  wire [0:0]s00_couplers_to_xbar_RVALID;
  wire [31:0]s00_couplers_to_xbar_WDATA;
  wire [0:0]s00_couplers_to_xbar_WREADY;
  wire [3:0]s00_couplers_to_xbar_WSTRB;
  wire s00_couplers_to_xbar_WVALID;
  wire [39:0]xbar_to_m00_couplers_ARADDR;
  wire [2:0]xbar_to_m00_couplers_ARPROT;
  wire xbar_to_m00_couplers_ARREADY;
  wire [0:0]xbar_to_m00_couplers_ARVALID;
  wire [39:0]xbar_to_m00_couplers_AWADDR;
  wire [2:0]xbar_to_m00_couplers_AWPROT;
  wire xbar_to_m00_couplers_AWREADY;
  wire [0:0]xbar_to_m00_couplers_AWVALID;
  wire [0:0]xbar_to_m00_couplers_BREADY;
  wire xbar_to_m00_couplers_BRESP;
  wire xbar_to_m00_couplers_BVALID;
  wire xbar_to_m00_couplers_RDATA;
  wire [0:0]xbar_to_m00_couplers_RREADY;
  wire xbar_to_m00_couplers_RRESP;
  wire xbar_to_m00_couplers_RVALID;
  wire [31:0]xbar_to_m00_couplers_WDATA;
  wire xbar_to_m00_couplers_WREADY;
  wire [3:0]xbar_to_m00_couplers_WSTRB;
  wire [0:0]xbar_to_m00_couplers_WVALID;
  wire [79:40]xbar_to_m01_couplers_ARADDR;
  wire [5:3]xbar_to_m01_couplers_ARPROT;
  wire xbar_to_m01_couplers_ARREADY;
  wire [1:1]xbar_to_m01_couplers_ARVALID;
  wire [79:40]xbar_to_m01_couplers_AWADDR;
  wire [5:3]xbar_to_m01_couplers_AWPROT;
  wire xbar_to_m01_couplers_AWREADY;
  wire [1:1]xbar_to_m01_couplers_AWVALID;
  wire [1:1]xbar_to_m01_couplers_BREADY;
  wire xbar_to_m01_couplers_BRESP;
  wire xbar_to_m01_couplers_BVALID;
  wire xbar_to_m01_couplers_RDATA;
  wire [1:1]xbar_to_m01_couplers_RREADY;
  wire xbar_to_m01_couplers_RRESP;
  wire xbar_to_m01_couplers_RVALID;
  wire [63:32]xbar_to_m01_couplers_WDATA;
  wire xbar_to_m01_couplers_WREADY;
  wire [7:4]xbar_to_m01_couplers_WSTRB;
  wire [1:1]xbar_to_m01_couplers_WVALID;
  wire [119:80]xbar_to_m02_couplers_ARADDR;
  wire [8:6]xbar_to_m02_couplers_ARPROT;
  wire xbar_to_m02_couplers_ARREADY;
  wire [2:2]xbar_to_m02_couplers_ARVALID;
  wire [119:80]xbar_to_m02_couplers_AWADDR;
  wire [8:6]xbar_to_m02_couplers_AWPROT;
  wire xbar_to_m02_couplers_AWREADY;
  wire [2:2]xbar_to_m02_couplers_AWVALID;
  wire [2:2]xbar_to_m02_couplers_BREADY;
  wire xbar_to_m02_couplers_BRESP;
  wire xbar_to_m02_couplers_BVALID;
  wire xbar_to_m02_couplers_RDATA;
  wire [2:2]xbar_to_m02_couplers_RREADY;
  wire xbar_to_m02_couplers_RRESP;
  wire xbar_to_m02_couplers_RVALID;
  wire [95:64]xbar_to_m02_couplers_WDATA;
  wire xbar_to_m02_couplers_WREADY;
  wire [11:8]xbar_to_m02_couplers_WSTRB;
  wire [2:2]xbar_to_m02_couplers_WVALID;
  wire [159:120]xbar_to_m03_couplers_ARADDR;
  wire [11:9]xbar_to_m03_couplers_ARPROT;
  wire xbar_to_m03_couplers_ARREADY;
  wire [3:3]xbar_to_m03_couplers_ARVALID;
  wire [159:120]xbar_to_m03_couplers_AWADDR;
  wire [11:9]xbar_to_m03_couplers_AWPROT;
  wire xbar_to_m03_couplers_AWREADY;
  wire [3:3]xbar_to_m03_couplers_AWVALID;
  wire [3:3]xbar_to_m03_couplers_BREADY;
  wire xbar_to_m03_couplers_BRESP;
  wire xbar_to_m03_couplers_BVALID;
  wire xbar_to_m03_couplers_RDATA;
  wire [3:3]xbar_to_m03_couplers_RREADY;
  wire xbar_to_m03_couplers_RRESP;
  wire xbar_to_m03_couplers_RVALID;
  wire [127:96]xbar_to_m03_couplers_WDATA;
  wire xbar_to_m03_couplers_WREADY;
  wire [15:12]xbar_to_m03_couplers_WSTRB;
  wire [3:3]xbar_to_m03_couplers_WVALID;
  wire [199:160]xbar_to_m04_couplers_ARADDR;
  wire [14:12]xbar_to_m04_couplers_ARPROT;
  wire [0:0]xbar_to_m04_couplers_ARREADY;
  wire [4:4]xbar_to_m04_couplers_ARVALID;
  wire [199:160]xbar_to_m04_couplers_AWADDR;
  wire [14:12]xbar_to_m04_couplers_AWPROT;
  wire [0:0]xbar_to_m04_couplers_AWREADY;
  wire [4:4]xbar_to_m04_couplers_AWVALID;
  wire [4:4]xbar_to_m04_couplers_BREADY;
  wire [1:0]xbar_to_m04_couplers_BRESP;
  wire [0:0]xbar_to_m04_couplers_BVALID;
  wire [31:0]xbar_to_m04_couplers_RDATA;
  wire [4:4]xbar_to_m04_couplers_RREADY;
  wire [1:0]xbar_to_m04_couplers_RRESP;
  wire [0:0]xbar_to_m04_couplers_RVALID;
  wire [159:128]xbar_to_m04_couplers_WDATA;
  wire [0:0]xbar_to_m04_couplers_WREADY;
  wire [19:16]xbar_to_m04_couplers_WSTRB;
  wire [4:4]xbar_to_m04_couplers_WVALID;
  wire [239:200]xbar_to_m05_couplers_ARADDR;
  wire [17:15]xbar_to_m05_couplers_ARPROT;
  wire [0:0]xbar_to_m05_couplers_ARREADY;
  wire [5:5]xbar_to_m05_couplers_ARVALID;
  wire [239:200]xbar_to_m05_couplers_AWADDR;
  wire [17:15]xbar_to_m05_couplers_AWPROT;
  wire [0:0]xbar_to_m05_couplers_AWREADY;
  wire [5:5]xbar_to_m05_couplers_AWVALID;
  wire [5:5]xbar_to_m05_couplers_BREADY;
  wire [1:0]xbar_to_m05_couplers_BRESP;
  wire [0:0]xbar_to_m05_couplers_BVALID;
  wire [31:0]xbar_to_m05_couplers_RDATA;
  wire [5:5]xbar_to_m05_couplers_RREADY;
  wire [1:0]xbar_to_m05_couplers_RRESP;
  wire [0:0]xbar_to_m05_couplers_RVALID;
  wire [191:160]xbar_to_m05_couplers_WDATA;
  wire [0:0]xbar_to_m05_couplers_WREADY;
  wire [23:20]xbar_to_m05_couplers_WSTRB;
  wire [5:5]xbar_to_m05_couplers_WVALID;
  wire [279:240]xbar_to_m06_couplers_ARADDR;
  wire [20:18]xbar_to_m06_couplers_ARPROT;
  wire [0:0]xbar_to_m06_couplers_ARREADY;
  wire [6:6]xbar_to_m06_couplers_ARVALID;
  wire [279:240]xbar_to_m06_couplers_AWADDR;
  wire [20:18]xbar_to_m06_couplers_AWPROT;
  wire [0:0]xbar_to_m06_couplers_AWREADY;
  wire [6:6]xbar_to_m06_couplers_AWVALID;
  wire [6:6]xbar_to_m06_couplers_BREADY;
  wire [1:0]xbar_to_m06_couplers_BRESP;
  wire [0:0]xbar_to_m06_couplers_BVALID;
  wire [31:0]xbar_to_m06_couplers_RDATA;
  wire [6:6]xbar_to_m06_couplers_RREADY;
  wire [1:0]xbar_to_m06_couplers_RRESP;
  wire [0:0]xbar_to_m06_couplers_RVALID;
  wire [223:192]xbar_to_m06_couplers_WDATA;
  wire [0:0]xbar_to_m06_couplers_WREADY;
  wire [27:24]xbar_to_m06_couplers_WSTRB;
  wire [6:6]xbar_to_m06_couplers_WVALID;
  wire [319:280]xbar_to_m07_couplers_ARADDR;
  wire [23:21]xbar_to_m07_couplers_ARPROT;
  wire [0:0]xbar_to_m07_couplers_ARREADY;
  wire [7:7]xbar_to_m07_couplers_ARVALID;
  wire [319:280]xbar_to_m07_couplers_AWADDR;
  wire [23:21]xbar_to_m07_couplers_AWPROT;
  wire [0:0]xbar_to_m07_couplers_AWREADY;
  wire [7:7]xbar_to_m07_couplers_AWVALID;
  wire [7:7]xbar_to_m07_couplers_BREADY;
  wire [1:0]xbar_to_m07_couplers_BRESP;
  wire [0:0]xbar_to_m07_couplers_BVALID;
  wire [31:0]xbar_to_m07_couplers_RDATA;
  wire [7:7]xbar_to_m07_couplers_RREADY;
  wire [1:0]xbar_to_m07_couplers_RRESP;
  wire [0:0]xbar_to_m07_couplers_RVALID;
  wire [255:224]xbar_to_m07_couplers_WDATA;
  wire [0:0]xbar_to_m07_couplers_WREADY;
  wire [31:28]xbar_to_m07_couplers_WSTRB;
  wire [7:7]xbar_to_m07_couplers_WVALID;

  assign M00_AXI_araddr = m00_couplers_to_axi_cpu_interconnect_ARADDR;
  assign M00_AXI_arprot = m00_couplers_to_axi_cpu_interconnect_ARPROT;
  assign M00_AXI_arvalid = m00_couplers_to_axi_cpu_interconnect_ARVALID;
  assign M00_AXI_awaddr = m00_couplers_to_axi_cpu_interconnect_AWADDR;
  assign M00_AXI_awprot = m00_couplers_to_axi_cpu_interconnect_AWPROT;
  assign M00_AXI_awvalid = m00_couplers_to_axi_cpu_interconnect_AWVALID;
  assign M00_AXI_bready = m00_couplers_to_axi_cpu_interconnect_BREADY;
  assign M00_AXI_rready = m00_couplers_to_axi_cpu_interconnect_RREADY;
  assign M00_AXI_wdata = m00_couplers_to_axi_cpu_interconnect_WDATA;
  assign M00_AXI_wstrb = m00_couplers_to_axi_cpu_interconnect_WSTRB;
  assign M00_AXI_wvalid = m00_couplers_to_axi_cpu_interconnect_WVALID;
  assign M01_AXI_araddr = m01_couplers_to_axi_cpu_interconnect_ARADDR;
  assign M01_AXI_arprot = m01_couplers_to_axi_cpu_interconnect_ARPROT;
  assign M01_AXI_arvalid = m01_couplers_to_axi_cpu_interconnect_ARVALID;
  assign M01_AXI_awaddr = m01_couplers_to_axi_cpu_interconnect_AWADDR;
  assign M01_AXI_awprot = m01_couplers_to_axi_cpu_interconnect_AWPROT;
  assign M01_AXI_awvalid = m01_couplers_to_axi_cpu_interconnect_AWVALID;
  assign M01_AXI_bready = m01_couplers_to_axi_cpu_interconnect_BREADY;
  assign M01_AXI_rready = m01_couplers_to_axi_cpu_interconnect_RREADY;
  assign M01_AXI_wdata = m01_couplers_to_axi_cpu_interconnect_WDATA;
  assign M01_AXI_wstrb = m01_couplers_to_axi_cpu_interconnect_WSTRB;
  assign M01_AXI_wvalid = m01_couplers_to_axi_cpu_interconnect_WVALID;
  assign M02_AXI_araddr = m02_couplers_to_axi_cpu_interconnect_ARADDR;
  assign M02_AXI_arprot = m02_couplers_to_axi_cpu_interconnect_ARPROT;
  assign M02_AXI_arvalid = m02_couplers_to_axi_cpu_interconnect_ARVALID;
  assign M02_AXI_awaddr = m02_couplers_to_axi_cpu_interconnect_AWADDR;
  assign M02_AXI_awprot = m02_couplers_to_axi_cpu_interconnect_AWPROT;
  assign M02_AXI_awvalid = m02_couplers_to_axi_cpu_interconnect_AWVALID;
  assign M02_AXI_bready = m02_couplers_to_axi_cpu_interconnect_BREADY;
  assign M02_AXI_rready = m02_couplers_to_axi_cpu_interconnect_RREADY;
  assign M02_AXI_wdata = m02_couplers_to_axi_cpu_interconnect_WDATA;
  assign M02_AXI_wstrb = m02_couplers_to_axi_cpu_interconnect_WSTRB;
  assign M02_AXI_wvalid = m02_couplers_to_axi_cpu_interconnect_WVALID;
  assign M03_AXI_araddr = m03_couplers_to_axi_cpu_interconnect_ARADDR;
  assign M03_AXI_arprot = m03_couplers_to_axi_cpu_interconnect_ARPROT;
  assign M03_AXI_arvalid = m03_couplers_to_axi_cpu_interconnect_ARVALID;
  assign M03_AXI_awaddr = m03_couplers_to_axi_cpu_interconnect_AWADDR;
  assign M03_AXI_awprot = m03_couplers_to_axi_cpu_interconnect_AWPROT;
  assign M03_AXI_awvalid = m03_couplers_to_axi_cpu_interconnect_AWVALID;
  assign M03_AXI_bready = m03_couplers_to_axi_cpu_interconnect_BREADY;
  assign M03_AXI_rready = m03_couplers_to_axi_cpu_interconnect_RREADY;
  assign M03_AXI_wdata = m03_couplers_to_axi_cpu_interconnect_WDATA;
  assign M03_AXI_wstrb = m03_couplers_to_axi_cpu_interconnect_WSTRB;
  assign M03_AXI_wvalid = m03_couplers_to_axi_cpu_interconnect_WVALID;
  assign M04_AXI_araddr[39:0] = m04_couplers_to_axi_cpu_interconnect_ARADDR;
  assign M04_AXI_arprot[2:0] = m04_couplers_to_axi_cpu_interconnect_ARPROT;
  assign M04_AXI_arvalid[0] = m04_couplers_to_axi_cpu_interconnect_ARVALID;
  assign M04_AXI_awaddr[39:0] = m04_couplers_to_axi_cpu_interconnect_AWADDR;
  assign M04_AXI_awprot[2:0] = m04_couplers_to_axi_cpu_interconnect_AWPROT;
  assign M04_AXI_awvalid[0] = m04_couplers_to_axi_cpu_interconnect_AWVALID;
  assign M04_AXI_bready[0] = m04_couplers_to_axi_cpu_interconnect_BREADY;
  assign M04_AXI_rready[0] = m04_couplers_to_axi_cpu_interconnect_RREADY;
  assign M04_AXI_wdata[31:0] = m04_couplers_to_axi_cpu_interconnect_WDATA;
  assign M04_AXI_wstrb[3:0] = m04_couplers_to_axi_cpu_interconnect_WSTRB;
  assign M04_AXI_wvalid[0] = m04_couplers_to_axi_cpu_interconnect_WVALID;
  assign M05_AXI_araddr[39:0] = m05_couplers_to_axi_cpu_interconnect_ARADDR;
  assign M05_AXI_arprot[2:0] = m05_couplers_to_axi_cpu_interconnect_ARPROT;
  assign M05_AXI_arvalid[0] = m05_couplers_to_axi_cpu_interconnect_ARVALID;
  assign M05_AXI_awaddr[39:0] = m05_couplers_to_axi_cpu_interconnect_AWADDR;
  assign M05_AXI_awprot[2:0] = m05_couplers_to_axi_cpu_interconnect_AWPROT;
  assign M05_AXI_awvalid[0] = m05_couplers_to_axi_cpu_interconnect_AWVALID;
  assign M05_AXI_bready[0] = m05_couplers_to_axi_cpu_interconnect_BREADY;
  assign M05_AXI_rready[0] = m05_couplers_to_axi_cpu_interconnect_RREADY;
  assign M05_AXI_wdata[31:0] = m05_couplers_to_axi_cpu_interconnect_WDATA;
  assign M05_AXI_wstrb[3:0] = m05_couplers_to_axi_cpu_interconnect_WSTRB;
  assign M05_AXI_wvalid[0] = m05_couplers_to_axi_cpu_interconnect_WVALID;
  assign M06_AXI_araddr[39:0] = m06_couplers_to_axi_cpu_interconnect_ARADDR;
  assign M06_AXI_arprot[2:0] = m06_couplers_to_axi_cpu_interconnect_ARPROT;
  assign M06_AXI_arvalid[0] = m06_couplers_to_axi_cpu_interconnect_ARVALID;
  assign M06_AXI_awaddr[39:0] = m06_couplers_to_axi_cpu_interconnect_AWADDR;
  assign M06_AXI_awprot[2:0] = m06_couplers_to_axi_cpu_interconnect_AWPROT;
  assign M06_AXI_awvalid[0] = m06_couplers_to_axi_cpu_interconnect_AWVALID;
  assign M06_AXI_bready[0] = m06_couplers_to_axi_cpu_interconnect_BREADY;
  assign M06_AXI_rready[0] = m06_couplers_to_axi_cpu_interconnect_RREADY;
  assign M06_AXI_wdata[31:0] = m06_couplers_to_axi_cpu_interconnect_WDATA;
  assign M06_AXI_wstrb[3:0] = m06_couplers_to_axi_cpu_interconnect_WSTRB;
  assign M06_AXI_wvalid[0] = m06_couplers_to_axi_cpu_interconnect_WVALID;
  assign M07_AXI_araddr[39:0] = m07_couplers_to_axi_cpu_interconnect_ARADDR;
  assign M07_AXI_arprot[2:0] = m07_couplers_to_axi_cpu_interconnect_ARPROT;
  assign M07_AXI_arvalid[0] = m07_couplers_to_axi_cpu_interconnect_ARVALID;
  assign M07_AXI_awaddr[39:0] = m07_couplers_to_axi_cpu_interconnect_AWADDR;
  assign M07_AXI_awprot[2:0] = m07_couplers_to_axi_cpu_interconnect_AWPROT;
  assign M07_AXI_awvalid[0] = m07_couplers_to_axi_cpu_interconnect_AWVALID;
  assign M07_AXI_bready[0] = m07_couplers_to_axi_cpu_interconnect_BREADY;
  assign M07_AXI_rready[0] = m07_couplers_to_axi_cpu_interconnect_RREADY;
  assign M07_AXI_wdata[31:0] = m07_couplers_to_axi_cpu_interconnect_WDATA;
  assign M07_AXI_wstrb[3:0] = m07_couplers_to_axi_cpu_interconnect_WSTRB;
  assign M07_AXI_wvalid[0] = m07_couplers_to_axi_cpu_interconnect_WVALID;
  assign S00_AXI_arready = axi_cpu_interconnect_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = axi_cpu_interconnect_to_s00_couplers_AWREADY;
  assign S00_AXI_bid[15:0] = axi_cpu_interconnect_to_s00_couplers_BID;
  assign S00_AXI_bresp[1:0] = axi_cpu_interconnect_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = axi_cpu_interconnect_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[31:0] = axi_cpu_interconnect_to_s00_couplers_RDATA;
  assign S00_AXI_rid[15:0] = axi_cpu_interconnect_to_s00_couplers_RID;
  assign S00_AXI_rlast = axi_cpu_interconnect_to_s00_couplers_RLAST;
  assign S00_AXI_rresp[1:0] = axi_cpu_interconnect_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = axi_cpu_interconnect_to_s00_couplers_RVALID;
  assign S00_AXI_wready = axi_cpu_interconnect_to_s00_couplers_WREADY;
  assign axi_cpu_interconnect_ACLK_net = ACLK;
  assign axi_cpu_interconnect_ARESETN_net = ARESETN;
  assign axi_cpu_interconnect_to_s00_couplers_ARADDR = S00_AXI_araddr[39:0];
  assign axi_cpu_interconnect_to_s00_couplers_ARBURST = S00_AXI_arburst[1:0];
  assign axi_cpu_interconnect_to_s00_couplers_ARCACHE = S00_AXI_arcache[3:0];
  assign axi_cpu_interconnect_to_s00_couplers_ARID = S00_AXI_arid[15:0];
  assign axi_cpu_interconnect_to_s00_couplers_ARLEN = S00_AXI_arlen[7:0];
  assign axi_cpu_interconnect_to_s00_couplers_ARLOCK = S00_AXI_arlock[0];
  assign axi_cpu_interconnect_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign axi_cpu_interconnect_to_s00_couplers_ARQOS = S00_AXI_arqos[3:0];
  assign axi_cpu_interconnect_to_s00_couplers_ARSIZE = S00_AXI_arsize[2:0];
  assign axi_cpu_interconnect_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign axi_cpu_interconnect_to_s00_couplers_AWADDR = S00_AXI_awaddr[39:0];
  assign axi_cpu_interconnect_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign axi_cpu_interconnect_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign axi_cpu_interconnect_to_s00_couplers_AWID = S00_AXI_awid[15:0];
  assign axi_cpu_interconnect_to_s00_couplers_AWLEN = S00_AXI_awlen[7:0];
  assign axi_cpu_interconnect_to_s00_couplers_AWLOCK = S00_AXI_awlock[0];
  assign axi_cpu_interconnect_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign axi_cpu_interconnect_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign axi_cpu_interconnect_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign axi_cpu_interconnect_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign axi_cpu_interconnect_to_s00_couplers_BREADY = S00_AXI_bready;
  assign axi_cpu_interconnect_to_s00_couplers_RREADY = S00_AXI_rready;
  assign axi_cpu_interconnect_to_s00_couplers_WDATA = S00_AXI_wdata[31:0];
  assign axi_cpu_interconnect_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign axi_cpu_interconnect_to_s00_couplers_WSTRB = S00_AXI_wstrb[3:0];
  assign axi_cpu_interconnect_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign m00_couplers_to_axi_cpu_interconnect_ARREADY = M00_AXI_arready;
  assign m00_couplers_to_axi_cpu_interconnect_AWREADY = M00_AXI_awready;
  assign m00_couplers_to_axi_cpu_interconnect_BRESP = M00_AXI_bresp;
  assign m00_couplers_to_axi_cpu_interconnect_BVALID = M00_AXI_bvalid;
  assign m00_couplers_to_axi_cpu_interconnect_RDATA = M00_AXI_rdata;
  assign m00_couplers_to_axi_cpu_interconnect_RRESP = M00_AXI_rresp;
  assign m00_couplers_to_axi_cpu_interconnect_RVALID = M00_AXI_rvalid;
  assign m00_couplers_to_axi_cpu_interconnect_WREADY = M00_AXI_wready;
  assign m01_couplers_to_axi_cpu_interconnect_ARREADY = M01_AXI_arready;
  assign m01_couplers_to_axi_cpu_interconnect_AWREADY = M01_AXI_awready;
  assign m01_couplers_to_axi_cpu_interconnect_BRESP = M01_AXI_bresp;
  assign m01_couplers_to_axi_cpu_interconnect_BVALID = M01_AXI_bvalid;
  assign m01_couplers_to_axi_cpu_interconnect_RDATA = M01_AXI_rdata;
  assign m01_couplers_to_axi_cpu_interconnect_RRESP = M01_AXI_rresp;
  assign m01_couplers_to_axi_cpu_interconnect_RVALID = M01_AXI_rvalid;
  assign m01_couplers_to_axi_cpu_interconnect_WREADY = M01_AXI_wready;
  assign m02_couplers_to_axi_cpu_interconnect_ARREADY = M02_AXI_arready;
  assign m02_couplers_to_axi_cpu_interconnect_AWREADY = M02_AXI_awready;
  assign m02_couplers_to_axi_cpu_interconnect_BRESP = M02_AXI_bresp;
  assign m02_couplers_to_axi_cpu_interconnect_BVALID = M02_AXI_bvalid;
  assign m02_couplers_to_axi_cpu_interconnect_RDATA = M02_AXI_rdata;
  assign m02_couplers_to_axi_cpu_interconnect_RRESP = M02_AXI_rresp;
  assign m02_couplers_to_axi_cpu_interconnect_RVALID = M02_AXI_rvalid;
  assign m02_couplers_to_axi_cpu_interconnect_WREADY = M02_AXI_wready;
  assign m03_couplers_to_axi_cpu_interconnect_ARREADY = M03_AXI_arready;
  assign m03_couplers_to_axi_cpu_interconnect_AWREADY = M03_AXI_awready;
  assign m03_couplers_to_axi_cpu_interconnect_BRESP = M03_AXI_bresp;
  assign m03_couplers_to_axi_cpu_interconnect_BVALID = M03_AXI_bvalid;
  assign m03_couplers_to_axi_cpu_interconnect_RDATA = M03_AXI_rdata;
  assign m03_couplers_to_axi_cpu_interconnect_RRESP = M03_AXI_rresp;
  assign m03_couplers_to_axi_cpu_interconnect_RVALID = M03_AXI_rvalid;
  assign m03_couplers_to_axi_cpu_interconnect_WREADY = M03_AXI_wready;
  assign m04_couplers_to_axi_cpu_interconnect_ARREADY = M04_AXI_arready[0];
  assign m04_couplers_to_axi_cpu_interconnect_AWREADY = M04_AXI_awready[0];
  assign m04_couplers_to_axi_cpu_interconnect_BRESP = M04_AXI_bresp[1:0];
  assign m04_couplers_to_axi_cpu_interconnect_BVALID = M04_AXI_bvalid[0];
  assign m04_couplers_to_axi_cpu_interconnect_RDATA = M04_AXI_rdata[31:0];
  assign m04_couplers_to_axi_cpu_interconnect_RRESP = M04_AXI_rresp[1:0];
  assign m04_couplers_to_axi_cpu_interconnect_RVALID = M04_AXI_rvalid[0];
  assign m04_couplers_to_axi_cpu_interconnect_WREADY = M04_AXI_wready[0];
  assign m05_couplers_to_axi_cpu_interconnect_ARREADY = M05_AXI_arready[0];
  assign m05_couplers_to_axi_cpu_interconnect_AWREADY = M05_AXI_awready[0];
  assign m05_couplers_to_axi_cpu_interconnect_BRESP = M05_AXI_bresp[1:0];
  assign m05_couplers_to_axi_cpu_interconnect_BVALID = M05_AXI_bvalid[0];
  assign m05_couplers_to_axi_cpu_interconnect_RDATA = M05_AXI_rdata[31:0];
  assign m05_couplers_to_axi_cpu_interconnect_RRESP = M05_AXI_rresp[1:0];
  assign m05_couplers_to_axi_cpu_interconnect_RVALID = M05_AXI_rvalid[0];
  assign m05_couplers_to_axi_cpu_interconnect_WREADY = M05_AXI_wready[0];
  assign m06_couplers_to_axi_cpu_interconnect_ARREADY = M06_AXI_arready[0];
  assign m06_couplers_to_axi_cpu_interconnect_AWREADY = M06_AXI_awready[0];
  assign m06_couplers_to_axi_cpu_interconnect_BRESP = M06_AXI_bresp[1:0];
  assign m06_couplers_to_axi_cpu_interconnect_BVALID = M06_AXI_bvalid[0];
  assign m06_couplers_to_axi_cpu_interconnect_RDATA = M06_AXI_rdata[31:0];
  assign m06_couplers_to_axi_cpu_interconnect_RRESP = M06_AXI_rresp[1:0];
  assign m06_couplers_to_axi_cpu_interconnect_RVALID = M06_AXI_rvalid[0];
  assign m06_couplers_to_axi_cpu_interconnect_WREADY = M06_AXI_wready[0];
  assign m07_couplers_to_axi_cpu_interconnect_ARREADY = M07_AXI_arready[0];
  assign m07_couplers_to_axi_cpu_interconnect_AWREADY = M07_AXI_awready[0];
  assign m07_couplers_to_axi_cpu_interconnect_BRESP = M07_AXI_bresp[1:0];
  assign m07_couplers_to_axi_cpu_interconnect_BVALID = M07_AXI_bvalid[0];
  assign m07_couplers_to_axi_cpu_interconnect_RDATA = M07_AXI_rdata[31:0];
  assign m07_couplers_to_axi_cpu_interconnect_RRESP = M07_AXI_rresp[1:0];
  assign m07_couplers_to_axi_cpu_interconnect_RVALID = M07_AXI_rvalid[0];
  assign m07_couplers_to_axi_cpu_interconnect_WREADY = M07_AXI_wready[0];
  m00_couplers_imp_I5GH1N m00_couplers
       (.M_ACLK(axi_cpu_interconnect_ACLK_net),
        .M_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .M_AXI_araddr(m00_couplers_to_axi_cpu_interconnect_ARADDR),
        .M_AXI_arprot(m00_couplers_to_axi_cpu_interconnect_ARPROT),
        .M_AXI_arready(m00_couplers_to_axi_cpu_interconnect_ARREADY),
        .M_AXI_arvalid(m00_couplers_to_axi_cpu_interconnect_ARVALID),
        .M_AXI_awaddr(m00_couplers_to_axi_cpu_interconnect_AWADDR),
        .M_AXI_awprot(m00_couplers_to_axi_cpu_interconnect_AWPROT),
        .M_AXI_awready(m00_couplers_to_axi_cpu_interconnect_AWREADY),
        .M_AXI_awvalid(m00_couplers_to_axi_cpu_interconnect_AWVALID),
        .M_AXI_bready(m00_couplers_to_axi_cpu_interconnect_BREADY),
        .M_AXI_bresp(m00_couplers_to_axi_cpu_interconnect_BRESP),
        .M_AXI_bvalid(m00_couplers_to_axi_cpu_interconnect_BVALID),
        .M_AXI_rdata(m00_couplers_to_axi_cpu_interconnect_RDATA),
        .M_AXI_rready(m00_couplers_to_axi_cpu_interconnect_RREADY),
        .M_AXI_rresp(m00_couplers_to_axi_cpu_interconnect_RRESP),
        .M_AXI_rvalid(m00_couplers_to_axi_cpu_interconnect_RVALID),
        .M_AXI_wdata(m00_couplers_to_axi_cpu_interconnect_WDATA),
        .M_AXI_wready(m00_couplers_to_axi_cpu_interconnect_WREADY),
        .M_AXI_wstrb(m00_couplers_to_axi_cpu_interconnect_WSTRB),
        .M_AXI_wvalid(m00_couplers_to_axi_cpu_interconnect_WVALID),
        .S_ACLK(axi_cpu_interconnect_ACLK_net),
        .S_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .S_AXI_araddr(xbar_to_m00_couplers_ARADDR[0]),
        .S_AXI_arprot(xbar_to_m00_couplers_ARPROT[0]),
        .S_AXI_arready(xbar_to_m00_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m00_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m00_couplers_AWADDR[0]),
        .S_AXI_awprot(xbar_to_m00_couplers_AWPROT[0]),
        .S_AXI_awready(xbar_to_m00_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m00_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m00_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m00_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m00_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m00_couplers_RDATA),
        .S_AXI_rready(xbar_to_m00_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m00_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m00_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m00_couplers_WDATA[0]),
        .S_AXI_wready(xbar_to_m00_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m00_couplers_WSTRB[0]),
        .S_AXI_wvalid(xbar_to_m00_couplers_WVALID));
  m01_couplers_imp_1UBGIXM m01_couplers
       (.M_ACLK(axi_cpu_interconnect_ACLK_net),
        .M_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .M_AXI_araddr(m01_couplers_to_axi_cpu_interconnect_ARADDR),
        .M_AXI_arprot(m01_couplers_to_axi_cpu_interconnect_ARPROT),
        .M_AXI_arready(m01_couplers_to_axi_cpu_interconnect_ARREADY),
        .M_AXI_arvalid(m01_couplers_to_axi_cpu_interconnect_ARVALID),
        .M_AXI_awaddr(m01_couplers_to_axi_cpu_interconnect_AWADDR),
        .M_AXI_awprot(m01_couplers_to_axi_cpu_interconnect_AWPROT),
        .M_AXI_awready(m01_couplers_to_axi_cpu_interconnect_AWREADY),
        .M_AXI_awvalid(m01_couplers_to_axi_cpu_interconnect_AWVALID),
        .M_AXI_bready(m01_couplers_to_axi_cpu_interconnect_BREADY),
        .M_AXI_bresp(m01_couplers_to_axi_cpu_interconnect_BRESP),
        .M_AXI_bvalid(m01_couplers_to_axi_cpu_interconnect_BVALID),
        .M_AXI_rdata(m01_couplers_to_axi_cpu_interconnect_RDATA),
        .M_AXI_rready(m01_couplers_to_axi_cpu_interconnect_RREADY),
        .M_AXI_rresp(m01_couplers_to_axi_cpu_interconnect_RRESP),
        .M_AXI_rvalid(m01_couplers_to_axi_cpu_interconnect_RVALID),
        .M_AXI_wdata(m01_couplers_to_axi_cpu_interconnect_WDATA),
        .M_AXI_wready(m01_couplers_to_axi_cpu_interconnect_WREADY),
        .M_AXI_wstrb(m01_couplers_to_axi_cpu_interconnect_WSTRB),
        .M_AXI_wvalid(m01_couplers_to_axi_cpu_interconnect_WVALID),
        .S_ACLK(axi_cpu_interconnect_ACLK_net),
        .S_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .S_AXI_araddr(xbar_to_m01_couplers_ARADDR[40]),
        .S_AXI_arprot(xbar_to_m01_couplers_ARPROT[3]),
        .S_AXI_arready(xbar_to_m01_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m01_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m01_couplers_AWADDR[40]),
        .S_AXI_awprot(xbar_to_m01_couplers_AWPROT[3]),
        .S_AXI_awready(xbar_to_m01_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m01_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m01_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m01_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m01_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m01_couplers_RDATA),
        .S_AXI_rready(xbar_to_m01_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m01_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m01_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m01_couplers_WDATA[32]),
        .S_AXI_wready(xbar_to_m01_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m01_couplers_WSTRB[4]),
        .S_AXI_wvalid(xbar_to_m01_couplers_WVALID));
  m02_couplers_imp_1J5P44O m02_couplers
       (.M_ACLK(axi_cpu_interconnect_ACLK_net),
        .M_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .M_AXI_araddr(m02_couplers_to_axi_cpu_interconnect_ARADDR),
        .M_AXI_arprot(m02_couplers_to_axi_cpu_interconnect_ARPROT),
        .M_AXI_arready(m02_couplers_to_axi_cpu_interconnect_ARREADY),
        .M_AXI_arvalid(m02_couplers_to_axi_cpu_interconnect_ARVALID),
        .M_AXI_awaddr(m02_couplers_to_axi_cpu_interconnect_AWADDR),
        .M_AXI_awprot(m02_couplers_to_axi_cpu_interconnect_AWPROT),
        .M_AXI_awready(m02_couplers_to_axi_cpu_interconnect_AWREADY),
        .M_AXI_awvalid(m02_couplers_to_axi_cpu_interconnect_AWVALID),
        .M_AXI_bready(m02_couplers_to_axi_cpu_interconnect_BREADY),
        .M_AXI_bresp(m02_couplers_to_axi_cpu_interconnect_BRESP),
        .M_AXI_bvalid(m02_couplers_to_axi_cpu_interconnect_BVALID),
        .M_AXI_rdata(m02_couplers_to_axi_cpu_interconnect_RDATA),
        .M_AXI_rready(m02_couplers_to_axi_cpu_interconnect_RREADY),
        .M_AXI_rresp(m02_couplers_to_axi_cpu_interconnect_RRESP),
        .M_AXI_rvalid(m02_couplers_to_axi_cpu_interconnect_RVALID),
        .M_AXI_wdata(m02_couplers_to_axi_cpu_interconnect_WDATA),
        .M_AXI_wready(m02_couplers_to_axi_cpu_interconnect_WREADY),
        .M_AXI_wstrb(m02_couplers_to_axi_cpu_interconnect_WSTRB),
        .M_AXI_wvalid(m02_couplers_to_axi_cpu_interconnect_WVALID),
        .S_ACLK(axi_cpu_interconnect_ACLK_net),
        .S_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .S_AXI_araddr(xbar_to_m02_couplers_ARADDR[80]),
        .S_AXI_arprot(xbar_to_m02_couplers_ARPROT[6]),
        .S_AXI_arready(xbar_to_m02_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m02_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m02_couplers_AWADDR[80]),
        .S_AXI_awprot(xbar_to_m02_couplers_AWPROT[6]),
        .S_AXI_awready(xbar_to_m02_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m02_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m02_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m02_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m02_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m02_couplers_RDATA),
        .S_AXI_rready(xbar_to_m02_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m02_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m02_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m02_couplers_WDATA[64]),
        .S_AXI_wready(xbar_to_m02_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m02_couplers_WSTRB[8]),
        .S_AXI_wvalid(xbar_to_m02_couplers_WVALID));
  m03_couplers_imp_T17W6X m03_couplers
       (.M_ACLK(axi_cpu_interconnect_ACLK_net),
        .M_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .M_AXI_araddr(m03_couplers_to_axi_cpu_interconnect_ARADDR),
        .M_AXI_arprot(m03_couplers_to_axi_cpu_interconnect_ARPROT),
        .M_AXI_arready(m03_couplers_to_axi_cpu_interconnect_ARREADY),
        .M_AXI_arvalid(m03_couplers_to_axi_cpu_interconnect_ARVALID),
        .M_AXI_awaddr(m03_couplers_to_axi_cpu_interconnect_AWADDR),
        .M_AXI_awprot(m03_couplers_to_axi_cpu_interconnect_AWPROT),
        .M_AXI_awready(m03_couplers_to_axi_cpu_interconnect_AWREADY),
        .M_AXI_awvalid(m03_couplers_to_axi_cpu_interconnect_AWVALID),
        .M_AXI_bready(m03_couplers_to_axi_cpu_interconnect_BREADY),
        .M_AXI_bresp(m03_couplers_to_axi_cpu_interconnect_BRESP),
        .M_AXI_bvalid(m03_couplers_to_axi_cpu_interconnect_BVALID),
        .M_AXI_rdata(m03_couplers_to_axi_cpu_interconnect_RDATA),
        .M_AXI_rready(m03_couplers_to_axi_cpu_interconnect_RREADY),
        .M_AXI_rresp(m03_couplers_to_axi_cpu_interconnect_RRESP),
        .M_AXI_rvalid(m03_couplers_to_axi_cpu_interconnect_RVALID),
        .M_AXI_wdata(m03_couplers_to_axi_cpu_interconnect_WDATA),
        .M_AXI_wready(m03_couplers_to_axi_cpu_interconnect_WREADY),
        .M_AXI_wstrb(m03_couplers_to_axi_cpu_interconnect_WSTRB),
        .M_AXI_wvalid(m03_couplers_to_axi_cpu_interconnect_WVALID),
        .S_ACLK(axi_cpu_interconnect_ACLK_net),
        .S_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .S_AXI_araddr(xbar_to_m03_couplers_ARADDR[120]),
        .S_AXI_arprot(xbar_to_m03_couplers_ARPROT[9]),
        .S_AXI_arready(xbar_to_m03_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m03_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m03_couplers_AWADDR[120]),
        .S_AXI_awprot(xbar_to_m03_couplers_AWPROT[9]),
        .S_AXI_awready(xbar_to_m03_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m03_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m03_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m03_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m03_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m03_couplers_RDATA),
        .S_AXI_rready(xbar_to_m03_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m03_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m03_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m03_couplers_WDATA[96]),
        .S_AXI_wready(xbar_to_m03_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m03_couplers_WSTRB[12]),
        .S_AXI_wvalid(xbar_to_m03_couplers_WVALID));
  m04_couplers_imp_15FU5SC m04_couplers
       (.M_ACLK(axi_cpu_interconnect_ACLK_net),
        .M_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .M_AXI_araddr(m04_couplers_to_axi_cpu_interconnect_ARADDR),
        .M_AXI_arprot(m04_couplers_to_axi_cpu_interconnect_ARPROT),
        .M_AXI_arready(m04_couplers_to_axi_cpu_interconnect_ARREADY),
        .M_AXI_arvalid(m04_couplers_to_axi_cpu_interconnect_ARVALID),
        .M_AXI_awaddr(m04_couplers_to_axi_cpu_interconnect_AWADDR),
        .M_AXI_awprot(m04_couplers_to_axi_cpu_interconnect_AWPROT),
        .M_AXI_awready(m04_couplers_to_axi_cpu_interconnect_AWREADY),
        .M_AXI_awvalid(m04_couplers_to_axi_cpu_interconnect_AWVALID),
        .M_AXI_bready(m04_couplers_to_axi_cpu_interconnect_BREADY),
        .M_AXI_bresp(m04_couplers_to_axi_cpu_interconnect_BRESP),
        .M_AXI_bvalid(m04_couplers_to_axi_cpu_interconnect_BVALID),
        .M_AXI_rdata(m04_couplers_to_axi_cpu_interconnect_RDATA),
        .M_AXI_rready(m04_couplers_to_axi_cpu_interconnect_RREADY),
        .M_AXI_rresp(m04_couplers_to_axi_cpu_interconnect_RRESP),
        .M_AXI_rvalid(m04_couplers_to_axi_cpu_interconnect_RVALID),
        .M_AXI_wdata(m04_couplers_to_axi_cpu_interconnect_WDATA),
        .M_AXI_wready(m04_couplers_to_axi_cpu_interconnect_WREADY),
        .M_AXI_wstrb(m04_couplers_to_axi_cpu_interconnect_WSTRB),
        .M_AXI_wvalid(m04_couplers_to_axi_cpu_interconnect_WVALID),
        .S_ACLK(axi_cpu_interconnect_ACLK_net),
        .S_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .S_AXI_araddr(xbar_to_m04_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m04_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m04_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m04_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m04_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m04_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m04_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m04_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m04_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m04_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m04_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m04_couplers_RDATA),
        .S_AXI_rready(xbar_to_m04_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m04_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m04_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m04_couplers_WDATA),
        .S_AXI_wready(xbar_to_m04_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m04_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m04_couplers_WVALID));
  m05_couplers_imp_GFBASD m05_couplers
       (.M_ACLK(axi_cpu_interconnect_ACLK_net),
        .M_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .M_AXI_araddr(m05_couplers_to_axi_cpu_interconnect_ARADDR),
        .M_AXI_arprot(m05_couplers_to_axi_cpu_interconnect_ARPROT),
        .M_AXI_arready(m05_couplers_to_axi_cpu_interconnect_ARREADY),
        .M_AXI_arvalid(m05_couplers_to_axi_cpu_interconnect_ARVALID),
        .M_AXI_awaddr(m05_couplers_to_axi_cpu_interconnect_AWADDR),
        .M_AXI_awprot(m05_couplers_to_axi_cpu_interconnect_AWPROT),
        .M_AXI_awready(m05_couplers_to_axi_cpu_interconnect_AWREADY),
        .M_AXI_awvalid(m05_couplers_to_axi_cpu_interconnect_AWVALID),
        .M_AXI_bready(m05_couplers_to_axi_cpu_interconnect_BREADY),
        .M_AXI_bresp(m05_couplers_to_axi_cpu_interconnect_BRESP),
        .M_AXI_bvalid(m05_couplers_to_axi_cpu_interconnect_BVALID),
        .M_AXI_rdata(m05_couplers_to_axi_cpu_interconnect_RDATA),
        .M_AXI_rready(m05_couplers_to_axi_cpu_interconnect_RREADY),
        .M_AXI_rresp(m05_couplers_to_axi_cpu_interconnect_RRESP),
        .M_AXI_rvalid(m05_couplers_to_axi_cpu_interconnect_RVALID),
        .M_AXI_wdata(m05_couplers_to_axi_cpu_interconnect_WDATA),
        .M_AXI_wready(m05_couplers_to_axi_cpu_interconnect_WREADY),
        .M_AXI_wstrb(m05_couplers_to_axi_cpu_interconnect_WSTRB),
        .M_AXI_wvalid(m05_couplers_to_axi_cpu_interconnect_WVALID),
        .S_ACLK(axi_cpu_interconnect_ACLK_net),
        .S_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .S_AXI_araddr(xbar_to_m05_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m05_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m05_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m05_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m05_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m05_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m05_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m05_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m05_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m05_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m05_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m05_couplers_RDATA),
        .S_AXI_rready(xbar_to_m05_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m05_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m05_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m05_couplers_WDATA),
        .S_AXI_wready(xbar_to_m05_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m05_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m05_couplers_WVALID));
  m06_couplers_imp_59JXRJ m06_couplers
       (.M_ACLK(axi_cpu_interconnect_ACLK_net),
        .M_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .M_AXI_araddr(m06_couplers_to_axi_cpu_interconnect_ARADDR),
        .M_AXI_arprot(m06_couplers_to_axi_cpu_interconnect_ARPROT),
        .M_AXI_arready(m06_couplers_to_axi_cpu_interconnect_ARREADY),
        .M_AXI_arvalid(m06_couplers_to_axi_cpu_interconnect_ARVALID),
        .M_AXI_awaddr(m06_couplers_to_axi_cpu_interconnect_AWADDR),
        .M_AXI_awprot(m06_couplers_to_axi_cpu_interconnect_AWPROT),
        .M_AXI_awready(m06_couplers_to_axi_cpu_interconnect_AWREADY),
        .M_AXI_awvalid(m06_couplers_to_axi_cpu_interconnect_AWVALID),
        .M_AXI_bready(m06_couplers_to_axi_cpu_interconnect_BREADY),
        .M_AXI_bresp(m06_couplers_to_axi_cpu_interconnect_BRESP),
        .M_AXI_bvalid(m06_couplers_to_axi_cpu_interconnect_BVALID),
        .M_AXI_rdata(m06_couplers_to_axi_cpu_interconnect_RDATA),
        .M_AXI_rready(m06_couplers_to_axi_cpu_interconnect_RREADY),
        .M_AXI_rresp(m06_couplers_to_axi_cpu_interconnect_RRESP),
        .M_AXI_rvalid(m06_couplers_to_axi_cpu_interconnect_RVALID),
        .M_AXI_wdata(m06_couplers_to_axi_cpu_interconnect_WDATA),
        .M_AXI_wready(m06_couplers_to_axi_cpu_interconnect_WREADY),
        .M_AXI_wstrb(m06_couplers_to_axi_cpu_interconnect_WSTRB),
        .M_AXI_wvalid(m06_couplers_to_axi_cpu_interconnect_WVALID),
        .S_ACLK(axi_cpu_interconnect_ACLK_net),
        .S_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .S_AXI_araddr(xbar_to_m06_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m06_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m06_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m06_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m06_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m06_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m06_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m06_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m06_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m06_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m06_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m06_couplers_RDATA),
        .S_AXI_rready(xbar_to_m06_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m06_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m06_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m06_couplers_WDATA),
        .S_AXI_wready(xbar_to_m06_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m06_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m06_couplers_WVALID));
  m07_couplers_imp_1GBLMBI m07_couplers
       (.M_ACLK(axi_cpu_interconnect_ACLK_net),
        .M_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .M_AXI_araddr(m07_couplers_to_axi_cpu_interconnect_ARADDR),
        .M_AXI_arprot(m07_couplers_to_axi_cpu_interconnect_ARPROT),
        .M_AXI_arready(m07_couplers_to_axi_cpu_interconnect_ARREADY),
        .M_AXI_arvalid(m07_couplers_to_axi_cpu_interconnect_ARVALID),
        .M_AXI_awaddr(m07_couplers_to_axi_cpu_interconnect_AWADDR),
        .M_AXI_awprot(m07_couplers_to_axi_cpu_interconnect_AWPROT),
        .M_AXI_awready(m07_couplers_to_axi_cpu_interconnect_AWREADY),
        .M_AXI_awvalid(m07_couplers_to_axi_cpu_interconnect_AWVALID),
        .M_AXI_bready(m07_couplers_to_axi_cpu_interconnect_BREADY),
        .M_AXI_bresp(m07_couplers_to_axi_cpu_interconnect_BRESP),
        .M_AXI_bvalid(m07_couplers_to_axi_cpu_interconnect_BVALID),
        .M_AXI_rdata(m07_couplers_to_axi_cpu_interconnect_RDATA),
        .M_AXI_rready(m07_couplers_to_axi_cpu_interconnect_RREADY),
        .M_AXI_rresp(m07_couplers_to_axi_cpu_interconnect_RRESP),
        .M_AXI_rvalid(m07_couplers_to_axi_cpu_interconnect_RVALID),
        .M_AXI_wdata(m07_couplers_to_axi_cpu_interconnect_WDATA),
        .M_AXI_wready(m07_couplers_to_axi_cpu_interconnect_WREADY),
        .M_AXI_wstrb(m07_couplers_to_axi_cpu_interconnect_WSTRB),
        .M_AXI_wvalid(m07_couplers_to_axi_cpu_interconnect_WVALID),
        .S_ACLK(axi_cpu_interconnect_ACLK_net),
        .S_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .S_AXI_araddr(xbar_to_m07_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m07_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m07_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m07_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m07_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m07_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m07_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m07_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m07_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m07_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m07_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m07_couplers_RDATA),
        .S_AXI_rready(xbar_to_m07_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m07_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m07_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m07_couplers_WDATA),
        .S_AXI_wready(xbar_to_m07_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m07_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m07_couplers_WVALID));
  s00_couplers_imp_WZLZH6 s00_couplers
       (.M_ACLK(axi_cpu_interconnect_ACLK_net),
        .M_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_xbar_ARADDR),
        .M_AXI_arprot(s00_couplers_to_xbar_ARPROT),
        .M_AXI_arready(s00_couplers_to_xbar_ARREADY),
        .M_AXI_arvalid(s00_couplers_to_xbar_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_xbar_AWADDR),
        .M_AXI_awprot(s00_couplers_to_xbar_AWPROT),
        .M_AXI_awready(s00_couplers_to_xbar_AWREADY),
        .M_AXI_awvalid(s00_couplers_to_xbar_AWVALID),
        .M_AXI_bready(s00_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s00_couplers_to_xbar_BRESP),
        .M_AXI_bvalid(s00_couplers_to_xbar_BVALID),
        .M_AXI_rdata(s00_couplers_to_xbar_RDATA),
        .M_AXI_rready(s00_couplers_to_xbar_RREADY),
        .M_AXI_rresp(s00_couplers_to_xbar_RRESP),
        .M_AXI_rvalid(s00_couplers_to_xbar_RVALID),
        .M_AXI_wdata(s00_couplers_to_xbar_WDATA),
        .M_AXI_wready(s00_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s00_couplers_to_xbar_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_xbar_WVALID),
        .S_ACLK(axi_cpu_interconnect_ACLK_net),
        .S_ARESETN(axi_cpu_interconnect_ARESETN_net),
        .S_AXI_araddr(axi_cpu_interconnect_to_s00_couplers_ARADDR),
        .S_AXI_arburst(axi_cpu_interconnect_to_s00_couplers_ARBURST),
        .S_AXI_arcache(axi_cpu_interconnect_to_s00_couplers_ARCACHE),
        .S_AXI_arid(axi_cpu_interconnect_to_s00_couplers_ARID),
        .S_AXI_arlen(axi_cpu_interconnect_to_s00_couplers_ARLEN),
        .S_AXI_arlock(axi_cpu_interconnect_to_s00_couplers_ARLOCK),
        .S_AXI_arprot(axi_cpu_interconnect_to_s00_couplers_ARPROT),
        .S_AXI_arqos(axi_cpu_interconnect_to_s00_couplers_ARQOS),
        .S_AXI_arready(axi_cpu_interconnect_to_s00_couplers_ARREADY),
        .S_AXI_arsize(axi_cpu_interconnect_to_s00_couplers_ARSIZE),
        .S_AXI_arvalid(axi_cpu_interconnect_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(axi_cpu_interconnect_to_s00_couplers_AWADDR),
        .S_AXI_awburst(axi_cpu_interconnect_to_s00_couplers_AWBURST),
        .S_AXI_awcache(axi_cpu_interconnect_to_s00_couplers_AWCACHE),
        .S_AXI_awid(axi_cpu_interconnect_to_s00_couplers_AWID),
        .S_AXI_awlen(axi_cpu_interconnect_to_s00_couplers_AWLEN),
        .S_AXI_awlock(axi_cpu_interconnect_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(axi_cpu_interconnect_to_s00_couplers_AWPROT),
        .S_AXI_awqos(axi_cpu_interconnect_to_s00_couplers_AWQOS),
        .S_AXI_awready(axi_cpu_interconnect_to_s00_couplers_AWREADY),
        .S_AXI_awsize(axi_cpu_interconnect_to_s00_couplers_AWSIZE),
        .S_AXI_awvalid(axi_cpu_interconnect_to_s00_couplers_AWVALID),
        .S_AXI_bid(axi_cpu_interconnect_to_s00_couplers_BID),
        .S_AXI_bready(axi_cpu_interconnect_to_s00_couplers_BREADY),
        .S_AXI_bresp(axi_cpu_interconnect_to_s00_couplers_BRESP),
        .S_AXI_bvalid(axi_cpu_interconnect_to_s00_couplers_BVALID),
        .S_AXI_rdata(axi_cpu_interconnect_to_s00_couplers_RDATA),
        .S_AXI_rid(axi_cpu_interconnect_to_s00_couplers_RID),
        .S_AXI_rlast(axi_cpu_interconnect_to_s00_couplers_RLAST),
        .S_AXI_rready(axi_cpu_interconnect_to_s00_couplers_RREADY),
        .S_AXI_rresp(axi_cpu_interconnect_to_s00_couplers_RRESP),
        .S_AXI_rvalid(axi_cpu_interconnect_to_s00_couplers_RVALID),
        .S_AXI_wdata(axi_cpu_interconnect_to_s00_couplers_WDATA),
        .S_AXI_wlast(axi_cpu_interconnect_to_s00_couplers_WLAST),
        .S_AXI_wready(axi_cpu_interconnect_to_s00_couplers_WREADY),
        .S_AXI_wstrb(axi_cpu_interconnect_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(axi_cpu_interconnect_to_s00_couplers_WVALID));
  system_xbar_0 xbar
       (.aclk(axi_cpu_interconnect_ACLK_net),
        .aresetn(axi_cpu_interconnect_ARESETN_net),
        .m_axi_araddr({xbar_to_m07_couplers_ARADDR,xbar_to_m06_couplers_ARADDR,xbar_to_m05_couplers_ARADDR,xbar_to_m04_couplers_ARADDR,xbar_to_m03_couplers_ARADDR,xbar_to_m02_couplers_ARADDR,xbar_to_m01_couplers_ARADDR,xbar_to_m00_couplers_ARADDR}),
        .m_axi_arprot({xbar_to_m07_couplers_ARPROT,xbar_to_m06_couplers_ARPROT,xbar_to_m05_couplers_ARPROT,xbar_to_m04_couplers_ARPROT,xbar_to_m03_couplers_ARPROT,xbar_to_m02_couplers_ARPROT,xbar_to_m01_couplers_ARPROT,xbar_to_m00_couplers_ARPROT}),
        .m_axi_arready({xbar_to_m07_couplers_ARREADY,xbar_to_m06_couplers_ARREADY,xbar_to_m05_couplers_ARREADY,xbar_to_m04_couplers_ARREADY,xbar_to_m03_couplers_ARREADY,xbar_to_m02_couplers_ARREADY,xbar_to_m01_couplers_ARREADY,xbar_to_m00_couplers_ARREADY}),
        .m_axi_arvalid({xbar_to_m07_couplers_ARVALID,xbar_to_m06_couplers_ARVALID,xbar_to_m05_couplers_ARVALID,xbar_to_m04_couplers_ARVALID,xbar_to_m03_couplers_ARVALID,xbar_to_m02_couplers_ARVALID,xbar_to_m01_couplers_ARVALID,xbar_to_m00_couplers_ARVALID}),
        .m_axi_awaddr({xbar_to_m07_couplers_AWADDR,xbar_to_m06_couplers_AWADDR,xbar_to_m05_couplers_AWADDR,xbar_to_m04_couplers_AWADDR,xbar_to_m03_couplers_AWADDR,xbar_to_m02_couplers_AWADDR,xbar_to_m01_couplers_AWADDR,xbar_to_m00_couplers_AWADDR}),
        .m_axi_awprot({xbar_to_m07_couplers_AWPROT,xbar_to_m06_couplers_AWPROT,xbar_to_m05_couplers_AWPROT,xbar_to_m04_couplers_AWPROT,xbar_to_m03_couplers_AWPROT,xbar_to_m02_couplers_AWPROT,xbar_to_m01_couplers_AWPROT,xbar_to_m00_couplers_AWPROT}),
        .m_axi_awready({xbar_to_m07_couplers_AWREADY,xbar_to_m06_couplers_AWREADY,xbar_to_m05_couplers_AWREADY,xbar_to_m04_couplers_AWREADY,xbar_to_m03_couplers_AWREADY,xbar_to_m02_couplers_AWREADY,xbar_to_m01_couplers_AWREADY,xbar_to_m00_couplers_AWREADY}),
        .m_axi_awvalid({xbar_to_m07_couplers_AWVALID,xbar_to_m06_couplers_AWVALID,xbar_to_m05_couplers_AWVALID,xbar_to_m04_couplers_AWVALID,xbar_to_m03_couplers_AWVALID,xbar_to_m02_couplers_AWVALID,xbar_to_m01_couplers_AWVALID,xbar_to_m00_couplers_AWVALID}),
        .m_axi_bready({xbar_to_m07_couplers_BREADY,xbar_to_m06_couplers_BREADY,xbar_to_m05_couplers_BREADY,xbar_to_m04_couplers_BREADY,xbar_to_m03_couplers_BREADY,xbar_to_m02_couplers_BREADY,xbar_to_m01_couplers_BREADY,xbar_to_m00_couplers_BREADY}),
        .m_axi_bresp({xbar_to_m07_couplers_BRESP,xbar_to_m06_couplers_BRESP,xbar_to_m05_couplers_BRESP,xbar_to_m04_couplers_BRESP,xbar_to_m03_couplers_BRESP,xbar_to_m03_couplers_BRESP,xbar_to_m02_couplers_BRESP,xbar_to_m02_couplers_BRESP,xbar_to_m01_couplers_BRESP,xbar_to_m01_couplers_BRESP,xbar_to_m00_couplers_BRESP,xbar_to_m00_couplers_BRESP}),
        .m_axi_bvalid({xbar_to_m07_couplers_BVALID,xbar_to_m06_couplers_BVALID,xbar_to_m05_couplers_BVALID,xbar_to_m04_couplers_BVALID,xbar_to_m03_couplers_BVALID,xbar_to_m02_couplers_BVALID,xbar_to_m01_couplers_BVALID,xbar_to_m00_couplers_BVALID}),
        .m_axi_rdata({xbar_to_m07_couplers_RDATA,xbar_to_m06_couplers_RDATA,xbar_to_m05_couplers_RDATA,xbar_to_m04_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA,xbar_to_m00_couplers_RDATA}),
        .m_axi_rready({xbar_to_m07_couplers_RREADY,xbar_to_m06_couplers_RREADY,xbar_to_m05_couplers_RREADY,xbar_to_m04_couplers_RREADY,xbar_to_m03_couplers_RREADY,xbar_to_m02_couplers_RREADY,xbar_to_m01_couplers_RREADY,xbar_to_m00_couplers_RREADY}),
        .m_axi_rresp({xbar_to_m07_couplers_RRESP,xbar_to_m06_couplers_RRESP,xbar_to_m05_couplers_RRESP,xbar_to_m04_couplers_RRESP,xbar_to_m03_couplers_RRESP,xbar_to_m03_couplers_RRESP,xbar_to_m02_couplers_RRESP,xbar_to_m02_couplers_RRESP,xbar_to_m01_couplers_RRESP,xbar_to_m01_couplers_RRESP,xbar_to_m00_couplers_RRESP,xbar_to_m00_couplers_RRESP}),
        .m_axi_rvalid({xbar_to_m07_couplers_RVALID,xbar_to_m06_couplers_RVALID,xbar_to_m05_couplers_RVALID,xbar_to_m04_couplers_RVALID,xbar_to_m03_couplers_RVALID,xbar_to_m02_couplers_RVALID,xbar_to_m01_couplers_RVALID,xbar_to_m00_couplers_RVALID}),
        .m_axi_wdata({xbar_to_m07_couplers_WDATA,xbar_to_m06_couplers_WDATA,xbar_to_m05_couplers_WDATA,xbar_to_m04_couplers_WDATA,xbar_to_m03_couplers_WDATA,xbar_to_m02_couplers_WDATA,xbar_to_m01_couplers_WDATA,xbar_to_m00_couplers_WDATA}),
        .m_axi_wready({xbar_to_m07_couplers_WREADY,xbar_to_m06_couplers_WREADY,xbar_to_m05_couplers_WREADY,xbar_to_m04_couplers_WREADY,xbar_to_m03_couplers_WREADY,xbar_to_m02_couplers_WREADY,xbar_to_m01_couplers_WREADY,xbar_to_m00_couplers_WREADY}),
        .m_axi_wstrb({xbar_to_m07_couplers_WSTRB,xbar_to_m06_couplers_WSTRB,xbar_to_m05_couplers_WSTRB,xbar_to_m04_couplers_WSTRB,xbar_to_m03_couplers_WSTRB,xbar_to_m02_couplers_WSTRB,xbar_to_m01_couplers_WSTRB,xbar_to_m00_couplers_WSTRB}),
        .m_axi_wvalid({xbar_to_m07_couplers_WVALID,xbar_to_m06_couplers_WVALID,xbar_to_m05_couplers_WVALID,xbar_to_m04_couplers_WVALID,xbar_to_m03_couplers_WVALID,xbar_to_m02_couplers_WVALID,xbar_to_m01_couplers_WVALID,xbar_to_m00_couplers_WVALID}),
        .s_axi_araddr(s00_couplers_to_xbar_ARADDR),
        .s_axi_arprot(s00_couplers_to_xbar_ARPROT),
        .s_axi_arready(s00_couplers_to_xbar_ARREADY),
        .s_axi_arvalid(s00_couplers_to_xbar_ARVALID),
        .s_axi_awaddr(s00_couplers_to_xbar_AWADDR),
        .s_axi_awprot(s00_couplers_to_xbar_AWPROT),
        .s_axi_awready(s00_couplers_to_xbar_AWREADY),
        .s_axi_awvalid(s00_couplers_to_xbar_AWVALID),
        .s_axi_bready(s00_couplers_to_xbar_BREADY),
        .s_axi_bresp(s00_couplers_to_xbar_BRESP),
        .s_axi_bvalid(s00_couplers_to_xbar_BVALID),
        .s_axi_rdata(s00_couplers_to_xbar_RDATA),
        .s_axi_rready(s00_couplers_to_xbar_RREADY),
        .s_axi_rresp(s00_couplers_to_xbar_RRESP),
        .s_axi_rvalid(s00_couplers_to_xbar_RVALID),
        .s_axi_wdata(s00_couplers_to_xbar_WDATA),
        .s_axi_wready(s00_couplers_to_xbar_WREADY),
        .s_axi_wstrb(s00_couplers_to_xbar_WSTRB),
        .s_axi_wvalid(s00_couplers_to_xbar_WVALID));
endmodule

module system_axi_hp2_interconnect_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_awaddr,
    M00_AXI_awburst,
    M00_AXI_awcache,
    M00_AXI_awlen,
    M00_AXI_awlock,
    M00_AXI_awprot,
    M00_AXI_awqos,
    M00_AXI_awready,
    M00_AXI_awsize,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_wdata,
    M00_AXI_wlast,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awlen,
    S00_AXI_awprot,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awvalid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_wdata,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [31:0]M00_AXI_awaddr;
  output [1:0]M00_AXI_awburst;
  output [3:0]M00_AXI_awcache;
  output [7:0]M00_AXI_awlen;
  output [0:0]M00_AXI_awlock;
  output [2:0]M00_AXI_awprot;
  output [3:0]M00_AXI_awqos;
  input M00_AXI_awready;
  output [2:0]M00_AXI_awsize;
  output M00_AXI_awvalid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  output [127:0]M00_AXI_wdata;
  output M00_AXI_wlast;
  input M00_AXI_wready;
  output [15:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [31:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [7:0]S00_AXI_awlen;
  input [2:0]S00_AXI_awprot;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input S00_AXI_awvalid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  input [63:0]S00_AXI_wdata;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [7:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;

  wire S00_ACLK_1;
  wire S00_ARESETN_1;
  wire axi_hp2_interconnect_ACLK_net;
  wire axi_hp2_interconnect_ARESETN_net;
  wire [31:0]axi_hp2_interconnect_to_s00_couplers_AWADDR;
  wire [1:0]axi_hp2_interconnect_to_s00_couplers_AWBURST;
  wire [3:0]axi_hp2_interconnect_to_s00_couplers_AWCACHE;
  wire [7:0]axi_hp2_interconnect_to_s00_couplers_AWLEN;
  wire [2:0]axi_hp2_interconnect_to_s00_couplers_AWPROT;
  wire axi_hp2_interconnect_to_s00_couplers_AWREADY;
  wire [2:0]axi_hp2_interconnect_to_s00_couplers_AWSIZE;
  wire axi_hp2_interconnect_to_s00_couplers_AWVALID;
  wire axi_hp2_interconnect_to_s00_couplers_BREADY;
  wire [1:0]axi_hp2_interconnect_to_s00_couplers_BRESP;
  wire axi_hp2_interconnect_to_s00_couplers_BVALID;
  wire [63:0]axi_hp2_interconnect_to_s00_couplers_WDATA;
  wire axi_hp2_interconnect_to_s00_couplers_WLAST;
  wire axi_hp2_interconnect_to_s00_couplers_WREADY;
  wire [7:0]axi_hp2_interconnect_to_s00_couplers_WSTRB;
  wire axi_hp2_interconnect_to_s00_couplers_WVALID;
  wire [31:0]s00_couplers_to_axi_hp2_interconnect_AWADDR;
  wire [1:0]s00_couplers_to_axi_hp2_interconnect_AWBURST;
  wire [3:0]s00_couplers_to_axi_hp2_interconnect_AWCACHE;
  wire [7:0]s00_couplers_to_axi_hp2_interconnect_AWLEN;
  wire [0:0]s00_couplers_to_axi_hp2_interconnect_AWLOCK;
  wire [2:0]s00_couplers_to_axi_hp2_interconnect_AWPROT;
  wire [3:0]s00_couplers_to_axi_hp2_interconnect_AWQOS;
  wire s00_couplers_to_axi_hp2_interconnect_AWREADY;
  wire [2:0]s00_couplers_to_axi_hp2_interconnect_AWSIZE;
  wire s00_couplers_to_axi_hp2_interconnect_AWVALID;
  wire s00_couplers_to_axi_hp2_interconnect_BREADY;
  wire [1:0]s00_couplers_to_axi_hp2_interconnect_BRESP;
  wire s00_couplers_to_axi_hp2_interconnect_BVALID;
  wire [127:0]s00_couplers_to_axi_hp2_interconnect_WDATA;
  wire s00_couplers_to_axi_hp2_interconnect_WLAST;
  wire s00_couplers_to_axi_hp2_interconnect_WREADY;
  wire [15:0]s00_couplers_to_axi_hp2_interconnect_WSTRB;
  wire s00_couplers_to_axi_hp2_interconnect_WVALID;

  assign M00_AXI_awaddr[31:0] = s00_couplers_to_axi_hp2_interconnect_AWADDR;
  assign M00_AXI_awburst[1:0] = s00_couplers_to_axi_hp2_interconnect_AWBURST;
  assign M00_AXI_awcache[3:0] = s00_couplers_to_axi_hp2_interconnect_AWCACHE;
  assign M00_AXI_awlen[7:0] = s00_couplers_to_axi_hp2_interconnect_AWLEN;
  assign M00_AXI_awlock[0] = s00_couplers_to_axi_hp2_interconnect_AWLOCK;
  assign M00_AXI_awprot[2:0] = s00_couplers_to_axi_hp2_interconnect_AWPROT;
  assign M00_AXI_awqos[3:0] = s00_couplers_to_axi_hp2_interconnect_AWQOS;
  assign M00_AXI_awsize[2:0] = s00_couplers_to_axi_hp2_interconnect_AWSIZE;
  assign M00_AXI_awvalid = s00_couplers_to_axi_hp2_interconnect_AWVALID;
  assign M00_AXI_bready = s00_couplers_to_axi_hp2_interconnect_BREADY;
  assign M00_AXI_wdata[127:0] = s00_couplers_to_axi_hp2_interconnect_WDATA;
  assign M00_AXI_wlast = s00_couplers_to_axi_hp2_interconnect_WLAST;
  assign M00_AXI_wstrb[15:0] = s00_couplers_to_axi_hp2_interconnect_WSTRB;
  assign M00_AXI_wvalid = s00_couplers_to_axi_hp2_interconnect_WVALID;
  assign S00_ACLK_1 = S00_ACLK;
  assign S00_ARESETN_1 = S00_ARESETN;
  assign S00_AXI_awready = axi_hp2_interconnect_to_s00_couplers_AWREADY;
  assign S00_AXI_bresp[1:0] = axi_hp2_interconnect_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = axi_hp2_interconnect_to_s00_couplers_BVALID;
  assign S00_AXI_wready = axi_hp2_interconnect_to_s00_couplers_WREADY;
  assign axi_hp2_interconnect_ACLK_net = M00_ACLK;
  assign axi_hp2_interconnect_ARESETN_net = M00_ARESETN;
  assign axi_hp2_interconnect_to_s00_couplers_AWADDR = S00_AXI_awaddr[31:0];
  assign axi_hp2_interconnect_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign axi_hp2_interconnect_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign axi_hp2_interconnect_to_s00_couplers_AWLEN = S00_AXI_awlen[7:0];
  assign axi_hp2_interconnect_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign axi_hp2_interconnect_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign axi_hp2_interconnect_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign axi_hp2_interconnect_to_s00_couplers_BREADY = S00_AXI_bready;
  assign axi_hp2_interconnect_to_s00_couplers_WDATA = S00_AXI_wdata[63:0];
  assign axi_hp2_interconnect_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign axi_hp2_interconnect_to_s00_couplers_WSTRB = S00_AXI_wstrb[7:0];
  assign axi_hp2_interconnect_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign s00_couplers_to_axi_hp2_interconnect_AWREADY = M00_AXI_awready;
  assign s00_couplers_to_axi_hp2_interconnect_BRESP = M00_AXI_bresp[1:0];
  assign s00_couplers_to_axi_hp2_interconnect_BVALID = M00_AXI_bvalid;
  assign s00_couplers_to_axi_hp2_interconnect_WREADY = M00_AXI_wready;
  s00_couplers_imp_SELTG5 s00_couplers
       (.M_ACLK(axi_hp2_interconnect_ACLK_net),
        .M_ARESETN(axi_hp2_interconnect_ARESETN_net),
        .M_AXI_awaddr(s00_couplers_to_axi_hp2_interconnect_AWADDR),
        .M_AXI_awburst(s00_couplers_to_axi_hp2_interconnect_AWBURST),
        .M_AXI_awcache(s00_couplers_to_axi_hp2_interconnect_AWCACHE),
        .M_AXI_awlen(s00_couplers_to_axi_hp2_interconnect_AWLEN),
        .M_AXI_awlock(s00_couplers_to_axi_hp2_interconnect_AWLOCK),
        .M_AXI_awprot(s00_couplers_to_axi_hp2_interconnect_AWPROT),
        .M_AXI_awqos(s00_couplers_to_axi_hp2_interconnect_AWQOS),
        .M_AXI_awready(s00_couplers_to_axi_hp2_interconnect_AWREADY),
        .M_AXI_awsize(s00_couplers_to_axi_hp2_interconnect_AWSIZE),
        .M_AXI_awvalid(s00_couplers_to_axi_hp2_interconnect_AWVALID),
        .M_AXI_bready(s00_couplers_to_axi_hp2_interconnect_BREADY),
        .M_AXI_bresp(s00_couplers_to_axi_hp2_interconnect_BRESP),
        .M_AXI_bvalid(s00_couplers_to_axi_hp2_interconnect_BVALID),
        .M_AXI_wdata(s00_couplers_to_axi_hp2_interconnect_WDATA),
        .M_AXI_wlast(s00_couplers_to_axi_hp2_interconnect_WLAST),
        .M_AXI_wready(s00_couplers_to_axi_hp2_interconnect_WREADY),
        .M_AXI_wstrb(s00_couplers_to_axi_hp2_interconnect_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_axi_hp2_interconnect_WVALID),
        .S_ACLK(S00_ACLK_1),
        .S_ARESETN(S00_ARESETN_1),
        .S_AXI_awaddr(axi_hp2_interconnect_to_s00_couplers_AWADDR),
        .S_AXI_awburst(axi_hp2_interconnect_to_s00_couplers_AWBURST),
        .S_AXI_awcache(axi_hp2_interconnect_to_s00_couplers_AWCACHE),
        .S_AXI_awlen(axi_hp2_interconnect_to_s00_couplers_AWLEN),
        .S_AXI_awprot(axi_hp2_interconnect_to_s00_couplers_AWPROT),
        .S_AXI_awready(axi_hp2_interconnect_to_s00_couplers_AWREADY),
        .S_AXI_awsize(axi_hp2_interconnect_to_s00_couplers_AWSIZE),
        .S_AXI_awvalid(axi_hp2_interconnect_to_s00_couplers_AWVALID),
        .S_AXI_bready(axi_hp2_interconnect_to_s00_couplers_BREADY),
        .S_AXI_bresp(axi_hp2_interconnect_to_s00_couplers_BRESP),
        .S_AXI_bvalid(axi_hp2_interconnect_to_s00_couplers_BVALID),
        .S_AXI_wdata(axi_hp2_interconnect_to_s00_couplers_WDATA),
        .S_AXI_wlast(axi_hp2_interconnect_to_s00_couplers_WLAST),
        .S_AXI_wready(axi_hp2_interconnect_to_s00_couplers_WREADY),
        .S_AXI_wstrb(axi_hp2_interconnect_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(axi_hp2_interconnect_to_s00_couplers_WVALID));
endmodule

module system_axi_hp3_interconnect_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arburst,
    M00_AXI_arcache,
    M00_AXI_arlen,
    M00_AXI_arlock,
    M00_AXI_arprot,
    M00_AXI_arqos,
    M00_AXI_arready,
    M00_AXI_arsize,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awburst,
    M00_AXI_awcache,
    M00_AXI_awlen,
    M00_AXI_awlock,
    M00_AXI_awprot,
    M00_AXI_awqos,
    M00_AXI_awready,
    M00_AXI_awsize,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rlast,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wlast,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arprot,
    S00_AXI_arready,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awprot,
    S00_AXI_awready,
    S00_AXI_awvalid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [31:0]M00_AXI_araddr;
  output [1:0]M00_AXI_arburst;
  output [3:0]M00_AXI_arcache;
  output [7:0]M00_AXI_arlen;
  output [0:0]M00_AXI_arlock;
  output [2:0]M00_AXI_arprot;
  output [3:0]M00_AXI_arqos;
  input M00_AXI_arready;
  output [2:0]M00_AXI_arsize;
  output M00_AXI_arvalid;
  output [31:0]M00_AXI_awaddr;
  output [1:0]M00_AXI_awburst;
  output [3:0]M00_AXI_awcache;
  output [7:0]M00_AXI_awlen;
  output [0:0]M00_AXI_awlock;
  output [2:0]M00_AXI_awprot;
  output [3:0]M00_AXI_awqos;
  input M00_AXI_awready;
  output [2:0]M00_AXI_awsize;
  output M00_AXI_awvalid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [127:0]M00_AXI_rdata;
  input M00_AXI_rlast;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [127:0]M00_AXI_wdata;
  output M00_AXI_wlast;
  input M00_AXI_wready;
  output [15:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [31:0]S00_AXI_araddr;
  input [2:0]S00_AXI_arprot;
  output S00_AXI_arready;
  input S00_AXI_arvalid;
  input [31:0]S00_AXI_awaddr;
  input [2:0]S00_AXI_awprot;
  output S00_AXI_awready;
  input S00_AXI_awvalid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;

  wire S00_ACLK_1;
  wire S00_ARESETN_1;
  wire axi_hp3_interconnect_ACLK_net;
  wire axi_hp3_interconnect_ARESETN_net;
  wire [31:0]axi_hp3_interconnect_to_s00_couplers_ARADDR;
  wire [2:0]axi_hp3_interconnect_to_s00_couplers_ARPROT;
  wire axi_hp3_interconnect_to_s00_couplers_ARREADY;
  wire axi_hp3_interconnect_to_s00_couplers_ARVALID;
  wire [31:0]axi_hp3_interconnect_to_s00_couplers_AWADDR;
  wire [2:0]axi_hp3_interconnect_to_s00_couplers_AWPROT;
  wire axi_hp3_interconnect_to_s00_couplers_AWREADY;
  wire axi_hp3_interconnect_to_s00_couplers_AWVALID;
  wire axi_hp3_interconnect_to_s00_couplers_BREADY;
  wire [1:0]axi_hp3_interconnect_to_s00_couplers_BRESP;
  wire axi_hp3_interconnect_to_s00_couplers_BVALID;
  wire [31:0]axi_hp3_interconnect_to_s00_couplers_RDATA;
  wire axi_hp3_interconnect_to_s00_couplers_RREADY;
  wire [1:0]axi_hp3_interconnect_to_s00_couplers_RRESP;
  wire axi_hp3_interconnect_to_s00_couplers_RVALID;
  wire [31:0]axi_hp3_interconnect_to_s00_couplers_WDATA;
  wire axi_hp3_interconnect_to_s00_couplers_WREADY;
  wire [3:0]axi_hp3_interconnect_to_s00_couplers_WSTRB;
  wire axi_hp3_interconnect_to_s00_couplers_WVALID;
  wire [31:0]s00_couplers_to_axi_hp3_interconnect_ARADDR;
  wire [1:0]s00_couplers_to_axi_hp3_interconnect_ARBURST;
  wire [3:0]s00_couplers_to_axi_hp3_interconnect_ARCACHE;
  wire [7:0]s00_couplers_to_axi_hp3_interconnect_ARLEN;
  wire [0:0]s00_couplers_to_axi_hp3_interconnect_ARLOCK;
  wire [2:0]s00_couplers_to_axi_hp3_interconnect_ARPROT;
  wire [3:0]s00_couplers_to_axi_hp3_interconnect_ARQOS;
  wire s00_couplers_to_axi_hp3_interconnect_ARREADY;
  wire [2:0]s00_couplers_to_axi_hp3_interconnect_ARSIZE;
  wire s00_couplers_to_axi_hp3_interconnect_ARVALID;
  wire [31:0]s00_couplers_to_axi_hp3_interconnect_AWADDR;
  wire [1:0]s00_couplers_to_axi_hp3_interconnect_AWBURST;
  wire [3:0]s00_couplers_to_axi_hp3_interconnect_AWCACHE;
  wire [7:0]s00_couplers_to_axi_hp3_interconnect_AWLEN;
  wire [0:0]s00_couplers_to_axi_hp3_interconnect_AWLOCK;
  wire [2:0]s00_couplers_to_axi_hp3_interconnect_AWPROT;
  wire [3:0]s00_couplers_to_axi_hp3_interconnect_AWQOS;
  wire s00_couplers_to_axi_hp3_interconnect_AWREADY;
  wire [2:0]s00_couplers_to_axi_hp3_interconnect_AWSIZE;
  wire s00_couplers_to_axi_hp3_interconnect_AWVALID;
  wire s00_couplers_to_axi_hp3_interconnect_BREADY;
  wire [1:0]s00_couplers_to_axi_hp3_interconnect_BRESP;
  wire s00_couplers_to_axi_hp3_interconnect_BVALID;
  wire [127:0]s00_couplers_to_axi_hp3_interconnect_RDATA;
  wire s00_couplers_to_axi_hp3_interconnect_RLAST;
  wire s00_couplers_to_axi_hp3_interconnect_RREADY;
  wire [1:0]s00_couplers_to_axi_hp3_interconnect_RRESP;
  wire s00_couplers_to_axi_hp3_interconnect_RVALID;
  wire [127:0]s00_couplers_to_axi_hp3_interconnect_WDATA;
  wire s00_couplers_to_axi_hp3_interconnect_WLAST;
  wire s00_couplers_to_axi_hp3_interconnect_WREADY;
  wire [15:0]s00_couplers_to_axi_hp3_interconnect_WSTRB;
  wire s00_couplers_to_axi_hp3_interconnect_WVALID;

  assign M00_AXI_araddr[31:0] = s00_couplers_to_axi_hp3_interconnect_ARADDR;
  assign M00_AXI_arburst[1:0] = s00_couplers_to_axi_hp3_interconnect_ARBURST;
  assign M00_AXI_arcache[3:0] = s00_couplers_to_axi_hp3_interconnect_ARCACHE;
  assign M00_AXI_arlen[7:0] = s00_couplers_to_axi_hp3_interconnect_ARLEN;
  assign M00_AXI_arlock[0] = s00_couplers_to_axi_hp3_interconnect_ARLOCK;
  assign M00_AXI_arprot[2:0] = s00_couplers_to_axi_hp3_interconnect_ARPROT;
  assign M00_AXI_arqos[3:0] = s00_couplers_to_axi_hp3_interconnect_ARQOS;
  assign M00_AXI_arsize[2:0] = s00_couplers_to_axi_hp3_interconnect_ARSIZE;
  assign M00_AXI_arvalid = s00_couplers_to_axi_hp3_interconnect_ARVALID;
  assign M00_AXI_awaddr[31:0] = s00_couplers_to_axi_hp3_interconnect_AWADDR;
  assign M00_AXI_awburst[1:0] = s00_couplers_to_axi_hp3_interconnect_AWBURST;
  assign M00_AXI_awcache[3:0] = s00_couplers_to_axi_hp3_interconnect_AWCACHE;
  assign M00_AXI_awlen[7:0] = s00_couplers_to_axi_hp3_interconnect_AWLEN;
  assign M00_AXI_awlock[0] = s00_couplers_to_axi_hp3_interconnect_AWLOCK;
  assign M00_AXI_awprot[2:0] = s00_couplers_to_axi_hp3_interconnect_AWPROT;
  assign M00_AXI_awqos[3:0] = s00_couplers_to_axi_hp3_interconnect_AWQOS;
  assign M00_AXI_awsize[2:0] = s00_couplers_to_axi_hp3_interconnect_AWSIZE;
  assign M00_AXI_awvalid = s00_couplers_to_axi_hp3_interconnect_AWVALID;
  assign M00_AXI_bready = s00_couplers_to_axi_hp3_interconnect_BREADY;
  assign M00_AXI_rready = s00_couplers_to_axi_hp3_interconnect_RREADY;
  assign M00_AXI_wdata[127:0] = s00_couplers_to_axi_hp3_interconnect_WDATA;
  assign M00_AXI_wlast = s00_couplers_to_axi_hp3_interconnect_WLAST;
  assign M00_AXI_wstrb[15:0] = s00_couplers_to_axi_hp3_interconnect_WSTRB;
  assign M00_AXI_wvalid = s00_couplers_to_axi_hp3_interconnect_WVALID;
  assign S00_ACLK_1 = S00_ACLK;
  assign S00_ARESETN_1 = S00_ARESETN;
  assign S00_AXI_arready = axi_hp3_interconnect_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = axi_hp3_interconnect_to_s00_couplers_AWREADY;
  assign S00_AXI_bresp[1:0] = axi_hp3_interconnect_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = axi_hp3_interconnect_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[31:0] = axi_hp3_interconnect_to_s00_couplers_RDATA;
  assign S00_AXI_rresp[1:0] = axi_hp3_interconnect_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = axi_hp3_interconnect_to_s00_couplers_RVALID;
  assign S00_AXI_wready = axi_hp3_interconnect_to_s00_couplers_WREADY;
  assign axi_hp3_interconnect_ACLK_net = M00_ACLK;
  assign axi_hp3_interconnect_ARESETN_net = M00_ARESETN;
  assign axi_hp3_interconnect_to_s00_couplers_ARADDR = S00_AXI_araddr[31:0];
  assign axi_hp3_interconnect_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign axi_hp3_interconnect_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign axi_hp3_interconnect_to_s00_couplers_AWADDR = S00_AXI_awaddr[31:0];
  assign axi_hp3_interconnect_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign axi_hp3_interconnect_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign axi_hp3_interconnect_to_s00_couplers_BREADY = S00_AXI_bready;
  assign axi_hp3_interconnect_to_s00_couplers_RREADY = S00_AXI_rready;
  assign axi_hp3_interconnect_to_s00_couplers_WDATA = S00_AXI_wdata[31:0];
  assign axi_hp3_interconnect_to_s00_couplers_WSTRB = S00_AXI_wstrb[3:0];
  assign axi_hp3_interconnect_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign s00_couplers_to_axi_hp3_interconnect_ARREADY = M00_AXI_arready;
  assign s00_couplers_to_axi_hp3_interconnect_AWREADY = M00_AXI_awready;
  assign s00_couplers_to_axi_hp3_interconnect_BRESP = M00_AXI_bresp[1:0];
  assign s00_couplers_to_axi_hp3_interconnect_BVALID = M00_AXI_bvalid;
  assign s00_couplers_to_axi_hp3_interconnect_RDATA = M00_AXI_rdata[127:0];
  assign s00_couplers_to_axi_hp3_interconnect_RLAST = M00_AXI_rlast;
  assign s00_couplers_to_axi_hp3_interconnect_RRESP = M00_AXI_rresp[1:0];
  assign s00_couplers_to_axi_hp3_interconnect_RVALID = M00_AXI_rvalid;
  assign s00_couplers_to_axi_hp3_interconnect_WREADY = M00_AXI_wready;
  s00_couplers_imp_MCTRXI s00_couplers
       (.M_ACLK(axi_hp3_interconnect_ACLK_net),
        .M_ARESETN(axi_hp3_interconnect_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_axi_hp3_interconnect_ARADDR),
        .M_AXI_arburst(s00_couplers_to_axi_hp3_interconnect_ARBURST),
        .M_AXI_arcache(s00_couplers_to_axi_hp3_interconnect_ARCACHE),
        .M_AXI_arlen(s00_couplers_to_axi_hp3_interconnect_ARLEN),
        .M_AXI_arlock(s00_couplers_to_axi_hp3_interconnect_ARLOCK),
        .M_AXI_arprot(s00_couplers_to_axi_hp3_interconnect_ARPROT),
        .M_AXI_arqos(s00_couplers_to_axi_hp3_interconnect_ARQOS),
        .M_AXI_arready(s00_couplers_to_axi_hp3_interconnect_ARREADY),
        .M_AXI_arsize(s00_couplers_to_axi_hp3_interconnect_ARSIZE),
        .M_AXI_arvalid(s00_couplers_to_axi_hp3_interconnect_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_axi_hp3_interconnect_AWADDR),
        .M_AXI_awburst(s00_couplers_to_axi_hp3_interconnect_AWBURST),
        .M_AXI_awcache(s00_couplers_to_axi_hp3_interconnect_AWCACHE),
        .M_AXI_awlen(s00_couplers_to_axi_hp3_interconnect_AWLEN),
        .M_AXI_awlock(s00_couplers_to_axi_hp3_interconnect_AWLOCK),
        .M_AXI_awprot(s00_couplers_to_axi_hp3_interconnect_AWPROT),
        .M_AXI_awqos(s00_couplers_to_axi_hp3_interconnect_AWQOS),
        .M_AXI_awready(s00_couplers_to_axi_hp3_interconnect_AWREADY),
        .M_AXI_awsize(s00_couplers_to_axi_hp3_interconnect_AWSIZE),
        .M_AXI_awvalid(s00_couplers_to_axi_hp3_interconnect_AWVALID),
        .M_AXI_bready(s00_couplers_to_axi_hp3_interconnect_BREADY),
        .M_AXI_bresp(s00_couplers_to_axi_hp3_interconnect_BRESP),
        .M_AXI_bvalid(s00_couplers_to_axi_hp3_interconnect_BVALID),
        .M_AXI_rdata(s00_couplers_to_axi_hp3_interconnect_RDATA),
        .M_AXI_rlast(s00_couplers_to_axi_hp3_interconnect_RLAST),
        .M_AXI_rready(s00_couplers_to_axi_hp3_interconnect_RREADY),
        .M_AXI_rresp(s00_couplers_to_axi_hp3_interconnect_RRESP),
        .M_AXI_rvalid(s00_couplers_to_axi_hp3_interconnect_RVALID),
        .M_AXI_wdata(s00_couplers_to_axi_hp3_interconnect_WDATA),
        .M_AXI_wlast(s00_couplers_to_axi_hp3_interconnect_WLAST),
        .M_AXI_wready(s00_couplers_to_axi_hp3_interconnect_WREADY),
        .M_AXI_wstrb(s00_couplers_to_axi_hp3_interconnect_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_axi_hp3_interconnect_WVALID),
        .S_ACLK(S00_ACLK_1),
        .S_ARESETN(S00_ARESETN_1),
        .S_AXI_araddr(axi_hp3_interconnect_to_s00_couplers_ARADDR),
        .S_AXI_arprot(axi_hp3_interconnect_to_s00_couplers_ARPROT),
        .S_AXI_arready(axi_hp3_interconnect_to_s00_couplers_ARREADY),
        .S_AXI_arvalid(axi_hp3_interconnect_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(axi_hp3_interconnect_to_s00_couplers_AWADDR),
        .S_AXI_awprot(axi_hp3_interconnect_to_s00_couplers_AWPROT),
        .S_AXI_awready(axi_hp3_interconnect_to_s00_couplers_AWREADY),
        .S_AXI_awvalid(axi_hp3_interconnect_to_s00_couplers_AWVALID),
        .S_AXI_bready(axi_hp3_interconnect_to_s00_couplers_BREADY),
        .S_AXI_bresp(axi_hp3_interconnect_to_s00_couplers_BRESP),
        .S_AXI_bvalid(axi_hp3_interconnect_to_s00_couplers_BVALID),
        .S_AXI_rdata(axi_hp3_interconnect_to_s00_couplers_RDATA),
        .S_AXI_rready(axi_hp3_interconnect_to_s00_couplers_RREADY),
        .S_AXI_rresp(axi_hp3_interconnect_to_s00_couplers_RRESP),
        .S_AXI_rvalid(axi_hp3_interconnect_to_s00_couplers_RVALID),
        .S_AXI_wdata(axi_hp3_interconnect_to_s00_couplers_WDATA),
        .S_AXI_wready(axi_hp3_interconnect_to_s00_couplers_WREADY),
        .S_AXI_wstrb(axi_hp3_interconnect_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(axi_hp3_interconnect_to_s00_couplers_WVALID));
endmodule

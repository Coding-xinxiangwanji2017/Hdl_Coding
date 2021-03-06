 








// (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.

`timescale 1ns/1ps

module system_sys_ps8_0 (
maxihpm0_lpd_aclk, 
maxigp2_awid, 
maxigp2_awaddr, 
maxigp2_awlen, 
maxigp2_awsize, 
maxigp2_awburst, 
maxigp2_awlock, 
maxigp2_awcache, 
maxigp2_awprot, 
maxigp2_awvalid, 
maxigp2_awuser, 
maxigp2_awready, 
maxigp2_wdata, 
maxigp2_wstrb, 
maxigp2_wlast, 
maxigp2_wvalid, 
maxigp2_wready, 
maxigp2_bid, 
maxigp2_bresp, 
maxigp2_bvalid, 
maxigp2_bready, 
maxigp2_arid, 
maxigp2_araddr, 
maxigp2_arlen, 
maxigp2_arsize, 
maxigp2_arburst, 
maxigp2_arlock, 
maxigp2_arcache, 
maxigp2_arprot, 
maxigp2_arvalid, 
maxigp2_aruser, 
maxigp2_arready, 
maxigp2_rid, 
maxigp2_rdata, 
maxigp2_rresp, 
maxigp2_rlast, 
maxigp2_rvalid, 
maxigp2_rready, 
maxigp2_awqos, 
maxigp2_arqos, 
saxihp1_fpd_aclk, 
saxigp3_aruser, 
saxigp3_awuser, 
saxigp3_awid, 
saxigp3_awaddr, 
saxigp3_awlen, 
saxigp3_awsize, 
saxigp3_awburst, 
saxigp3_awlock, 
saxigp3_awcache, 
saxigp3_awprot, 
saxigp3_awvalid, 
saxigp3_awready, 
saxigp3_wdata, 
saxigp3_wstrb, 
saxigp3_wlast, 
saxigp3_wvalid, 
saxigp3_wready, 
saxigp3_bid, 
saxigp3_bresp, 
saxigp3_bvalid, 
saxigp3_bready, 
saxigp3_arid, 
saxigp3_araddr, 
saxigp3_arlen, 
saxigp3_arsize, 
saxigp3_arburst, 
saxigp3_arlock, 
saxigp3_arcache, 
saxigp3_arprot, 
saxigp3_arvalid, 
saxigp3_arready, 
saxigp3_rid, 
saxigp3_rdata, 
saxigp3_rresp, 
saxigp3_rlast, 
saxigp3_rvalid, 
saxigp3_rready, 
saxigp3_awqos, 
saxigp3_arqos, 
saxihp2_fpd_aclk, 
saxigp4_aruser, 
saxigp4_awuser, 
saxigp4_awid, 
saxigp4_awaddr, 
saxigp4_awlen, 
saxigp4_awsize, 
saxigp4_awburst, 
saxigp4_awlock, 
saxigp4_awcache, 
saxigp4_awprot, 
saxigp4_awvalid, 
saxigp4_awready, 
saxigp4_wdata, 
saxigp4_wstrb, 
saxigp4_wlast, 
saxigp4_wvalid, 
saxigp4_wready, 
saxigp4_bid, 
saxigp4_bresp, 
saxigp4_bvalid, 
saxigp4_bready, 
saxigp4_arid, 
saxigp4_araddr, 
saxigp4_arlen, 
saxigp4_arsize, 
saxigp4_arburst, 
saxigp4_arlock, 
saxigp4_arcache, 
saxigp4_arprot, 
saxigp4_arvalid, 
saxigp4_arready, 
saxigp4_rid, 
saxigp4_rdata, 
saxigp4_rresp, 
saxigp4_rlast, 
saxigp4_rvalid, 
saxigp4_rready, 
saxigp4_awqos, 
saxigp4_arqos, 
saxihp3_fpd_aclk, 
saxigp5_aruser, 
saxigp5_awuser, 
saxigp5_awid, 
saxigp5_awaddr, 
saxigp5_awlen, 
saxigp5_awsize, 
saxigp5_awburst, 
saxigp5_awlock, 
saxigp5_awcache, 
saxigp5_awprot, 
saxigp5_awvalid, 
saxigp5_awready, 
saxigp5_wdata, 
saxigp5_wstrb, 
saxigp5_wlast, 
saxigp5_wvalid, 
saxigp5_wready, 
saxigp5_bid, 
saxigp5_bresp, 
saxigp5_bvalid, 
saxigp5_bready, 
saxigp5_arid, 
saxigp5_araddr, 
saxigp5_arlen, 
saxigp5_arsize, 
saxigp5_arburst, 
saxigp5_arlock, 
saxigp5_arcache, 
saxigp5_arprot, 
saxigp5_arvalid, 
saxigp5_arready, 
saxigp5_rid, 
saxigp5_rdata, 
saxigp5_rresp, 
saxigp5_rlast, 
saxigp5_rvalid, 
saxigp5_rready, 
saxigp5_awqos, 
saxigp5_arqos, 
emio_gpio_i, 
emio_gpio_o, 
emio_gpio_t, 
emio_spi0_sclk_i, 
emio_spi0_sclk_o, 
emio_spi0_sclk_t, 
emio_spi0_m_i, 
emio_spi0_m_o, 
emio_spi0_mo_t, 
emio_spi0_s_i, 
emio_spi0_s_o, 
emio_spi0_so_t, 
emio_spi0_ss_i_n, 
emio_spi0_ss_o_n, 
emio_spi0_ss1_o_n, 
emio_spi0_ss2_o_n, 
emio_spi0_ss_n_t, 
emio_spi1_sclk_i, 
emio_spi1_sclk_o, 
emio_spi1_sclk_t, 
emio_spi1_m_i, 
emio_spi1_m_o, 
emio_spi1_mo_t, 
emio_spi1_s_i, 
emio_spi1_s_o, 
emio_spi1_so_t, 
emio_spi1_ss_i_n, 
emio_spi1_ss_o_n, 
emio_spi1_ss1_o_n, 
emio_spi1_ss2_o_n, 
emio_spi1_ss_n_t, 
pl_ps_irq0, 
pl_ps_irq1, 
pl_resetn0, 
pl_clk0, 
pl_clk1 
);
input maxihpm0_lpd_aclk;
output [15 : 0] maxigp2_awid;
output [39 : 0] maxigp2_awaddr;
output [7 : 0] maxigp2_awlen;
output [2 : 0] maxigp2_awsize;
output [1 : 0] maxigp2_awburst;
output maxigp2_awlock;
output [3 : 0] maxigp2_awcache;
output [2 : 0] maxigp2_awprot;
output maxigp2_awvalid;
output [15 : 0] maxigp2_awuser;
input maxigp2_awready;
output [31 : 0] maxigp2_wdata;
output [3 : 0] maxigp2_wstrb;
output maxigp2_wlast;
output maxigp2_wvalid;
input maxigp2_wready;
input [15 : 0] maxigp2_bid;
input [1 : 0] maxigp2_bresp;
input maxigp2_bvalid;
output maxigp2_bready;
output [15 : 0] maxigp2_arid;
output [39 : 0] maxigp2_araddr;
output [7 : 0] maxigp2_arlen;
output [2 : 0] maxigp2_arsize;
output [1 : 0] maxigp2_arburst;
output maxigp2_arlock;
output [3 : 0] maxigp2_arcache;
output [2 : 0] maxigp2_arprot;
output maxigp2_arvalid;
output [15 : 0] maxigp2_aruser;
input maxigp2_arready;
input [15 : 0] maxigp2_rid;
input [31 : 0] maxigp2_rdata;
input [1 : 0] maxigp2_rresp;
input maxigp2_rlast;
input maxigp2_rvalid;
output maxigp2_rready;
output [3 : 0] maxigp2_awqos;
output [3 : 0] maxigp2_arqos;
input saxihp1_fpd_aclk;
input saxigp3_aruser;
input saxigp3_awuser;
input [5 : 0] saxigp3_awid;
input [48 : 0] saxigp3_awaddr;
input [7 : 0] saxigp3_awlen;
input [2 : 0] saxigp3_awsize;
input [1 : 0] saxigp3_awburst;
input saxigp3_awlock;
input [3 : 0] saxigp3_awcache;
input [2 : 0] saxigp3_awprot;
input saxigp3_awvalid;
output saxigp3_awready;
input [127 : 0] saxigp3_wdata;
input [15 : 0] saxigp3_wstrb;
input saxigp3_wlast;
input saxigp3_wvalid;
output saxigp3_wready;
output [5 : 0] saxigp3_bid;
output [1 : 0] saxigp3_bresp;
output saxigp3_bvalid;
input saxigp3_bready;
input [5 : 0] saxigp3_arid;
input [48 : 0] saxigp3_araddr;
input [7 : 0] saxigp3_arlen;
input [2 : 0] saxigp3_arsize;
input [1 : 0] saxigp3_arburst;
input saxigp3_arlock;
input [3 : 0] saxigp3_arcache;
input [2 : 0] saxigp3_arprot;
input saxigp3_arvalid;
output saxigp3_arready;
output [5 : 0] saxigp3_rid;
output [127 : 0] saxigp3_rdata;
output [1 : 0] saxigp3_rresp;
output saxigp3_rlast;
output saxigp3_rvalid;
input saxigp3_rready;
input [3 : 0] saxigp3_awqos;
input [3 : 0] saxigp3_arqos;
input saxihp2_fpd_aclk;
input saxigp4_aruser;
input saxigp4_awuser;
input [5 : 0] saxigp4_awid;
input [48 : 0] saxigp4_awaddr;
input [7 : 0] saxigp4_awlen;
input [2 : 0] saxigp4_awsize;
input [1 : 0] saxigp4_awburst;
input saxigp4_awlock;
input [3 : 0] saxigp4_awcache;
input [2 : 0] saxigp4_awprot;
input saxigp4_awvalid;
output saxigp4_awready;
input [127 : 0] saxigp4_wdata;
input [15 : 0] saxigp4_wstrb;
input saxigp4_wlast;
input saxigp4_wvalid;
output saxigp4_wready;
output [5 : 0] saxigp4_bid;
output [1 : 0] saxigp4_bresp;
output saxigp4_bvalid;
input saxigp4_bready;
input [5 : 0] saxigp4_arid;
input [48 : 0] saxigp4_araddr;
input [7 : 0] saxigp4_arlen;
input [2 : 0] saxigp4_arsize;
input [1 : 0] saxigp4_arburst;
input saxigp4_arlock;
input [3 : 0] saxigp4_arcache;
input [2 : 0] saxigp4_arprot;
input saxigp4_arvalid;
output saxigp4_arready;
output [5 : 0] saxigp4_rid;
output [127 : 0] saxigp4_rdata;
output [1 : 0] saxigp4_rresp;
output saxigp4_rlast;
output saxigp4_rvalid;
input saxigp4_rready;
input [3 : 0] saxigp4_awqos;
input [3 : 0] saxigp4_arqos;
input saxihp3_fpd_aclk;
input saxigp5_aruser;
input saxigp5_awuser;
input [5 : 0] saxigp5_awid;
input [48 : 0] saxigp5_awaddr;
input [7 : 0] saxigp5_awlen;
input [2 : 0] saxigp5_awsize;
input [1 : 0] saxigp5_awburst;
input saxigp5_awlock;
input [3 : 0] saxigp5_awcache;
input [2 : 0] saxigp5_awprot;
input saxigp5_awvalid;
output saxigp5_awready;
input [127 : 0] saxigp5_wdata;
input [15 : 0] saxigp5_wstrb;
input saxigp5_wlast;
input saxigp5_wvalid;
output saxigp5_wready;
output [5 : 0] saxigp5_bid;
output [1 : 0] saxigp5_bresp;
output saxigp5_bvalid;
input saxigp5_bready;
input [5 : 0] saxigp5_arid;
input [48 : 0] saxigp5_araddr;
input [7 : 0] saxigp5_arlen;
input [2 : 0] saxigp5_arsize;
input [1 : 0] saxigp5_arburst;
input saxigp5_arlock;
input [3 : 0] saxigp5_arcache;
input [2 : 0] saxigp5_arprot;
input saxigp5_arvalid;
output saxigp5_arready;
output [5 : 0] saxigp5_rid;
output [127 : 0] saxigp5_rdata;
output [1 : 0] saxigp5_rresp;
output saxigp5_rlast;
output saxigp5_rvalid;
input saxigp5_rready;
input [3 : 0] saxigp5_awqos;
input [3 : 0] saxigp5_arqos;
input [94 : 0] emio_gpio_i;
output [94 : 0] emio_gpio_o;
output [94 : 0] emio_gpio_t;
input emio_spi0_sclk_i;
output emio_spi0_sclk_o;
output emio_spi0_sclk_t;
input emio_spi0_m_i;
output emio_spi0_m_o;
output emio_spi0_mo_t;
input emio_spi0_s_i;
output emio_spi0_s_o;
output emio_spi0_so_t;
input emio_spi0_ss_i_n;
output emio_spi0_ss_o_n;
output emio_spi0_ss1_o_n;
output emio_spi0_ss2_o_n;
output emio_spi0_ss_n_t;
input emio_spi1_sclk_i;
output emio_spi1_sclk_o;
output emio_spi1_sclk_t;
input emio_spi1_m_i;
output emio_spi1_m_o;
output emio_spi1_mo_t;
input emio_spi1_s_i;
output emio_spi1_s_o;
output emio_spi1_so_t;
input emio_spi1_ss_i_n;
output emio_spi1_ss_o_n;
output emio_spi1_ss1_o_n;
output emio_spi1_ss2_o_n;
output emio_spi1_ss_n_t;
input [7 : 0] pl_ps_irq0;
input [7 : 0] pl_ps_irq1;
output pl_resetn0;
output pl_clk0;
output pl_clk1;
wire pl_clk_t[3:0] ;

wire saxihpc0_fpd_rclk_temp;
wire saxihpc0_fpd_wclk_temp;
wire saxihpc1_fpd_rclk_temp;
wire saxihpc1_fpd_wclk_temp;
wire saxihp0_fpd_rclk_temp;
wire saxihp0_fpd_wclk_temp;
wire saxihp1_fpd_rclk_temp;
wire saxihp1_fpd_wclk_temp;
wire saxihp2_fpd_rclk_temp;
wire saxihp2_fpd_wclk_temp;
wire saxihp3_fpd_rclk_temp;
wire saxihp3_fpd_wclk_temp;
wire saxi_lpd_rclk_temp;
wire saxi_lpd_wclk_temp;


assign pl_clk0 = pl_clk_t[0] ;

 assign pl_clk1 = pl_clk_t[1] ;

 assign  pl_clk2 = 1'b0 ;

 assign  pl_clk3 = 1'b0 ;

  
   
   
    assign saxihp1_fpd_rclk_temp  =  saxihp1_fpd_aclk ;
	assign saxihp1_fpd_wclk_temp  =  saxihp1_fpd_aclk ;
   
    assign saxihp2_fpd_rclk_temp  =  saxihp2_fpd_aclk ;
	assign saxihp2_fpd_wclk_temp  =  saxihp2_fpd_aclk ;
   
    assign saxihp3_fpd_rclk_temp  =  saxihp3_fpd_aclk ;
	assign saxihp3_fpd_wclk_temp  =  saxihp3_fpd_aclk ;
   


  


  zynq_ultra_ps_e_vip_v1_0_1 #(
    .C_USE_M_AXI_GP0(0),
    .C_USE_M_AXI_GP1(0),
    .C_USE_M_AXI_GP2(1),
    .C_USE_S_AXI_GP0(0),
    .C_USE_S_AXI_GP1(0),
    .C_USE_S_AXI_GP2(0),
    .C_USE_S_AXI_GP3(1),
    .C_USE_S_AXI_GP4(1),
    .C_USE_S_AXI_GP5(1),
    .C_USE_S_AXI_GP6(0),
    .C_USE_S_AXI_ACP(0),
    .C_USE_S_AXI_ACE(0),
    .C_M_AXI_GP0_DATA_WIDTH(128),
    .C_M_AXI_GP1_DATA_WIDTH(128),
    .C_M_AXI_GP2_DATA_WIDTH(32),
    .C_S_AXI_GP0_DATA_WIDTH(128),
    .C_S_AXI_GP1_DATA_WIDTH(128),
    .C_S_AXI_GP2_DATA_WIDTH(128),
    .C_S_AXI_GP3_DATA_WIDTH(128),
    .C_S_AXI_GP4_DATA_WIDTH(128),
    .C_S_AXI_GP5_DATA_WIDTH(128),
    .C_S_AXI_GP6_DATA_WIDTH(128),
    .C_FCLK_CLK0_FREQ(99.990),
    .C_FCLK_CLK1_FREQ(187.481),
    .C_FCLK_CLK2_FREQ(100),
    .C_FCLK_CLK3_FREQ(100)
  ) inst (
    .MAXIGP0ARVALID(),
    .MAXIGP0AWVALID(),
    .MAXIGP0BREADY(),
    .MAXIGP0RREADY(),
    .MAXIGP0WLAST(),
    .MAXIGP0WVALID(),
    .MAXIGP0ARID(),
    .MAXIGP0ARUSER(),
    .MAXIGP0AWID(),
    .MAXIGP0ARBURST(),
    .MAXIGP0ARLOCK(),
    .MAXIGP0ARSIZE(),
    .MAXIGP0AWBURST(),
    .MAXIGP0AWLOCK(),
    .MAXIGP0AWSIZE(),
    .MAXIGP0ARPROT(),
    .MAXIGP0AWPROT(),
    .MAXIGP0ARADDR(),
    .MAXIGP0AWADDR(),
    .MAXIGP0WDATA(),
    .MAXIGP0AWUSER(),
    .MAXIGP0ARCACHE(),
    .MAXIGP0ARLEN(),
    .MAXIGP0ARQOS(),
    .MAXIGP0AWCACHE(),
    .MAXIGP0AWLEN(),
    .MAXIGP0AWQOS(),
    .MAXIGP0WSTRB(),
    .MAXIGP0ACLK(),
    .MAXIGP0ARREADY(1'B0),
    .MAXIGP0AWREADY(1'B0),
    .MAXIGP0BVALID(1'B0),
    .MAXIGP0RLAST(1'B0),
    .MAXIGP0RVALID(1'B0),
    .MAXIGP0WREADY(1'B0),
    .MAXIGP0BID(12'B0),
    .MAXIGP0RID(12'B0),
    .MAXIGP0BRESP(2'B0),
    .MAXIGP0RRESP(2'B0),
    .MAXIGP0RDATA(32'B0),
    .MAXIGP1ARVALID(),
    .MAXIGP1AWVALID(),
    .MAXIGP1BREADY(),
    .MAXIGP1RREADY(),
    .MAXIGP1WLAST(),
    .MAXIGP1WVALID(),
    .MAXIGP1ARID(),
    .MAXIGP1ARUSER(),
    .MAXIGP1AWID(),
    .MAXIGP1ARBURST(),
    .MAXIGP1ARLOCK(),
    .MAXIGP1ARSIZE(),
    .MAXIGP1AWBURST(),
    .MAXIGP1AWLOCK(),
    .MAXIGP1AWSIZE(),
    .MAXIGP1ARPROT(),
    .MAXIGP1AWPROT(),
    .MAXIGP1ARADDR(),
    .MAXIGP1AWADDR(),
    .MAXIGP1WDATA(),
    .MAXIGP1AWUSER(),
    .MAXIGP1ARCACHE(),
    .MAXIGP1ARLEN(),
    .MAXIGP1ARQOS(),
    .MAXIGP1AWCACHE(),
    .MAXIGP1AWLEN(),
    .MAXIGP1AWQOS(),
    .MAXIGP1WSTRB(),
    .MAXIGP1ACLK(1'B0),
    .MAXIGP1ARREADY(1'B0),
    .MAXIGP1AWREADY(1'B0),
    .MAXIGP1BVALID(1'B0),
    .MAXIGP1RLAST(1'B0),
    .MAXIGP1RVALID(1'B0),
    .MAXIGP1WREADY(1'B0),
    .MAXIGP1BID(12'B0),
    .MAXIGP1RID(12'B0),
    .MAXIGP1BRESP(2'B0),
    .MAXIGP1RRESP(2'B0),
    .MAXIGP1RDATA(32'B0),

    .MAXIGP2ARVALID(maxigp2_arvalid),
    .MAXIGP2AWVALID(maxigp2_awvalid),
    .MAXIGP2BREADY(maxigp2_bready),
    .MAXIGP2RREADY(maxigp2_rready),
    .MAXIGP2WLAST(maxigp2_wlast),
    .MAXIGP2WVALID(maxigp2_wvalid),
    .MAXIGP2ARID(maxigp2_arid),
    .MAXIGP2ARUSER(maxigp2_aruser),
    .MAXIGP2AWID(maxigp2_awid),
    .MAXIGP2ARBURST(maxigp2_arburst),
    .MAXIGP2ARLOCK(maxigp2_arlock),
    .MAXIGP2ARSIZE(maxigp2_arsize),
    .MAXIGP2AWBURST(maxigp2_awburst),
    .MAXIGP2AWLOCK(maxigp2_awlock),
    .MAXIGP2AWSIZE(maxigp2_awsize),
    .MAXIGP2ARPROT(maxigp2_arprot),
    .MAXIGP2AWPROT(maxigp2_awprot),
    .MAXIGP2ARADDR(maxigp2_araddr),
    .MAXIGP2AWADDR(maxigp2_awaddr),
    .MAXIGP2WDATA(maxigp2_wdata),
    .MAXIGP2AWUSER(maxigp2_awuser),
    .MAXIGP2ARCACHE(maxigp2_arcache),
    .MAXIGP2ARLEN(maxigp2_arlen),
    .MAXIGP2ARQOS(maxigp2_arqos),
    .MAXIGP2AWCACHE(maxigp2_awcache),
    .MAXIGP2AWLEN(maxigp2_awlen),
    .MAXIGP2AWQOS(maxigp2_awqos),
    .MAXIGP2WSTRB(maxigp2_wstrb),
    .MAXIGP2ACLK(maxihpm0_lpd_aclk),
    .MAXIGP2ARREADY(maxigp2_arready),
    .MAXIGP2AWREADY(maxigp2_awready),
    .MAXIGP2BVALID(maxigp2_bvalid),
    .MAXIGP2RLAST(maxigp2_rlast),
    .MAXIGP2RVALID(maxigp2_rvalid),
    .MAXIGP2WREADY(maxigp2_wready),
    .MAXIGP2BID(maxigp2_bid),
    .MAXIGP2RID(maxigp2_rid),
    .MAXIGP2BRESP(maxigp2_bresp),
    .MAXIGP2RRESP(maxigp2_rresp),
    .MAXIGP2RDATA(maxigp2_rdata),

    .SAXIGP0RCLK(),
    .SAXIGP0WCLK(),
    .SAXIGP0ARUSER(),
    .SAXIGP0AWUSER(),
    .SAXIGP0RACOUNT(),
    .SAXIGP0WACOUNT(),
    .SAXIGP0RCOUNT(),
    .SAXIGP0WCOUNT(),
    .SAXIGP0ARREADY(),
    .SAXIGP0AWREADY(),
    .SAXIGP0BVALID(),
    .SAXIGP0RLAST(),
    .SAXIGP0RVALID(),
    .SAXIGP0WREADY(),
    .SAXIGP0BRESP(),
    .SAXIGP0RRESP(),
    .SAXIGP0RDATA(),
    .SAXIGP0BID(),
    .SAXIGP0RID(),
    .SAXIGP0ARVALID(1'B0),
    .SAXIGP0AWVALID(1'B0),
    .SAXIGP0BREADY(1'B0),
    .SAXIGP0RREADY(1'B0),
    .SAXIGP0WLAST(1'B0),
    .SAXIGP0WVALID(1'B0),
    .SAXIGP0ARBURST(2'B0),
    .SAXIGP0ARLOCK(2'B0),
    .SAXIGP0ARSIZE(3'B0),
    .SAXIGP0AWBURST(2'B0),
    .SAXIGP0AWLOCK(2'B0),
    .SAXIGP0AWSIZE(3'B0),
    .SAXIGP0ARPROT(3'B0),
    .SAXIGP0AWPROT(3'B0),
    .SAXIGP0ARADDR(32'B0),
    .SAXIGP0AWADDR(32'B0),
    .SAXIGP0WDATA(32'B0),
    .SAXIGP0ARCACHE(4'B0),
    .SAXIGP0ARLEN(4'B0),
    .SAXIGP0ARQOS(4'B0),
    .SAXIGP0AWCACHE(4'B0),
    .SAXIGP0AWLEN(4'B0),
    .SAXIGP0AWQOS(4'B0),
    .SAXIGP0WSTRB(4'B0),
    .SAXIGP0ARID(6'B0),
    .SAXIGP0AWID(6'B0),
    .SAXIGP1RCLK(),
    .SAXIGP1WCLK(),
    .SAXIGP1ARUSER(),
    .SAXIGP1AWUSER(),
    .SAXIGP1RACOUNT(),
    .SAXIGP1WACOUNT(),
    .SAXIGP1RCOUNT(),
    .SAXIGP1WCOUNT(),
    .SAXIGP1ARREADY(),
    .SAXIGP1AWREADY(),
    .SAXIGP1BVALID(),
    .SAXIGP1RLAST(),
    .SAXIGP1RVALID(),
    .SAXIGP1WREADY(),
    .SAXIGP1BRESP(),
    .SAXIGP1RRESP(),
    .SAXIGP1RDATA(),
    .SAXIGP1BID(),
    .SAXIGP1RID(),
    .SAXIGP1ARVALID(1'B0),
    .SAXIGP1AWVALID(1'B0),
    .SAXIGP1BREADY(1'B0),
    .SAXIGP1RREADY(1'B0),
    .SAXIGP1WLAST(1'B0),
    .SAXIGP1WVALID(1'B0),
    .SAXIGP1ARBURST(2'B0),
    .SAXIGP1ARLOCK(2'B0),
    .SAXIGP1ARSIZE(3'B0),
    .SAXIGP1AWBURST(2'B0),
    .SAXIGP1AWLOCK(2'B0),
    .SAXIGP1AWSIZE(3'B0),
    .SAXIGP1ARPROT(3'B0),
    .SAXIGP1AWPROT(3'B0),
    .SAXIGP1ARADDR(32'B0),
    .SAXIGP1AWADDR(32'B0),
    .SAXIGP1WDATA(32'B0),
    .SAXIGP1ARCACHE(4'B0),
    .SAXIGP1ARLEN(4'B0),
    .SAXIGP1ARQOS(4'B0),
    .SAXIGP1AWCACHE(4'B0),
    .SAXIGP1AWLEN(4'B0),
    .SAXIGP1AWQOS(4'B0),
    .SAXIGP1WSTRB(4'B0),
    .SAXIGP1ARID(6'B0),
    .SAXIGP1AWID(6'B0),
    .SAXIGP2RCLK(),
    .SAXIGP2WCLK(),
    .SAXIGP2ARUSER(),
    .SAXIGP2AWUSER(),
    .SAXIGP2RACOUNT(),
    .SAXIGP2WACOUNT(),
    .SAXIGP2RCOUNT(),
    .SAXIGP2WCOUNT(),
    .SAXIGP2ARREADY(),
    .SAXIGP2AWREADY(),
    .SAXIGP2BVALID(),
    .SAXIGP2RLAST(),
    .SAXIGP2RVALID(),
    .SAXIGP2WREADY(),
    .SAXIGP2BRESP(),
    .SAXIGP2RRESP(),
    .SAXIGP2RDATA(),
    .SAXIGP2BID(),
    .SAXIGP2RID(),
    .SAXIGP2ARVALID(1'B0),
    .SAXIGP2AWVALID(1'B0),
    .SAXIGP2BREADY(1'B0),
    .SAXIGP2RREADY(1'B0),
    .SAXIGP2WLAST(1'B0),
    .SAXIGP2WVALID(1'B0),
    .SAXIGP2ARBURST(2'B0),
    .SAXIGP2ARLOCK(2'B0),
    .SAXIGP2ARSIZE(3'B0),
    .SAXIGP2AWBURST(2'B0),
    .SAXIGP2AWLOCK(2'B0),
    .SAXIGP2AWSIZE(3'B0),
    .SAXIGP2ARPROT(3'B0),
    .SAXIGP2AWPROT(3'B0),
    .SAXIGP2ARADDR(32'B0),
    .SAXIGP2AWADDR(32'B0),
    .SAXIGP2WDATA(32'B0),
    .SAXIGP2ARCACHE(4'B0),
    .SAXIGP2ARLEN(4'B0),
    .SAXIGP2ARQOS(4'B0),
    .SAXIGP2AWCACHE(4'B0),
    .SAXIGP2AWLEN(4'B0),
    .SAXIGP2AWQOS(4'B0),
    .SAXIGP2WSTRB(4'B0),
    .SAXIGP2ARID(6'B0),
    .SAXIGP2AWID(6'B0),
    .SAXIGP3RCLK(saxihp1_fpd_rclk_temp),
    .SAXIGP3WCLK(saxihp1_fpd_wclk_temp),
    .SAXIGP3ARUSER(saxigp3_aruser),
    .SAXIGP3AWUSER(saxigp3_awuser),
    .SAXIGP3RACOUNT(saxigp3_racount),
    .SAXIGP3WACOUNT(saxigp3_wacount),
    .SAXIGP3RCOUNT(saxigp3_rcount),
    .SAXIGP3WCOUNT(saxigp3_wcount),
    .SAXIGP3ARREADY(saxigp3_arready),
    .SAXIGP3AWREADY(saxigp3_awready),
    .SAXIGP3BVALID(saxigp3_bvalid),
    .SAXIGP3RLAST(saxigp3_rlast),
    .SAXIGP3RVALID(saxigp3_rvalid),
    .SAXIGP3WREADY(saxigp3_wready),
    .SAXIGP3BRESP(saxigp3_bresp),
    .SAXIGP3RRESP(saxigp3_rresp),
    .SAXIGP3RDATA(saxigp3_rdata),
    .SAXIGP3BID(saxigp3_bid),
    .SAXIGP3RID(saxigp3_rid),
    .SAXIGP3ARVALID(saxigp3_arvalid),
    .SAXIGP3AWVALID(saxigp3_awvalid),
    .SAXIGP3BREADY(saxigp3_bready),
    .SAXIGP3RREADY(saxigp3_rready),
    .SAXIGP3WLAST(saxigp3_wlast),
    .SAXIGP3WVALID(saxigp3_wvalid),
    .SAXIGP3ARBURST(saxigp3_arburst),
    .SAXIGP3ARLOCK(saxigp3_arlock),
    .SAXIGP3ARSIZE(saxigp3_arsize),
    .SAXIGP3AWBURST(saxigp3_awburst),
    .SAXIGP3AWLOCK(saxigp3_awlock),
    .SAXIGP3AWSIZE(saxigp3_awsize),
    .SAXIGP3ARPROT(saxigp3_arprot),
    .SAXIGP3AWPROT(saxigp3_awprot),
    .SAXIGP3ARADDR(saxigp3_araddr),
    .SAXIGP3AWADDR(saxigp3_awaddr),
    .SAXIGP3WDATA(saxigp3_wdata),
    .SAXIGP3ARCACHE(saxigp3_arcache),
    .SAXIGP3ARLEN(saxigp3_arlen),
    .SAXIGP3ARQOS(saxigp3_arqos),
    .SAXIGP3AWCACHE(saxigp3_awcache),
    .SAXIGP3AWLEN(saxigp3_awlen),
    .SAXIGP3AWQOS(saxigp3_awqos),
    .SAXIGP3WSTRB(saxigp3_wstrb),
    .SAXIGP3ARID(saxigp3_arid),
    .SAXIGP3AWID(saxigp3_awid),
    .SAXIGP4RCLK(saxihp2_fpd_rclk_temp),
    .SAXIGP4WCLK(saxihp2_fpd_wclk_temp),
    .SAXIGP4ARUSER(saxigp4_aruser),
    .SAXIGP4AWUSER(saxigp4_awuser),
    .SAXIGP4RACOUNT(saxigp4_racount),
    .SAXIGP4WACOUNT(saxigp4_wacount),
    .SAXIGP4RCOUNT(saxigp4_rcount),
    .SAXIGP4WCOUNT(saxigp4_wcount),
    .SAXIGP4ARREADY(saxigp4_arready),
    .SAXIGP4AWREADY(saxigp4_awready),
    .SAXIGP4BVALID(saxigp4_bvalid),
    .SAXIGP4RLAST(saxigp4_rlast),
    .SAXIGP4RVALID(saxigp4_rvalid),
    .SAXIGP4WREADY(saxigp4_wready),
    .SAXIGP4BRESP(saxigp4_bresp),
    .SAXIGP4RRESP(saxigp4_rresp),
    .SAXIGP4RDATA(saxigp4_rdata),
    .SAXIGP4BID(saxigp4_bid),
    .SAXIGP4RID(saxigp4_rid),
    .SAXIGP4ARVALID(saxigp4_arvalid),
    .SAXIGP4AWVALID(saxigp4_awvalid),
    .SAXIGP4BREADY(saxigp4_bready),
    .SAXIGP4RREADY(saxigp4_rready),
    .SAXIGP4WLAST(saxigp4_wlast),
    .SAXIGP4WVALID(saxigp4_wvalid),
    .SAXIGP4ARBURST(saxigp4_arburst),
    .SAXIGP4ARLOCK(saxigp4_arlock),
    .SAXIGP4ARSIZE(saxigp4_arsize),
    .SAXIGP4AWBURST(saxigp4_awburst),
    .SAXIGP4AWLOCK(saxigp4_awlock),
    .SAXIGP4AWSIZE(saxigp4_awsize),
    .SAXIGP4ARPROT(saxigp4_arprot),
    .SAXIGP4AWPROT(saxigp4_awprot),
    .SAXIGP4ARADDR(saxigp4_araddr),
    .SAXIGP4AWADDR(saxigp4_awaddr),
    .SAXIGP4WDATA(saxigp4_wdata),
    .SAXIGP4ARCACHE(saxigp4_arcache),
    .SAXIGP4ARLEN(saxigp4_arlen),
    .SAXIGP4ARQOS(saxigp4_arqos),
    .SAXIGP4AWCACHE(saxigp4_awcache),
    .SAXIGP4AWLEN(saxigp4_awlen),
    .SAXIGP4AWQOS(saxigp4_awqos),
    .SAXIGP4WSTRB(saxigp4_wstrb),
    .SAXIGP4ARID(saxigp4_arid),
    .SAXIGP4AWID(saxigp4_awid),
    .SAXIGP5RCLK(saxihp3_fpd_rclk_temp),
    .SAXIGP5WCLK(saxihp3_fpd_wclk_temp),
    .SAXIGP5ARUSER(saxigp5_aruser),
    .SAXIGP5AWUSER(saxigp5_awuser),
    .SAXIGP5RACOUNT(saxigp5_racount),
    .SAXIGP5WACOUNT(saxigp5_wacount),
    .SAXIGP5RCOUNT(saxigp5_rcount),
    .SAXIGP5WCOUNT(saxigp5_wcount),
    .SAXIGP5ARREADY(saxigp5_arready),
    .SAXIGP5AWREADY(saxigp5_awready),
    .SAXIGP5BVALID(saxigp5_bvalid),
    .SAXIGP5RLAST(saxigp5_rlast),
    .SAXIGP5RVALID(saxigp5_rvalid),
    .SAXIGP5WREADY(saxigp5_wready),
    .SAXIGP5BRESP(saxigp5_bresp),
    .SAXIGP5RRESP(saxigp5_rresp),
    .SAXIGP5RDATA(saxigp5_rdata),
    .SAXIGP5BID(saxigp5_bid),
    .SAXIGP5RID(saxigp5_rid),
    .SAXIGP5ARVALID(saxigp5_arvalid),
    .SAXIGP5AWVALID(saxigp5_awvalid),
    .SAXIGP5BREADY(saxigp5_bready),
    .SAXIGP5RREADY(saxigp5_rready),
    .SAXIGP5WLAST(saxigp5_wlast),
    .SAXIGP5WVALID(saxigp5_wvalid),
    .SAXIGP5ARBURST(saxigp5_arburst),
    .SAXIGP5ARLOCK(saxigp5_arlock),
    .SAXIGP5ARSIZE(saxigp5_arsize),
    .SAXIGP5AWBURST(saxigp5_awburst),
    .SAXIGP5AWLOCK(saxigp5_awlock),
    .SAXIGP5AWSIZE(saxigp5_awsize),
    .SAXIGP5ARPROT(saxigp5_arprot),
    .SAXIGP5AWPROT(saxigp5_awprot),
    .SAXIGP5ARADDR(saxigp5_araddr),
    .SAXIGP5AWADDR(saxigp5_awaddr),
    .SAXIGP5WDATA(saxigp5_wdata),
    .SAXIGP5ARCACHE(saxigp5_arcache),
    .SAXIGP5ARLEN(saxigp5_arlen),
    .SAXIGP5ARQOS(saxigp5_arqos),
    .SAXIGP5AWCACHE(saxigp5_awcache),
    .SAXIGP5AWLEN(saxigp5_awlen),
    .SAXIGP5AWQOS(saxigp5_awqos),
    .SAXIGP5WSTRB(saxigp5_wstrb),
    .SAXIGP5ARID(saxigp5_arid),
    .SAXIGP5AWID(saxigp5_awid),
    .SAXIGP6RCLK(),
    .SAXIGP6WCLK(),
    .SAXIGP6ARUSER(),
    .SAXIGP6AWUSER(),
    .SAXIGP6RACOUNT(),
    .SAXIGP6WACOUNT(),
    .SAXIGP6RCOUNT(),
    .SAXIGP6WCOUNT(),
    .SAXIGP6ARREADY(),
    .SAXIGP6AWREADY(),
    .SAXIGP6BVALID(),
    .SAXIGP6RLAST(),
    .SAXIGP6RVALID(),
    .SAXIGP6WREADY(),
    .SAXIGP6BRESP(),
    .SAXIGP6RRESP(),
    .SAXIGP6RDATA(),
    .SAXIGP6BID(),
    .SAXIGP6RID(),
    .SAXIGP6ARVALID(1'B0),
    .SAXIGP6AWVALID(1'B0),
    .SAXIGP6BREADY(1'B0),
    .SAXIGP6RREADY(1'B0),
    .SAXIGP6WLAST(1'B0),
    .SAXIGP6WVALID(1'B0),
    .SAXIGP6ARBURST(2'B0),
    .SAXIGP6ARLOCK(2'B0),
    .SAXIGP6ARSIZE(3'B0),
    .SAXIGP6AWBURST(2'B0),
    .SAXIGP6AWLOCK(2'B0),
    .SAXIGP6AWSIZE(3'B0),
    .SAXIGP6ARPROT(3'B0),
    .SAXIGP6AWPROT(3'B0),
    .SAXIGP6ARADDR(32'B0),
    .SAXIGP6AWADDR(32'B0),
    .SAXIGP6WDATA(32'B0),
    .SAXIGP6ARCACHE(4'B0),
    .SAXIGP6ARLEN(4'B0),
    .SAXIGP6ARQOS(4'B0),
    .SAXIGP6AWCACHE(4'B0),
    .SAXIGP6AWLEN(4'B0),
    .SAXIGP6AWQOS(4'B0),
    .SAXIGP6WSTRB(4'B0),
    .SAXIGP6ARID(6'B0),
    .SAXIGP6AWID(6'B0),
    .SAXIACPARREADY(),
    .SAXIACPAWREADY(),
    .SAXIACPBVALID(),
    .SAXIACPRLAST(),
    .SAXIACPRVALID(),
    .SAXIACPWREADY(),
    .SAXIACPBRESP(),
    .SAXIACPRRESP(),
    .SAXIACPBID(),
    .SAXIACPRID(),
    .SAXIACPRDATA(),
    .SAXIACPACLK(1'B0),
    .SAXIACPARVALID(1'B0),
    .SAXIACPAWVALID(1'B0),
    .SAXIACPBREADY(1'B0),
    .SAXIACPRREADY(1'B0),
    .SAXIACPWLAST(1'B0),
    .SAXIACPWVALID(1'B0),
    .SAXIACPARID(3'B0),
    .SAXIACPARPROT(3'B0),
    .SAXIACPAWID(3'B0),
    .SAXIACPAWPROT(3'B0),
    .SAXIACPARADDR(32'B0),
    .SAXIACPAWADDR(32'B0),
    .SAXIACPARCACHE(4'B0),
    .SAXIACPARLEN(4'B0),
    .SAXIACPARQOS(4'B0),
    .SAXIACPAWCACHE(4'B0),
    .SAXIACPAWLEN(4'B0),
    .SAXIACPAWQOS(4'B0),
    .SAXIACPARBURST(2'B0),
    .SAXIACPARLOCK(2'B0),
    .SAXIACPARSIZE(3'B0),
    .SAXIACPAWBURST(2'B0),
    .SAXIACPAWLOCK(2'B0),
    .SAXIACPAWSIZE(3'B0),
    .SAXIACPARUSER(5'B0),
    .SAXIACPAWUSER(5'B0),
    .SAXIACPWDATA(64'B0),
    .SAXIACPWSTRB(8'B0),
.SACEFPDACREADY(),       
.SACEFPDARLOCK(),
.SACEFPDARVALID(),
.SACEFPDAWLOCK(),
.SACEFPDAWVALID(),
.SACEFPDBREADY(),
.SACEFPDCDLAST(),
.SACEFPDCDVALID(),
.SACEFPDCRVALID(),
.SACEFPDRACK(),
.SACEFPDRREADY(),
.SACEFPDWACK(),
.SACEFPDWLAST(),
.SACEFPDWUSER(),
.SACEFPDWVALID(),
.SACEFPDCDDATA(),
.SACEFPDWDATA(),
.SACEFPDARUSER(),
.SACEFPDAWUSER(),
.SACEFPDWSTRB(),
.SACEFPDARBAR(),
.SACEFPDARBURST(),
.SACEFPDARDOMAIN(),
.SACEFPDAWBAR(),
.SACEFPDAWBURST(),
.SACEFPDAWDOMAIN(),
.SACEFPDARPROT(),
.SACEFPDARSIZE(),
.SACEFPDAWPROT(),
.SACEFPDAWSIZE(),
.SACEFPDAWSNOOP(),
.SACEFPDARCACHE(),
.SACEFPDARQOS(),
.SACEFPDARREGION(),
.SACEFPDARSNOOP(),
.SACEFPDAWCACHE(),
.SACEFPDAWQOS(),
.SACEFPDAWREGION(),
.SACEFPDARADDR(),
.SACEFPDAWADDR(),
.SACEFPDCRRESP(),
.SACEFPDARID(),
.SACEFPDAWID(),
.SACEFPDARLEN(),
.SACEFPDAWLEN(),
.SACEFPDACVALID(),
.SACEFPDARREADY(),
.SACEFPDAWREADY(),
.SACEFPDBUSER(),
.SACEFPDBVALID(),
.SACEFPDCDREADY(),
.SACEFPDCRREADY(),
.SACEFPDRLAST(),
.SACEFPDRUSER(),
.SACEFPDRVALID(),
.SACEFPDWREADY(),
.SACEFPDRDATA(),
.SACEFPDBRESP(),
.SACEFPDACPROT(),
.SACEFPDACSNOOP(),
.SACEFPDRRESP(),
.SACEFPDACADDR(),
.SACEFPDBID(),
.SACEFPDRID(),

.PLPSIRQ0(pl_ps_irq0),
.PLPSIRQ1(pl_ps_irq1), 

.PL_RESETN0(pl_resetn0),
.PLCLK({pl_clk_t[3],pl_clk_t[2],pl_clk_t[1],pl_clk_t[0]})
  );

endmodule

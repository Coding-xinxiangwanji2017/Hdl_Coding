// (c) Copyright 1995-2018 Xilinx, Inc. All rights reserved.
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


// IP VLNV: analog.com:user:util_adcfifo:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_axi_ad9680_fifo_0 (
  adc_rst,
  adc_clk,
  adc_wr,
  adc_wdata,
  adc_wovf,
  dma_clk,
  dma_wr,
  dma_wdata,
  dma_wready,
  dma_xfer_req,
  dma_xfer_status
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME adc_rst, POLARITY ACTIVE_HIGH" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 adc_rst RST" *)
input wire adc_rst;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME adc_clk, ASSOCIATED_RESET adc_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN system_util_daq2_xcvr_0_rx_out_clk_0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 adc_clk CLK" *)
input wire adc_clk;
input wire adc_wr;
input wire [127 : 0] adc_wdata;
output wire adc_wovf;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dma_clk, FREQ_HZ 99990000, PHASE 0.000, CLK_DOMAIN system_sys_ps8_0_pl_clk0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 dma_clk CLK" *)
input wire dma_clk;
output wire dma_wr;
output wire [63 : 0] dma_wdata;
input wire dma_wready;
input wire dma_xfer_req;
output wire [3 : 0] dma_xfer_status;

  util_adcfifo #(
    .DEVICE_TYPE(0),
    .ADC_DATA_WIDTH(128),
    .DMA_DATA_WIDTH(64),
    .DMA_READY_ENABLE(1),
    .DMA_ADDRESS_WIDTH(16)
  ) inst (
    .adc_rst(adc_rst),
    .adc_clk(adc_clk),
    .adc_wr(adc_wr),
    .adc_wdata(adc_wdata),
    .adc_wovf(adc_wovf),
    .dma_clk(dma_clk),
    .dma_wr(dma_wr),
    .dma_wdata(dma_wdata),
    .dma_wready(dma_wready),
    .dma_xfer_req(dma_xfer_req),
    .dma_xfer_status(dma_xfer_status)
  );
endmodule

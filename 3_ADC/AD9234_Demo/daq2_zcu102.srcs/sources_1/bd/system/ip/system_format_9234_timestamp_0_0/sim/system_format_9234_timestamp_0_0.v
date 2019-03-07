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


// IP VLNV: zvision:user:format_9234_timestamp:1.0
// IP Revision: 4

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_format_9234_timestamp_0_0 (
  in_0,
  in_1,
  clk,
  clk_2x,
  rst_n,
  trig,
  o_ps_irq,
  out_0,
  out_1,
  i_adc_valid_0,
  i_adc_valid_1,
  o_adc_valid_0,
  o_adc_valid_1,
  i_adc_enable_0,
  i_adc_enable_1,
  o_adc_enable_0,
  o_adc_enable_1,
  waveform_0,
  waveform_1
);

input wire [63 : 0] in_0;
input wire [63 : 0] in_1;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst_n, ASSOCIATED_BUSIF clk, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN system_util_daq2_xcvr_0_rx_out_clk_0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
input wire clk_2x;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *)
input wire rst_n;
input wire trig;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_ps_irq, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 o_ps_irq INTERRUPT" *)
output wire o_ps_irq;
output wire [63 : 0] out_0;
output wire [63 : 0] out_1;
input wire i_adc_valid_0;
input wire i_adc_valid_1;
output wire o_adc_valid_0;
output wire o_adc_valid_1;
input wire i_adc_enable_0;
input wire i_adc_enable_1;
output wire o_adc_enable_0;
output wire o_adc_enable_1;
output wire [11 : 0] waveform_0;
output wire [11 : 0] waveform_1;

  format_9234 #(
    .RECV64_CNT(250),
    .TRIGtoRECV_DELAY(0),
    .TRIGtoPSIRQ_DELAY(0)
  ) inst (
    .in_0(in_0),
    .in_1(in_1),
    .clk(clk),
    .clk_2x(clk_2x),
    .rst_n(rst_n),
    .trig(trig),
    .o_ps_irq(o_ps_irq),
    .out_0(out_0),
    .out_1(out_1),
    .i_adc_valid_0(i_adc_valid_0),
    .i_adc_valid_1(i_adc_valid_1),
    .o_adc_valid_0(o_adc_valid_0),
    .o_adc_valid_1(o_adc_valid_1),
    .i_adc_enable_0(i_adc_enable_0),
    .i_adc_enable_1(i_adc_enable_1),
    .o_adc_enable_0(o_adc_enable_0),
    .o_adc_enable_1(o_adc_enable_1),
    .waveform_0(waveform_0),
    .waveform_1(waveform_1)
  );
endmodule

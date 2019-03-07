//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Wed Sep 19 20:50:17 2018
//Host        : DESKTOP-9BSENP7 running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
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
  input clk_in1_0;
  output clk_out200M;
  input [94:0]gpio_i;
  output [94:0]gpio_o;
  output [94:0]gpio_t;
  output lmfc_clk;
  output lmfc_edge;
  input ps_intr_00;
  input ps_intr_01;
  input ps_intr_02;
  input ps_intr_03;
  input ps_intr_04;
  input ps_intr_05;
  input ps_intr_06;
  input ps_intr_07;
  input ps_intr_08;
  input ps_intr_09;
  input ps_intr_14;
  input ps_intr_15;
  input rx_data_0_n;
  input rx_data_0_p;
  input rx_data_1_n;
  input rx_data_1_p;
  input rx_data_2_n;
  input rx_data_2_p;
  input rx_data_3_n;
  input rx_data_3_p;
  output rx_out_clk;
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
  output start1;
  output tx_data_0_n;
  output tx_data_0_p;
  output tx_data_1_n;
  output tx_data_1_p;
  output tx_data_2_n;
  output tx_data_2_p;
  output tx_data_3_n;
  output tx_data_3_p;

  wire adc_fda;
  wire adc_fdb;
  wire clk_in1_0;
  wire clk_out200M;
  wire [94:0]gpio_i;
  wire [94:0]gpio_o;
  wire [94:0]gpio_t;
  wire lmfc_clk;
  wire lmfc_edge;
  wire ps_intr_00;
  wire ps_intr_01;
  wire ps_intr_02;
  wire ps_intr_03;
  wire ps_intr_04;
  wire ps_intr_05;
  wire ps_intr_06;
  wire ps_intr_07;
  wire ps_intr_08;
  wire ps_intr_09;
  wire ps_intr_14;
  wire ps_intr_15;
  wire rx_data_0_n;
  wire rx_data_0_p;
  wire rx_data_1_n;
  wire rx_data_1_p;
  wire rx_data_2_n;
  wire rx_data_2_p;
  wire rx_data_3_n;
  wire rx_data_3_p;
  wire rx_out_clk;
  wire rx_ref_clk_0;
  wire [0:0]rx_sync_0;
  wire rx_sysref_0;
  wire [2:0]spi0_csn;
  wire spi0_miso;
  wire spi0_mosi;
  wire spi0_sclk;
  wire [2:0]spi1_csn;
  wire spi1_miso;
  wire spi1_mosi;
  wire spi1_sclk;
  wire start1;
  wire tx_data_0_n;
  wire tx_data_0_p;
  wire tx_data_1_n;
  wire tx_data_1_p;
  wire tx_data_2_n;
  wire tx_data_2_p;
  wire tx_data_3_n;
  wire tx_data_3_p;

  system system_i
       (.adc_fda(adc_fda),
        .adc_fdb(adc_fdb),
        .clk_in1_0(clk_in1_0),
        .clk_out200M(clk_out200M),
        .gpio_i(gpio_i),
        .gpio_o(gpio_o),
        .gpio_t(gpio_t),
        .lmfc_clk(lmfc_clk),
        .lmfc_edge(lmfc_edge),
        .ps_intr_00(ps_intr_00),
        .ps_intr_01(ps_intr_01),
        .ps_intr_02(ps_intr_02),
        .ps_intr_03(ps_intr_03),
        .ps_intr_04(ps_intr_04),
        .ps_intr_05(ps_intr_05),
        .ps_intr_06(ps_intr_06),
        .ps_intr_07(ps_intr_07),
        .ps_intr_08(ps_intr_08),
        .ps_intr_09(ps_intr_09),
        .ps_intr_14(ps_intr_14),
        .ps_intr_15(ps_intr_15),
        .rx_data_0_n(rx_data_0_n),
        .rx_data_0_p(rx_data_0_p),
        .rx_data_1_n(rx_data_1_n),
        .rx_data_1_p(rx_data_1_p),
        .rx_data_2_n(rx_data_2_n),
        .rx_data_2_p(rx_data_2_p),
        .rx_data_3_n(rx_data_3_n),
        .rx_data_3_p(rx_data_3_p),
        .rx_out_clk(rx_out_clk),
        .rx_ref_clk_0(rx_ref_clk_0),
        .rx_sync_0(rx_sync_0),
        .rx_sysref_0(rx_sysref_0),
        .spi0_csn(spi0_csn),
        .spi0_miso(spi0_miso),
        .spi0_mosi(spi0_mosi),
        .spi0_sclk(spi0_sclk),
        .spi1_csn(spi1_csn),
        .spi1_miso(spi1_miso),
        .spi1_mosi(spi1_mosi),
        .spi1_sclk(spi1_sclk),
        .start1(start1),
        .tx_data_0_n(tx_data_0_n),
        .tx_data_0_p(tx_data_0_p),
        .tx_data_1_n(tx_data_1_n),
        .tx_data_1_p(tx_data_1_p),
        .tx_data_2_n(tx_data_2_n),
        .tx_data_2_p(tx_data_2_p),
        .tx_data_3_n(tx_data_3_n),
        .tx_data_3_p(tx_data_3_p));
endmodule

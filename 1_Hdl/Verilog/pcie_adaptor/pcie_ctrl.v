//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
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
//-----------------------------------------------------------------------------
// Project    : Series-7 Integrated Block for PCI Express
// File       : PIO.v
// Version    : 1.11
//
// Description:  Programmed I/O module. Design implements 8 KBytes of programmable
//--              memory space. Host processor can access this memory space using
//--              Memory Read 32 and Memory Write 32 TLPs. Design accepts
//--              1 Double Word (DW) payload length on Memory Write 32 TLP and
//--              responds to 1 DW length Memory Read 32 TLPs with a Completion
//--              with Data TLP (1DW payload).
//--
//--------------------------------------------------------------------------------

`timescale 1ns/1ns

module pcie_ctrl #(
  parameter C_DATA_WIDTH = 64,            // RX/TX interface data width

  // Do not override parameters below this line
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8,              // TSTRB width
  parameter TCQ        = 0
)(
  input                         user_clk,
  input                         user_reset,
  input                         user_lnk_up,

  // AXIS local---->pcie core
input                         i_s_axis_tx_tready,
   output  [C_DATA_WIDTH-1:0]    o64_s_axis_tx_tdata,
   output  [KEEP_WIDTH-1:0]      o8_s_axis_tx_tkeep,
   output                        o_s_axis_tx_tlast,
   output                        o_s_axis_tx_tvalid,
  output                        o_tx_src_dsc,

 // AXIS pcie core---->local
   input  [C_DATA_WIDTH-1:0]     i64_m_axis_rx_tdata,
   input  [KEEP_WIDTH-1:0]       i8_m_axis_rx_tkeep,
   input                         i_m_axis_rx_tlast,
   input                         i_m_axis_rx_tvalid,
   output                        o_m_axis_rx_tready,
  input    [21:0]               i22_m_axis_rx_tuser,


  input                         i_cfg_to_turnoff,
  output                        o_cfg_turnoff_ok,

  input [15:0]                  i16_cfg_completer_id,
  
    //pcie	transaction cpci
   input					i_pcie_wr_rdy,
   output					o_pcie_rd_wl_l, //1:rd 0:wr
   output					o_pcie_req,
   output		[26:0]	o27_pcie_addr,
   output		[31:0]	o32_pcie_wr_data,
   input		[31:0]	i32_pcie_rd_data,
   input					i_pcie_rd_valid,
  output		reg		pio_reset_n,
  
  output                        cfg_interrupt,
  input                         cfg_interrupt_rdy,
  output                        cfg_interrupt_assert,
  output    [7:0]               cfg_interrupt_di,
  input     [7:0]               cfg_interrupt_do,
  input     [2:0]               cfg_interrupt_mmenable,
  input                         cfg_interrupt_msienable,
  input                         cfg_interrupt_msixenable,
  input                         cfg_interrupt_msixfm,
  output                        cfg_interrupt_stat,
  output    [4:0]               cfg_pciecap_interrupt_msgnum,
  

  input          i_irq_link_change    ,
  input          i_sync_state_strict    ,  
  input          i_irq_us_start       ,
  output         o_irq_ack_link_change,
  output         o_irq_ack_sync_state_change,
  output         o_irq_ack_us_start   ,
  input  [31:0]  i_irq_link_change_flag   ,
  input  [31:0]  i_irq_us_start_flag   ,
  output         o_us_done            ,
  output         o_rd_eth_fifo_en     ,
  input [35:0]  i_rd_eth_fifo_data    ,
  input          i_ds_rdy             ,
  output         o_wr_eth_fifo_en     ,
  output [35:0]  o_wr_eth_fifo_data   

); // synthesis syn_hier = "hard"


  // Local wires

  wire          w_req_compl;
  wire          w_compl_done;
//  reg           pio_reset_n;
  
  wire [31:0]   interrupt_mask_reg;


  always @(posedge user_clk) begin
    if (user_reset)
        pio_reset_n <= #TCQ 1'b0;
    else
        pio_reset_n <= #TCQ user_lnk_up;
  end



  pcie_ctrl_rw_t  #(
    .C_DATA_WIDTH( C_DATA_WIDTH ),
    .KEEP_WIDTH( KEEP_WIDTH ),
    .TCQ( TCQ )
  ) pcie_ctrl_rw_t_inst (

    .clk( user_clk ),                             // I
    .rst_n( pio_reset_n ),                        // I

    .i_s_axis_tx_tready( i_s_axis_tx_tready ),     // I
    .o64_s_axis_tx_tdata( o64_s_axis_tx_tdata ),   // O
    .o8_s_axis_tx_tkeep( o8_s_axis_tx_tkeep ),     // O
    .o_s_axis_tx_tlast( o_s_axis_tx_tlast ),       // O
    .o_s_axis_tx_tvalid( o_s_axis_tx_tvalid ),     // O
    .o_tx_src_dsc( o_tx_src_dsc ),                 // O

    .i64_m_axis_rx_tdata( i64_m_axis_rx_tdata ),   // I
    .i8_m_axis_rx_tkeep( i8_m_axis_rx_tkeep ),     // I
    .i_m_axis_rx_tlast( i_m_axis_rx_tlast ),       // I
    .i_m_axis_rx_tvalid( i_m_axis_rx_tvalid ),     // I
    .o_m_axis_rx_tready( o_m_axis_rx_tready ),     // O
    .i22_m_axis_rx_tuser ( i22_m_axis_rx_tuser ),  // I

    .o_req_compl(w_req_compl),                     // O
    .o_compl_done(w_compl_done),                   // O

    .i16_cfg_completer_id ( i16_cfg_completer_id ),// I [15:0]
	 
	 .i_pcie_wr_rdy(i_pcie_wr_rdy),
	 .o_pcie_rd_wl_l(o_pcie_rd_wl_l),
	 .o_pcie_req(o_pcie_req),
	 .o27_pcie_addr(o27_pcie_addr),
	 .o32_pcie_wr_data(o32_pcie_wr_data),
	 .i32_pcie_rd_data(i32_pcie_rd_data),
	 .i_pcie_rd_valid(i_pcie_rd_valid),
   .i_irq_link_change     (i_irq_link_change     ),
   .i_sync_state_strict   (i_sync_state_strict),
   .i_irq_us_start        (i_irq_us_start        ),
   .o_irq_ack_link_change (o_irq_ack_link_change ),
   .o_irq_ack_sync_state_change (o_irq_ack_sync_state_change ),
   .o_irq_ack_us_start    (o_irq_ack_us_start    ),
   .i_irq_link_change_flag(i_irq_link_change_flag),
   .i_irq_us_start_flag   (i_irq_us_start_flag   ),  
//   .o_interrupt_mask_reg(interrupt_mask_reg),
  
   .o_us_done          (o_us_done         ), 
   .o_rd_eth_fifo_en   (o_rd_eth_fifo_en  ), 
   .i_rd_eth_fifo_data (i_rd_eth_fifo_data), 
   .i_ds_rdy           (i_ds_rdy          ), 
   .o_wr_eth_fifo_en   (o_wr_eth_fifo_en  ), 
   .o_wr_eth_fifo_data (o_wr_eth_fifo_data),
   
   .cfg_interrupt                 ( cfg_interrupt                ),
   .cfg_interrupt_rdy             ( cfg_interrupt_rdy            ),
   .cfg_interrupt_assert          ( cfg_interrupt_assert         ),
   .cfg_interrupt_di              ( cfg_interrupt_di             ),
   .cfg_interrupt_do              ( cfg_interrupt_do             ),
   .cfg_interrupt_mmenable        ( cfg_interrupt_mmenable       ),
   .cfg_interrupt_msienable       ( cfg_interrupt_msienable      ),
   .cfg_interrupt_msixenable      ( cfg_interrupt_msixenable     ),
   .cfg_interrupt_msixfm          ( cfg_interrupt_msixfm         ),
   .cfg_interrupt_stat            ( cfg_interrupt_stat           ),
   .cfg_pciecap_interrupt_msgnum  ( cfg_pciecap_interrupt_msgnum )
  );


  //
  // Turn-Off controller
  //

  pcie_link #(
    .TCQ( TCQ )
  ) pcie_link_inst  (
    .clk( user_clk ),                       // I
    .rst_n( pio_reset_n ),                  // I

    .i_req_compl( w_req_compl ),                // I
    .i_compl_done( w_compl_done ),              // I

    .i_cfg_to_turnoff( i_cfg_to_turnoff ),      // I
    .o_cfg_turnoff_ok( o_cfg_turnoff_ok )       // O
  );  
  
  
  //////////////////////////////////////////////////////////////////////////////register module////////////////
  
                             


endmodule 


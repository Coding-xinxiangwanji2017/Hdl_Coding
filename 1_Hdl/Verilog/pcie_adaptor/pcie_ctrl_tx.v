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
// File       : PIO_TX_ENGINE.v
// Version    : 1.11
//-- Description: Local-Link Transmit Unit.
//--
//--------------------------------------------------------------------------------

`timescale 1ps/1ps

module pcie_ctrl_tx    #(
  // RX/TX interface data width
  parameter C_DATA_WIDTH = 64,
  parameter TCQ = 0,

  // TSTRB width
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8
)(

  input             clk,
  input             rst_n,

    // AXIS local---->pcie core
   input                         		i_s_axis_tx_tready,
   output  reg[C_DATA_WIDTH-1:0]    	o64_s_axis_tx_tdata,
   output  reg[KEEP_WIDTH-1:0]      	o8_s_axis_tx_tkeep,
   output  reg                      	o_s_axis_tx_tlast,
   output  reg                     	o_s_axis_tx_tvalid,
   output                        	  o_tx_src_dsc,

  input                           i_req_compl,
  input                           i_req_compl_wd,
  output reg                      o_compl_done,
  
  input [2:0]                     i3_req_tc,
  input                           i_req_td,
  input                           i_req_ep,
  input [1:0]                     i2_req_attr,
  input [9:0]                     i10_req_len,
  input [15:0]                    i16_req_rid,
  input [7:0]                     i8_req_tag,
  input [7:0]                     i8_req_be,
  input [26:0]                    i27_req_addr,

  output [26:0]                   o27_rd_addr,
  output reg [3:0]                o4_rd_be,
  input  [31:0]                   o32_rd_data,

  input [15:0]                    i16_completer_id,
  
  //for pcie - cpci
  input									 i_pcie_rd_valid,
  //  output	reg							 o_pcie_rd_req  
	
	input  [31:0]   i_eth_flag_data,
	input           i_eth_flag_rd_req,
	input           i_rd_eth_flag_en,
	input           i_eth_data_rd_req,
	output          o_eth_data_rd_ack,
  input  [31:0]   i_eth_data_rd_len,
  input           i_dma_rd_cmpl_done,
  
    output reg      o_rd_eth_fifo_en   ,
    input  [35:0]   i_rd_eth_fifo_data ,
  
  input           i_eth_data_wr_req,
  output          o_eth_data_wr_ack,
  input  [31:0]   i_eth_data_wr_len,
  input  [31:0]   i_dma_wr_address_reg,
  input  [31:0]   i_dma_rd_address_reg,
  
  output          o_dma_wr_done


);

localparam PIO_CPLD_FMT_TYPE    = 7'b10_01010;
localparam PIO_CPL_FMT_TYPE     = 7'b00_01010;
localparam PIO_MEM_WR_FMT_TYPE  = 7'b10_00000;
localparam PIO_MEM_RD_FMT_TYPE  = 7'b00_00000;

localparam PIO_TX_RST_STATE                = 4'b0000;
localparam PIO_TX_CPLD_QW1_WAIT_RDY        = 4'b0001;
localparam PIO_TX_CPLD_QW1                 = 4'b0011;
localparam PIO_TX_CPLD_QW2                 = 4'b0010;
localparam PIO_TX_RD_MANY_PRE_WAIT_RDY     = 4'b0110;
localparam PIO_TX_RD_MANY_PRE              = 4'b0111;
localparam TX_WAIT_STATE                   = 4'b0101;
localparam DMA_RD_CONTINUE                 = 4'b0100;
localparam PIO_TX_WR_MANY_PRE_WAIT_RDY     = 4'b1100;
localparam PIO_TX_WR_MANY_PRE              = 4'b1101;
localparam PIO_TX_WR_MANY                  = 4'b1111;
localparam PIO_TX_CONTINUE_HEAD            = 4'b1110;
localparam PIO_TX_ERR                      = 4'b1010;


localparam MAX_PAYLOAD_LEN  = 10'h40;
localparam PAD_DATA    = 32'hdead_beaf; // used to stuff the odd frame
  // Local registers

  reg [11:0]              	f12_byte_count;
  reg [28:0]               f29_lower_addr;

//    reg                     f_req_compl_q;
  reg                     f_req_compl_wd_q;
//   reg                     f_pcie_rd_valid1;
//   reg                     f_pcie_rd_valid2;

  // Local wires

  wire                    w_compl_wd;
   reg  [31:0]              current_state_cnt;
     reg  [9:0]              current_tlp_cnt;
  reg  [9:0]              current_payload_len;
  reg                     rd_eth_fifo_en_d1;
  reg                     rd_eth_fifo_en_d2;
  reg                     rd_eth_fifo_en_d3;
  reg                     rd_eth_fifo_en_d4;
  reg                     rd_eth_fifo_en_d5;
  reg  [35:0]             rd_eth_fifo_data_d1;
  reg  [35:0]             rd_eth_fifo_data_d2;
  reg  [35:0]             rd_eth_fifo_data_d3;
  reg  [35:0]             rd_eth_fifo_data_d4;
  reg  [35:0]             rd_eth_fifo_data_d5;
  reg  [35:0]             rd_eth_fifo_data_d6;
  reg  [35:0]             rd_eth_fifo_data_d7;
  reg  [35:0]             rd_eth_fifo_data_d8;
  wire                    delay_en;
  reg                     delay_en_d1;
  reg                     advance_en_d1;
  reg  [3:0]              delay_cnt;
   reg  [3:0]              state_d1;
     reg  [29:0]             dma_wr_remain_len;
  wire                    state_change;
  reg                     nofirst_lowtvalid_data;
   reg                     end_dw_en;
   reg                     end_dw_en_d1;
  reg  [29:0]             dma_wr_address;
  reg  [29:0]             dma_rd_address;
  reg  [29:0]             dma_rd_remain_len;
  reg  [7:0]              dma_rd_tag;
  
  reg  [31:0]             high_dw_tdata;
  reg  [31:0]             low_dw_tdata;
  
  
  reg                     dma_wr_done;
  reg                     dma_wr_done_d1;
  reg                     dma_wr_done_d2;
  
  reg                     pcie_rd_valid;
  reg                     eth_flag_rd_req;
  reg   [3:0]             state;
  //////////////////////////////////////////////////////////////

wire advance_en;
   reg [9:0] advance_cnt;
assign advance_en = i_s_axis_tx_tready && o_s_axis_tx_tvalid;


  // Unused discontinue
  assign o_tx_src_dsc = 1'b0;

  // Present address and byte enable to memory module

  assign o27_rd_addr = i27_req_addr;
 
// always @ (posedge clk)
//    if(!rst_n)begin
//        f_pcie_rd_valid1 <= 0;
//        f_pcie_rd_valid2 <= 0;
//    end else begin
//        f_pcie_rd_valid1 <= i_pcie_rd_valid;
//        f_pcie_rd_valid2 <= f_pcie_rd_valid1;       
//    end
  always @(posedge clk) begin
    if (!rst_n)
     pcie_rd_valid <= #TCQ 0;
    else if(i_pcie_rd_valid)
     pcie_rd_valid <= #TCQ 1'b1;
    else if(state == PIO_TX_CPLD_QW1_WAIT_RDY && state_d1 == PIO_TX_RST_STATE && pcie_rd_valid == 1'b1)
     pcie_rd_valid <= #TCQ 1'b0;
  end

  always @(posedge clk) begin
    if (!rst_n)
     eth_flag_rd_req <= #TCQ 0;
    else if(i_eth_flag_rd_req)
     eth_flag_rd_req <= #TCQ 1'b1;
    else if(state == PIO_TX_CPLD_QW1_WAIT_RDY && state_d1 == PIO_TX_RST_STATE && eth_flag_rd_req == 1'b1)
     eth_flag_rd_req <= #TCQ 1'b0;
  end

  always @(posedge clk) begin
    if (!rst_n)
    begin
     o4_rd_be <= #TCQ 0;
    end else begin
     o4_rd_be <= #TCQ i8_req_be[3:0];
    end
  end

  // Calculate byte count based on byte enable

  always @ (o4_rd_be) begin
    case (o4_rd_be[3:0])
      4'b1111 : f12_byte_count = 12'h004;
      4'b1101 : f12_byte_count = 12'h004;
      4'b1011 : f12_byte_count = 12'h004;
      4'b1001 : f12_byte_count = 12'h004;
      4'b0111 : f12_byte_count = 12'h003;
      4'b0101 : f12_byte_count = 12'h003;
      4'b1110 : f12_byte_count = 12'h003;
      4'b1010 : f12_byte_count = 12'h003;
      4'b0011 : f12_byte_count = 12'h002;
      4'b0110 : f12_byte_count = 12'h002;
      4'b1100 : f12_byte_count = 12'h002;
      4'b0001 : f12_byte_count = 12'h001;
      4'b0010 : f12_byte_count = 12'h001;
      4'b0100 : f12_byte_count = 12'h001;
      4'b1000 : f12_byte_count = 12'h001;
      4'b0000 : f12_byte_count = 12'h001;
      default : f12_byte_count = 12'h000;
    endcase
  end

  always @ ( posedge clk ) begin
    if (!rst_n ) 
    begin
//      f_req_compl_q      <= #TCQ 1'b0;
      f_req_compl_wd_q   <= #TCQ 1'b1;
    end // if !rst_n
    else
    begin
//      f_req_compl_q      <= #TCQ i_req_compl;
      f_req_compl_wd_q   <= #TCQ i_req_compl_wd;
    end // if rst_n
  end


    always @ (o4_rd_be or i27_req_addr or w_compl_wd) begin
    case ({w_compl_wd, o4_rd_be[3:0]})
       5'b1_0000 : f29_lower_addr = {i27_req_addr[26:0], 2'b00};
       5'b1_1111 : f29_lower_addr = {i27_req_addr[26:0], 2'b00};
       5'b1_1101 : f29_lower_addr = {i27_req_addr[26:0], 2'b00};
       5'b1_1011 : f29_lower_addr = {i27_req_addr[26:0], 2'b00};
       5'b1_1001 : f29_lower_addr = {i27_req_addr[26:0], 2'b00};
       5'b1_0111 : f29_lower_addr = {i27_req_addr[26:0], 2'b00};
       5'b1_0101 : f29_lower_addr = {i27_req_addr[26:0], 2'b00};
       5'b1_0011 : f29_lower_addr = {i27_req_addr[26:0], 2'b00};
       5'b1_0001 : f29_lower_addr = {i27_req_addr[26:0], 2'b00};
       5'b1_1110 : f29_lower_addr = {i27_req_addr[26:0], 2'b01};
       5'b1_1010 : f29_lower_addr = {i27_req_addr[26:0], 2'b01};
       5'b1_0110 : f29_lower_addr = {i27_req_addr[26:0], 2'b01};
       5'b1_0010 : f29_lower_addr = {i27_req_addr[26:0], 2'b01};
       5'b1_1100 : f29_lower_addr = {i27_req_addr[26:0], 2'b10};
       5'b1_0100 : f29_lower_addr = {i27_req_addr[26:0], 2'b10};
       5'b1_1000 : f29_lower_addr = {i27_req_addr[26:0], 2'b11};
       5'b0_1111 : f29_lower_addr = 8'h0;
       5'b0_1110 : f29_lower_addr = 8'h0;
       5'b0_1101 : f29_lower_addr = 8'h0;
       5'b0_1100 : f29_lower_addr = 8'h0;
       5'b0_1011 : f29_lower_addr = 8'h0;
       5'b0_1010 : f29_lower_addr = 8'h0;
       5'b0_1001 : f29_lower_addr = 8'h0;
       5'b0_1000 : f29_lower_addr = 8'h0;
       5'b0_0111 : f29_lower_addr = 8'h0;
       5'b0_0110 : f29_lower_addr = 8'h0;
       5'b0_0101 : f29_lower_addr = 8'h0;
       5'b0_0100 : f29_lower_addr = 8'h0;
       5'b0_0011 : f29_lower_addr = 8'h0;
       5'b0_0010 : f29_lower_addr = 8'h0;
       5'b0_0001 : f29_lower_addr = 8'h0;
       5'b0_0000 : f29_lower_addr = 8'h0;
       default   : f29_lower_addr = 8'h0;
    endcase // casex ({w_compl_wd, o4_rd_be[3:0]})
    end

  //  Generate Completion with 1 DW Payload

   
  generate
    if (C_DATA_WIDTH == 64) begin : gen_cpl_64

      assign w_compl_wd = f_req_compl_wd_q;

      always @ ( posedge clk ) begin

        if (!rst_n ) 
        begin
          o_compl_done        <= #TCQ 1'b0;
          state             <= #TCQ PIO_TX_RST_STATE;
          dma_wr_remain_len <= 0;
          nofirst_lowtvalid_data <= 0;
          end_dw_en <= 0;
          current_tlp_cnt <= 0;
          current_payload_len <=0;
          dma_wr_address <= 0;
          o_s_axis_tx_tlast   <= #TCQ 1'b0;
          o_s_axis_tx_tvalid  <= #TCQ 1'b0;
          o64_s_axis_tx_tdata   <= #TCQ {C_DATA_WIDTH{1'b0}};
          o8_s_axis_tx_tkeep   <= #TCQ {KEEP_WIDTH{1'b0}};
          o_rd_eth_fifo_en   <= #TCQ 1'b0;
          dma_rd_tag <= 8'd1;
          dma_wr_done <= 0;
        end // if (!rst_n ) 
        else
        begin

          case ( state )
            PIO_TX_RST_STATE : begin
              dma_wr_done <= 0;
              if (pcie_rd_valid || eth_flag_rd_req) begin
                  
                  // Wait in this state if the PCIe core does not accept
                  // the first beat of the packet
//                  if (advance_en) begin
//                      state             <= #TCQ PIO_TX_CPLD_QW1;
					       
//						end
//                  else
                  state             <= #TCQ PIO_TX_CPLD_QW1_WAIT_RDY;                  

                  o_s_axis_tx_tlast  <= #TCQ 1'b0;
                  o_s_axis_tx_tvalid <= #TCQ 1'b1;
                  // Swap DWORDS for AXI
                  o64_s_axis_tx_tdata  <= #TCQ {                      // Bits
                                        i16_completer_id,             // 16
                                        {3'b0},                   // 3
                                        {1'b0},                   // 1
                                        f12_byte_count,               // 12
                                        {1'b0},                   // 1
                                        (f_req_compl_wd_q ?
                                        PIO_CPLD_FMT_TYPE :
                                        PIO_CPL_FMT_TYPE),        // 7
                                        {1'b0},                   // 1
                                        i3_req_tc,                   // 3
                                        {4'b0},                   // 4
                                        i_req_td,                   // 1
                                        i_req_ep,                   // 1
                                        i2_req_attr,                 // 2
                                        {2'b0},                   // 2
                                        i10_req_len                   // 10
                                        };
                  o8_s_axis_tx_tkeep   <= #TCQ 8'hFF;

              end 
              else if (i_eth_data_wr_req && i_eth_data_wr_len != 32'h0) begin
                  dma_wr_address <= i_dma_wr_address_reg[31:2];
                  if(i_eth_data_wr_len[31:8] != 24'h0) begin // >= 64
                      current_tlp_cnt <= MAX_PAYLOAD_LEN;
                      current_payload_len <= MAX_PAYLOAD_LEN[9:1];
                  end
                  else begin 
                      current_tlp_cnt <= i_eth_data_wr_len[11:2];
                      current_payload_len <= i_eth_data_wr_len[12:3];
                  end
                      
                  if(i_eth_data_wr_len[31:8] != 24'h0) // i_eth_data_wr_len[31:2] >= x40   
                      dma_wr_remain_len <= i_eth_data_wr_len[31:2] - MAX_PAYLOAD_LEN;
                  else 
                      dma_wr_remain_len <= 0;
                      
                  // Wait in this state if the PCIe core does not accept
                  // the first beat of the packet
                  //if (i_s_axis_tx_tready)begin
                  //    state             <= #TCQ PIO_TX_WR_MANY_PRE;
						      //o_pcie_rd_req		<= 1'b1;
                  //end else begin
                      state             <= #TCQ PIO_TX_WR_MANY_PRE_WAIT_RDY;                  
                  //end
                  o_s_axis_tx_tlast  <= #TCQ 1'b0;
                  o_s_axis_tx_tvalid <= #TCQ 1'b1;
                  // Swap DWORDS for AXI
                  o64_s_axis_tx_tdata  <= #TCQ {                      // Bits
                                        {16'b0},                  // 16 requester id
                                        {8'b1},                   // 8  tag
                                        8'b11111111,               // 8 byte enable
                                        {1'b0},                   // 1 reserved
                                        PIO_MEM_WR_FMT_TYPE,      //7 fmt type
                                        {1'b0},                   // 1 reserved
                                        3'b000,                   // 3 tc
                                        {4'b0},                   // 4
                                        1'b0,                   // 1 td
                                        1'b0,                   // 1 ep
                                        2'b0,                   // 2 attr
                                        {2'b0},                   // 2
                                        ((i_eth_data_wr_len[31:8] != 24'h0) ? MAX_PAYLOAD_LEN : i_eth_data_wr_len[11:2])        // 10
                                        };
                  o8_s_axis_tx_tkeep   <= #TCQ 8'hFF;
                  o_rd_eth_fifo_en   <= #TCQ 1'b0;
              end  
			  
			  else if (i_eth_data_wr_req && i_eth_data_wr_len == 32'h0) begin
			    state             <= #TCQ PIO_TX_ERR;
				dma_wr_done <= #TCQ 0;
			  end
			  
              else if (i_eth_data_rd_req) begin
                  dma_rd_address <= i_dma_rd_address_reg[31:2];
                     
                  if(i_eth_data_rd_len[31:8] != 24'h0)  // i_eth_data_rd_len[31:2] >= x40 
                      dma_rd_remain_len <= i_eth_data_rd_len[31:2] - MAX_PAYLOAD_LEN;
                  else 
                      dma_rd_remain_len <= 0;
                      
//                  if (i_s_axis_tx_tready)begin
//                      state             <= #TCQ PIO_TX_RD_MANY_PRE;
//                  end else begin
                      state             <= #TCQ PIO_TX_RD_MANY_PRE_WAIT_RDY;                  
//                  end
                  o_s_axis_tx_tlast  <= #TCQ 1'b0;
                  o_s_axis_tx_tvalid <= #TCQ 1'b1;
                  o64_s_axis_tx_tdata  <= #TCQ {                      // Bits
                                        i16_completer_id,             // 16 requester id
                                        dma_rd_tag,                   // 8  tag
                                        8'hff,               // 8 byte enable
                                        {1'b0},                   // 1 reserved
                                        PIO_MEM_RD_FMT_TYPE,      //7 fmt type
                                        {1'b0},                   // 1 reserved
                                        3'b000,                   // 3 tc
                                        {4'b0},                   // 4
                                        1'b0,                   // 1 td
                                        1'b0,                   // 1 ep
                                        2'b0,                   // 2 attr
                                        {2'b0},                   // 2
                                        ((i_eth_data_rd_len[23:8] != 18'h0) ? 
                                        MAX_PAYLOAD_LEN : i_eth_data_rd_len[11:2])        // 10
                                        };
                  o8_s_axis_tx_tkeep   <= #TCQ 8'hFF;
                  o_rd_eth_fifo_en   <= #TCQ 1'b0;
              end  

              else begin

                o_compl_done        <= #TCQ 1'b0;
                state             <= #TCQ PIO_TX_RST_STATE;
                o_s_axis_tx_tlast   <= #TCQ 1'b0;
                o_s_axis_tx_tvalid  <= #TCQ 1'b0;
                o64_s_axis_tx_tdata   <= #TCQ 64'b0;
                o8_s_axis_tx_tkeep   <= #TCQ 8'hFF;

              end 

            end 
            
            PIO_TX_CPLD_QW1_WAIT_RDY : begin
                if (advance_en) begin
                    state <= PIO_TX_CPLD_QW1;                    
                    o_s_axis_tx_tvalid <= #TCQ 1'b1;
                    if (i_rd_eth_flag_en && i10_req_len == 10'h1) begin
                        o64_s_axis_tx_tdata  <= #TCQ {        // Bits
                                          i_eth_flag_data[7:0],
                                          i_eth_flag_data[15:8],
                                          i_eth_flag_data[23:16],
                                          i_eth_flag_data[31:24],
                                          i16_req_rid,    // 16
                                          i8_req_tag,    //  8
                                          1'b0,                            //  1
                                          f29_lower_addr[6:0]  //  7
                                          };
                        o_s_axis_tx_tlast  <= #TCQ 1'b1;
                    end
                    else if (!i_rd_eth_flag_en && i10_req_len == 10'h1) begin
                        o64_s_axis_tx_tdata  <= #TCQ {        // Bits
                                                                o32_rd_data[7:4],
                                                                o32_rd_data[3:0],
                                                                o32_rd_data[15:12],
                                                                o32_rd_data[11:8],
                                                                o32_rd_data[23:20],
                                                                o32_rd_data[19:16],
                                                                o32_rd_data[31:28],
                                                                o32_rd_data[27:24],    
                                                                i16_req_rid,    // 16
                                                                i8_req_tag,    //  8
                                                                1'b0,                            //  1
                                                                f29_lower_addr[6:0]  //  7
                                                                };
                        o_s_axis_tx_tlast  <= #TCQ 1'b1;
                    end
                    else if (i_rd_eth_flag_en && i10_req_len == 10'h2) begin
                        o64_s_axis_tx_tdata  <= #TCQ {        // Bits
                                          i_eth_flag_data[7:0],
                                          i_eth_flag_data[15:8],
                                          i_eth_flag_data[23:16],
                                          i_eth_flag_data[31:24],
                                          i16_req_rid,    // 16
                                          i8_req_tag,    //  8
                                          1'b0,                            //  1
                                          f29_lower_addr[6:0]  //  7
                                          };
                        o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    end
                    else if (!i_rd_eth_flag_en && i10_req_len == 10'h2) begin
                        o64_s_axis_tx_tdata  <= #TCQ {        // Bits
                                                                o32_rd_data[7:4],
                                                                o32_rd_data[3:0],
                                                                o32_rd_data[15:12],
                                                                o32_rd_data[11:8],
                                                                o32_rd_data[23:20],
                                                                o32_rd_data[19:16],
                                                                o32_rd_data[31:28],
                                                                o32_rd_data[27:24],    
                                                                i16_req_rid,    // 16
                                                                i8_req_tag,    //  8
                                                                1'b0,                            //  1
                                                                f29_lower_addr[6:0]  //  7
                                                                };
                        o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    end

                    
                    if (f_req_compl_wd_q)
                      o8_s_axis_tx_tkeep <= #TCQ 8'hFF;
                    else
                      o8_s_axis_tx_tkeep <= #TCQ 8'h0F;
					 end
                else
                    state <= PIO_TX_CPLD_QW1_WAIT_RDY;
            end
            
            PIO_TX_CPLD_QW1 : begin
                if (advance_en)
                begin               
                    if(i10_req_len == 10'h1) begin
                        o_compl_done        <= #TCQ 1'b1;
                        state             <= #TCQ PIO_TX_RST_STATE;
                        o_s_axis_tx_tlast  <= #TCQ 1'b0;
                        o_s_axis_tx_tvalid <= #TCQ 1'b0;
                        o64_s_axis_tx_tdata  <= #TCQ 64'h0;                   
                        o8_s_axis_tx_tkeep <= #TCQ 8'h00;                   
                    end
					else begin 	  
                        o_compl_done        <= #TCQ 1'b0;
                        state             <= #TCQ PIO_TX_CPLD_QW2;
                        o_s_axis_tx_tlast  <= #TCQ 1'b1;
                        o_s_axis_tx_tvalid <= #TCQ 1'b1;
                        o64_s_axis_tx_tdata  <= #TCQ {        // Bits
                                              32'h0,
                                              PAD_DATA[7:0],
                                              PAD_DATA[15:8],
                                              PAD_DATA[23:16],
                                              PAD_DATA[31:24]
                                              };
                        o8_s_axis_tx_tkeep <= #TCQ 8'h0f;                   
                    end
                end
                else
                    state             <= #TCQ PIO_TX_CPLD_QW1;                
            
            end 

            PIO_TX_CPLD_QW2 : begin
                if (advance_en)
                begin               
                    o_compl_done        <= #TCQ 1'b1;
                    state             <= #TCQ PIO_TX_RST_STATE;
						  
                    o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    o_s_axis_tx_tvalid <= #TCQ 1'b0;
                    o64_s_axis_tx_tdata  <= #TCQ 64'h0;                   
                    o8_s_axis_tx_tkeep <= #TCQ 8'h00;                   
                end 
                else
                    state             <= #TCQ PIO_TX_CPLD_QW2;                
            
            end 

            PIO_TX_RD_MANY_PRE_WAIT_RDY : begin
                if (advance_en) begin
                    state <= PIO_TX_RD_MANY_PRE;
                    o_s_axis_tx_tlast  <= #TCQ 1'b1;
                    o_s_axis_tx_tvalid <= #TCQ 1'b1;
                    o64_s_axis_tx_tdata  <= #TCQ {32'h0,                  //32
                                                  dma_rd_address,   //30
                                                  2'b0                    //2
                                                  };
                    if(dma_rd_tag[7:6] != 2'b00) // dma_rd_tag>= 8'd64
                        dma_rd_tag <= 8'd1;
                    else
                        dma_rd_tag <= dma_rd_tag + 1'b1;
                        
                    o8_s_axis_tx_tkeep <= #TCQ 8'h0F;
			    end
                else
                    state <= PIO_TX_RD_MANY_PRE_WAIT_RDY;
            end
            
            PIO_TX_RD_MANY_PRE : begin
                if (advance_en)
                begin               
                    state             <= #TCQ TX_WAIT_STATE;                   
                    o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    o_s_axis_tx_tvalid <= #TCQ 1'b0;
                    o64_s_axis_tx_tdata  <= #TCQ 0;
           			o8_s_axis_tx_tkeep <= 0;
                end 
                else
                    state             <= #TCQ PIO_TX_RD_MANY_PRE;
            end 
            
            TX_WAIT_STATE: begin
                    o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    o_s_axis_tx_tvalid <= #TCQ 1'b0;
                    o64_s_axis_tx_tdata  <= #TCQ 0;
           					o8_s_axis_tx_tkeep <= 0;
                    if(dma_rd_remain_len != 30'h1 && dma_rd_remain_len != 30'h0)
                        state <= DMA_RD_CONTINUE;
                    else 
                        state <= PIO_TX_RST_STATE;
					end	

            DMA_RD_CONTINUE: begin
                  dma_rd_address <= dma_rd_address + MAX_PAYLOAD_LEN;
                  o_rd_eth_fifo_en   <= #TCQ 1'b0;                 
                       o_s_axis_tx_tlast  <= #TCQ 1'b0;
                      o_s_axis_tx_tvalid <= #TCQ 1'b1;
                      o64_s_axis_tx_tdata  <= #TCQ {                      // Bits
                                            i16_completer_id,             // 16 requester id
                                            dma_rd_tag,                   // 8  tag
                                            8'b11111111,               // 8 byte enable
                                            {1'b0},                   // 1 reserved
                                            PIO_MEM_RD_FMT_TYPE,      //7 fmt type
                                            {1'b0},                   // 1 reserved
                                            3'b000,                   // 3 tc
                                            {4'b0},                   // 4
                                            1'b0,                   // 1 td
                                            1'b0,                   // 1 ep
                                            2'b0,                   // 2 attr
                                            {2'b0},                   // 2
                                            ((dma_rd_remain_len[29:6] != 24'h0) ? MAX_PAYLOAD_LEN : dma_rd_remain_len[9:0])        // 10
                                            };
                      o8_s_axis_tx_tkeep   <= #TCQ 8'hFF;
                      dma_rd_address <= dma_rd_address + MAX_PAYLOAD_LEN;
                      if(dma_rd_remain_len[29:6] != 24'h0) //   dma_rd_remain_len >= x40
                          dma_rd_remain_len <= dma_rd_remain_len - MAX_PAYLOAD_LEN;
                      else 
                          dma_rd_remain_len <= 0;
                     
                  if (advance_en)begin
                      state             <= #TCQ PIO_TX_RD_MANY_PRE;
                      state <= PIO_TX_RD_MANY_PRE;
                      o_s_axis_tx_tlast  <= #TCQ 1'b1;
                      o_s_axis_tx_tvalid <= #TCQ 1'b1;
                      o64_s_axis_tx_tdata  <= #TCQ {32'h0,                  //32
                                                    dma_rd_address,   //30
                                                    2'b0                    //2
                                                    };
                      if(dma_rd_tag[7:6] != 2'b00) //dma_rd_tag >= x40
                          dma_rd_tag <= 8'd1;
                      else
                          dma_rd_tag <= dma_rd_tag + 1'b1;
                        
                      o8_s_axis_tx_tkeep <= #TCQ 8'h0F;
                  end else begin
                      state             <= #TCQ PIO_TX_RD_MANY_PRE_WAIT_RDY;                  
                  end
            end
            
            PIO_TX_WR_MANY_PRE_WAIT_RDY : begin   

                if (advance_en) begin
                    state <= PIO_TX_WR_MANY_PRE;
                end
                else begin
                    state <= PIO_TX_WR_MANY_PRE_WAIT_RDY;                    
                end
				
                o_rd_eth_fifo_en   <= #TCQ 1'b0;
                if (i_s_axis_tx_tready) begin
                    o_s_axis_tx_tvalid <= #TCQ 1'b0;
                end
                else begin
                    o_s_axis_tx_tvalid <= #TCQ 1'b1;
                    
                end

            end
            
            PIO_TX_WR_MANY_PRE : begin
			    dma_wr_done <= 0;
                nofirst_lowtvalid_data <= 0;
                end_dw_en <= 0;
                advance_cnt <=0;
                if(o_rd_eth_fifo_en && current_tlp_cnt != 10'h1 && current_tlp_cnt != 10'h0) //current_tlp_cnt > 10'h1
                    current_tlp_cnt <= current_tlp_cnt - 2'b10;
                else
                    current_tlp_cnt <= current_tlp_cnt;
                
                if(!state_change && current_state_cnt == 8'h9) begin
                    state             <= #TCQ PIO_TX_WR_MANY;
                end 
                else begin
                    state                <= #TCQ PIO_TX_WR_MANY_PRE;
                end          

                o64_s_axis_tx_tdata  <= #TCQ 64'h0;
                o_s_axis_tx_tvalid   <= 0;
                
                if((((current_state_cnt == 8'h0 || current_state_cnt == 8'h1 || current_state_cnt == 8'h2 || current_state_cnt == 8'h3 || current_state_cnt == 8'h4) && !state_change) || state_change) && 
                    ((current_tlp_cnt[9:2] != 8'h0 && o_rd_eth_fifo_en) || // current_tlp_cnt > 10'h3
                    (current_tlp_cnt[9:1] != 9'h0 && !o_rd_eth_fifo_en)))       //current_tlp_cnt > 10'h1
                    o_rd_eth_fifo_en     <= #TCQ 1'b1;
                else 
                    o_rd_eth_fifo_en     <= #TCQ 1'b0;
				
            end
            
            PIO_TX_WR_MANY : begin
					      //o_pcie_rd_req <= 1'b0;	
					      if(advance_en) begin
					          nofirst_lowtvalid_data <= 1;
                    advance_cnt <= advance_cnt + 1;
                end

                if(advance_en && dma_wr_remain_len == 30'h0 && end_dw_en) begin
                    dma_wr_done <= 1;
                    end_dw_en <= 1'b0;
                    state             <= #TCQ PIO_TX_RST_STATE;
                    o64_s_axis_tx_tdata <= 0;
                    o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    o_s_axis_tx_tvalid <= #TCQ 1'b0;
                    o8_s_axis_tx_tkeep <= #TCQ 8'h00;
                end                               
                else if(advance_en && dma_wr_remain_len >  30'h0 && end_dw_en) begin         
                    dma_wr_done <= 0;
                    end_dw_en <= 1'b0;           
                    state             <= #TCQ PIO_TX_CONTINUE_HEAD;
                    o64_s_axis_tx_tdata <= 0;
                    o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    o_s_axis_tx_tvalid <= #TCQ 1'b0;
                    o8_s_axis_tx_tkeep <= #TCQ 8'h00;
                end                               
                else if(advance_en && advance_cnt == (current_payload_len -1)  && !end_dw_en) begin
                    dma_wr_done <= 0;
                    end_dw_en <= 1'b1;
                    state             <= #TCQ PIO_TX_WR_MANY;
                    o64_s_axis_tx_tdata  <= #TCQ {32'h0,
                                                  low_dw_tdata
                                                  };               
                    o_s_axis_tx_tlast  <= #TCQ 1'b1;
                    o_s_axis_tx_tvalid <= #TCQ 1'b1;
                    o8_s_axis_tx_tkeep <= #TCQ 8'h0f;
                end                               
                else if(advance_en && advance_cnt < (current_payload_len -1)) begin                    
                    dma_wr_done <= 0;
                    end_dw_en <= 1'b0;
                    state             <= #TCQ PIO_TX_WR_MANY;
                    o64_s_axis_tx_tdata  <= #TCQ {high_dw_tdata,
                                                  low_dw_tdata
                                                  };          
                    o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    o_s_axis_tx_tvalid <= #TCQ 1'b1;
                    o8_s_axis_tx_tkeep <= #TCQ 8'hff;
                end                               
                else if(state_change) begin
                    dma_wr_done <= 0;
                    end_dw_en <= end_dw_en;
                    state      <= #TCQ PIO_TX_WR_MANY;
                    o64_s_axis_tx_tdata  <= #TCQ {high_dw_tdata,    
                                                  dma_wr_address,   //[31:2] address
                                                  2'b00                    //[1:0]
                                                  };               
                    o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    o_s_axis_tx_tvalid <= #TCQ 1'b1;
                    o8_s_axis_tx_tkeep <= #TCQ 8'hff;
                end

                if(o_rd_eth_fifo_en && current_tlp_cnt[9:1] != 9'h0) //current_tlp_cnt > 10'h1
                    current_tlp_cnt <= current_tlp_cnt - 2'b10;
                else
                    current_tlp_cnt <= current_tlp_cnt;                
                
                if(advance_en && ((current_tlp_cnt[9:2] != 8'h0 && o_rd_eth_fifo_en) || (current_tlp_cnt[9:1] != 9'h0 && !o_rd_eth_fifo_en))) 
                    o_rd_eth_fifo_en <= 1'b1;     
                else
                    o_rd_eth_fifo_en <= 1'b0;
                                                  

            end // PIO_TX_CPLD_QW1
            
            PIO_TX_CONTINUE_HEAD : begin
                //if (i_s_axis_tx_tready)begin
                //    state             <= #TCQ PIO_TX_WR_MANY_PRE;
                //end else begin
                    state             <= #TCQ PIO_TX_WR_MANY_PRE_WAIT_RDY; 
				//end                 
				
                   if(dma_wr_remain_len[29:6] != 24'h0) begin   //>= 64
                        current_tlp_cnt <= MAX_PAYLOAD_LEN;
                        current_payload_len <= MAX_PAYLOAD_LEN[9:1];
                    end
                    else begin
                        current_tlp_cnt <= dma_wr_remain_len[9:0];
                        current_payload_len <= dma_wr_remain_len[9:1];
                    end
                        
                    if(dma_wr_remain_len[29:6] != 24'h0) //dma_wr_remain_len >= 30'h40
                        dma_wr_remain_len <= dma_wr_remain_len - MAX_PAYLOAD_LEN;
                    else 
                        dma_wr_remain_len <= 0;
						
                    dma_wr_done <= 0;
                    dma_wr_address <= dma_wr_address + MAX_PAYLOAD_LEN;
                    o_s_axis_tx_tlast  <= #TCQ 1'b0;
                    o_s_axis_tx_tvalid <= #TCQ 1'b1;
    
                    o64_s_axis_tx_tdata  <= #TCQ {                      // Bits
                                            i16_completer_id,             // 16 requester id
                                            {8'b0},                   // 8  tag
                                            8'b11111111,               // 8 byte enable
                                            {1'b0},                   // 1 reserved
                                            PIO_MEM_WR_FMT_TYPE,      //7 fmt type
                                            {1'b0},                   // 1 reserved
                                            3'b000,                   // 3 tc
                                            {4'b0},                   // 4
                                            1'b0,                   // 1 td
                                            1'b0,                   // 1 ep
                                            2'b0,                   // 2 attr
                                            {2'b0},                   // 2
                                            ((dma_wr_remain_len[29:6] != 24'h0) ? MAX_PAYLOAD_LEN : dma_wr_remain_len[9:0])        // 10
                                            };
                      o_rd_eth_fifo_en   <= #TCQ 1'b0;
                      o8_s_axis_tx_tkeep   <= #TCQ 8'hFF;
                
			 end            
            
			PIO_TX_ERR : begin
			  state             <= #TCQ PIO_TX_RST_STATE;
              o_s_axis_tx_tlast  <= #TCQ 1'b0;
              o_s_axis_tx_tvalid <= #TCQ 1'b0;
    
              o64_s_axis_tx_tdata  <= #TCQ 64'h0;		
              o8_s_axis_tx_tkeep  <= #TCQ  8'h00;
			  
			  dma_wr_done <= #TCQ  1'b1;
			end
			
            default : begin
              // case default stmt
              state             <= #TCQ PIO_TX_RST_STATE;
            end

          endcase
        end // if rst_n
      end
    end
    

  endgenerate

  always @ ( posedge clk ) begin
      if (!rst_n ) begin
          rd_eth_fifo_en_d1 <= 0;
          rd_eth_fifo_en_d2 <= 0;
          rd_eth_fifo_en_d3 <= 0;
          rd_eth_fifo_en_d4 <= 0;
          rd_eth_fifo_en_d5 <= 0;
      end
      else begin
          rd_eth_fifo_en_d1 <= o_rd_eth_fifo_en;
          rd_eth_fifo_en_d2 <= rd_eth_fifo_en_d1;
          rd_eth_fifo_en_d3 <= rd_eth_fifo_en_d2;
          rd_eth_fifo_en_d4 <= rd_eth_fifo_en_d3;
          rd_eth_fifo_en_d5 <= rd_eth_fifo_en_d4;
      end
  end
  
  //assign delay_en = ((!state_change && state == PIO_TX_WR_MANY_PRE && (current_state_cnt == 8'h1 || current_state_cnt == 8'h2 || current_state_cnt == 8'h3 || current_state_cnt == 8'h4 || current_state_cnt == 8'h5)) || 
  //                     (state == PIO_TX_WR_MANY && advance_en)) ? 1'b1 : 1'b0;
  assign delay_en = rd_eth_fifo_en_d1;
  
  always @ ( posedge clk ) begin
      if (!rst_n ) begin
          delay_en_d1 <= 0;
          advance_en_d1 <= 0;
      end
      else begin
          delay_en_d1 <= delay_en;
          advance_en_d1 <= advance_en;
      end
  end
          
  always @ ( posedge clk ) begin
      if (!rst_n ) 
          delay_cnt <= 0;
      else if(!(state == PIO_TX_WR_MANY || state == PIO_TX_WR_MANY_PRE) || (state == PIO_TX_WR_MANY_PRE && state_change))
          delay_cnt <= 0;
      else if(rd_eth_fifo_en_d2 && !advance_en)
          delay_cnt <= delay_cnt + 1'b1;
      else if(advance_en && !rd_eth_fifo_en_d2)
          delay_cnt <= delay_cnt - 1'b1;
  end
          
  always @ ( posedge clk ) begin
      if (!rst_n ) begin
          rd_eth_fifo_data_d1 <= 0;
          rd_eth_fifo_data_d2 <= 0;
          rd_eth_fifo_data_d3 <= 0;
          rd_eth_fifo_data_d4 <= 0;          
          rd_eth_fifo_data_d5 <= 0;
          rd_eth_fifo_data_d6 <= 0;
          rd_eth_fifo_data_d7 <= 0;
          rd_eth_fifo_data_d8 <= 0;
      end
      else if(delay_en) begin
          rd_eth_fifo_data_d1 <= i_rd_eth_fifo_data;
          rd_eth_fifo_data_d2 <= rd_eth_fifo_data_d1;
          rd_eth_fifo_data_d3 <= rd_eth_fifo_data_d2;
          rd_eth_fifo_data_d4 <= rd_eth_fifo_data_d3;
          rd_eth_fifo_data_d5 <= rd_eth_fifo_data_d4;
          rd_eth_fifo_data_d6 <= rd_eth_fifo_data_d5;
          rd_eth_fifo_data_d7 <= rd_eth_fifo_data_d6;
          rd_eth_fifo_data_d8 <= rd_eth_fifo_data_d7;
      end
  end
  
/*   always @( * ) begin
      case (delay_cnt)
          4'd1: if(advance_en && !rd_eth_fifo_en_d2)
                    high_dw_tdata <= {i_rd_eth_fifo_data[7:0],i_rd_eth_fifo_data[15:8],i_rd_eth_fifo_data[23:16],i_rd_eth_fifo_data[31:24]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d2[7:0],rd_eth_fifo_data_d2[15:8],rd_eth_fifo_data_d2[23:16],rd_eth_fifo_data_d2[31:24]};
                else
                    high_dw_tdata <= {rd_eth_fifo_data_d1[7:0],rd_eth_fifo_data_d1[15:8],rd_eth_fifo_data_d1[23:16],rd_eth_fifo_data_d1[31:24]};
          4'd2: if(advance_en && !rd_eth_fifo_en_d2)
                    high_dw_tdata <= {rd_eth_fifo_data_d1[7:0],rd_eth_fifo_data_d1[15:8],rd_eth_fifo_data_d1[23:16],rd_eth_fifo_data_d1[31:24]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d3[7:0],rd_eth_fifo_data_d3[15:8],rd_eth_fifo_data_d3[23:16],rd_eth_fifo_data_d3[31:24]};
                else
                    high_dw_tdata <= {rd_eth_fifo_data_d2[7:0],rd_eth_fifo_data_d2[15:8],rd_eth_fifo_data_d2[23:16],rd_eth_fifo_data_d2[31:24]};
          4'd3: if(advance_en && !rd_eth_fifo_en_d2)
                    high_dw_tdata <= {rd_eth_fifo_data_d2[7:0],rd_eth_fifo_data_d2[15:8],rd_eth_fifo_data_d2[23:16],rd_eth_fifo_data_d2[31:24]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d4[7:0],rd_eth_fifo_data_d4[15:8],rd_eth_fifo_data_d4[23:16],rd_eth_fifo_data_d4[31:24]};
                else
                    high_dw_tdata <= {rd_eth_fifo_data_d3[7:0],rd_eth_fifo_data_d3[15:8],rd_eth_fifo_data_d3[23:16],rd_eth_fifo_data_d3[31:24]};
          4'd4: if(advance_en && !rd_eth_fifo_en_d2) 
                    high_dw_tdata <= {rd_eth_fifo_data_d3[7:0],rd_eth_fifo_data_d3[15:8],rd_eth_fifo_data_d3[23:16],rd_eth_fifo_data_d3[31:24]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d5[7:0],rd_eth_fifo_data_d5[15:8],rd_eth_fifo_data_d5[23:16],rd_eth_fifo_data_d5[31:24]};
                else 
                    high_dw_tdata <= {rd_eth_fifo_data_d4[7:0],rd_eth_fifo_data_d4[15:8],rd_eth_fifo_data_d4[23:16],rd_eth_fifo_data_d4[31:24]};
          4'd5: if(advance_en && !rd_eth_fifo_en_d2)
                    high_dw_tdata <= {rd_eth_fifo_data_d4[7:0],rd_eth_fifo_data_d4[15:8],rd_eth_fifo_data_d4[23:16],rd_eth_fifo_data_d4[31:24]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d6[7:0],rd_eth_fifo_data_d6[15:8],rd_eth_fifo_data_d6[23:16],rd_eth_fifo_data_d6[31:24]};
                else
                    high_dw_tdata <= {rd_eth_fifo_data_d5[7:0],rd_eth_fifo_data_d5[15:8],rd_eth_fifo_data_d5[23:16],rd_eth_fifo_data_d5[31:24]};
          4'd6: if(advance_en && !rd_eth_fifo_en_d2) 
                    high_dw_tdata <= {rd_eth_fifo_data_d5[7:0],rd_eth_fifo_data_d5[15:8],rd_eth_fifo_data_d5[23:16],rd_eth_fifo_data_d5[31:24]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d7[7:0],rd_eth_fifo_data_d7[15:8],rd_eth_fifo_data_d7[23:16],rd_eth_fifo_data_d7[31:24]};
                else 
                    high_dw_tdata <= {rd_eth_fifo_data_d6[7:0],rd_eth_fifo_data_d6[15:8],rd_eth_fifo_data_d6[23:16],rd_eth_fifo_data_d6[31:24]};
          default : high_dw_tdata <= 0;
      endcase
  end */
  always @( * ) begin
      case (delay_cnt)
          4'd1: if(advance_en && !rd_eth_fifo_en_d2)
                    high_dw_tdata <= {i_rd_eth_fifo_data[31:0]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d2[31:0]};
                else
                    high_dw_tdata <= {rd_eth_fifo_data_d1[31:0]};
          4'd2: if(advance_en && !rd_eth_fifo_en_d2)
                    high_dw_tdata <= {rd_eth_fifo_data_d1[31:0]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d3[31:0]};
                else
                    high_dw_tdata <= {rd_eth_fifo_data_d2[31:0]};
          4'd3: if(advance_en && !rd_eth_fifo_en_d2)
                    high_dw_tdata <= {rd_eth_fifo_data_d2[31:0]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d4[31:0]};
                else
                    high_dw_tdata <= {rd_eth_fifo_data_d3[31:0]};
          4'd4: if(advance_en && !rd_eth_fifo_en_d2) 
                    high_dw_tdata <= {rd_eth_fifo_data_d3[31:0]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d5[31:0]};
                else 
                    high_dw_tdata <= {rd_eth_fifo_data_d4[31:0]};
          4'd5: if(advance_en && !rd_eth_fifo_en_d2)
                    high_dw_tdata <= {rd_eth_fifo_data_d4[31:0]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d6[31:0]};
                else
                    high_dw_tdata <= {rd_eth_fifo_data_d5[31:0]};
          4'd6: if(advance_en && !rd_eth_fifo_en_d2) 
                    high_dw_tdata <= {rd_eth_fifo_data_d5[31:0]};
                else if(rd_eth_fifo_en_d3 && !advance_en)    
                    high_dw_tdata <= {rd_eth_fifo_data_d7[31:0]};
                else 
                    high_dw_tdata <= {rd_eth_fifo_data_d6[31:0]};
          default : high_dw_tdata <= 0;
      endcase
  end
  
/*   always @( * ) begin
      case (delay_cnt)
          4'd1: if(advance_en && !rd_eth_fifo_en_d2)
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d1[35:32],24'h0};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d3[35:32],24'h0};
                else
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d2[35:32],24'h0};
          4'd2: if(advance_en && !rd_eth_fifo_en_d2)
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d2[35:32],24'h0};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d4[35:32],24'h0};
                else
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d3[35:32],24'h0};
          4'd3: if(advance_en && !rd_eth_fifo_en_d2)
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d3[35:32],24'h0};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d5[35:32],24'h0};
                else
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d4[35:32],24'h0};
          4'd4: if(advance_en && !rd_eth_fifo_en_d2) 
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d4[35:32],24'h0};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d6[35:32],24'h0};
                else
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d5[35:32],24'h0};
          4'd5: if(advance_en && !rd_eth_fifo_en_d2)
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d5[35:32],24'h0};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d7[35:32],24'h0};
                else
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d6[35:32],24'h0};
          4'd6: if(advance_en && !rd_eth_fifo_en_d2) 
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d6[35:32],24'h0};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d8[35:32],24'h0};
                else
                    low_dw_tdata <= {4'h0,rd_eth_fifo_data_d7[35:32],24'h0};
          default : low_dw_tdata <= 0;
      endcase
  end
 */  always @( * ) begin
      case (delay_cnt)
          4'd1: if(advance_en && !rd_eth_fifo_en_d2)
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d1[35:32]};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d3[35:32]};
                else
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d2[35:32]};
          4'd2: if(advance_en && !rd_eth_fifo_en_d2)
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d2[35:32]};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d4[35:32]};
                else
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d3[35:32]};
          4'd3: if(advance_en && !rd_eth_fifo_en_d2)
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d3[35:32]};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d5[35:32]};
                else
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d4[35:32]};
          4'd4: if(advance_en && !rd_eth_fifo_en_d2) 
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d4[35:32]};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d6[35:32]};
                else
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d5[35:32]};
          4'd5: if(advance_en && !rd_eth_fifo_en_d2)
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d5[35:32]};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d7[35:32]};
                else
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d6[35:32]};
          4'd6: if(advance_en && !rd_eth_fifo_en_d2) 
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d6[35:32]};
                else if(rd_eth_fifo_en_d2 && !advance_en)    
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d8[35:32]};
                else
                    low_dw_tdata <= {24'h0,4'h0,rd_eth_fifo_data_d7[35:32]};
          default : low_dw_tdata <= 0;
      endcase
  end
     
              
  always @ ( posedge clk ) begin
      if (!rst_n ) 
          current_state_cnt <= 0;
      else if(state_change)
          current_state_cnt <= 0;
      else 
          current_state_cnt <= current_state_cnt + 1'b1;
  end

  always @ ( posedge clk ) begin
      if (!rst_n ) begin
          state_d1                 <= 0;
		  end_dw_en_d1             <= 0;
		      dma_wr_done_d1       <= 0;
		      dma_wr_done_d2       <= 0;
      end
      else begin
          state_d1                 <= state;
		  end_dw_en_d1             <= end_dw_en;
		      dma_wr_done_d1       <= dma_wr_done;
		      dma_wr_done_d2       <= dma_wr_done_d1;
      end
  end
  
  assign  o_dma_wr_done = dma_wr_done || dma_wr_done_d1 || dma_wr_done_d2;
  
  assign  state_change = ( state != state_d1 ) ? 1'b1 : 1'b0;
  
  assign  o_eth_data_wr_ack = ((state == PIO_TX_WR_MANY_PRE          && state_d1 == PIO_TX_RST_STATE) || 
                               (state == PIO_TX_WR_MANY_PRE_WAIT_RDY && state_d1 == PIO_TX_RST_STATE)) ? 1'b1 : 1'b0;
  
  assign  o_eth_data_rd_ack = ((state == PIO_TX_RD_MANY_PRE          && state_d1 == PIO_TX_RST_STATE) || 
                               (state == PIO_TX_RD_MANY_PRE_WAIT_RDY && state_d1 == PIO_TX_RST_STATE)) ? 1'b1 : 1'b0;
  
  
endmodule // PIO_TX_ENGINE

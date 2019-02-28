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
// File       : PIO_RX_ENGINE.v
// Version    : 1.11
//--
//-- Description: Local-Link Receive Unit.
//--
//--------------------------------------------------------------------------------

`timescale 1ps/1ps


module pcie_ctrl_recive #(
  parameter TCQ = 0,
  parameter C_DATA_WIDTH = 64,            // RX/TX interface data width

  // Do not override parameters below this line
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8               // TSTRB width
) (
  input                         clk,
  input                         rst_n,

 // AXIS pcie core---->local
  input  [C_DATA_WIDTH-1:0]     i64_m_axis_rx_tdata,
  input  [KEEP_WIDTH-1:0]       i8_m_axis_rx_tkeep,
  input                         i_m_axis_rx_tlast,
  input                         i_m_axis_rx_tvalid,
  output  reg                   o_m_axis_rx_tready,
  input    [21:0]               i22_m_axis_rx_tuser,


  //  Memory Read data handshake with Completion
  //  transmit unit. Transmit unit reponds to
  //  req_compl assertion and responds with compl_done
  //  assertion when a Completion w/ data is transmitted.


  output reg         o_req_compl,
  output reg         o_req_compl_wd,
  input              i_compl_done,

  output reg [2:0]   o3_req_tc,                       // Memory Read TC
  output reg         o_req_td,                        // Memory Read TD
  output reg         o_req_ep,                        // Memory Read EP
  output reg [1:0]   o2_req_attr,                     // Memory Read Attribute
  output reg [9:0]   o10_req_len,                     // Memory Read Length (1DW)
  output reg [15:0]  o16_req_rid,                     // Memory Read Requestor ID
  output reg [7:0]   o8_req_tag,                      // Memory Read Tag
  output reg [7:0]   o8_req_be,                       // Memory Read Byte Enables
  output reg [26:0]  o27_req_addr,                    // Memory Read Address


  // Memory interface used to save 1 DW data received
  // on Memory Write 32 TLP. Data extracted from
  // inbound TLP is presented to the Endpoint memory
  // unit. Endpoint memory unit reacts to wr_en
  // assertion and asserts wr_busy when it is
  // processing written information.


  output reg [26:0]  o27_wr_addr,                       // Memory Write Address
  output reg [7:0]   o8_wr_be,                         // Memory Write Byte Enable
  output reg [31:0]  o32_wr_data,                       // Memory Write Data
//  output reg         o_wr_en,                         // Memory Write Enable
  input              i_wr_busy,                       // Memory Write Busy
  

  input					i_pcie_wr_rdy,
   output	reg			o_pcie_rd_req,

  output	reg			o_pcie_wr_req,

  output reg         o_eth_flag_rd_req          ,
  output reg         o_eth_flag_wr_req ,
	output reg         o_rd_eth_flag_en,
	output reg         o_dma_rd_cmpl_done,
	input [31:0]       i_eth_data_rd_len,
	
	input              i_ds_rdy,
  output reg         o_wr_eth_fifo_en   ,
  output reg [35:0]  o_wr_eth_fifo_data 

  
);

localparam MAX_PAYLOAD_LEN  = 10'h40;

  localparam PIO_RX_MEM_RD32_FMT_TYPE = 7'b00_00000;
  localparam PIO_RX_MEM_WR32_FMT_TYPE = 7'b10_00000;
  localparam RX_CPLD_FMT_TYPE         = 7'b10_01010;

  localparam PIO_RX_RST_STATE            = 4'b0000;
  localparam PIO_RX_MEM_RD32_DW1DW2_PRE  = 4'b0001;
  localparam PIO_RX_MEM_RD32_DW1DW2      = 4'b0011;
  localparam PIO_RX_MEM_WR32_FAKE_READY  = 4'b0010;
  localparam PIO_RX_MEM_WR32_DW1DW2_PRE  = 4'b0110;
  localparam PIO_RX_MEM_WR32_DW1DW2      = 4'b0111;
  localparam PIO_RX_WAIT_STATE           = 4'b0101;
  localparam PIO_RX_IO_MEM_WR_WAIT_STATE = 4'b0100;
  localparam RX_DMA_RD_CPLD              = 4'b1100;
  localparam RX_DMA_RD_CPLD_WAIT         = 4'b1101;
  localparam PIO_RX_ERR_STATE            = 4'b1111;


  // Local Registers

  reg [3:0]          f4_state;   
  reg                state_change;
  reg [7:0]          f_tlp_type;

  reg [31:0]           dma_rd_cpld_num;
  reg [31:0]           wr_eth_fifo_data_high;
  
  wire [31:0]          eth_data_rd_len_minus1;
  wire [31:0]          dma_rd_cpld_num_minus1;
  wire                 advance_en;
  reg  [7:0]           advance_cnt;
  reg   [31:0]         dma_rd_cpld_cnt;
  assign eth_data_rd_len_minus1 = (i_eth_data_rd_len == 32'h0) ? 32'h0 : (i_eth_data_rd_len - 1);
  assign dma_rd_cpld_num_minus1 = dma_rd_cpld_num - 1'b1;
  always @(posedge clk) begin
    if(!rst_n)
      dma_rd_cpld_num <= 0;
    else if(eth_data_rd_len_minus1[7:0] != 8'h00)
        dma_rd_cpld_num <= eth_data_rd_len_minus1[31:8] + 1'b1;
    else
	    dma_rd_cpld_num <= eth_data_rd_len_minus1[31:8];
  end
      
  generate
    if (C_DATA_WIDTH == 64) begin : pio_rx_sm_64
      wire               w_sop;                   // Start of packet
      reg                f_in_packet_q;

      // Generate a signal that indicates if we are currently receiving a packet.
      // This value is one clock cycle delayed from what is actually on the AXIS
      // data bus.
      always@(posedge clk)
      begin
        if(!rst_n)
          f_in_packet_q <= #   TCQ 1'b0;
        else if (i_m_axis_rx_tvalid && i_m_axis_rx_tlast&&o_m_axis_rx_tready)
          f_in_packet_q <= #   TCQ 1'b0;
        else if (w_sop && o_m_axis_rx_tready)
          f_in_packet_q <= #   TCQ 1'b1;
      end

      assign w_sop = !f_in_packet_q && i_m_axis_rx_tvalid;
      assign advance_en = i_m_axis_rx_tvalid && o_m_axis_rx_tready;
      
  always @ ( posedge clk ) begin
      if (!rst_n )
          advance_cnt <= 0;
      else if(i_m_axis_rx_tlast)
          advance_cnt <= 0;
      else if(advance_en && advance_cnt < 8'd128)
          advance_cnt <= advance_cnt + 1;
  end
  
  always @ ( posedge clk ) begin
                      if (!rst_n )begin
          o_m_axis_rx_tready <= #TCQ 1'b0;
//          o_req_compl    	<= #TCQ 1'b0;
//          o_req_compl_wd 	<= #TCQ 1'b1;
          o3_req_tc       	<= #TCQ 3'b0;
          o_req_td       	<= #TCQ 1'b0;
          o_req_ep       	<= #TCQ 1'b0;
          o2_req_attr     	<= #TCQ 2'b0;
          o10_req_len      <= #TCQ 10'b0;
          o16_req_rid      <= #TCQ 16'b0;
          o8_req_tag      	<= #TCQ 8'b0;
          o8_req_be       	<= #TCQ 8'b0;
          o27_req_addr     <= #TCQ 13'b0;		
          o8_wr_be        	<= #TCQ 8'b0;
          o27_wr_addr      <= #TCQ 27'd0;
          o32_wr_data      <= #TCQ 32'b0;
 //         o_wr_en        	<= #TCQ 1'b0;
          f4_state        	<= #TCQ PIO_RX_RST_STATE;
          f_tlp_type     	<= #TCQ 8'b0;			 
//			    o_pcie_wr_req <= 1'b0;
//			    o_pcie_rd_req <= 1'b0;
//				  o_eth_flag_rd_req <= 1'b0;
//				  o_eth_flag_wr_req <= 1'b0;
//				  o_wr_eth_fifo_en <= 0;
//				  o_wr_eth_fifo_data <= 0;
//				  wr_eth_fifo_data_high <= 0;
//				  o_dma_rd_cmpl_done <= 0;
				  dma_rd_cpld_cnt <= 0;
      end else begin
//          o_wr_en        <= #TCQ 1'b0;
            o_req_compl    <= #TCQ 1'b0;
            o_pcie_wr_req <= 1'b0;
            o_pcie_rd_req <= 1'b0;
			      o_eth_flag_rd_req <= 1'b0;
			      o_eth_flag_wr_req <= 1'b0;			      
            case (f4_state)
            PIO_RX_RST_STATE :
            begin
		          o_wr_eth_fifo_en <= #TCQ 0;
		          o_wr_eth_fifo_data <= #TCQ 0;
              o_m_axis_rx_tready <= #TCQ 1'b0;
              o_req_compl_wd     <= #TCQ 1'b1;
              o_pcie_wr_req <= 1'b0;
			        o_dma_rd_cmpl_done <= 0;
			        dma_rd_cpld_cnt <= dma_rd_cpld_cnt;
			        wr_eth_fifo_data_high <= 0;
              if (w_sop)begin
							  case (i64_m_axis_rx_tdata[30:24])
                    
                    PIO_RX_MEM_RD32_FMT_TYPE : begin
									      f_tlp_type     <= #TCQ i64_m_axis_rx_tdata[31:24];
									      o10_req_len    <= #TCQ i64_m_axis_rx_tdata[9:0];
									      //o_pcie_rd_req  <= 1;
									      //o_m_axis_rx_tready <= #TCQ 1'b0;
									      if (i64_m_axis_rx_tdata[9:0] != 10'b0) begin  //((i64_m_axis_rx_tdata[9:0] == 10'b1) || i64_m_axis_rx_tdata[9:0] > 10'b1) begin
                            o3_req_tc     	<= #TCQ i64_m_axis_rx_tdata[22:20];
                            o_req_td     	<= #TCQ i64_m_axis_rx_tdata[15];
                            o_req_ep     	<= #TCQ i64_m_axis_rx_tdata[14];
                            o2_req_attr   	<= #TCQ i64_m_axis_rx_tdata[13:12];
                            o10_req_len    <= #TCQ i64_m_axis_rx_tdata[9:0];
                            o16_req_rid    <= #TCQ i64_m_axis_rx_tdata[63:48];
                            o8_req_tag    	<= #TCQ i64_m_axis_rx_tdata[47:40];
                            o8_req_be     	<= #TCQ i64_m_axis_rx_tdata[39:32];
                            f4_state      	<= #TCQ PIO_RX_MEM_RD32_DW1DW2_PRE;
                            o_m_axis_rx_tready <= #TCQ 1'b1;
									      end else begin
                            f4_state        <= #TCQ PIO_RX_RST_STATE;
                            o_m_axis_rx_tready <= #TCQ 1'b0;
                        end // if !(i64_m_axis_rx_tdata[9:0] == 10'b1)
                    end // PIO_RX_MEM_RD32_FMT_TYPE
						        
								    PIO_RX_MEM_WR32_FMT_TYPE : begin
								        f_tlp_type     <= #TCQ i64_m_axis_rx_tdata[31:24];
								        o10_req_len      <= #TCQ i64_m_axis_rx_tdata[9:0];
                        //o_m_axis_rx_tready <= #TCQ 1'b1;
									      if (i64_m_axis_rx_tdata[9:0] == 10'b1)begin
									  	      o8_wr_be      <= #TCQ i64_m_axis_rx_tdata[39:32];
									  	      f4_state      <= #TCQ PIO_RX_MEM_WR32_DW1DW2_PRE;
									  	      o_m_axis_rx_tready <= #TCQ 1'b1;
									  	  end 
										  else begin
									  	      f4_state      <= #TCQ PIO_RX_MEM_WR32_FAKE_READY;
									  	      o_m_axis_rx_tready <= #TCQ 1'b1;
										  end
                    end // PIO_RX_MEM_WR32_FMT_TYPE	
						            
						        RX_CPLD_FMT_TYPE: begin
						            f4_state <= RX_DMA_RD_CPLD;
						            o_m_axis_rx_tready <= #TCQ 1;
						        end    
                    default : begin // other TLPs
                        f4_state        <= #TCQ PIO_RX_RST_STATE;
                    end // default
                endcase
              end // if (w_sop)
              else
                  f4_state <= #TCQ PIO_RX_RST_STATE;
            end // PIO_RX_RST_STATE
            
            PIO_RX_MEM_RD32_DW1DW2_PRE : begin
              f4_state <= #TCQ PIO_RX_MEM_RD32_DW1DW2;
            end
            
				
            PIO_RX_MEM_RD32_DW1DW2 : begin
               
              if (i_m_axis_rx_tvalid)begin
                  o_m_axis_rx_tready <= #TCQ 1'b0;
                  //o27_req_addr     <= #TCQ {f2_region_select[1:0],i64_m_axis_rx_tdata[10:2], 2'b00};
                  o27_req_addr     <= #TCQ {i64_m_axis_rx_tdata[25:2]};
                  if (i64_m_axis_rx_tdata[26] == 1'b1) begin
                    o_eth_flag_rd_req <= 1;
                    o_pcie_rd_req  <= 0;                    
                  end
                  else begin
                    o_eth_flag_rd_req <= 0;
                    o_pcie_rd_req  <= 1;
                  end  
                  o_req_compl    	<= #TCQ 1'b1;
                  o_req_compl_wd 	<= #TCQ 1'b1;
                  f4_state        	<= #TCQ PIO_RX_WAIT_STATE;
              end else// if (i_m_axis_rx_tvalid)            
              f4_state        	<= #TCQ PIO_RX_MEM_RD32_DW1DW2;
                 //o_pcie_rd_req  <= 0;
            end // PIO_RX_MEM_RD32_DW1DW2

            PIO_RX_MEM_WR32_FAKE_READY : begin
			  if(i_m_axis_rx_tlast && advance_en) begin
			      o_m_axis_rx_tready <= #TCQ 1'b0;
				  f4_state        <= #TCQ PIO_RX_RST_STATE;
			  end
			  else begin
			      o_m_axis_rx_tready <= #TCQ 1'b1;
				  f4_state        <= #TCQ PIO_RX_MEM_WR32_FAKE_READY;
			  end			    
			end
			
            PIO_RX_MEM_WR32_DW1DW2_PRE : begin
              f4_state <= #TCQ PIO_RX_MEM_WR32_DW1DW2;
            end
            
            PIO_RX_MEM_WR32_DW1DW2 : begin
              if(i_m_axis_rx_tvalid)begin
                //o32_wr_data      <= #TCQ i64_m_axis_rx_tdata[63:32];
                o32_wr_data      <= #TCQ {i64_m_axis_rx_tdata[39:36],i64_m_axis_rx_tdata[35:32],i64_m_axis_rx_tdata[47:44],i64_m_axis_rx_tdata[43:40],i64_m_axis_rx_tdata[55:52],
                                          i64_m_axis_rx_tdata[51:48],i64_m_axis_rx_tdata[63:60],i64_m_axis_rx_tdata[59:56]};
                       
                //o_wr_en        	<= #TCQ 1'b1;
                o_m_axis_rx_tready <= #TCQ 1'b0;
                //o27_wr_addr      <= #TCQ {f2_region_select[1:0],i64_m_axis_rx_tdata[10:2]};
                o27_wr_addr      <= #TCQ i64_m_axis_rx_tdata[25:2];
                
                if(i64_m_axis_rx_tdata[26] == 1'b1) begin
                  o_eth_flag_wr_req <= 1'b1;
                  o_pcie_wr_req   	<= 1'b0;
                end
                else begin
                  o_eth_flag_wr_req <= 1'b0;
                  o_pcie_wr_req   	<= 1'b1;
                end
                
                f4_state        	<= #TCQ  PIO_RX_WAIT_STATE;
              end else// if (i_m_axis_rx_tvalid)             
                f4_state        <= #TCQ PIO_RX_MEM_WR32_DW1DW2;
            end // PIO_RX_MEM_WR32_DW1DW2

            PIO_RX_WAIT_STATE : begin
//              o_wr_en      <= #TCQ 1'b0;
                o_req_compl  <= #TCQ 1'b0;
                o_pcie_wr_req	<= 1'b0;
                o_pcie_rd_req  <= 0;
				        o_eth_flag_rd_req <= 1'b0;
				        o_eth_flag_wr_req <= 1'b0;
              if ((f_tlp_type == PIO_RX_MEM_WR32_FMT_TYPE) && (!i_wr_busy))begin
                //o_m_axis_rx_tready <= #TCQ 1'b1;
                f4_state        <= #TCQ PIO_RX_RST_STATE;
              end else if ((f_tlp_type == PIO_RX_MEM_RD32_FMT_TYPE) && (i_compl_done))begin
                //o_m_axis_rx_tready <= #TCQ 1'b1;
                f4_state        <= #TCQ PIO_RX_RST_STATE;
              end else
                f4_state        <= #TCQ PIO_RX_WAIT_STATE;
            end // PIO_RX_WAIT_STATE
            
            RX_DMA_RD_CPLD: begin
                if(i_m_axis_rx_tlast && advance_en && dma_rd_cpld_cnt >= dma_rd_cpld_num_minus1) begin
				            dma_rd_cpld_cnt <=  #TCQ 0;
                    f4_state        <= #TCQ RX_DMA_RD_CPLD_WAIT; 
					          o_dma_rd_cmpl_done <= #TCQ  1;					
					          o_wr_eth_fifo_en <= #TCQ 1;
					          o_wr_eth_fifo_data <= #TCQ {i64_m_axis_rx_tdata[31:0],wr_eth_fifo_data_high};
					          wr_eth_fifo_data_high <= #TCQ i64_m_axis_rx_tdata[63:32];
							  o_m_axis_rx_tready <= #TCQ 0;    
                end
                else if(i_m_axis_rx_tlast && advance_en) begin
				            dma_rd_cpld_cnt <= #TCQ dma_rd_cpld_cnt + 1'b1;
                    f4_state        <= #TCQ RX_DMA_RD_CPLD_WAIT; 
					          o_dma_rd_cmpl_done <= #TCQ 0;
					          o_wr_eth_fifo_en <= #TCQ 1;
					          o_wr_eth_fifo_data <= #TCQ {i64_m_axis_rx_tdata[31:0],wr_eth_fifo_data_high};
					          wr_eth_fifo_data_high <= #TCQ i64_m_axis_rx_tdata[63:32];
							  o_m_axis_rx_tready <= #TCQ 0;   
                end
                else if(advance_cnt == 8'd1 && advance_en && (dma_rd_cpld_cnt <= dma_rd_cpld_num_minus1)) begin
				            dma_rd_cpld_cnt <= #TCQ dma_rd_cpld_cnt;
                    f4_state        <= #TCQ RX_DMA_RD_CPLD;
					          o_dma_rd_cmpl_done <= #TCQ 0;
					          o_wr_eth_fifo_en <= #TCQ 0;
					          o_wr_eth_fifo_data <= #TCQ 0;
					          wr_eth_fifo_data_high <= #TCQ i64_m_axis_rx_tdata[63:32];
							  o_m_axis_rx_tready <= #TCQ i_ds_rdy;    
					      end
                else if(advance_cnt[7:1] != 7'b0 && advance_en && (dma_rd_cpld_cnt <= dma_rd_cpld_num_minus1)) begin 
				            dma_rd_cpld_cnt <= #TCQ dma_rd_cpld_cnt;
                    f4_state        <= #TCQ RX_DMA_RD_CPLD;
					          o_dma_rd_cmpl_done <= #TCQ 0;
					          o_wr_eth_fifo_en <= #TCQ 1;
					          o_wr_eth_fifo_data <= #TCQ {i64_m_axis_rx_tdata[31:0],wr_eth_fifo_data_high};
					          wr_eth_fifo_data_high <= #TCQ i64_m_axis_rx_tdata[63:32];
							  o_m_axis_rx_tready <= #TCQ i_ds_rdy;   
					      end
					      else begin
				            dma_rd_cpld_cnt <= #TCQ dma_rd_cpld_cnt;
                    f4_state        <= #TCQ RX_DMA_RD_CPLD;
					          o_dma_rd_cmpl_done <= #TCQ o_dma_rd_cmpl_done;
					          o_wr_eth_fifo_en <= #TCQ 0;
					          o_wr_eth_fifo_data <= #TCQ 0;
					          wr_eth_fifo_data_high <= #TCQ wr_eth_fifo_data_high;
							  o_m_axis_rx_tready <= #TCQ i_ds_rdy;  
					      end
            end
			RX_DMA_RD_CPLD_WAIT : begin
			        o_m_axis_rx_tready <= #TCQ 0; //insert rx_tready 0 
				    dma_rd_cpld_cnt <=  #TCQ dma_rd_cpld_cnt;
                    f4_state        <= #TCQ PIO_RX_RST_STATE; 
					o_dma_rd_cmpl_done <= #TCQ  o_dma_rd_cmpl_done;					
					o_wr_eth_fifo_en <= #TCQ 0;
					o_wr_eth_fifo_data <= #TCQ 0;
					wr_eth_fifo_data_high <= #TCQ 0;
			end
			
            PIO_RX_ERR_STATE : begin
              f4_state        <= #TCQ PIO_RX_RST_STATE; 
            end
            default : begin
              // default case stmt
              f4_state        <= #TCQ PIO_RX_RST_STATE;
            end // default
          endcase
        end
      end
    end
  endgenerate


//assign  w_io_bar_hit_n = ~(i22_m_axis_rx_tuser[2]);
//assign  w_mem32_bar_hit_n = ~(i22_m_axis_rx_tuser[3]);

//  always @*
//  begin
//    case ({w_io_bar_hit_n, w_mem32_bar_hit_n})
//      3'b01 : begin
//        f2_region_select <= #TCQ 2'b00;    // Select IO region
//      end // 

//      3'b10 : begin
//        f2_region_select <= #TCQ 2'b01;    // Select Mem32 region
//      end //
//      default : begin
//        f2_region_select <= #TCQ 2'b00;   
//      end // default

//    endcase // case ({io_bar_hit_n, mem32_bar_hit_n, mem64_bar_hit_n, erom_bar_hit_n})

//  end
  
//wire	[6:0]	w_m_axis__rx_tdata;
//assign w_m_axis__rx_tdata = {i64_m_axis_rx_tdata[11:10],i64_m_axis_rx_tdata[19:16],i64_m_axis_rx_tdata[23]};

  always @ ( posedge clk ) begin
		  if (!rst_n )
          o_rd_eth_flag_en <= 0;
      else if(o_eth_flag_rd_req) 
          o_rd_eth_flag_en <= 1;
      else if(o_pcie_rd_req)
          o_rd_eth_flag_en <= 0;
  end


  endmodule // PIO_RX_ENGINE

